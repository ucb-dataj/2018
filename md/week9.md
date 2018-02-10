## Week 9 | March 15, 2018
*Instructor: Amanda Hickman*

Tile map scale plugin allows you to pull in a tile base map:

"tile map scale plugin" -- automatically zooms you to an available tile layer, which the other base map plugins don't do. 

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
