## Week 11 | April 5, 2018
*Instructor: Amanda Hickman*

# Strategies for Slow Computers

We already used [`head`](https://www.gnu.org/software/coreutils/manual/html_node/head-invocation.html) with the [`-n 100` flag](https://en.wikipedia.org/wiki/Head_(Unix)) set, to output the first hundred lines of a file. Another good option is to just create a smaller table to work with:

```SQL

CREATE TABLE example_shorter AS
  SELECT * FROM example LIMIT 1000;

```

This will let you stumble around and figure out what you're trying to do without waiting for your computer to catch up with a larger data file. If QGIS is so slow that you can't get much done there are a few other good options to look into:

* Actually **create a spatial index**. We'll do this to a data set today. We haven't talked a lot about indexing but it's (roughly) the process of creating a structured view of the data so that the computer can find it quickly. If you know you want to be able to search a particular column regularly, for instance, you'd want to create a search index for that column. This is more advanced than we need to go deep on, but creating a spatial index is always a good idea.

* Turn off rendering (there's a checkbox in the lower right) so that QGIS isn't continually trying to re-draw.

* 

https://gis.stackexchange.com/questions/67736/qgis-very-slow-i-dont-know-what-to-do#67779

# Adding PostGIS to QGIS

Few setup steps:

```sql

CREATE DATABASE week11_postgis;

/* make sure you're using it. */

CREATE EXTENSION postgis;


```

## Puzzle One: Why Aren't Todd's Points Showing Up?

When you import a CSV into QGIS directly, you have two options. If there's a latitude column and a longitude column you can just select "Point coordinates" as your Geometry definition, and identify the X (longitude) and Y (latitude) columns. The other option is [Well Known Text](https://en.wikipedia.org/wiki/Well-known_text) which is a standardized format for identifying points, lines and polygons. WKT wants point definitions as `POINT (lon lat)`.

If your data has a single column that you know includes the latitude and longitude but it isn't in WKT format:

    location
    (37.7875044952742, -122.414163693123)
    (37.7657922226195, -122.420909958943)
    (37.7657922226195, -122.420909958943)
    (37.7657922226195, -122.420909958943)
    (37.7657922226195, -122.420909958943)
    (37.7657922226195, -122.420909958943)
    (37.783163427134, -122.411599278937)
    (37.783163427134, -122.411599278937)

You have a few options. You can use Open Refine to break out the latitude and longitude into their own columns. You could use a spreadsheet function, if your data is small enough to open in a spreadsheet. You could use SQL in postgres to find [substrings](https://www.postgresql.org/docs/8.1/static/functions-string.html) and pull them into their own column.

Start by building up the `SELECT` statement:

```sql
SELECT location,
	btrim(location, '()'),
	split_part(location, ',', 1),                 
	split_part(btrim(location, '()'), ',', 1),
	split_part(btrim(location, '()'), ',', 2)
	FROM example;
```

Then pull it into it's own column:

```sql

ALTER TABLE example
  ADD COLUMN longitude FLOAT,
  ADD COLUMN latitude FLOAT;


UPDATE test SET longitude = split_part(btrim(location, '()'), ',', 2),
                latitude = split_part(btrim(location, '()'), ',', 1);

```

Read the error message. What does it actually say?

```sql

UPDATE example SET longitude = split_part(btrim(location, '()'), ',', 2)::float,
                 latitude = split_part(btrim(location, '()'), ',', 1)::float;

```

Then you can export to a CSV and import the CSV into QGIS. But the whole point here is to start introducing PostGIS. So let's.

The first thing we need to do is actually `CREATE EXTENSION postgis;` -- but we've done that. So then we need to generate points in a format that


### [ST_MakePoint](https://postgis.net/docs/ST_MakePoint.html)

```sql
ALTER TABLE example ADD COLUMN the_geom GEOMETRY;
UPDATE example SET the_geom =  ST_MakePoint(longitude, latitude);
```

So now we need to connect in QGIS. You can go to `Layer > Add Layer > Postgis` or look for the elephant on the sidebar.

The connection settings are probably the same as for Postico.

Once you've successfully connected, you might have to look for the "Also list tables with no geometry" check box, and check it.

A few more observations:

* The distinction between GEOGRAPHY and GEOMETRY [is fuzzy](https://postgis.net/docs/manual-2.1/using_postgis_dbmanagement.html#PostGIS_GeographyVSGeometry) but my general rule is that I use GEOMETRY until I get stuck and then I adjust.
* I think it is important to think in terms of tables and to recognize that this data is all super accessible.
* I think it is also important to get to a place where you can frame the question in front of you in a meaningful way.
* The QGIS documentation is really bad. But the [PostGIS documentation](http://postgis.net/docs/manual-2.4/) is great.
* Using the "the_geom" convention is optional but it will save you a lot of aggravation.

# Tidying

Look for `Database > DB Manager` in the menu. You should be able to drill down to `PostGIS > Localhost > public > {tablename}` and you'll see some warnings.

> ￼   No spatial index defined (create it)

Use the link to create a spatial index. And then add a primary key, with:  

```sql
ALTER TABLE test ADD PRIMARY KEY (call_number, unit_id);
```

# Queries We Want To Accomplish

* Find all the points that are inside of a shape.





Note: you're going to notice that I slip between Geometry and Geography.
