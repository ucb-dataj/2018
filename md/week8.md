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




Introduction to Databases and SQL

Postico

Exercise: SQL Bingo
Council Members, Votes, Districts, committees

Getting Set Up;

Possibly: Puerto Rico power grid?

Opiod data to demonstrate joins

Working from the command line:
