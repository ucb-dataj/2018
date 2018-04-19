## Week 13 -- April 19, 2018
*Instructor: Amanda Hickman*

# Fixing your path

This is a good explanation of the command path issues we were navigating last time we worked in the terminal.

http://www.tech-recipes.com/rx/2621/os_x_change_path_environment_variable/k

If you run `echo $PATH` at the command line, you can see a list of all the directories your shell looks in for executable programs. To add `shp2pgsql` so you can access it easily, you want to tell your shell that it needs to look in `/Applications/Postgres.app/Contents/Versions/10/bin/` for programs.

To do that, you're going to edit a hidden file in your home directory (probably `/Users/yourname/`) called `.profile`, to add a line like:

    export PATH=/Applications/Postgres.app/Contents/Versions/10/bin/:$PATH

`PATH` is the [shell variable](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameters.html#index-shell-variable) that contains the array of directories that bash looks in to find executable programs, and we print the contents of that variable with `$PATH`. This command `exports` or "sets" a new `PATH` by concatenating the new directory (`/Applications/Postgres.app/Contents/Versions/10/bin/`) that you want to include, with the existing values stored in `PATH`.

# Data of the Week


# SQL Vocabulary
Another thing that came up in class was why FLOAT is a synonym for DOUBLE PRECISION, and what that means to begin with. The short answer is "it has something to do with how computers store data" -- and for almost any arcane topic in mathematics and computing there is a wikipedia article that goes deep on the finer points. [Floating point arithmetic](https://en.wikipedia.org/wiki/Floating-point_arithmetic) is no exception.

You can see the full list of data types that Postgres supports in [the Postgres documentation](https://www.postgresql.org/docs/10/static/datatype.html). You're almost always going to be using one of only a few:  numeric, float, integer, text, char, varchar, and geometry.

# Hands On PostGIS
