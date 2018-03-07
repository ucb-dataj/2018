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
+ [BLS Fatality Data (csv)](cartodb/)
+ [2011 Population Estimates](https://www.census.gov/popest/data/state/totals/2011/tables/NST-EST2011-01.csv) (via [census.gov](http://www.census.gov/popest/data/historical/2010s/vintage_2011/state.html))

Load them as tables and join them.

Use `=find()` to confirm that state names match. They will until ~New York

Use ALTER and UPDATE  to set fatality_rate to fatalities per capita, talk about scientific notation, then `=(G10/E10)*100000` for per 100,000


# Advanced query
Sex offender restrictions buffered around schools to show how much of a city is off limits.

distance arcs

distance query
buffer

points to tracks --

two types of data that have an overlaps
