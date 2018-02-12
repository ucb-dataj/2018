# load packages to read, write and process data, and to work with dates
library(readr)
library(dplyr)
library(lubridate)

# load ca medical board disciplinary actions data
ca_discipline <- read_csv("ca_discipline.csv")

# view structure of data
str(ca_discipline)

# print values for alert_date in the ca_discipline data
ca_discipline$alert_date

# convert alert_date to text
ca_discipline$alert_date <- as.character(ca_discipline$alert_date)
str(ca_discipline)

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

# license revokations for doctors based in Califorina, by year
revoked_ca_year <- ca_discipline %>%
  filter(action_type == "Revoked" 
         & state == "CA") %>%
  group_by(year) %>%
  summarize(revocations = n())

# license revokations for doctors based in Califorina, by month
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


# load opioid prescription dara

ca_opioids <- read_csv("ca_medicare_opioids.csv")


# look at data
View(ca_opioids)


# which doctors filed the most prescriptions for fentanyl in 2015?
fentanyl_2015 <- ca_opioids %>%
  filter(generic_name == "FENTANYL" 
         & year == 2015) %>%
  arrange(desc(total_claim_count)) %>%
  select(npi,
         nppes_provider_last_org_name,
         nppes_provider_first_name,
         nppes_provider_city,
         specialty_description,
         total_claim_count)
  

# OK, let's remove physician assistants, nurse practioners, and pharmacists
fentanyl_2015_doctors <- ca_opioids %>%
  filter(generic_name == "FENTANYL" 
         & year == 2015 
         & specialty_description != "Physician Assistant" 
         & specialty_description != "Nurse Practitioner"
         & specialty_description != "Pharmacist") %>%
  arrange(desc(total_claim_count)) %>%
  select(npi,
         nppes_provider_last_org_name,
         nppes_provider_first_name,
         nppes_provider_city,
         specialty_description,
         total_claim_count)

fentanyl_2015_doctors <- ca_opioids %>%
  filter(generic_name == "FENTANYL" 
         & year == 2015 
         & !grepl("assistant|nurse|pharmacist", 
                  specialty_description, 
                  ignore.case = TRUE)) %>%
  arrange(desc(total_claim_count))  %>%
  select(npi,
         nppes_provider_last_org_name,
         nppes_provider_first_name,
         nppes_provider_city,
         specialty_description,
         total_claim_count)


# Did anyone notice a problem with what we've done for fentanyl? Hint: look at the drug list
# We'll come back to this later

# Calculate the total number opioid prescriptions for each year, their cost, and the total number of patients
fentanyl_year_summary <- ca_opioids %>%
  filter(generic_name == "FENTANYL") %>%
  group_by(year) %>%
  summarize(claims = sum(total_claim_count),
            cost = sum(total_drug_cost),
            patients = sum(bene_count))

# calculate the total number of fentanyl prescriptions, their cost, and the total number of patient/drug , for each year
fentanyl_year_summary <- ca_opioids %>%
  filter(generic_name == "FENTANYL") %>%
  group_by(year) %>%
  summarize(claims = sum(total_claim_count),
            cost = sum(total_drug_cost),
            patients = sum(bene_count, na.rm = TRUE))



# now filter for these cities, and look at how prescriptions have changed over the three years
summary_top5_year <- ca_opioids %>%
  filter(nppes_provider_city == "LOS ANGELES"
         | nppes_provider_city == "SACRAMENTO"
         | nppes_provider_city == "SAN DIEGO"
         | nppes_provider_city == "FRESNO"
         | nppes_provider_city == "BAKERSFIELD") %>%
  group_by(nppes_provider_city,year) %>%
  summarize(claims = sum(total_claim_count),
            cost = sum(total_drug_cost),
            patient_drug = sum(bene_count, na.rm=TRUE)) %>%
  arrange(nppes_provider_city, year)


########### week6

# all opioid prescriptions, summary statistics by doctor

library(ggplot2)
library(scales)

doctor_summary <- ca_opioids %>%
  filter(!grepl("assistant|nurse|pharmacist",specialty_description)) %>%
  group_by(npi,
           nppes_provider_last_org_name,
           nppes_provider_first_name,
           nppes_provider_city,
           specialty_description) %>%
  summarize(claims = sum(total_claim_count),
            cost = sum(total_drug_cost)) %>%
  mutate(cost_per_claim = cost/claims)

# histograms of claims and costs
ggplot(doctor_summary, aes(x=claims)) +
  geom_histogram()

