################
# reading in multiple files, combining into one data frame

# required packages
library(readr)
library(dplyr)

# list files
files <- list.files("ca_discipline")

# create empty data frame to hold data
ca_discipline <- data_frame()

# loop to read in files
for (f in files) {
  print(f)
  tmp <- read_csv(paste0("ca_discipline/",f), col_types = cols(
    .default = col_character(),
    alert_date = col_datetime(),
    action_date = col_datetime()))
  ca_discipline <- bind_rows(ca_discipline,tmp)
}
# cleanup
rm(tmp,files,f)

# explain concept of a loop, paste0 function, and how to define columns when importing data

# Making new variables with conditional statements 

action_types <- ca_discipline %>%
  select(action_type) %>%
  unique() %>%
  arrange(action_type)

ca_discipline <- ca_discipline %>%
  mutate(type_edit = case_when(action_type == "Revoked" ~ "Revoked",
                               action_type == "Surrendered" ~ "Surrendered",
                               !grepl("Revoked|Surrendered", action_type) ~ "Other"))


##################
# working with Census data and with shapefiles in R

# load package
library(tidycensus)
library(tigris)
library(rgdal)
library(dplyr)

census_api_key("f6811bb29b8f3f4de930ececf654c6d0ebe6c7be", install = TRUE)

# get variables acs_2016 5 year estimates

acs_2016_5yr_variables <- load_variables(2016, "acs5", cache = TRUE)

# median household income is "B19013_001"

# use tidycensus to get data on medium household income for all Census tracts in California
ca_tracts <- get_acs(state = "CA",
                     year = 2016,
                     survey = "acs5",
                     geography = "tract",
                     variables = "B19013_001",
                     output = "tidy",
                     geometry = FALSE)

# explain get_decennial function

# Use tigris to get shapefile for Census tracts in California, imported as SpatialPolygonsDataFrame
ca_tracts_map <- tracts(state = "CA", year = 2016)

# plot
plot(ca_tracts_map)

# read in a shapefile from your computer
ca_tracts_map <- readOGR("ca_tracts_map", "ca_tracts_map")



# look at data behind the map
View(ca_tracts_map@data)

# join the median household income data to the map
ca_tracts_map@data <- inner_join(ca_tracts_map@data, ca_tracts, by = "GEOID")

# check the join has worked
View(ca_tracts_map@data)

# write out a shapefile 
writeOGR(ca_tracts_map, "ca_tracts_income", "ca_tracts_income", driver = "ESRI Shapefile")

# upload mapped data straight from R into a PostGreSQL/PostGIS database
# you will need to have the Postgres app running for this to work
library(RPostgreSQL)
library(rpostgis)

# create DB and set up local connection
system("createdb week14")
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "week14", host = "localhost")

ca_tracts_map <- spTransform(ca_tracts_map, CRS("+init=epsg:4326"))

pgInsert(con, 
         name = "ca_tracts_income", 
         data.obj = ca_tracts_map, 
         geom = "geom", 
         overwrite = TRUE, 
         df.mode = FALSE, partial.match = FALSE, new.id = NULL,
         row.names = FALSE, upsert.using = NULL, 
         alter.names = FALSE, encoding = NULL, return.pgi = FALSE)

##################

# load package
library(jsonlite)

# get san francisco 2018 police incident data from https://data.sfgov.org/Public-Safety/Police-Department-Incidents-Current-Year-2018-/956q-2t7k
incidents <- fromJSON("https://data.sfgov.org/resource/956q-2t7k.json?$limit=50000")

# see https://dev.socrata.com/

# look at the data
glimpse(incidents)

# this ensures we don't lose any decimal places when converting text values for lat and lon
options(digits = 17)

# process the data
incidents <- incidents %>%
  select(-location) %>%
  mutate(date = as.Date(date),
         latitude = as.double(y),
         longitude = as.double(x),
         hour = as.integer(substr(time,1,2)))


# if we're interested in theft from cars, what crimes should be included?
theft_types <- incidents %>%
  filter(grepl("theft|larceny", category, ignore.case=TRUE)) %>%
  select(category,descript) %>%
  unique()

