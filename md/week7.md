## Week 7 | March 1, 2018
*Instructor: Amanda Hickman*

# Don't Let the Data Lie To You

## Dataset of The Week (10 Min)
Presenting:  Sarah El Safty and Josh Slowiczek

## Lies Data Tells

### Some people want to lie.

* <https://qz.com/122921/the-chart-tim-cook-doesnt-want-you-to-see/> -- QZ on a very disingenous Apple chart.

You’re often going to find yourself working with numbers that were given to you by a source who has a vested interest in how your story turns out. Ask lots of questions. Be skeptical.

### All data lies.

What do you think is the fastest way to reduce the number of unsolved rape cases in your precinct?  

*  <https://www.eastbayexpress.com/oakland/too-many-rapes-dismissed/Content?oid=12633555>
*  <https://www.buzzfeed.com/alexcampbell/unfounded>
*  <http://www.pulitzer.org/winners/t-christian-miller-propublica-and-ken-armstrong-marshall-projec>

If there's a meaningful reward for moving the numbers, there's a real incentive to move the numbers without changing the underlying issue at all.

And if you see a hospital that advertises high surgical success rates, does that mean they have the best surgeons? Or that they only take easy cases?

VA Hospitals are addicted to metrics and they almost always turn out to be gameable, often in ways that make problems worse.
  * https://www.nytimes.com/2014/05/29/us/va-report-confirms-improper-waiting-lists-at-phoenix-center.html
  * https://www.wnyc.org/story/manipulating-metrics-veterans-health-care-system
  * https://www.nytimes.com/2018/01/01/us/at-veterans-hospital-in-oregon-a-push-for-better-ratings-puts-patients-at-risk-doctors-say.html

90% of fetuses diagnosed with Down Syndrome are aborted. <!-- Because the amniocentesis is optional and invasive and if you know you aren't going to change the course of a pregnancy, there's no reason to get a diagnosis. That may change with changes in the science of pre-natal testing, but for now, that's why. -->

### All data has context.

It is made by people. People take shortcuts. They interpret things and make calls.

* The NYT -- often [accidental gun deaths](http://www.nytimes.com/2013/09/29/us/children-and-guns-the-hidden-toll.html) are classified as homicides and suicides -- one core takeaway is that it is up to the coroner to make a call, and they don't always make the call you'd expect. One result is that accidental gun deaths are wildly under counted.

* Kansas: <https://splinternews.com/how-an-internet-mapping-glitch-turned-a-random-kansas-f-1793856052> / <https://splinternews.com/this-is-the-new-digital-center-of-the-united-states-1793856143> / <https://source.opennews.org/articles/distrust-your-data/> (esp <https://www.buzzfeed.com/ryanhatesthis/who-watches-more-porn-republicans-or-democrats> and <https://www.vox.com/2014/4/21/5636040/whats-the-matter-with-kansas-and-porn> )

* **The Fires (Joe Flood)** -- The Fires is one of a few excellent stories about the famous burning Bronx of the 1970s. One thing he talks about, which others have also talked about, is the direct relationship between radical cutbacks in FDNY station funding in the Bronx and the rise in fires -- maybe The Bronx was burning because the infrastructure to put fires out had been decimated. RAND's statistical team analyzed *precicted* citywide response times and determined that the city could safely close a lot of Bronx firehouses -- without acknowledging that those firehouses were some of the busiest in the city and often weren't responding to fires in their immediate vicinity because they were already out fighting fires. So a very "pure" data-driven approach conveniently rationalized shuttering a lot of stations in poor areas.
  * [Why The Bronx Burned](https://nypost.com/2010/05/16/why-the-bronx-burned/) (NY Post, May 2010)
  * [Goodreads on The Flood](https://www.goodreads.com/book/show/7906964-the-fires)
  * [Reviews: A City on Fire](https://citylimits.org/2010/06/04/reviews-a-city-on-fire/) (City Limits, June 2010)

* [538 had to retract a story on broadband reach](https://fivethirtyeight.com/features/we-used-broadband-data-we-shouldnt-have-heres-what-went-wrong/) because they didn't understand the data they were working from.

IP addresses as a proxy for location will give you a ton of hits in Kansas.


* Years ago, the Chicago Sun Times ran a story about exceptionally [high crime rates at CTA stations](https://web.archive.org/web/20130303021058/http://www.suntimes.com/opinions/letters/18515250-474/story-misses-the-mark-on-cta-crime.html), but the "crime spike" was turnstile jumping. ([WBEZ](http://wbezdata.tumblr.com/post/44257873024/cta-sun-times-get-in-data-fight))


### All data has biases.
I've talked about this before, so I won't dwell on it, but 311 calls are not a random sample of lived experiences.
* https://nextcity.org/daily/entry/who-is-most-likely-dial-311  

* This is a classic in statistics texts: in the 70s, researchers looked at admissions rates at UC Berkeley and found that women were far, far more likely to be rejected. A closer examination revealed that women were more likely to apply to more competitive programs, so department by department, there wasn’t evidence of discrimination. http://vudlab.com/simpsons/ --

    “The only real way to maybe avoid this and similar potential land mines in a statistical model is to thoroughly understand your subject area and to be skeptical of any result." John Perry @ AJC

This is closely related to the ecological fallacy: if I tell you that states with more foreign born residents have more wealthy households, what’s your next question? (Are foreign born people more likely to be wealthy? No.) An older study showed that there was a positive state-by-state correlation between literacy and foreign born populations: areas with high immigrant populations were likely to be more literate. What you don’t know is whether immigrants are likely to be more literate.

http://blog.statwing.com/the-ecological-fallacy/ http://andrewgelman.com/2013/02/03/heuristics-for-identifying-ecological-fallacies/

Question order changes how people respond to questions. This is over a decade old now, but in '03, Americans were more likely to say they support civil unions if you already asked them if they support gay marriage.
* http://www.pewresearch.org/methodology/u-s-survey-research/questionnaire-design/#question-order

Pew has a lot of great research about survey design.

[![I used to think correlation was causation but then I took a statistics course.](https://imgs.xkcd.com/comics/correlation.png)](https://xkcd.com/552/)


* [Spurious Correlations](http://tylervigen.com/spurious-correlations)
* [More Notes](https://github.com/amandabee/CUNY-data-storytelling/blob/master/lecture%20notes/skepticism.md)
* [How you tell the story matters](https://archives.cjr.org/cover_story/dark_shadows.php)
* Newsrooms cherry pick data, too.  https://www.theatlantic.com/business/archive/2012/09/whats-really-eating-the-family-budget-it-aint-smartphones/262918/


## Where do you find data?
Who is stuck? Let's brainstorm getting unstuck.



## SQL Bingo

[Slides](https://docs.google.com/presentation/d/1qsd1hZsd6U6b0sZJCoshFvjXnGcVy9yqafNlWe3SsB4/edit#slide=id.g344ba11d90_0_20)

<!-- if we have time, I can introduce the core concept of SQL. -->
[Source](https://github.com/amandabee/workshops/tree/master/2018/sqlbingo)



## Next week (10 min)

* No data preso next week, Caron and Carlos are up 3/15
* We're meeting on Tuesday 3/6 in the same room.
