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

# Keep Learning

* [QGIS Tutorial](https://multimedia.journalism.berkeley.edu/tutorials/qgis-basics-journalists/)
* [Lynda QGIS](https://www.lynda.com/search?q=qgis) | [Lynda PostGIS](https://www.lynda.com/search?q=postgis)