# filter grand and petty theft from locked or unlocked auto
car_breakins <- incidents %>%
  filter(grepl("grand|petty", descript, ignore.case = TRUE)
         & grepl(" unlocked auto|locked auto", descript, ignore.case = TRUE))

# check we have just those types
car_breakin_types <- car_breakin %>%
  select(descript) %>%
  unique()

# let's just look at those locations
car_breakin_locations <- car_breakins %>%
  group_by(address) %>%
  summarize(count = n()) %>%
  arrange(desc(count))

# so let's remove those from our analysis
car_breakins <- incidents %>%
  filter(grepl("grand|petty", descript, ignore.case = TRUE)
         & grepl("unlocked auto|locked auto", descript, ignore.case = TRUE)
         & !grepl("800 block of bryant", address, ignore.case = TRUE))

# now convert to a spatial points data frame for mapping

# may need this line if your object is a tbl-df (which it will be if you imported using readr)
car_breakins <- as.data.frame(car_breakins)

# get just the lat and lon coordinates
xy <- car_breakins %>%
  select(longitude,latitude)

car_breakins <- SpatialPointsDataFrame(coords = xy, 
                                       data = car_breakins, 
                                       proj4string = CRS("+init=epsg:4326"))

pgInsert(con, 
         name = "sf_car_breakins", 
         data.obj = car_breakins, 
         geom = "geom", 
         overwrite = TRUE, 
         df.mode = FALSE, partial.match = FALSE, new.id = NULL,
         row.names = FALSE, upsert.using = NULL, 
         alter.names = FALSE, encoding = NULL, return.pgi = FALSE)


##################
# linear regression on schools data from  https://www.educationequalityindex.org/
# Performance of Students from Low-Income Families in Schools and Cities Across the Country 

# load packages 
library(readr)
library(dplyr)
library(GGally)
library(ggplot2)
library(forcats)

options()

write.csv()

# load data
oakland_eei_2015 <- read_csv("oakland_eei_2015.csv")

glimpse(oakland_eei_2015)

# visualize relationship between variables, and their distribution
oakland_eei_2015_pairs <- oakland_eei_2015 %>%
  select(-school_name)

ggpairs(oakland_eei_2015_pairs) +
  theme_minimal()

# explain this, in relation to some assumptions of multiple regression
# dependent variabale should be approximately normally distributed
# continuous variables should have a linear relationship with response variable
# explanatory variables should not be highly correlated with one another
# explanatpry variables should be independent
# you should have at least 10 to 20 times as many observations as you have explanatory variables
# consider removing extreme outliers

# that leads to trying this model

oak_fit1 <- lm(eei_score ~ pc_free_lunch + pc_black + charter + enroll_100, data=oakland_eei_2015)
summary(oak_fit1)

# Residuals:
#   Min      1Q  Median      3Q     Max 
# -47.770 -16.144  -2.293  12.326  48.813 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept)  29.2924     5.4652   5.360 4.51e-07 ***
#   pc_black     -0.3210     0.1014  -3.165 0.002000 ** 
#   charterY     19.0416     4.5395   4.195 5.49e-05 ***
#   enroll_100    2.8983     0.7460   3.885 0.000174 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 21.44 on 112 degrees of freedom
# (3 observations deleted due to missingness)
# Multiple R-squared:  0.3113,	Adjusted R-squared:  0.2929 
# F-statistic: 16.88 on 3 and 112 DF,  p-value: 4.111e-09

# take out free lunch
oak_fit2 <- lm(eei_score ~ pc_black + charter + enroll_100, data=oakland_eei_2015)
summary(oak_fit2)

# Residuals:
#   Min      1Q  Median      3Q     Max 
# -47.770 -16.144  -2.293  12.326  48.813 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept)  29.2924     5.4652   5.360 4.51e-07 ***
#   pc_black     -0.3210     0.1014  -3.165 0.002000 ** 
#   charterY     19.0416     4.5395   4.195 5.49e-05 ***
#   enroll_100    2.8983     0.7460   3.885 0.000174 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 21.44 on 112 degrees of freedom
# (3 observations deleted due to missingness)
# Multiple R-squared:  0.3113,	Adjusted R-squared:  0.2929 
# F-statistic: 16.88 on 3 and 112 DF,  p-value: 4.111e-09

