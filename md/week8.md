## Week 8 | Tuesday March 6, 2018
*Instructor: Amanda Hickman*

# Learning to Love the Terminal

We're going to use a few command line tools.   

## Looking Better
Before we do more, go ahead and look under `Terminal > Preferences` and set the default to "Homebrew" -- you can fuss with that on your own later if you'd like a different color scheme.

I also want you to add "open in terminal" to your finder. Right click in the finder and look for `services > New Terminal` check box.

### Bash, Term, Console, Huh?

Some vocabulary: `Terminal` is an OSX app that provides you direct access the command line. `Command Line Interface` or `cli` is the interface you see in the terminal. The `shell` is the command line interpreter -- there are a few different shells, but `bash` is the most common. The `console` is a hardware interface -- the physical machine, but people sometimes use the term to apply generically to terminal applications. The `prompt` is the actual line in your shell that is waiting for input. Most of the time by default that is something like `$` -- mine is `amanda@mona:~$ `

Technically this is accurate: Terminal runs a shell, such as bash, that gives you access to a command line interface where you can use the command line to run commands by typing them at the command prompt.

Functionally, the terms are more or less interchangeable.

[More on that.](https://askubuntu.com/questions/506510/what-is-the-difference-between-terminal-console-shell-and-command-line).

## For Starters

The [csvkit installation instructions](http://csvkit.readthedocs.org/en/latest/install.html) are probably way over your head. If they aren't, go ahead and install csvkit and walk through [their tutorial](https://csvkit.readthedocs.io/en/1.0.2/tutorial/1_getting_started.html#about-this-tutorial).

We're going to try a few commands, but I also want to flag that it is very possible to make a terrible mess using the terminal. For instance this simple command:  `rm -r /` will ... wipe the contents of you r entire computer. So You shouldn't run anything at the terminal without knowing what it is?

1. Open Terminal. Look at what you see there.
2. Try running `pwd` -- note that when I say "run `pwd`" what I mean is "type the command `pwd` at the prompt and hit <kbd>enter</kbd>". That command, "print working directory" will tell you what directory you are currently in.
3. Try running `cd`. And then run `pwd` again.
4. Type `cd Dow` and use tab completion to fill in the rest: it should populate with `Downloads`. Run it by hitting <kbd>enter</kbd>.
5. Try running `ls` and `ls -al` -- `-a` and `-l` are "options" that extend the `ls` command.
6. Run `man cat` -- what does the `cat` command do? If you run `cat` by itself it is going to hang, waiting for you to tell it what to concatenate. Use <kbd>ctrl</kbd><kbd>c</kbd> to escape.
7. When you ran `ls` did you see any `csv` files? Try printing one to the screen with `cat {filename}.csv` -- `{filename}.csv` is an argument that extends the `cat` command. The curly braces are a convention you'll see a fair bit, they indicate that you need to fill in the {generic term} with a real term. You probably don't have anything called `filename.csv` but you have a few things that have a filename.

We're going to stop there because all we really need right now is access to the command line in general, and a foolproof way to figure out what directory we're in. As I said when we started out, there are tools you can use at the command line to trash your machine, so if someone tells you to "just run this command" you should always make sure you understand what it is doing. `man {command}` is your friend here.

Noah Veltman has an [excellent resource](https://github.com/veltman/clmystery/blob/master/cheatsheet.md) for learning your way around the command line, or this [2015 NICAR Workshop](https://github.com/chrislkeller/nicar15-command-line-basics) is a great place to start.

## Installing CSVkit
One of the reasons we're doing this is to make `csvkit` a bit more accessible.
I wrote a [tutorial on installing CSVkit](https://github.com/amandabee/CUNY-SOJ-data-storytelling/wiki/Tutorial:-Installing-CSVKit) that gives you a bunch of different options. I've heard that's a great place to start. From there you can [use](https://github.com/amandabee/CUNY-data-storytelling/wiki/Tutorial:-Using-CSVkit) csvkit.


# Using Posgres

There are a lot of reasons I want you to get comfortable with Postgres. Last week we talked a little bit about generating CREATE statements and I want you to be able to do that, but you're also going to find a lot of situations where facility with Postgres will make a big difference. It opens the door to some geographic queries that are quite powerful.

Postico does have [keyboard shortcuts](https://eggerapps.at/postico/docs/v1.3.2/keyboard-shortcuts.html)

I keep a running list of [SQL commands](https://github.com/amandabee/CUNY-data-storytelling/wiki/Tip-Sheet:-SQL) that I wind up showing to students often.

I have a few conventions that I use. The [Postgres manual](https://www.postgresql.org/docs/9.5/static/sql-syntax.html) is dense but incredibly helpful if you find yourself wondering _why_ something is the way it is.

### [CREATE DATABASE](https://www.postgresql.org/docs/9.5/static/sql-createdatabase.html)

You probably want to create a new database for each project, just to stay organized.  So go ahead and run `CREATE DATABASE week8` (you may need something closer to `CREATE DATABASE week8 WITH OWNER = amanda;`).

Everything we do tonight we're going to do in that Week8 database.


### [CREATE](https://www.postgresql.org/docs/9.5/static/sql-createtable.html)

We're going to start by pulling some of the data Peter had you working with into Postgres -- this should give you a nice sense of how the tools compare.

One thing to keep in mind: R is super efficient about referring back to your base data. If you start generating tables from old tables, you are going to duplicate data.

I used `csvkit` to generate my create statements: `csvsql *.csv ` -- it took about 40 seconds to run through all of it.

```sql
CREATE TABLE ca_discipline (
	alert_date DATE,
	last_name VARCHAR(19),
	first_name VARCHAR(14),
	middle_name VARCHAR(19),
	name_suffix VARCHAR(33),
	city VARCHAR(22) NOT NULL,
	state VARCHAR(11),
	license VARCHAR(9),
	action_type VARCHAR(62) NOT NULL,
	action_date DATE NOT NULL
);

CREATE TABLE ca_medicare_opioids (
	npi INTEGER NOT NULL,
	nppes_provider_last_org_name VARCHAR(44),
	nppes_provider_first_name VARCHAR(20),
	nppes_provider_city VARCHAR(22) NOT NULL,
	nppes_provider_state VARCHAR(2) NOT NULL,
	specialty_description VARCHAR(62) NOT NULL,
	description_flag VARCHAR(1) NOT NULL,
	drug_name VARCHAR(30) NOT NULL,
	generic_name VARCHAR(30) NOT NULL,
	bene_count INTEGER,
	total_claim_count INTEGER NOT NULL,
	total_30_day_fill_count FLOAT NOT NULL,
	total_day_supply INTEGER NOT NULL,
	total_drug_cost FLOAT NOT NULL,
	bene_count_ge65 INTEGER,
	bene_count_ge65_suppress_flag VARCHAR(4),
	total_claim_count_ge65 INTEGER,
	ge65_suppress_flag VARCHAR(4),
	total_30_day_fill_count_ge65 FLOAT,
	total_day_supply_ge65 INTEGER,
	total_drug_cost_ge65 FLOAT,
	year INTEGER NOT NULL
);

CREATE TABLE npi_license (
	npi INTEGER NOT NULL,
	plicnum VARCHAR(20) NOT NULL,
	license VARCHAR(22) NOT NULL
);

```
We can just run with this since we aren't going to add new data. Our next project is to load in the data. Last week we used this command to load `courses.csv` into the `courses` table:

`COPY courses from '/path/to/courses.csv' DELIMITER ',' CSV HEADER;`

How do you think we should populate the `ca_discipline` table? First, try running `head ca_discipline.csv` in your terminal. Does this file have a header row? What is the delimeter?

<!-- Note: I actually had to use psql at the terminal and `copy ca_discipline FROM '~/Public/2018/data/week5/ca_discipline.csv'  DELIMITER ',' CSV HEADER;` -->

You probably got an error:

```
ERROR:  value too long for type character varying(11)
CONTEXT:  COPY ca_discipline, line 1314, column state: " South Korea"
```

I used `csvkit` to see what was going on: `csvstat -c "state" ca_discipline.csv`.

I can use an [ALTER](https://www.postgresql.org/docs/9.5/static/sql-altertable.html) statement to make more room.

```sql
ALTER TABLE ca_discipline ALTER COLUMN state TYPE varchar(15)

```

And then let's try the `COPY` statement again. And once all the data is in there, we need to clean it up.

```sql

SELECT DISTINCT state FROM ca_discipline;

/* That's a little disordered.*/

SELECT DISTINCT state FROM ca_discipline ORDER BY state;

/* Better. Just out of curiousity, how are these distributed? */

SELECT DISTINCT state, count(*) FROM ca_discipline ORDER BY state;

/* Ok. So now we need to trim those spaces. */

UPDATE ca_discipline SET state=trim(state);

SELECT DISTINCT state, count(*) FROM ca_discipline GROUP BY state ORDER BY state;
```

### [SELECT](https://www.postgresql.org/docs/9.5/static/sql-select.html)

We just tried some SELECT statements to examine the "State" column. We added in a [COUNT]() function and two clauses, [GROUP BY(https://www.postgresql.org/docs/9.5/static/queries-table-expressions.html#QUERIES-GROUP) and [ORDER BY](https://www.postgresql.org/docs/9.5/static/sql-select.html#SQL-ORDERBY)

The next thing we did in R was create a smaller view with just a few cities, so let's resolve our query to look at what cities exist in the data:

```sql
SELECT DISTINCT city, state, count(*) FROM ca_discipline GROUP BY city, state ORDER BY city, state;
/* and add a WHERE clause to see just a few Alameda County cities */


SELECT DISTINCT city, state, count(*) FROM ca_discipline
	WHERE city IN ('Kensington','Piedmont','Berkeley','Oakland', 'Alameda')
	GROUP BY city, state ORDER BY city, state;

SELECT action_type, count(*) FROM ca_discipline GROUP BY action_type;

/* I like to know I'm hitting everything first  */

```

So: if we want to SELECT only those entries where the license was revoked, what are we going to do? I want everyone to sketch out what you think it is going to be, in [Etherpad](https://public.etherpad-mozilla.org/p/J298). And then try running it.

<https://public.etherpad-mozilla.org/p/J298>

Then see if you can make these two queries happen:

* Filter the ca_discipline data to show licenses Revoked for doctors based in Los Angeles, with the most recent first.

* Filter the data to show licenses Suspended or Revoked for doctors in Los Angeles or San Diego. Sort the results by Doctor's names.

Note: I find it a bit easier to compose my scripts separately in a [text editor](https://beebom.com/best-text-editors-for-mac/) -- [Sublime](https://www.sublimetext.com/docs/3/linux_repositories.html) and [Atom](https://flight-manual.atom.io/getting-started/sections/installing-atom/#platform-mac) are both good bets. TextEdit is actually a lightweight word processor. (One good clue is that you can tweak the fonts in TextEdit) but you can use it as a text editor if you switch to Plain Text mode. (It's under format for any one document, or under preferences for the software as a whole.)

#### [VIEWS](https://www.postgresql.org/docs/9.5/static/sql-createview.html)

One of the ways that SQL is a little less efficient than R is that it doesn't do a great job of caching views. So sometimes it makes sense to create a new table with a subset of the data, while other times [CREATE VIEW](https://www.postgresql.org/docs/9.5/static/sql-createview.html)

```sql

CREATE TEMP VIEW ca_discipline_local_revoked AS
	SELECT * FROM public.ca_discipline
	WHERE
	  ca_discipline.city IN ('Alameda', 'Albany', 'Berkeley', 'Dublin', 'Emeryville', 'Fremont', 'Hayward', 'Kensington', 'Livermore', 'Newark', 'Oakland', 'Piedmont', 'Pleasaanton', 'San Leandro', 'Union City')
	AND
	  ca_discipline.action_type = 'Revoked';

/* Note that this assumes my database is called "public" */

```

Working with [dates](https://www.postgresql.org/docs/9.5/static/functions-datetime.html)

```sql
SELECT date_part('year', alert_date) AS year, date_part('month', alert_date) AS month, count(*)
	FROM  ca_discipline_local_revoked
	GROUP BY date_part('year', alert_date), date_part('month', alert_date)
	ORDER BY year, month;

```

So let's think about how we might go about looking at how many licenses are revoked in CA each year.  Sketch out what you think it is going to be, in a text editor. Drop your query in  [Etherpad](https://public.etherpad-mozilla.org/p/J298). And then try running it.

```sql
SELECT date_part('year', alert_date) AS year, count(*)
	FROM  ca_discipline WHERE action_type = 'Revoked'
	GROUP BY date_part('year', alert_date)
	ORDER BY year;
```

And if you want to start playing with fentanyl prescriptions:

```sql
SELECT generic_name, count(*) FROM  public.ca_medicare_opioids
	WHERE generic_name LIKE '%FENTANYL%' GROUP BY generic_name;

SELECT year, count(*) FROM  public.ca_medicare_opioids
	WHERE generic_name LIKE '%FENTANYL%' GROUP BY year ORDER BY year;

```

### [JOIN](https://www.postgresql.org/docs/9.5/static/queries-table-expressions.html#QUERIES-JOIN)

We played with this a bit last week, and I know that you did some joins Week 6 as well. So I wanted to translate those queries into SQL for you.

#### Create a summary, showing the number of opioid prescriptions written by each doctor, the total cost of the opioids prescribed, and the cost per claim.

Sketch out how you think you would do it. 

<https://blog.codinghorror.com/a-visual-explanation-of-sql-joins/>

### [UPDATE](https://www.postgresql.org/docs/9.5/static/sql-update.html)

We actually introduced update above. You can use Postico to manually tweak individual values, but if you want to change values en masse, UPDATE is your friend.
