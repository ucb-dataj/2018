#######################
# baseball salary data

# load required packages
library(Lahman)
library(dplyr)
library(readr)
library(ggplot2)

# convert Lahman tables to local data frames, with data for 2015 only for Teams and Salaries
Teams <- filter(Teams, yearID == 2015)
Salaries <- filter(Salaries, yearID == 2015)
Master <- Master

mlb_salaries_2015 <- Salaries %>%
  left_join(Master, by="playerID") %>%
  left_join(Teams, by="teamID") %>%
  mutate(salary_mil=salary/1000000, nameFull=paste(nameFirst, nameLast, sep=" ")) %>%
  rename(teamName=name) %>%
  select(playerID, nameFirst, nameLast, nameFull, teamID, teamName, salary, salary_mil)

ggplot(mlb_salaries_2015, aes(x=salary_mil, y=..count..)) + 
  geom_histogram(binwidth=0.5, fill = "red") + 
  ylab("Number of players") + 
  xlab("Salary ($ millions)") + 
  scale_x_continuous(limits = c(0,35)) +
  theme_minimal(base_size = 14, base_family = "Georgia")

# export data 
write.csv(mlb_salaries_2015, "mlb_salaries_2015.csv", row.names=F, na = "")

######################
# unemployment data

library(scales)

# load list of available BLS time series
series <- read_tsv("http://download.bls.gov/pub/time.series/ln/ln.series")

# load data
all_series <- read.table("http://download.bls.gov/pub/time.series/ln/ln.data.1.AllData", header=T, fill=T)

# create dates, setting to 15th of each month
monthly_series <- all_series %>%
  filter(grepl("M",period)) %>%
  mutate(month=as.integer(substr(period,2,3)),
         date=as.Date(paste0(year,"-",month,"-15")),
         value=as.numeric(as.character(value)))

View(head(monthly_series))

# filter for U1 - U6 unemployment rates
unem_rates <- monthly_series %>%
  filter(series_id == "LNS13025670" | series_id=="LNS14023621" | series_id == "LNS14000000" | series_id == "LNS13327707" | series_id == "LNS13327708" | series_id == "LNS13327709") %>%
  filter(date > "1980-01-01")

# replace series names
unem_rates$series_id <- gsub("LNS13025670", "U1", unem_rates$series_id)
unem_rates$series_id <- gsub("LNS14023621", "U2", unem_rates$series_id)
unem_rates$series_id <- gsub("LNS14000000", "U3", unem_rates$series_id)
unem_rates$series_id <- gsub("LNS13327707", "U4", unem_rates$series_id)
unem_rates$series_id <- gsub("LNS13327708", "U5", unem_rates$series_id)
unem_rates$series_id <- gsub("LNS13327709", "U6", unem_rates$series_id)

# line chart
ggplot(unem_rates, aes(x=date,y=value/100, color=series_id)) + 
  theme_minimal(base_size = 14, base_family = "Georgia") + 
  ggtitle("What is the true unemployment rate?") + 
  scale_y_continuous(labels = percent) +
  theme(legend.title = element_blank()) +
  geom_line(size=0.7) + 
  xlab("") + 
  ylab("")

# filter for men and women
unem_sex <- monthly_series %>%
  filter(series_id == "LNS14000001" | series_id=="LNS14000002") %>%
  filter(date > "1980-01-01")

# replace series names
unem_sex$series_id <- gsub("LNS14000001", "Men", unem_sex$series_id)
unem_sex$series_id <- gsub("LNS14000002", "Women", unem_sex$series_id)

# line chart
ggplot(unem_sex, aes(x=date,y=value/100, color=series_id)) + 
  theme_minimal(base_size = 14, base_family = "Georgia") + 
  ggtitle("Unemployment rate by sex") + 
  scale_y_continuous(labels = percent) +
  theme(legend.title = element_blank()) +
  geom_line(size=0.7) + 
  xlab("") + 
  ylab("")

# filter for race/ethnicity
unem_race <- monthly_series %>%
  filter(series_id == "LNS14000003" | series_id=="LNS14000006" | series_id=="LNS14000009") %>%
  filter(date > "1980-01-01")

# replace series names
unem_race$series_id <- gsub("LNS14000003", "White", unem_race$series_id)
unem_race$series_id <- gsub("LNS14000006", "Black", unem_race$series_id)
unem_race$series_id <- gsub("LNS14000009", "Latino", unem_race$series_id)

# line chart
ggplot(unem_race, aes(x=date,y=value/100, color=series_id)) + 
  theme_minimal(base_size = 14, base_family = "Georgia") + 
  ggtitle("Unemployment rate by race/ethnicity") + 
  scale_y_continuous(labels = percent) +
  theme(legend.title = element_blank()) +
  geom_line(size=0.7) + 
  xlab("") + 
  ylab("")

# filter for age
unem_age <- monthly_series %>%
  filter(series_id == "LNS14000012" | series_id=="LNS14000036" | series_id=="LNS14000089" | series_id=="LNS14000091" | series_id=="LNS14000093" | series_id=="LNS14024230") %>%
  filter(date > "1980-01-01")

# replace series names
unem_age$series_id <- gsub("LNS14000012", "16-19", unem_age$series_id)
unem_age$series_id <- gsub("LNS14000036", "20-24", unem_age$series_id)
unem_age$series_id <- gsub("LNS14000089", "25-34", unem_age$series_id)
unem_age$series_id <- gsub("LNS14000091", "35-44", unem_age$series_id)
unem_age$series_id <- gsub("LNS14000093", "45-54", unem_age$series_id)
unem_age$series_id <- gsub("LNS14024230", "55+", unem_age$series_id)

# line chart
ggplot(unem_age, aes(x=date,y=value/100, color=series_id)) + 
  theme_minimal(base_size = 14, base_family = "Georgia") + 
  ggtitle("Unemployment rate by age") + 
  scale_y_continuous(labels = percent) +
  theme(legend.title = element_blank()) +
  geom_line(size=0.7) + 
  xlab("") + 
  ylab("")