oak_fit2 <- lm(eei_score ~ pc_black + charter + enroll_100, data=oakland_eei_2015)
summary(oak_fit2)



# take out the three outliers for enrollment
oakland_eei_2015_edit <- oakland_eei_2015 %>%
  filter(enroll_100 < 15)

# fit the model again
oak_fit3 <- lm(eei_score ~ pc_black + charter + enroll_100, data=oakland_eei_2015_edit)
summary(oak_fit3)

# Residuals:
#   Min      1Q  Median      3Q     Max 
# -45.122 -15.700  -2.461  11.135  49.081 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept)  23.9248     7.6779   3.116  0.00234 ** 
#   pc_black     -0.2894     0.1072  -2.700  0.00804 ** 
#   charterY     19.5028     4.5817   4.257 4.41e-05 ***
#   enroll_100    4.0856     1.4075   2.903  0.00448 ** 
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 21.55 on 109 degrees of freedom
# (3 observations deleted due to missingness)
# Multiple R-squared:  0.2997,	Adjusted R-squared:  0.2805 
# F-statistic: 15.55 on 3 and 109 DF,  p-value: 1.728e-08

# Global test of model assumptions
library(gvlma)
gvmodel <- gvlma(oak_fit2) 
summary(gvmodel)

# Residuals:
#   Min      1Q  Median      3Q     Max 
# -45.122 -15.700  -2.461  11.135  49.081 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept)  23.9248     7.6779   3.116  0.00234 ** 
#   pc_black     -0.2894     0.1072  -2.700  0.00804 ** 
#   charterY     19.5028     4.5817   4.257 4.41e-05 ***
#   enroll_100    4.0856     1.4075   2.903  0.00448 ** 
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 21.55 on 109 degrees of freedom
# (3 observations deleted due to missingness)
# Multiple R-squared:  0.2997,	Adjusted R-squared:  0.2805 
# F-statistic: 15.55 on 3 and 109 DF,  p-value: 1.728e-08
# 
# 
# ASSESSMENT OF THE LINEAR MODEL ASSUMPTIONS
# USING THE GLOBAL TEST ON 4 DEGREES-OF-FREEDOM:
#   Level of Significance =  0.05 
# 
# Call:
#   gvlma(x = oak_fit3) 
# 
# Value p-value                   Decision
# Global Stat        8.92348 0.06304    Assumptions acceptable.
# Skewness           5.21625 0.02238 Assumptions NOT satisfied!
#   Kurtosis           0.38174 0.53667    Assumptions acceptable.
# Link Function      0.03963 0.84220    Assumptions acceptable.
# Heteroscedasticity 3.28586 0.06988    Assumptions acceptable.

# recoding variables
library(forcats)

oakland_eei_2015_edit <- oakland_eei_2015_edit %>%
  mutate(charter = as.factor(charter))

levels(oakland_eei_2015_edit$charter)
# [1] "N" "Y"

oakland_eei_2015_edit <- oakland_eei_2015_edit %>%
  mutate(charter = fct_relevel(charter, "Y"))

levels(oakland_eei_2015_edit$charter)
# [1] "Y" "N"

# fit the model again
oak_fit4 <- lm(eei_score ~ pc_black + charter + enroll_100, data=oakland_eei_2015_edit)
summary(oak_fit4)

# Residuals:
#   Min      1Q  Median      3Q     Max 
# -45.122 -15.700  -2.461  11.135  49.081 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept)  43.4276     7.2336   6.004 2.58e-08 ***
#   pc_black     -0.2894     0.1072  -2.700  0.00804 ** 
#   charterN    -19.5028     4.5817  -4.257 4.41e-05 ***
#   enroll_100    4.0856     1.4075   2.903  0.00448 ** 
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 21.55 on 109 degrees of freedom
# (3 observations deleted due to missingness)
# Multiple R-squared:  0.2997,	Adjusted R-squared:  0.2805 
# F-statistic: 15.55 on 3 and 109 DF,  p-value: 1.728e-08

  
# explain logistic regression, and randomforest
