## Week 9 | March 15, 2018
*Instructor: Amanda Hickman*

# 10 Min: Data of the Week

Carlos & Nikka

Let's take a few minutes to capture and organize [the presentation schedule](https://docs.google.com/spreadsheets/d/11JLkkyWZf3fvVz3aebgMjcZ6mxV-j5Gw7hEpeiPAGY4/edit#gid=0).

# SQL: What was tricky?

We're going to spend the next three weeks on SQL and mapping. I want to look at where folks got stuck and how to get unstuck.

Charlotte had a fun one this week, and I want to walk through some of my troubleshooting:

+ I didn't tell you what the redirect operator `>` does. Did anyone try it? What does it do?
+ Some of you tried running that in Postico, instead of in the Terminal. What's the difference?
+ Some of you tried to run "snippet.csv" -- why wouldn't that work?
+ Here's an example of a question that I immediately knew the answer to. What does that Error mean?:


    I tried loading the three datasets I have from AHS into Postico just to view the tables and I got:

    "ERROR:  relation "household" does not exist"

    This was the code I used to load the data:

    COPY household FROM '/Users/Charlotte/Desktop/Spring 2018/Data/AHS data/AHS files/household.csv' DELIMITER ',' CSV HEADER;

+ Which one is the Postgres table? Which is the csv file?
+ And then we encountered a new error. What clues do you see in this error? I had to look at the [Posgres COPY](https://www.postgresql.org/docs/9.5/static/sql-copy.html) documentation to resolve it.

    ERROR:  invalid input syntax for integer: "'11000001'"
    CONTEXT:  COPY household_snip, line 2, column CONTROL: "'11000001'"

+ If you're curious, here's a data sample:

```CSV
CONTROL,TOTROOMS,TOTHCAMT,PERPOVLVL,JACPRIMARY,JACSECNDRY,JADEQUACY,JARTACCESS,JARTATTRACT,JARTAWARE,JARTECON,
'11000001',7,'14',501,'0','0','2','0','0','0','0',
```

## Creating New databases

This might be easy. Try just running this in the Postico SQL Query pane:


```SQL

CREATE DATABASE week9;

```

If that doesn't work, then we get to do some fancy footwork. One more reason to learning to  love the command line. The Postgres documentation has a walk through for enabling [command line tools](http://postgresapp.com/documentation/cli-tools.html) but what did I say last week about `sudo`?

So we're going to use their second option.

```sh
echo $path
which psql
cd
nano .profile
```
You're going to edit your `.profile` file to add this line:

`export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin"`

Use <kbd>ctrl</kbd><kbd>o</kbd> then <kbd>ctrl</kbd><kbd>x</kbd> to save.

```sh
which psql
source ~/.profile
which psql
psql
```

That should get you into a postgres command prompt. Then we need to run `CREATE DATABASE week9;` in the psql command prompt. Use `\q` to exit.

## More Homework Troubleshooting


+ Josh had a question about [number formats](https://www.postgresql.org/docs/9.5/static/functions-formatting.html). Go ahead and [grab his data](https://drive.google.com/file/d/1qyVKQkpmJ1Tj4A0_He2rU_E1blcLkELg/view), create a table for it, and import the data into the table.

```sql
CREATE TABLE forfeiture (
	admin_number VARCHAR(17) NOT NULL,
	docket_number VARCHAR(24),
	amount_forfeit FLOAT NOT NULL,
	date_dispersed DATE NOT NULL,
	recipient VARCHAR(26),
	amount_dispersed FLOAT NOT NULL,
	county VARCHAR(14) NOT NULL,
	year INTEGER NOT NULL
);

COPY {tablename} FROM {file path} CSV HEADER;

SELECT county, year, SUM(amount_forfeit)
FROM forfeiture GROUP BY county, year ORDER BY county;

SELECT county, recipient, SUM(amount_forfeit)
FROM forfeiture WHERE county = 'Los Angeles' AND recipient = 'GENERAL FUND'
GROUP BY county, recipient ORDER BY county;
```

The second problem is super quirky. The short version is [math is hard](https://www.postgresql.org/docs/9.5/static/datatype-numeric.html) even for computers. And honestly I'm a little embarrassed that I've just never bothered to dig into this, so the best I can do is wave my hands around and mumble about how computers store numeric data and optimization. In fairness to myself the Postgres manual isn't a lot more specific:

> Inexact means that some values cannot be converted exactly to the internal format and are stored as approximations, so that storing and retrieving a value might show slight discrepancies. Managing these errors and how they propagate through calculations is the subject of an entire branch of mathematics and computer science and will not be discussed here

What I can tell you is what your options are for solving the problem.

There are a few different options. You can use [formatting](https://www.postgresql.org/docs/9.5/static/functions-formatting.html) to customize the number, you can [round it off](https://www.postgresql.org/docs/9.5/static/typeconv-func.html) or, you cast as [money](https://www.postgresql.org/docs/9.5/static/datatype-money.html).

```SQL
SELECT county, year, SUM(amount_forfeit::numeric)
FROM forfeiture GROUP BY county, year ORDER BY county;

/* You might want actual currency: */
SELECT county, year, SUM(amount_forfeit::numeric::money)
FROM forfeiture GROUP BY county, year ORDER BY county;

/* We're smart, so we can figure out how to make this work: */
SELECT county, year, to_char(SUM(amount_forfeit), '9999.00') as total
FROM forfeiture GROUP BY county, year ORDER BY total DESC;

```

I have a bigger question though: should we be taking the sum of all `amount_forfeit` to begin with? Try these two queries and let's discuss.

```SQL

SELECT * FROM forfeiture WHERE admin_number = '13-121J';

SELECT SUM(amount_forfeit) FROM forfeiture WHERE admin_number = '13-121J';

```



# Digging into Mapping

Cartography and GIS aren't the same thing. We're talking about very basic maps as visualizations here. [More on that](http://maptime.io/lessons-resources/)

## Shapes, Points, Lines

### Mapping Points
"Geocoding" refers to the process of identifying an individual latitude/longitude pair for an address or other location description. To actually plot a location on a map, you need the location's latitude and longitude. `219 West 40th Street` means nothing without coordinates.

Geocoding is actually challenging because there aren't good, free resources for doing batch jobs, where many addresses are geocoded at once. My [Geocoding Tip Sheet](https://github.com/amandabee/cunyjdata/wiki/Tip-Sheet:-Geocoding) includes some helpful resources, but many city data sources actually include coordinates, so double check that, first.

If you're committed to mapping points, you may need my help geocoding them.

### Mapping Lines
No student has ever pitched me a compelling map that features lines rather than shapes or points. I did a project that drew out flight maps showing how far from home every prisoner incarcerated in Florence, CO is, but I pitched that, so it doesn't count. To draw that map I had to take a [crash course](http://flowingdata.com/2011/05/11/how-to-map-connections-with-great-circles/) in rendering lines. If you're excited about doing something like this, great! But you're going to need to install R and walk through Nathan Yau's tutorial before you do anything else.

### Mapping Polygons
Zipcodes, council districts, police precincts -- these are all polygons. Most of your maps will be in polygons. These polygons are defined in (usually) one of two specialized file formats -- a "Shapefile" or a "KML" file. The syntax of the file types varies, but they contain basically the same information -- the polygon called "Bronx CB 04" is defined by this series of lat/lon pairs. My [Shapefiles Tip Sheet](https://github.com/amandabee/cunyjdata/wiki/Where-to-Find-Shapefiles) has some excellent resources for finding shapefiles though a lot of the resources there are New York City specific.

Often (usually) your data won't include a shapefile. If you have High School graduation rates by school districts, and you want to map those, you need to find a shapefile that describes the outline of each school district, and then you need to combine that shapefile with your data, by identifying a column that the two tables have in common.

## Projections
We don't deal with [projections](http://xkcd.com/977/) much but they matter. And if you have inconsistent projections you might end up with a map where the city of [San Francisco is floating about 10 miles NE of where it belongs](https://amandabee.carto.com/viz/d42d245a-5aa2-11e5-ba80-0e853d047bba/public_map).  I had to [ask for help](https://gis.stackexchange.com/questions/162779/why-is-the-city-of-san-francsico-floating-over-point-richmond) to resolve that.

Most of the time you're going to be in WGS84.

The Wikipedia article on [web mercator](https://en.wikipedia.org/wiki/Web_Mercator) is pretty good if you're dying to understand how this all fits together, but EPSG is an obsolete acronym for European Petroleum Survey Group a scientific research group with ties to the petroleum industry. They compiled a comprehensive database of projections and coordinate systems.  

## Vectors and Rasters

We can head down some serious rabbit holes here. But it is worth understanding the distinction between a [vector](https://en.wikipedia.org/wiki/Vector_graphics) and a [raster](https://en.wikipedia.org/wiki/Raster_graphics), because they'll come up again and again in all kinds of contexts.

## Shapefiles
What is a shapefile? There are a few different widely used formats for storing geographic information. ESRI makes ArcGIS which is popular and expensive. Their shapefile format is almost universal. Google Maps uses it's own KML format.

## Asking for help

I can't say enough about the importance of learning how to ask for help. If you look at my [gis.stackexchange.com](https://gis.stackexchange.com/users/24497/amanda?tab=questions&sort=newest) profile you can see where I got stuck and then unstuck, starting back in 2013. There's a community there that is very good about [thoroughly explaining](https://gis.stackexchange.com/questions/84443/what-is-this-postgis-query-doing-to-show-great-circle-connections) what you're dealing with.

# Open QGIS

Okay, so let's actually do some mapping.

In 2011, the BLS published a [map of fatal workplace injuries](https://www.bls.gov/opub/btn/volume-2/death-on-the-job-fatal-work-injuries-in-2011.htm) by state.

What do we think of this map?

* Are these colors continuous or categorical? Should they be? Is anyone surprised that CA and TX have a lot of workplace injuries? How can we improve on this?

<!-- Takeaway: BLS data is mapped, but it isn’t normalized to the population and the gradient makes no sense at all. -->

So we'll recreate it:
+ [BLS Fatality Data](data/week9/)
+ [2011 Population Estimates](https://www.census.gov/popest/data/state/totals/2011/tables/NST-EST2011-01.csv) (via [census.gov](http://www.census.gov/popest/data/historical/2010s/vintage_2011/state.html))

I already combined the Census 2011 population estimates with the BLS workplace fatality data. We're actually going to use Postgres to do the first piece of this -- we could do it just as easily in [a spreadsheet](https://www.libreoffice.org/discover/calc/) but we need the SQL practice.

```SQL
CREATE TABLE bls_fatalities_2011 (
  state character varying(20) NOT NULL,
  fatalities integer NOT NULL,
  population integer NOT NULL
);
```

Do you remember how to load data into a table?

And how are we going to normalize this?

```SQL
ALTER TABLE bls_fatalities_2011 ADD COLUMN fatality_rate float;
```

And then try out a query to fill that rate column:

```sql
SELECT *,
  ((fatalities::float/population)*100000) AS rate
  FROM bls_fatalities_2011
```

And then actually do it:

```sql
UPDATE bls_fatalities_2011 SET fatality_rate = ((fatalities::float/population)*100000);
```

Why did we have to re-cast it? Well, [because](https://dba.stackexchange.com/questions/200320/what-am-i-doing-wrong-with-my-math).
And then output it:

```sql
COPY bls_fatalities_2011 TO '~/Desktop/bls_normalized.csv' DELIMITER ',' CSV HEADER;
```

### Adding a shapefile
To actually map this, we need some states. Who keeps track of US State boundaries? [The Census](https://www.census.gov/geo/maps-data/data/tiger.html). You want "Cartographic Boundary Shapefiles" > "States". The state boundaries don't actually change, so it doesnt matter which year.

For our purposes 1:20,000,000 is plenty of resolution.

You should be able to load the zip file in as a layer.

Why does it look all squished? Once upon a time [I asked about that](https://gis.stackexchange.com/questions/167181/why-would-an-svg-output-from-cartodb-look-squished-when-the-map-doesnt), too. The answer is kind of cool. If we use the toggle on the bottom right to switch to "EPSG 54004" we get something that looks a little more familiar.  


### Loading a basemap

You need a basemap. The "tile map scale plugin" -- does a nice job of automatically zooming you to an available tile layer, which the other base map plugins don't do.

So go ahead and download the plugin. `Plugins > Manage and Install Plugins ...`  and search for "Tile Map Scale"

![adding a layer](img/week9_01.png)

That will give you a tiny pulldown on the map that lets you add a base layer so you can see where you are in the world.

### QGIS Built In Join

Add your CSV to QGIS (it has no geometry.)

Look at the Attribute table for the Shapefile. How are we going to join this?

And then style it.

* Use equal intervals. [I found a bug once](https://gis.stackexchange.com/questions/84562/am-i-misunderstanding-equal-interval) which is another reason to ask for help. They had no idea.

* Make compound labels with the `||` operator. Eg. `NAME  || '\n' || "bls_fatalities_2011_Workplace Fatalities 2011"`


## Keep going with QGIS

This series is highly recommended:
<https://www.youtube.com/watch?v=Pf9cYvaCYWA&index=3&list=PL7HotvlLKHCs9nD1fFUjSOsZrsnctyV2R>



# Advanced query
We probably won't get to this. And this week all we're going to do is talk it through. We're not going to tackle it.

In 2006, California voters passed [Prop 83](http://www.lao.ca.gov/ballot/2006/83_11_2006.htm), which requires registered sex offenders to live at least 2000 feet from any school or playground. In 2015, the state supreme court said the [blanket restriction was too broad](https://www.nbclosangeles.com/news/local/California-Loosens-Sex-Offender-Residency-Restrictions-297740931.html) and the law could only be applied to offenders whose crimes involved children.

Sex offender restrictions buffered around schools to show how much of a city is off limits.
* Walk through how we would do it, in theory. What do we need?

```
+ location of every public school in the county
+ location of every private school in the county
+ location of every playground in the county
```

Alameda publishes at least the schools: <https://data.acgov.org/Education/Alameda-County-Schools/yza6-6jwu>

Then we're going to need a way to calculate circles around those points. I want you to take five minutes to think of a Google search that might let you get at that. Put your search terms in the Etherpad.

<!-- http://postgis.net/docs/ST_Buffer.html -->


More applications of this? If you aren't following SB 827 you should be. So how would you map the impact of that bill? <https://transitrichhousing.org/> tried.


# Homework
I want you to find one shapefile that is relevant to your story, load it and label it. By Wednesday night you should be able to send me a screenshot of QGIS with the data loaded as well as a clear sentence or two describing the source of the data, the URL you got it from, and the relevance to your project.


I keep a [list of shapefile sources](https://github.com/amandabee/CUNY-SOJ-data-storytelling/wiki/Where-to-Find-Shapefiles), and a [list of geocoders](https://github.com/amandabee/CUNY-data-storytelling/wiki/Tip-Sheet:-Geocoding) which you'll need if you have addresses, but no latitude or longitude. Note that for this week's homework I want you to identify a shapefile.

The Data of the Week is a little scattered so let's fill in a Google Spreadsheet:
[with the presentation schedule](https://docs.google.com/spreadsheets/d/11JLkkyWZf3fvVz3aebgMjcZ6mxV-j5Gw7hEpeiPAGY4/edit#gid=0).
