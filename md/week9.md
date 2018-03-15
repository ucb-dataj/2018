## Week 9 | March 15, 2018
*Instructor: Amanda Hickman*

# 10 Min: Data of the Week

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


## Vectors and Rasters

We can head down some serious rabbit holes here. But it is worth understanding the distinction between a [vector](https://en.wikipedia.org/wiki/Vector_graphics) and a [raster](https://en.wikipedia.org/wiki/Raster_graphics), because they'll come up again and again in all kinds of contexts.

## Shapefiles
What is a shapefile? There are a few different widely used formats for storing geographic information. ESRI makes ArcGIS which is popular and expensive. Their shapefile format is almost universal. Google Maps uses it's own KML format.

## Asking for help

I can't say enough about the importance of learning how to ask for help. If you look at my [gis.stackexchange.com](https://gis.stackexchange.com/users/24497/amanda?tab=questions&sort=newest) profile you can see where I got stuck and then unstuck, starting back in 2013. There's a community there that is very good about [thoroughly explaining](https://gis.stackexchange.com/questions/84443/what-is-this-postgis-query-doing-to-show-great-circle-connections) what you're dealing with.

# Open QGIS

Okay, so let's actually do some mapping.


[BLS Walkthrough](/home/amanda/Public/CUNY_Coursebits/CUNY-data-skills_pages/_posts/2015-02-18-mapping.md)

[CSV Sound System's 2014 NICAR Workshop](https://github.com/csvsoundsystem/nicar-cartodb-postgis)

California layer CRS:
National layer CRS:



QUESTIONS: How do I reset the zoom? (Right click; zoom to layer.)



QUESTIONS: How do I refactor fields if table whatever is depricated?

layer crs: best for us, sf?


## Loading a basemap

You need a basemap. The "tile map scale plugin" -- does a nice job of automatically zooming you to an available tile layer, which the other base map plugins don't do.

So go ahead and download the plugin. `Plugins > Manage and Install Plugins ...`  and search for "Tile Map Scale"

![adding a layer](img/week9_01.png)



## Don't unzip your shapefiles

## Finding points that intersect with shapes




### Where to Find Boundary Files
+ [NYC:](http://www.nyc.gov/html/dcp/html/bytes/dwndistricts.shtml)
+ [CUNY Research Center](http://researchcenter.journalism.cuny.edu/digital-maps-database/)
+ [Google Fusion Table search](http://www.google.com/fusiontables/search)
+ [NYC Data sets](https://github.com/jweir/nyc-gov-data/blob/master/data/nyc_data_sets.markdown)
+ [GeoCommons](http://geocommons.com/)
+ [CartoDB's Common Data](https://cunydata.cartodb.com/dashboard/common_data)
+ [Census.gov](https://www.census.gov/geo/maps-data/)

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
