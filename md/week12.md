# Practice with R

### Getting reacquainted with the tidyverse

The goal of today's class is to practice the skills we learned in weeks 5 and 6. This will not be an excercise in copying and pasting code. Instead, you will work in small groups to answer questions from the data, in two stages.

**1)** In plain English, work out the sequence of steps to achieve the desired result, using our basic operations with data:
 - **Sort:** Largest to smallest, oldest to newest, alphabetical etc.

 - **Filter:** Select a defined subset of the data.

 - **Summarize/Aggregate:** Deriving one value from a series of other values to produce a summary statistic. Examples include: count, sum, mean, median, maximum, minimum etc. Often you'll **group** data into categories first, and then aggregate by group.

 - **Join:** Merging entries from two or more datasets based on common field(s), e.g. unique ID number, last name and first name.

**2)** Convert those steps into **dplyr** code.

### The data we will use today

Download the data for this session from [here](data/week12.zip), unzip the folder and place it on your desktop. It contains the following files, used in reporting [this story](https://www.newscientist.com/article/dn18806-revealed-pfizers-payments-to-censured-doctors/), which revealed that some of the doctors paid as "experts" by the drug company Pfizer had troubling disciplinary records:

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

### Setting up

As before, save your R script to the folder with your data, then set the working directory to this folder by selecting from the top menu `Session>Set Working Directory>To Source File Location`. Then load the packages you will need today by running this code:

```R
library(dplyr)
library(readr)
library(lubridate)
library(ggplot2)
```
#### Load and view data

Load and inspect the two files containing the data. We will discuss the data in class before we get started with this exercise.

#### Find doctors in California paid $10,000 or more by Pfizer to run “Expert-Led Forums.”

List them in descending order of the total received.

#### Find doctors in California *or* New York who were paid $10,000 or more by Pfizer to run “Expert-Led Forums.”

Again, list them in descending order of the total received.

#### Find doctors in states *other than* California who were paid $10,000 or more by Pfizer to run “Expert-Led Forums.”

Again, list them in descending order of the total received.

#### Find the 20 doctors across the four largest states (CA, TX, FL, NY) who were paid the most for professional advice.

#### Filter the data for all payments for running Expert-Led Forums or for Professional Advising, and arrange alphabetically by doctor (last name, then first name)

For brevity, filter using the `grepl` function we encountered in week 6.

#### Write the data from the previous query to a CSV file

#### Calculate the total payments by state

List the states in descending order of the total received.

#### Calculate the total payments by state and category

Sort by state and category.

#### Filter the FDA data for letters sent from the start of 2005 onwards

#### Count the number of letters issued by year

For this one you will need to extract the year from the dates.

#### Count the number of letters issued by year and month

The resulting data should contain entries for Jan 2005, Feb 2005, and so on. You will need to extract both years and months from the dates.

#### Find doctors paid to run "Expert-led forums" who also received a warning letter from the FDA

Your final result should contain just these variables: `first_plus`, `last_name`, `city`, `state`, `total`, `issued`.

#### Find the doctor paid the most by Pfizer (across all categories of payment) who also received a warning letter from the FDA

Do this in two steps: First calculate the total payments per doctor across all categories; then join that data frame to the FDA data. Make sure that the grouping variables in your initial calculation include those you'll need to make the join!

Again, your final result should contain just these variables: `first_plus`, `last_name`, `city`, `state`, `total`, `issued`.

For both of the last two queries, further research would be needed to confirm that the doctors matched are the same individuals!

### Assignment

 - Complete the queries listed above, filing your entire R script via bCourses.

### Further reading

**[Introduction to dplyr](https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html)**

**[RStudio Data Wrangling Cheet Sheet](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf)**

**[Stack Overflow](http://stackoverflow.com/)**
For any work involving code, this question-and-answer site is a great resource for when you get stuck, to see how others have solved similar problems. Search the site, or [browse R questions](http://stackoverflow.com/questions/tagged/r)

