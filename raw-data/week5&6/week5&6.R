# load packages to read, write and process data, and to work with dates
library(readr)
library(dplyr)
library(lubridate)

# load ca medical board disciplinary actions data
ca_discipline <- read_csv("ca_discipline.csv")

# view structure of data
glimpse(ca_discipline)

# print values for alert_date in the ca_discipline data
ca_discipline$alert_date

# convert alert_date to text
ca_discipline$alert_date <- as.character(ca_discipline$alert_date)
glimpse(ca_discipline)

# convert alert_date to date using dplyr
ca_discipline <- ca_discipline %>%
  mutate(alert_date = as.Date(alert_date))

# look at types of disciplinary actions
types <- ca_discipline %>%
  select(action_type) %>%
  unique()

# filter for license revocations only
revoked <- ca_discipline %>%
  filter(action_type == "Revoked")

# filter for license revocations by doctors based in California, and sort by city
revoked_ca <- ca_discipline %>%
  filter(action_type == "Revoked"
         & state == "CA") %>%
  arrange(city)

# doctors in Berkeley or Oakland who have had their licenses revoked 
revoked_oak_berk <- ca_discipline %>%
  filter(action_type == "Revoked"
       & (city == "Oakland" | city == "Berkeley"))

# doctors in Berkeley who had their licenses revoked
revoked_oak <- ca_discipline %>%
  filter(action_type == "Revoked"
         & city == "Berkeley")

# doctors in Oakland who had their licenses revoked
revoked_berk <- ca_discipline %>%
  filter(action_type == "Revoked"
         & city == "Oakland")

# doctors in Berkeley or Oakland who have had their licenses revoked
revoked_oak_berk <- bind_rows(revoked_oak, revoked_berk)

# write data to CSV file
write_csv(revoked_oak_berk, "revoked_oak_berk.csv", na="")

# extract year and month from action_date
ca_discipline <- ca_discipline %>%
  mutate(year = year(action_date),
         month = month(action_date))

# license revocations for doctors based in Califorina, by year
revoked_ca_year <- ca_discipline %>%
  filter(action_type == "Revoked" 
         & state == "CA") %>%
  group_by(year) %>%
  summarize(revocations = n())

# license revocations for doctors based in Califorina, by month
revoked_ca_month <- ca_discipline %>%
  filter(action_type == "Revoked" 
         & state == "CA"
         & year >= 2009) %>%
  group_by(month) %>%
  summarize(revocations = n())

# disciplinary actions for doctors in California by year and month, from 2009 to 2017
actions_year_month <- ca_discipline %>%
  filter(state == "CA"
         & year >= 2009) %>%
  group_by(year,month) %>%
  summarize(actions = n()) %>%
  arrange(year,month)

# mean and median actions per month, 2009 to 2017
summary_year_month <- actions_year_month %>%
  ungroup() %>%
  summarize(mean = mean(actions),
            median = median(actions))

# load opioid prescription data
ca_opioids <- read_csv("ca_medicare_opioids.csv")

# look at data
View(ca_opioids)

# 
generics <- ca_opioids %>%
  select(generic_name) %>%
  unique() %>%
  arrange(generic_name)

glimpse(ca_opioids)

# who wrote the most prescriptions for fentanyl in 2015?
fentanyl_2015 <- ca_opioids %>%
  filter(year == 2015
         & (generic_name == "FENTANYL" | generic_name == "FENTANYL CITRATE" | generic_name == "FENTANYL CITRATE/PF")) %>%
  group_by(npi,
         nppes_provider_last_org_name,
         nppes_provider_first_name,
         nppes_provider_city,
         specialty_description) %>%
  summarize(prescriptions = sum(total_claim_count)) %>%
  arrange(desc(prescriptions))

# same result, text pattern matching
fentanyl_2015 <- ca_opioids %>%
  filter(year == 2015
         & grepl("fentanyl", generic_name, ignore.case = TRUE)) %>%
  group_by(npi,
           nppes_provider_last_org_name,
           nppes_provider_first_name,
           nppes_provider_city,
           specialty_description) %>%
  summarize(prescriptions = sum(total_claim_count)) %>%
  arrange(desc(prescriptions))

# remove nurses etc
fentanyl_2015_doctors <- ca_opioids %>%
  filter(year == 2015
         & grepl("fentanyl", generic_name, ignore.case = TRUE)
         & !grepl("assistant|practitioner|pharmacist", specialty_description, ignore.case = TRUE)) %>%
  group_by(npi,
           nppes_provider_last_org_name,
           nppes_provider_first_name,
           nppes_provider_city,
           specialty_description) %>%
  summarize(prescriptions = sum(total_claim_count)) %>%
  arrange(desc(prescriptions))



# calculate the total number of fentanyl prescriptions, their cost, and the total number of patient/drug, for each year
fentanyl_year_summary <- ca_opioids %>%
  filter(grepl("fentanyl", generic_name, ignore.case = TRUE)) %>%
  group_by(year) %>%
  summarize(claims = sum(total_claim_count),
            cost = sum(total_drug_cost),
            patients = sum(bene_count))

