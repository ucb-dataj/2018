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
Another thing that came up in class was why FLOAT is a synonym for DOUBLE PRECISION, and what that means to begin with. The short answer is "it has something to do with how computers store data" -- and for almost any arcane topic in mathematics and computing there is a wikipedia article that goes deep on the finer points. [Floating point arithmetic](https://en.wikipedia.org/wiki/Floating-point_arithmetic) is no exception.

You can see the full list of data types that Postgres supports in [the Postgres documentation](https://www.postgresql.org/docs/10/static/datatype.html). You're almost always going to be using one of only a few:  numeric, float, integer, text, char, varchar, and geometry.

# Hands On PostGIS

We started this two weeks ago and hit some walls that I wasn't expecting.