ggplot(doctor_summary, aes(x=claims)) +
  geom_histogram(binwidth=50) +
  scale_x_continuous(limits = c(0,3000),
                     labels = comma) +
  scale_y_continuous(labels = comma)

ggplot(doctor_summary, aes(x=cost)) +
  geom_histogram() +
  scale_x_continuous(labels = dollar)

# calculate median and claims and costs per doctor over the three years
medians_means <- ca_opioids %>%
  filter(!grepl("assistant|nurse|pharmacist",specialty_description)) %>%
  group_by(npi) %>%
  summarize(claims = sum(total_claim_count),
                        cost = sum(total_drug_cost)) %>%
  mutate(cost_per_claim = cost/claims) %>%
  summarize(median_claims = median(claims),
            median_cost = median(cost),
            median_cost_per_claim = median(cost_per_claim),
            mean_claims = mean(claims),
            mean_cost = mean(cost),
            mean_cost_per_claim = mean(cost_per_claim))

# scatterplot of claims versus costs per doctor
ggplot(doctor_summary, aes(x=claims, 
                           y=cost)) +
  geom_point()

ggplot(doctor_summary, aes(x=claims, 
                           y=cost)) +
  geom_point(alpha = 0.3) + 
  geom_smooth(method = lm) +
  scale_x_continuous(labels = comma) +
  scale_y_continuous(labels = dollar)

# bar chart of doctors with highest cost per claim
top20_costs_per_claim <- doctor_summary %>%
  arrange(desc(cost_per_claim)) %>%
  head(20) %>%
  mutate(id = paste0(nppes_provider_first_name,
                     " ", 
                     nppes_provider_last_org_name, 
                     ", ", 
                     nppes_provider_city))

ggplot(top20_costs_per_claim, aes(x=id,
                                  y=cost_per_claim)) +
  geom_bar(stat="identity") +
  coord_flip()

ggplot(top20_costs_per_claim, aes(x=reorder(id,cost_per_claim),
                                  y=cost_per_claim)) +
  geom_bar(stat="identity") +
  scale_y_continuous(labels = dollar) +
  ylab("Cost per claim") +
  xlab("") +
  coord_flip()

# import disciplinary actions data, work with dates
library(lubridate)

ca_discipline <- read_csv("ca_discipline.csv")

str(ca_discipline)

ca_discipline <- ca_discipline %>%
  mutate(action_year = year(action_date),
         action_month = month(action_date, label = TRUE))

# actions per year
actions_year <- ca_discipline %>%
  group_by(action_year) %>%
  summarize(count=n())

ggplot(actions_year, aes(x=action_year, y = count)) +
  geom_bar(stat = "identity") +
  xlab("") +
  ylab("number of actions") +
  scale_x_continuous(breaks = c(2008,2012,2016))

# actions per month
actions_month <- ca_discipline %>%
  group_by(action_month) %>%
  summarize(count=n())

ggplot(actions_month, aes(x=action_month, y = count)) +
  geom_bar(stat = "identity") +
  xlab("") +
  ylab("number of actions")

# Which doctors that prescribed opioids have disciplinary actions on their record?
npi_license <- read_csv("npi_license.csv")%>%
  mutate(npi = as.character(npi))

ca_discipline <- left_join(ca_discipline,npi_license) %>%
  mutate(last_name = toupper(last_name),
         first_name = toupper(first_name))

# ca_discipline <- left_join(ca_discipline,npi_license, by="license") %>%
#   mutate(last_name = toupper(last_name),
#          first_name = toupper(first_name))

doctor_summary_actions1 <- inner_join(doctor_summary,ca_discipline, by="npi") %>%
  arrange(desc(claims)) %>%


# by first and last names (explain why we get more here)
doctor_summary_actions2 <- inner_join(doctor_summary,ca_discipline, by=c("nppes_provider_last_org_name"="last_name",
                                                                         "nppes_provider_first_name"="first_name")) %>%
  arrange(desc(claims))

# which doctors matched by names but not license numbers?
doctors1 <- doctor_summary_actions1 %>%
  ungroup() %>%
  select(nppes_provider_last_org_name,nppes_provider_first_name,specialty_description,claims,cost,cost_per_claim,license,action_type,action_date) %>%
  unique()

doctors2 <- doctor_summary_actions2 %>%
  ungroup() %>%
  select(nppes_provider_last_org_name,nppes_provider_first_name,specialty_description,claims,cost,cost_per_claim,license,action_type,action_date) %>%
  unique()

doctors_difference <- anti_join(doctors2,doctors1)

doctor_summary_actions2 <- semi_join(doctor_summary_actions2,doctors_difference, by="license")




  

  



  








    












