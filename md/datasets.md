# Datasets

Click on the title links to download the data. Email your instructors if you have any problems downloading.

## Class exercises

#### [Download Week 1](./data/week1.zip)

- `berkeley_collisions.csv` Data on injury and fatal traffic accidents in Berkeley from 2006 to 2014, from the [Transportation Injury Mapping System](http://tims.berkeley.edu/). The data comes from the California Highway Patrol’s [Statewide Integrated Traffic Records System](http://iswitrs.chp.ca.gov/Reports/jsp/userLogin.jsp) and was then geocoded for mapping by UC Berkeley’s Safe Transportation Research & Education Center.

- `mlb_salaries_2015.csv` Salaries of players in Major League Baseball at the start of the 2015 season, from the [Lahman Baseball Database](http://www.seanlahman.com/baseball-archive/statistics/).

#### [Download Week 3](./data/week3.zip)

- `calpads_cohort16_alameda.csv` The State of California publishes quite a bit of [high school graduation](https://www.cde.ca.gov/ds/sd/sd/filescohort.asp) data statewide, here filtered for Alemeda county only.
- `USGS_2.5_month.csv` USGS publishes [real time earthquake data](https://earthquake.usgs.gov/earthquakes/feed/v1.0/csv.php).
- `311_Cases_Dec2017.csv` San Francisco's 311 call records, from [SF's Open Data Portal](https://data.sfgov.org/City-Infrastructure/311-Cases/vw6y-z8j6), filtered for cases opened between 12/01/2017 12:00:00 AM and 01/01/2018 12:00:00 AM.

#### [Download Week 4](./data/week4.zip)

- `techexports.xls` [High-technology exports](http://data.worldbank.org/indicator/TX.VAL.TECH.CD) from 1990 to 2015, in current US dollars, from the UN Comtrade database, supplied via the World Bank. High-technology exports include products in aerospace, computers, pharmaceuticals, scientific instruments, and electrical machinery.

- `ucb_stanford_2014.csv` Data on federal government grants to UC Berkeley and Stanford University in 2014, downloaded from [USASpending.gov](https://www.usaspending.gov/Pages/Default.aspx).

- `alerts-actions_2017.xls` Records of [disciplinary alerts issued and actions taken](http://www.mbc.ca.gov/Publications/Disciplinary_Actions/) by the Medical Board of California in 2017.

#### [Download Week 5 & 6](./data/week5.zip)

- `ca_discipline.csv` Disciplinary alerts and actions issued by the Medical Board of California from 2008 to 2017. Processed from downloads available [here](http://www.mbc.ca.gov/Publications/Disciplinary_Actions/).
- `ca_medicare_opioids.csv` Data on prescriptions of opioid drugs under the Medicare Part D Prescription Drug Program by doctors in California, from 2013 to 2015. Filtered from the national data downloads available [here](https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/Part-D-Prescriber.html). This is the public release of the data that ProPublica used FOIA to obtain for earlier years for the story we discussed in Week 2. 
- `npi_license.csv` Crosswalk file to join [National Provider Identifier](https://npiregistry.cms.hhs.gov/) codes to state license numbers, processed from the download available [here](http://www.nber.org/data/npi-state-license-crosswalk.html) to include license numbers potentially matching California doctors.

#### [Download Week 12](./data/week12.zip)

- `pfizer.csv` Payments made by Pfizer to doctors across the United States in the second half on 2009. Contains the following variables:
 - `org_indiv` Full name of the doctor, or their organization.
 - `first_plus` Doctor's first and middle names.
 - `first_name` `last_name`. First and last names.
 - `city` `state` City and state.
 - `category of payment` Type of payment, which include `Expert-led Forums`, in which doctors lecture their peers on using Pfizer's drugs, and `Professional Advising.
 - `cash` Value of payments made in cash.
 - `other` Value of payments made in-kind, for example puschase of meals.
 - `total` value of payment, whether cash or in-kind.

- `fda.csv` Data on warning letters sent to doctors by the US Food and Drug Administration, because of problems in the way in which they ran clinical trials testing experimental treatments. Contains the following variables:
 - `name_last` `name_first` `name_middle` Doctor's last, first, and middle names.
 - `issued` Date letter was sent.
 - `office` Office within the FDA that sent the letter.

