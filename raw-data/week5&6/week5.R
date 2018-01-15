# load required packages
library(readr)
library(readxl)
library(dplyr)
library(stringr)

############# Medicare Part D prescription data

# opioid drug list
files <- list.files("medicare_drug_lists")

opioids <- data_frame()

for (f in files) {
  tmp <- read_excel(paste0("medicare_drug_lists/",f), sheet = 2, skip = 2) %>%
    select(2,3)
  names(tmp) <- c("drug_name","generic_name")
  tmp <- tmp %>%
    filter(!is.na(generic_name))
  opioids <- bind_rows(opioids,tmp)
}

opioids <- unique(opioids) %>%
  arrange(drug_name)

rm(files,tmp,f)

# full Medicare Part D files, filtering for opioid prescriptions by CA doctors

files <- list.files("medicare_prescriptions")

ca_medicare_opioids <- data_frame()

for (f in files) {
  year <- as.integer(paste0("20",str_extract(f, "[0-9]+")))
  print(year)
  tmp <- read_tsv(paste0("medicare_prescriptions/",f)) %>%
    mutate(year = year) %>%
    filter(nppes_provider_state == "CA") %>%
    semi_join(opioids, by = "drug_name")
  ca_medicare_opioids <- bind_rows(ca_medicare_opioids,tmp)
  rm(tmp)
}
rm(files,f,year)

# write to csv
write.csv(ca_medicare_opioids, "ca_medicare_opioids.csv", row.names = F, na="")

###############

############### ca disciplinary actions

files <- list.files("ca_discipline")

ca_discipline <- data_frame()

for (f in files) {
  print(f)
  tmp <- read.csv(paste0("ca_discipline/",f), stringsAsFactors = F)
  ca_discipline <- bind_rows(ca_discipline,tmp) 
}

ca_discipline <- ca_discipline %>%
  mutate(alert_date = as.Date(alert_date),
         action_date = as.Date(action_date),
         # remove spaces in license numbers
         license = gsub(" ","",license))

# get the starting character of all license codes (for filtering crosswalk data, below)
unique(substr(ca_discipline$license,1,1))

# looking at data for different license types
test <- ca_discipline %>%
  filter(substr(ca_discipline$license,1,1) == "S")

str(ca_discipline)

# write to csv
write.csv(ca_discipline, "ca_discipline.csv", row.names = F, na="")

############

############ NBER NPI/state license crosswalk
npi_license <- read_csv("nber/statelic.csv") %>%
  filter(plicstate == "CA",
         seq==1) %>% 
  mutate(plicnum = str_replace_all(plicnum," ",""),
         license = str_replace_all(plicnum, "[^[:alnum:]]", ""), # removes special characters
         license = str_replace(plicnum, "(^|[^0-9])0+", ""), # removes trailing zeros
         letters = str_extract(license, "[A-Z]+"),
         numbers = as.integer(str_extract(license, "[0-9]+")),
         license = paste0(letters,numbers)) %>%
  filter(!is.na(letters))
npi_license[is.na(npi_license)] <- ""
npi_license <- npi_license %>%
  # filter for license codes that may be in the ca discipline data, based on first character
  filter(grepl("G|A|C|P|S",substr(license,1,1))) %>%
  select(npi,plicnum,license) %>%
  filter(nchar(license) > 3)
  
write.csv(npi_license,"npi_license.csv",row.names = F,na="")

#############

