## Week 9 | March 15, 2018
*Instructor: Amanda Hickman*

# Some Technical Notes
Don't ignore errors, but I don't want to try to troubleshoot individual errors in class, either. So if you're getting an error, let's look at how to resolve it.

My error:`Couldn't load plugin MetaSearch due to an error when calling its classFactory() method`

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
We don't deal with [projections](http://xkcd.com/977/) much but they matter.

## Vectors and Rasters

We can head down some serious rabbit holes here. But it is worth understanding the distinction between a vector and a raster.



# Loading our first data

QUESTIONS: How do I reset the zoom? (Right click; zoom to layer.)

What is a shapefile? There are a few different widely used formats for storing geographic information. ESRI makes ArcGIS which is popular and expensive. Their shapefile format is almost universal. Google Maps uses it's own format.

QUESTIONS: How do I refactor fields if table whatever is depricated?

layer crs: best for us, sf?


## Loading a basemap

You need a basemap.

"tile map scale plugin" -- automatically zooms you to an available tile layer, which the other base map plugins don't do.

## Don't unzip your shapefiles

## Finding points that intersect with shapes

[BLS Walkthrough](/home/amanda/Public/CUNY_Coursebits/CUNY-data-skills_pages/_posts/2015-02-18-mapping.md)

[CSV Sound System's 2014 NICAR Workshop](https://github.com/csvsoundsystem/nicar-cartodb-postgis)

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


### Where to Find Boundary Files
+ [NYC:](http://www.nyc.gov/html/dcp/html/bytes/dwndistricts.shtml)
+ [CUNY Research Center](http://researchcenter.journalism.cuny.edu/digital-maps-database/)
+ [Google Fusion Table search](http://www.google.com/fusiontables/search)
+ [NYC Data sets](https://github.com/jweir/nyc-gov-data/blob/master/data/nyc_data_sets.markdown)
+ [GeoCommons](http://geocommons.com/)
+ [CartoDB's Common Data](https://cunydata.cartodb.com/dashboard/common_data)
+ [Census.gov](https://www.census.gov/geo/maps-data/)
+

[My List](https://github.com/amandabee/CUNY-SOJ-data-storytelling/wiki/Where-to-Find-Shapefiles)

### How to Geocode
If you need to transform addresses into lat/lon pairs, you have a couple of options:

+ Fusion Tables will do it, but their terms of service say you have to use that data on a Google Map.
+ Geocoder.us Will do one address at a time, or you can pay for a batch
+ CartoDB gives you a bunch free and you can pay for more.
+ More [suggestions](https://stackoverflow.com/questions/373383/geocoding-libraries)

## Keep going with QGIS

This series is highly recommended:
https://www.youtube.com/watch?v=Pf9cYvaCYWA&index=3&list=PL7HotvlLKHCs9nD1fFUjSOsZrsnctyV2R
