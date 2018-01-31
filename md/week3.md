## Week 3
*Instructor: Amanda Hickman*

### Presentations
Chenwei Tian & Chloe Lessard


### Quiz Review
How did we do? Peter is going to grade them, but we can use Google Spreadsheets to check our answers to some questions.

> 4. An agency’s budget was $21 million in 2017. It is $24.5 million in 2018. What was the percentage increase, rounded to one decimal place?

Can we use a spreadsheet formula to calculate this? (Yes. So open Google Sheets ...)

> 5. There were 15,000 violent crimes in 2017 in city A, which had a population of 350,000. There were 9,000 violent crimes in City B, which had a population of 500,000. Complete the following sentence with a number rounded to one decimal place: “City A’s violent crime rate was ... times that of city B.”

What we need to do is normalize the data to the population.

| City | Crimes | Population | Rate         
|------|--------|------------|-----------------|
| A    | 15000  | 350000     |                 |
| B    | 9000   | 500000     |                 |



## Spreadsheets

Spreadsheets are the simplest tool in your data toolbox. There are some real limitations that you'll encounter when you try to use spreadsheets for large datasets or complex, reproducible analysis, but some facility with core spreadsheet functions will go a long, long way towards improving your data skills.

Sort, filter, summarize, group and join.

We're going to use Google Sheets in class, but [LibreOffice Calc](https://www.libreoffice.org/download/download/) is a great, open source option. Excel is also perfectly good, though it's been a long time since anyone showed me a reason to choose it over LibreOffice.


### Filtering:

On a data set the size of ProPublica's Medicaid data, you aren't going to be able to use Google Sheets (which has a max of ~200K cells -- meaning that a four column spreadsheet can only accommodate 50K rows). So as the semester progresses and we move into tools that are way harder to use than spreadsheets are, it's because we can't use a spreadsheet.

Open [`311_Cases_Dec2017.csv`](raw-data/week3/311_Cases_Dec2017.csv) . We're going to start by just sniffing around. The best way to get it into a Google Drive spreadsheet is to use `File > Import ...`

The data is San Francisco's 311 call records, from [SF's Open Data Portal](https://data.sfgov.org/City-Infrastructure/311-Cases/vw6y-z8j6) -- I used their service to filter out only the cases opened between 12/01/2017 12:00:00 AM and 01/01/2018 12:00:00 AM.

Click in any cell in the header row and look for the 'filter' icon. Click it. It will take a minute but we'll get a little filter icon in each header cell, and then we can start to skim a bit. Try filtering by status, and source.

Notice that it takes a minute to get through this data.


### Pitches

In groups of 3, pull up your pitches and go over them. Questions to ask:
* Is this enough? too much?
* "Compared to What?" -- what are the points of comparison you'd want to see as a reader?
* What would make it more interesting? Feel free to riff, speculate, and brainstorm but also try to dial in what you think this is going to need as a story.

You have 5 minutes each, so do dial in your elevator pitch.

No records requests w/out a backup plan. 

Most of you need to:
a) get your hands on the actual data and make sure there's something there, and
b) go do some reading of other reporting on this.



## Formulas

I keep a running list of my favorite spreadsheet commands on a [course wiki](https://github.com/amandabee/cunyjdata/wiki/Tip-Sheet:-Spreadsheets) -- it's a great resource.

You went over the basics week 1: `=SUM`, `=AVERAGE`, `=MAX`, `=MIN`



| City | Crimes | Population | Formula         | Rate |
|------|--------|------------|-----------------|------|
| A    | 15000  | 350000     | =(B2/C2)*100000 | 4286 |
| B    | 9000   | 500000     | =(B3/C3)*100000 | 1800 |



## Pivot Tables

Later this semester, we'll use some much more powerful tools, especially R. And the honest truth is that spreadsheets can be super dangerous. It's hard to keep track of the transformations you're applying when they're hidden in spreadsheet functions. But: you can do a lot in spreadsheets and sometimes they're exactly the right tool.

+ Turn off the auto-filter.
+ Make sure you don't have any data selected.
+ `Data > Pivot Table...`
+ Add `Responsible Agency` and then `Category` as rows
+ Add `CaseID` as value.
+ Take a look at the default operation: is the sum of all case ids a useful value?
+ Add `Supervisor District` as columns.
+ Use "Sort by" to sort within the Pivot Table.


### Try it:

If you wanted to quickly see the opened vs closed case count for each Supervisor's district, how would you do that?

### More Data: Earthquakes

The USGS publishes [real time earthquake data](https://earthquake.usgs.gov/earthquakes/feed/v1.0/csv.php), but the locations they include are not something we can sort by.

Start by using `Data > Text to Columns ... ` to separate out the broad location from the specifics.

+ Filter for blank cells. We can copy and paste to fill in the blank cells.

+ Create a pivot table -- use "COUNT of Mag"; sort it by count.

+ Go back to the spreadsheet and Categorize by magnitude. I made the slightly arbitrary decision that we're going to call everything below 4.5 "Minor", and everything above 6.0 "Strong" -- the USGS actually has a few more grades in their system, but these are good buckets.

#### `=LOOKUP(E2,{0,4.5,6},{"Minor","Moderate","Strong"})`

+ Fill Down: Select F2 through F6 and do <kbd>ctrl</kbd><kbd>d</kbd> -- that's one "fill down" option. Or grab the blue box and pull down. Or, hover over the little blue square and double click. They're all good options.

+ Go back to your pivot table and add the "categories" as columns.

## More Data: Graduation Outcomes

The State of California publishes quite a bit of [high school graduation](https://www.cde.ca.gov/ds/sd/sd/filescohort.asp) data statewide. Open  [calpad_cohort16_alameda.csv](raw-data/week3/calpads_cohort16_alameda.csv) in Google Sheets.

Note that the statewide data comes with a 14 digit code. Take a look at the [dictionary](https://www.cde.ca.gov/ds/sd/sd/fscohort.asp) and let's figure out how to break out the CDS into county, district, school.

If we want to know how Oakland Technical compares to the rest of Oakland's High Schools, how would you approach that?


# CSVKit

If we power through spreadsheets, I want to show you CSVkit, which is a powerful command line tool for chewing through data that's a little too big (or not) for a spreadsheet.

https://github.com/amandabee/CUNY-SOJ-data-storytelling/wiki/Tutorial:-Installing-CSVKit

# Homework

Installs: you need to have chrome installed; and open refine.

Pivot Table Exercise

Data Presentation *Feb. 8*
Cat Schuknecht & James Steinbauer
