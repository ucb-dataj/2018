## Week 3
*Instructor: Amanda Hickman*

Spreadsheets are the simplest tool in your data toolbox. There are some real limitations that you'll encounter when you try to use spreadsheets for large datasets or complex, reproducible analysis, but some facility with core spreadsheet functions will go a long, long way towards improving your data skills.

We're going to use Google Sheets in class, but [LibreOffice Calc](https://www.libreoffice.org/download/download/) is a great, open source option.

## Filtering:

## Formulas
Basics: =SUM, =AVERAGE
Advanced spread sheetery (RIGHT, LEFT, TRIM)



....................

Notes for heavy revision...

We're going to look at Oakland 311 data.

Later this semester, we'll use some much more powerful tools, especially R. And the honest truth is that spreadsheets can be super dangerous. It's hard to keep track of the transformations you're applying when they're hidden in spreadsheet functions.

Bonus: CSV Kit (installing it and using it to break up a data set)


https://github.com/amandabee/CUNY-SOJ-data-storytelling/wiki/Tutorial:-Installing-CSVKit
..............

</home/amanda/Public/CUNY_Coursebits/CUNY-data-skills_pages/\_posts/2015-02-11-refine.md>

## Keep spreadsheeting
Filter [NYC's 311 call data](https://nycopendata.socrata.com/Social-Services/311-Service-Requests-from-2010-to-Present/erm2-nwe9?) to include only Noise complaints from 2014. (Use `Complaint Type`, `starts with` and "Noise"; then add a second filter for `Created Date` between January 1, 2014 and January 1, 2015.)

Play around with it and post *something* interesting to the tumblr, tagged `311 assignment`.

## Pitches
We'll be working in pairs on community profiles.

> Students will work in pairs to compile a portfolio of data about a single community, based primarily on publicly available data, though where appropriate students are welcome to incorporate proprietary intelligence. Identify at least eight salient characteristics (is income relevant? educational attainment? is this community anchored in a single location or geographically dispersed?) and points of comparison (neighboring communities, for instance, in the case of a geographically-based community), and find data to quantify those characteristics.

> Your final product will be a short report that describes the community in numbers and puts those numbers in context.

What am I looking for in a pitch?

> Pitches: A complete pitch should tell me who cares, why we care now, and what pre-reporting you’ve done. You must include:
    a proposed title or headline
    a slug – up to three words that capture the essence of your profile
    a list of the defining characteristics of this community
    For your community profile: propose at least ten data points you’d like to work with and explain why each is relevant.

Start organizing your data.

Create a [Github gist](https://gist.github.com/) of your pitch (Public or Secret is up to you) and post it to the [assignments document](https://docs.google.com/a/journalism.cuny.edu/document/d/1kUg2EfTBZsK0HG5TAenIa68_d9B6Od6uO6B_BRch0SE/edit?usp=sharing). Follow my format. If you decide to use [Markdown](http://daringfireball.net/projects/markdown/dingus) to format your document, be sure the name has a `.md` extension.

## Software and Accounts

Make sure [Open Refine](http://openrefine.org/) is  installed on your computer.

Create an account on [Git Hub](http://www.github.com) and send me your handle.

Sign up for your CartoDB Academy plan. Start at <http://cartodb.com/industries/education-and-research/> and select the "Free" plan from the options at the bottom of the page. That will take you to <https://cartodb.com/signup?plan=academy> to
sign up. That *should* get you the plan you need for our purposes. Be sure to use your `@journalism.cuny.edu` address!



..............


I keep a running list of my favorite spreadsheet commands on the [cunyjdata wiki](https://github.com/amandabee/cunyjdata/wiki/Tip-Sheet:-Spreadsheets). That's a great resource.

## From this week's assignment:

Cristina found a [pretty interesting data set](
http://www.nyc.gov/html/dot/downloads/misc/outreach_schools.json) that is in JSON.
There are a lot of different ways to convert JSON to CSV. [This is one.](https://json-csv.com/)

+ Convert it to CSV
+ Open it in Excel
+ Pivot -- you probably *don't* want column A.
+ Let's use `features__properties__Activity` as our Row Labels and a count of `features__properties__FID` for our Values

So what have they been up to?

+ Add the dates as a column label, and then right click on **row 4** of the pivot table itself to `group` by `Month`.

## Education Outcomes

Download [2005-2010 Graduation Outcomes Data](https://data.cityofnewyork.us/Education/Graduation-Outcomes-Classes-Of-2005-2010-By-Boroug/avir-tzek)

Pivot, use Boroughs as row labels, Demographic as column labels, % of cohort as the Value.
Play around. Add "Cohort" as a row label.

In groups of 3, what's interesting about this data? What would you like to chart. How could you pivot to get to what you want to chart?

## Flu Trends

Google tracks searches for flu-related terms. Start at <http://www.google.org/flutrends/> -- it is worth reading up on how they produce this data so you have a sense of the limitations of it, but we're just going to play with it.

Open it in a spreadsheet. Use `Data > Text to Columns` to break it up if it isn't already broken up. Hint: it is "comma delimited"

+ In which week did which country have the most flu searches?  
	`=Max()`  
	`=Match(criterion, range, 0)`  
	`=Indirect(“A”&cell)` to get date or re-order columns
+ How much more did that country search for flu in that week than average?
+ Order the countries by most flu searches (SUM...choose arbitrary 2012-13 to capture searches from all countries, Transpose countries-values to make a quick bar chart)

## Noise Complaints by CD

Starting at [the dataset of datasets](https://nycopendata.socrata.com/dashboard), find 311 complaints and filter for noise.


................
#Install
If you haven't already [installed csvkit](https://github.com/amandabee/CUNY-SOJ-data-storytelling/wiki/Tutorial:-Installing-CSVKit), start by [installing it](https://github.com/amandabee/CUNY-SOJ-data-storytelling/wiki/Tutorial:-Installing-CSVKit)

# Walk-thru 1: DOB Complaints

<https://github.com/amandabee/CUNY-SOJ-data-storytelling/wiki/Tutorial:-CSVkit>

# Walk-thru 2: MapPLUTO

NYC's Department of City Planning publishes incredibly useful [property maps of NYC](http://www.nyc.gov/html/dcp/html/bytes/applbyte.shtml). Not for nothing, these are available on Socrata, but if you find them on NYC Open Data you're way (way) better off going back to the agency that provides the data. Among other things, City Planning provides clear context for their data.

Today the link for the most up to date MapPLUTO data is <http://www.nyc.gov/html/dcp/html/bytes/dwn_pluto_mappluto.shtml> but that may change. Download the CSV format. You'll see why in a moment.

## Set Up For Command Line

For everyone's sanity, I'd like everyone to use **the same** file and folder names. So ...

1. Download the data (or copy it from Baker)
2. Make a folder called "pluto"
3. Move the data into that folder and unzip it
4. Open a terminal from that folder.

# Command Line Basics

We're going to use a bunch of command line tools to work with these files.

## Vanity
Before we do more, go ahead and look under `Terminal > Preferences` and set the default to "Homebrew" -- you can futz with that on your own later if you'd like a different color scheme.

## Getting Around
You don't actually have to launch the terminal from the folder every time -- but since you can, we're not going to walk through that part (though if you want to do more with this, I recommend [Zed Shaw](http://cli.learncodethehardway.org/).)

+ `ls` should show you a list of files. If it doesn't, use `pwd` to make sure you're in the right directory.
+ use `wc --help` to figure out what `wc` does
+ `wc -l BK.csv` and  `wc -l *.csv` -- what do you think the `*` does?
+ `head BK.csv` or `tail BK.csv` (what do `head` and `tail` do?)
+ what does `split` do? Split is incredibly useful if you find yourself in over your head. You can at least open a chunk of the data and figure out if it is even something you can work with.
+ `split -l 5000 MN.csv Manhattan_chunks`
+ Use `wc -l Manhattan*` to see the length of each.
+ Play with tab completion. What happens if you just type Man<kbd>tab</kb>?
+ We actually don't need those, so do `ls Manhattan*` and see what that gets you, then do `rm Manhattan*` to delete the files. I always use `ls` as a sanity check when I'm about to delete files, especially when I'm using a regular expression to catch more than one file.
+ `du -h ./*.csv` -- this gives us the size of each of these files in `-h` a human readable format. So these are big files, even without the polygons.


## Installing CSVkit
So far, we've been using built-in shell commands. But I want everyone to do this `which pip` -- if you get a path like `/usr/bin/pip` that means that `pip` is on your computer. If you get an error or another command prompt, you must log in to a lab computer and we'll troubleshoot your computer later.

Then do `pip install --user csvkit` -- if you had admin privs on this machine you could install it everywhere, but the `--user` flag means you're only installing it for you.

+ csvcut -n BK.csv

How many columns are there?

If we only want to work with the following columns:

+ LandUse
+ OwnerType
+ ZoneDist
+ AssessTot
+ ExemptTot
+ Council
+ ZipCode
+ Address
+ CDTaxLotTaxBlock
+ XCoord
+ YCoord

What column numbers are we working with?

+ LandUse **26**
+ OwnerType **28** (Try `csvcut -n BK.csv | grep Own`)
+ ZoneDist
+ AssessTot **55**
+ ExemptTot **57**
+ Council **8**
+ ZipCode **9**
+ Address **12**
+ CD **4**
+ Lot **3**
+ Block **2**
+ XCoord **72**
+ YCoord **73**

So let's check that:

`csvcut -c 26,28,55,57,8,9,12,4,3,2,72,73 MN.csv`

*Oh man oh man oh man, there's a ton of crap spewing down your screen like you're caught in the matrix!!*

That's cool. We can wait.


`csvcut -c 26,28,55,57,8,9,12,4,3,2,72,73 MN.csv`

## Redirection

We're not going to go deep into this, but one of the nice things I can do at the command line is take the output of a command and, instead of writing it to `stdout` (aka the screen)

`csvcut -c 26,28,55,57,8,9,12,4,3,2,72,73 MN.csv | head`


`csvcut -c 26,28,55,57,8,9,12,4,3,2,72,73 MN.csv > smaller_MN.csv`

`csvcut -c 26,28,55,57,8,9,12,4,3,2,72,73 BX.csv > smaller_BX.csv`

`csvcut -c 26,28,55,57,8,9,12,4,3,2,72,73 SI.csv > smaller_SI.csv`

`csvcut -c 26,28,55,57,8,9,12,4,3,2,72,73 QN.csv > smaller_QN.csv`

`csvcut -c 26,28,55,57,8,9,12,4,3,2,72,73 BK.csv > smaller_BK.csv`

That is going to take a few minutes. That's okay.

Now try `du -h ./*.csv` -- we've already shrunk our files way, way down.

That's huge. These are now much, much more manageable files. And in this case, we are *only* interested in Vacant Land. From the data dictionary, I know that that's "LandUse" code 11. So we can use another command, `csvgrep` to find a pattern in the data:

`csvcut -n smaller_MN.csv`

`csvgrep -c 1 -m 11 smaller_MN.csv > vacant_MN.csv`



##Stacking
Now, I actually used this:

`csvstack -g BK,BX,MN,QN,SI smaller_BK.csv smaller_BX.csv smaller_MN.csv smaller_QN.csv smaller_SI.csv > FiveBoro.csv` to get a single file for all five boros.


And then I used grep to find the vacant lots:
`csvcut -n FiveBoro.csv`

`csvgrep -c 2 -m 11 FiveBoro.csv > vacant_FiveBoro.csv`

## TK TK TK
*LandUse: *Only 11 (vacant land)

*OwnerType:*
P (Private Ownership)
*BLANK* (possibly privately-owned)
I want to combine C, M, O, and X into another category, which is ownership
that's mixed or public

*ZoneDist*
I am primarily concerned with lots currently listed as
R1-1 - R10H (Residential)
M1-1/R5 - M1-6/R10 (Mixed Manufacturing and Residential)
*Then I want to combine all the other zoning categories: *
C1-6 - C8-4
M1-1 - M3-2
ZNA
ZR 11-151


## CSVkit

We're going to use a little Python program called [csvkit](http://csvkit.readthedocs.org)

`pip install --user csvkit`

## Experimenting
Using the complete 311 files on Baker


Use [`wc -l`](http://unixhelp.ed.ac.uk/CGI/man-cgi?wc) and `split`

and `less -N` (or `=` while in `less`)

`head` and `tail`
