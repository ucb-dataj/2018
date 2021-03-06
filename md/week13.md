## Week 13 -- April 19, 2018
*Instructor: Amanda Hickman*

# Fixing your path

This is a good explanation of the command path issues we were navigating last time we worked in the terminal:

http://www.tech-recipes.com/rx/2621/os_x_change_path_environment_variable/k

Roughly, your command line interpreter, `bash`, uses a variable called `PATH` to decide where to look for programs to run. If you run `echo $PATH` at the command line, you can see a list of all the directories your shell looks in for executable programs. Yours is probably different from mine, but on my primary laptop (which runs Ubuntu, not OSX), my path looks like this:

```bash
amanda@mona:~$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/local/heroku/bin:/opt/venvs/vdirsyncer-latest/bin/

```

Note that I manually added a few paths there: `/usr/local/heroku/bin` lets me run a handful of specialized heroku commands, and `/opt/venvs/vdirsyncer-latest/bin/` lets me run vidirsyncer, which I'm super happy to talk about but is kind of a rabbit hole in this context.

If you want to run a program that isn't in your `PATH` variable, you have to use the "absolute path" -- the full path to the program, starting with `/` for the root directory. Alternatively, you can edit your `PATH` to include the path to the directory that includes that program.

To add `shp2pgsql` so you can access it easily, you want to tell your shell that it needs to look in `/Applications/Postgres.app/Contents/Versions/10/bin/` for programs.

To do that, you're going to edit a hidden file in your home directory (probably `/Users/yourname/`) called `.profile`, to add a line like:

    export PATH=/Applications/Postgres.app/Contents/Versions/10/bin/:$PATH