# calculate the total number of fentanyl prescriptions, their cost, and the total number of patient/drug, for each year
fentanyl_year_summary <- ca_opioids %>%
  filter(grepl("fentanyl", generic_name, ignore.case = TRUE)) %>%
  group_by(year) %>%
  summarize(claims = sum(total_claim_count),
            cost = sum(total_drug_cost),
            patients = sum(bene_count, na.rm = TRUE))

# how many patients might be missing from the data
fentanyl_year_missing <- ca_opioids %>%
  filter(grepl("fentanyl", generic_name, ignore.case = TRUE)
         & is.na(bene_count)) %>%
  group_by(year) %>%
  summarize(max_missing_patients = n()*10)


doctor_summary <- ca_opioids %>%
  filter(!grepl("assistant|nurse|pharmacist",specialty_description, ignore.case = TRUE)) %>%
  group_by(npi,
           nppes_provider_last_org_name,
           nppes_provider_first_name,
           nppes_provider_city,
           specialty_description) %>%
  summarize(prescriptions = sum(total_claim_count),
            cost = sum(total_drug_cost)) %>%
  mutate(cost_per_prescription = cost/prescriptions) %>%
  arrange(desc(prescriptions))

library(ggplot2)
library(scales)

# histograms
ggplot(doctor_summary, aes(x = prescriptions)) +
  geom_histogram()

ggplot(doctor_summary, aes(x = prescriptions)) +
  geom_histogram(binwidth = 50) +
  theme_minimal() +
  scale_x_continuous(limits = c(0,3000),
                     labels = comma) +
  scale_y_continuous(labels = comma)

mean_median <- doctor_summary %>%
  ungroup() %>%
  summarize(mean_prescriptions = mean(prescriptions),
            median_prescriptions = median(prescriptions))

doctor_summary <- doctor_summary %>%
  ungroup()


#### Make a scatterplot of prescriptions and costs data
ggplot(doctor_summary, aes(x = prescriptions, y = cost)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = lm) +
  theme_minimal() +
  scale_x_continuous(labels = comma) +
  scale_y_continuous(labels = dollar)

### joins

# load data

ca_discipline <- read_csv("ca_discipline.csv")

npi_license <- read_csv("npi_license.csv")

ca_discipline_npi <- left_join(ca_discipline,npi_license) 

ca_discipline_npi <- left_join(ca_discipline, npi_license, by = "license")



# exercises

# Filter the `ca_discipline` data to show licenses `Revoked` for doctors based in Los Angeles.
revoke_la <- ca_discipline %>%
  filter(city == "Los Angeles" 
         & action_type == "Revoked")

# Filter the `ca_discipline` data to show licenses `Suspended` or `Revoked` for doctors in Los Angeles or San Diego.
suspended_revoked_la_sd <- ca_discipline %>%
  filter((city == "Los Angeles" | city == "San Diego")
         & (action_type == "Revoked" | action_type == "Suspended"))

# Calculate the total number of licences for doctors based in other states that revoked from 2009 to 2017
revoked_out_state <- ca_discipline %>%
  filter(state != "CA"
         & action_type == "Revoked"
         & year >= 2009) %>%
  summarize(revocations = n())

# Calculate the total number of licenses Suspended or Revoked for doctors based in California for each year.
suspended_revoked_year <- ca_discipline %>%
  filter(state == "CA"
         & (action_type == "Revoked" | action_type == "Suspended")) %>%
  group_by(year) %>%
  summarize(actions = n())


# Find the doctor(s) with the largest number of actions in the data
most_actions <- ca_discipline %>%
  filter(state == "CA") %>%
  group_by(license, last_name, first_name, middle_name, name_suffix, city) %>%
  summarize(actions = n()) %>%
  arrange(desc(actions))

# Filter the data for nurse practitioners who prescribed PERCOCET, sorting in reverse order of the number of prescriptions
percocet_2015 <- ca_opioids %>%
  filter(drug_name == "PERCOCET"
         & year == 2015) %>%
  arrange(desc(total_claim_count))

# Calculate to the total days' supply of opioids prescribed in by doctors in Berkeley in each year
berkeley_days_2015 <- ca_opioids %>%
  filter(nppes_provider_city == "BERKELEY") %>%
  group_by(year) %>%
  summarize(days_supply = sum(total_day_supply))

# Calculate the total number of prescriptions and total cost of the opioids given to seniors (aged 65 and older) in Oakland in each year.
oakland_seniors <- ca_opioids %>%
  filter(nppes_provider_city == "BERKELEY") %>%
  group_by(year) %>%
  summarize(claims = sum(total_claim_count_ge65, na.rm=TRUE),
            cost = sum(total_drug_cost_ge65, na.rm=TRUE))

# which doctors wrote the most prescriptions for fentanyl in 2015?
fentanyl_2015_doctors <- ca_opioids %>%
  filter(grepl("fentanyl", generic_name, ignore.case = TRUE)
         & year == 2015 
         & !grepl("assistant|practitioner|pharmacist", 
                  specialty_description, 
                  ignore.case = TRUE)) %>%
  group_by(npi,npi,
           nppes_provider_last_org_name,
           nppes_provider_first_name,
           nppes_provider_city,
           specialty_description) %>%
  summarize(prescriptions = sum(total_claim_count)) %>%
  arrange(desc(prescriptions))

