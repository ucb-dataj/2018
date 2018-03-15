## Week 10 | March 22, 2018
*Instructor: Amanda Hickman*

PostGIS
Maps meet databases

* using the command line to pull data into Postgres


#BLS Data
Easy, easy lesson -- we can do this all in QGIS

In 2011, the BLS published a [map of fatal workplace injuries](http://bls.gov/opub/btn/volume-2/death-on-the-job-fatal-work-injuries-in-2011.htm) by state.

Good discussion questions:
Are these colors continuous or categorical? Should they be? Is anyone surprised that CA and TX have a lot of workplace injuries? How can we improve on this?

Takeaway: BLS data is mapped, but it isn’t normalized to the population and the gradient makes no sense at all.

So we'll recreate it:
+ [BLS Fatality Data (csv)]()
+ [2011 Population Estimates](https://www.census.gov/popest/data/state/totals/2011/tables/NST-EST2011-01.csv) (via [census.gov](http://www.census.gov/popest/data/historical/2010s/vintage_2011/state.html))

Load them as tables and join them.

Use `=find()` to confirm that state names match. They will until ~New York

Use ALTER and UPDATE  to set fatality_rate to fatalities per capita, talk about scientific notation, then `=(G10/E10)*100000` for per 100,000


# Advanced query
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

## More advanced queries

* distance arcs
* distance query
* buffer
* points to tracks --
* two types of data that have an overlaps

### From Peter, probably too hard.

Should look for hurricane tracks.

Here <http://paldhous.github.io/ucb/2017/dataviz/week10.html>'s a basic
QGIS mapping class, more for data viz than analysis (a bit of that
toward the end), but might be useful:.

Also attached is the point data for planes from Acorn Growth Companies
(the star of this story
<https://www.buzzfeed.com/christianstork/spy-planes-over-american-cities>)
flying surveillance patterns over the Gulf Coast to support US Marines
Special Ops RAVEN training exercises.

For the maps in the story, I had to turn the points into lines. Once you
get this loaded into PostgreSQL/PostGIS, the query should be something like:

CREATE TABLE acorn_tracks_gulf AS
SELECT ST_Makeline(tracks.geom) AS geom,
tracks.REG,tracks.FLIGHT_ID,tracks.ADSHEX,tracks.NAME,tracks.AGENCY,tracks.AGENC
+Y2,tracks.DATE
FROM (SELECT
geom,REG,FLIGHT_IS,ADSHEX,NAME,AGENCY,AGENCY2,CAST(CENTRAL_TI AS date)
AS DATE FROM acorn_points_gulf ORDER BY
REG,FLIGHT_ID,ADSHEX,NAME,AGENCY,AGENCY2,DATE,CENTRAL_TI) AS tracks
GROUP BY
tracks.REG,tracks.FLIGHT_ID,tracks.ADSHEX,tracks.NAME,tracks.AGENCY,tracks.AGENC
+Y2,tracks.DATE;

Sorry about all the capitals. That's what happens when you save out from
QGIS as a shapefile. I can explain what all the fields are ..

------------------------

Tile map scale plugin allows you to pull in a tile base map:


osm mapnik

in project properties, enable on the fly crs transformation

write the query that pulls points from the db and turns them into tracks




QGIS
Finding Stories Using Maps

* Super basic stuff; where is this happening? Where is this concentrated?
* Campaign donations from outside your district

Spatial functions and how they work;
Looking at incarceration location vs. home zip and calculating differences

Taking some kind of point data and turning it into line data with st_makeline function. eg. hurricane data;

2017 Hurricane data -- Peter has a good python script to transform into a CSV

Counting things within a box and without a box? (Campaign donations.)

Sex offender residency restrictions: Map the facilities and use ST_Buffer / ST_union to map a shape and look at where there are zero places outside the buffer. Does that intersect with low cost housing.

Distance to abortion clinics. https://pudding.cool/2017/09/clinics/ / https://www.npr.org/sections/health-shots/2017/10/03/555166033/for-many-women-the-nearest-abortion-clinic-is-hundreds-of-miles-away

Mapping Quakes (and filtering USGS data by geography)
http://2015.padjo.org/tutorials/spreadsheets/maps-earthquakes-spreadsheets-part-1/

PETER: will dig out some of his favorite examples.

Cal Fire shapefiles: Calculate ST_area for burn areas over last two years, vs parcel data. Intersect with land use data from 10 years ago? Building permits?

How to go from making maps to coming out with really compelling conclusions.