`PATH` is the [shell variable](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameters.html#index-shell-variable) that contains the array of directories that bash looks in to find executable programs, and we print the contents of that variable with `$PATH`. This command `exports` or "sets" a new `PATH` by concatenating the new directory (`/Applications/Postgres.app/Contents/Versions/10/bin/`) that you want to include, with the existing values stored in `PATH`.

# Do you have enough RAM for this?

I was surprised to discover that quite a few of you couldn't actually load the US zipcode file into postgres via Postico. My suspicion is that you could load it if you use the command line tools, but Postico wasn't able to load the whole thing into its preview window -- queueing it up so you can scroll around in it takes more memory than just loading it.

Use [these instructions](https://support.apple.com/en-us/HT201260) to find some basic information about your computer. Please complete this survey: https://goo.gl/forms/oIsHQAUuyWREvlrC3 so we can get a handle on the problem.

# Data of the Week
Charlotte and Susie are up:
https://docs.google.com/spreadsheets/d/11JLkkyWZf3fvVz3aebgMjcZ6mxV-j5Gw7hEpeiPAGY4/edit#gid=0

# SQL Vocabulary
Quick follow up to a conversation we had two weeks ago about why FLOAT is a synonym for DOUBLE PRECISION, and what that means to begin with. The short answer is "it has something to do with how computers store data" -- As for almost any arcane topic in mathematics and computing there is a wikipedia article that goes deep on the finer points. [Floating point arithmetic](https://en.wikipedia.org/wiki/Floating-point_arithmetic) is no exception.

You can see the full list of data types that Postgres supports in [the Postgres documentation](https://www.postgresql.org/docs/10/static/datatype.html). You're almost always going to be using one of only a few:  numeric, float, integer, text, char, varchar, and geometry.

  format   | usage
  ---------|--------
  NUMERIC  | any number -- this is the preferable format but some systems default to `FLOAT` if you don't specify `NUMERIC`
  FLOAT    | a decimal number, synonymous with `DOUBLE PRECISION`-- if you plan to do any math on the number, `NUMERIC` is preferable
  INTEGER  | any whole number
  BIGINT   | very large integer (> 2.1B or < -2.1B)
  TEXT     | any text -- this is an efficient format to use in Postgres but in other SQL databases you may not be able to index, search or sort a `TEXT` column. It isn't standard across SQL implementations.
  CHAR     | text that is always the same length
  VARCHAR  | text of varying length
  GEOMETRY | geographic data (points, lines, polygons)


# Hands On PostGIS

We started this two weeks ago and hit some walls that I wasn't expecting, so let's try again. Download the [Week 13 data](data/week13.zip) bundle so you have everything in one place.

## Where are you working?

[Remember](week11.html) that to do PostGIS queries you will need to make sure you've enabled it on the database you're working in, with `CREATE EXTENSION postgis;` -- so make sure that you're working in a database where you've enabled postgis.

## Find Alameda County zipcodes

what are the zipcodes that are overlap with Alameda county. Start by spelling out how you'd approach this. Can you describe in words what you're trying to do? Write this in a comment at the top of your script.

You're looking for a way to capture all the shapes in one layer that intersect with a single shape in another layer.  The census publishes [zipcode boundaries for the whole US](https://www.census.gov/geo/maps-data/data/cbf/cbf_zcta.html), but for some of your computers that was too much data, so I cut it down to just California zipcodes for you. You'll need the [sql](https://ucb-dataj.github.io/2018/data/week13/ca_zips.sql) to create a table and the data itself is in a [separate csv](https://ucb-dataj.github.io/2018/data/week13/ca_zips.csv).

Alameda County's open data portal publishes a [county boundary file](https://data.acgov.org/Geospatial-Data/County-Boundary/rygg-x9nr). I already used [`shp2pgsql`](http://bostongis.com/pgsql2shp_shp2pgsql_quickguide.bqg) to convert the shapefile to SQL.

1. Use `shp2pgsql` to convert the Shapefile into SQL.
2. Import the SQL into Postgres. You can either
  a. use Postico's "Load Query" button to load `alameda_county_boundary.sql`, or  
  b. use `psql` at the command line with `psql -d week11_postgis -f alameda_county_boundary.sql` (but note that `week11_postgis` is my database name. You may not have named your database `week11_postgis`.)
3. Create a spatial index. You can either
  a. Load it into QGIS and click "create index" or
  b. run `CREATE INDEX sidx_alameda_geom ON alameda USING gist (geom);`


### Find Your PostGIS command

  There are a few that sound like they might be what we want: [ST_Within](http://postgis.net/docs/ST_Within.html), [ST_Contains](http://postgis.net/docs/ST_Contains.html),  [ST_Intersection ](http://postgis.net/docs/ST_Intersection.html),  [ST_Intersects](http://postgis.net/docs/ST_Intersects.html). Take a look at the documentation: how do these differ?


We're going to use [ST_Intersects](http://postgis.net/docs/ST_Intersects.html) to find all the California zipcode shapes that intersect with Alameda county.

```SQL

SELECT
  alameda.geom AS county_geom,
  alameda.name AS county,
  zipcodes.zcta5ce10 AS zipcode,
  zipcodes.geom as zip_geom
FROM
  alameda, zipcodes
WHERE
  ST_Intersects(zipcodes.geom, alameda.geom) AND alameda.name = 'Alameda County';

```

Since that seems like it worked, make a table out of that:

```sql
CREATE TABLE alameda_zipcodes AS
  SELECT zipcodes.* FROM zipcodes, alameda
  WHERE ST_Intersects(zipcodes.geom, alameda.geom) AND alameda.name = 'Alameda County';

```


### Troubleshooting

You're going to wind up capturing a few zipcodes that only cross the county line in tiny spots. Can you brainstorm some ways to address those?


## Find San Francisco zipcodes

San Francisco doesn't publish a handy county file, so I pulled down the [TIGER county shapefiles](https://www.census.gov/geo/maps-data/data/cbf/cbf_counties.html). This is smaller than the zipcode file but it's still pretty big, so I also ran it through [`shp2pgsql`](http://bostongis.com/pgsql2shp_shp2pgsql_quickguide.bqg) with `shp2pgsql cb_2017_us_county_20m.shp counties postgres > counties.sql`, and then pruned it by loading it into Postgres and running:

    DELETE FROM counties WHERE statefp != '06';

You can load the smaller, California only file from the [week 13 data](data/week13.zip) file -- it's `counties.sql`.

### Find all the zipcodes in San Francisco county? What about Fresno county?

Start by writing down the steps you need to take, then ... take them.


## Create mappable points

San Francisco publishes [car break in data](https://data.sfgov.org/Public-Safety/Car-Break-ins/6har-q36k).

Can you ...
* Create a new table for this data
* Import the data into a PostGIS database
* Do you remember the function you need to make WKT point out of latitude and longitude values?
* View it in QGIS

I did use [csvsql](https://csvkit.readthedocs.io/en/1.0.3/scripts/csvsql.html) to generate a CREATE statement for you.

```sql
CREATE TABLE car_breakins (
	incidntnum VARCHAR(9) NOT NULL,
	category VARCHAR(13) NOT NULL,
	descript VARCHAR(28) NOT NULL,
	dayofweek VARCHAR(9) NOT NULL,
	event_date DATE NOT NULL,
	event_time TIME WITHOUT TIME ZONE NOT NULL,
	pddistrict VARCHAR(10) NOT NULL,
	resolution VARCHAR(21),
	address VARCHAR(42) NOT NULL,
	x FLOAT NOT NULL,
	y FLOAT NOT NULL,
	location VARCHAR(41) NOT NULL
);
```
Bonus questions: where is this data from? Who compiled it? Can you sniff anything out from the Socrata metadata?

<!-- Solution:

COPY car_breakins FROM /home/amanda/Downloads/Car_Break-ins.csv DELIMITER ',' CSV HEADER;
ALTER TABLE car_breakins ADD COLUMN geom GEOMETRY;
UPDATE car_breakins SET geom = ST_MakePoint(x,y);

And then head over to the QGIS > Database menu.

-->

## Points Within a Shape

As James correctly deduced last week, we can use `ST_Within` or `ST_Contains` to find points within a shape. So I wanted to add a walk through of how we'd actually do that. It helps to take a look at the documentation to understand the distinction between the two functions. [ST_Within](http://postgis.net/docs/ST_Within.html) will find all the points (or shapes or lines) that are entirely inside of a polygon. [ST_Contains](http://postgis.net/docs/ST_Within.html) will capture points inside the polygon or exactly on its border.

As ever, I like to do this in steps:

First, I just use a `SELECT` statement to find the matches:

```SQL
SELECT car_breakins.geom,
       ca_zipcodes.zcta5ce10,
       ca_zipcodes.geom
FROM car_breakins, ca_zipcodes
WHERE ST_Within(car_breakins.geom, ca_zipcodes.geom);
```

Then, I create a new column to hold the zipcode:

```SQL
ALTER TABLE car_breakins ADD COLUMN zipcode INTEGER;
```
And last I fill the column with values:

```SQL
UPDATE car_breakins
  SET zipcode = (SELECT ca_zipcodes.zcta5ce10
  FROM car_breakins, ca_zipcodes
  WHERE ST_Within(car_breakins.geom, ca_zipcodes.geom)););
```

But there's an error there: `ERROR:  column "zipcode" is of type integer but expression is of type character varying` -- this is a clue that I need to recast the ca_zipcodes value:

```SQL
UPDATE car_breakins
  SET zipcode = (SELECT ca_zipcodes.zcta5ce10::INTEGER
  FROM car_breakins, ca_zipcodes
  WHERE ST_Within(car_breakins.geom, ca_zipcodes.geom)););
```


Full disclosure: I actually tested this out first on a known-known: the `example_one` table we worked with in Week 11 already has zipcodes in it, so I actually tested my query by looking it up there:

First, I just use a `SELECT` statement to find the matches:

```SQL
SELECT example_one.zipcode_of_incident,
       example_one.geom,
       ca_zipcodes.zcta5ce10,
       ca_zipcodes.geom
FROM example_one, ca_zipcodes
WHERE ST_Within(example_one.geom, ca_zipcodes.geom);
```
I like to do a little sanity checking, to make sure I'm doing it right, so I usually test the query on a data set where I know the outcome, and I try a few tests for discrepancies:

```SQL
SELECT example_one.zipcode_of_incident,
       example_one.geom,
       ca_zipcodes.zcta5ce10,
       ca_zipcodes.geom
FROM example_one, ca_zipcodes
WHERE ST_Within(example_one.geom, ca_zipcodes.geom)
      AND example_one.zipcode_of_incident != ca_zipcodes.zcta5ce10;
```

That query gives me an error: `operator does not exist: integer !~~ character varying` -- a clue that in example_one, the zipcode is stored as INTEGER, while in ca_zipcodes it's stored as VARCHAR, so I need to recast one or the other.

```SQL
SELECT example_one.zipcode_of_incident,
       example_one.geom,
       ca_zipcodes.zcta5ce10,
       ca_zipcodes.geom
FROM example_one, ca_zipcodes
WHERE ST_Within(example_one.geom, ca_zipcodes.geom)
      AND example_one.zipcode_of_incident != ca_zipcodes.zcta5ce10::INTEGER;
```

That query draws up a few points where the police records and the zipcode shapefile don't concur. But I can just zoom in on the 94108/94109 border and confirm that the calculated zipcode is better. Use the "Identify" icon and then select the point, right click on it, and choose to view the "attribute table" to confirm that we're looking at the same incident.

Once you know that your query makes sense, you can actually add a column to the table and populate it with the new data.





Then, I add a column to contain the information I want to add:

Finally, I use an `UPDATE` query to populate the column:



## Keep Learning

* [QGIS Tutorial](https://multimedia.journalism.berkeley.edu/tutorials/qgis-basics-journalists/)
* [Lynda QGIS](https://www.lynda.com/search?q=qgis) | [Lynda PostGIS](https://www.lynda.com/search?q=postgis)


# Assigment

Please submit your final data journalism project by **Tuesday May 1 at 8pm**.

- In bCourses, submit a full write-up of your project. This should be written so that someone with no prior knowledge of your project can understand why this is interesting as well as what you have done. It should include:

 - A clear and direct lede that tells us why we should keep reading, and what the main points of your work are. This should be written for a new audience and should demonstrate the writing skills you have learned in your other classes. Think of this as your chance to sell an editor on this work, by showing that you can write and that you understand this data.

 - A description of the data you used, and how it was cleaned and processed for analysis. Again, imagine you are writing for an editor who doesn't know you and needs to know that you have made smart decisions about data to base your reporting on and that you truly understand what you are doing.

 - The questions you asked of the data, and the tools you used to ask them.

 - The conclusions you have drawn. Include any charts/maps that are relevant.

 - Any further analyses you would need to run to turn this project into a story.

 - The additional reporting, beyond data analysis, that would be required to turn this project into a story.

- Share the data and code for your analysis. Code should be commented so that your instructors are able to understand each step of your analysis. You can share this in a zipped folder and email if the data files are not too large. If they are too large to email, you can share via a Dropbox link.

- Plan to come to class on May 3 prepared to give a 5-7 minute presentation on your project, and answer questions from other students. Plan, also, to listen thoughtfully to your classroom colleagues and engage them on their work this semester.
