### Asking Good Questions

If you challenge yourself (and you should challenge yourself), you're bound to get stuck. Technology is changing constantly, so learning how to ask the right questions and get help with new tools is probably more important than actually learning how to use any one tool well today. <!--more-->

ProPublica's Sisi Wei has a great [intro to asking questions](https://www.propublica.org/nerds/how-to-ask-programming-questions).

Questions like these are hard to answer:

> I've been trying for the past couple of hours to figure out what exactly I'm doing wrong with the  assignment. My spreadsheet is attached -- can you tell me what I'm doing wrong?

or

> I want to start putting together my map, but the QGIS doesn't seem to be working on my computer. Do you know why?

or

> When I run the R code from the class example, it doesn't work.

or

> I've been looking for a KML file for Russia and this is the closest I've gotten but there's still a glitch: https://www.google.com/fusiontables/DataSource?docid=… Please help! I would really like to pitch this today.

or

> I can't install Open Refine! I tried, but the download is just broken.

All we know is that you're using QGIS, or R, or Open Refine. We don't know what you've tried, we don't know what happens when you try it, I don't know what you thought was going to happen. I don't know what "glitch" I should be looking for. So I don't know enough to help you. A good question will include all of this:

*   What steps will reproduce the problem? (Sometimes this means actually walking through the steps again, until you reach the problem.)
*   If you're working with code or data, we probably need to see your data to reproduce the problem! Put your code or data into a [gist](http://gist.github.com) or [pastebin](http://paste.debian.net/) and include a link with your question.
*   What is the expected output?
*   What do you see instead? **If you are working in code and you see an error message, we need to know what that says.**
*   What version of the software are you using?
*   What version of the Mac OS are you using (El Capitan, Sierra, etc)?

Walk us through it, step by step. Don't just say "I followed the instructions," describe the instructions you followed. You're aiming for something like this:

> I can download Refine just fine, but when I try to actually open it, I get an error that says the file is corrupted: "OpenRefine is damaged and can't be opened. You should move it to the Trash" -- I've downloaded it three time from three different browsers and I keep getting the same error.

(If you are actually getting that particular error, [the solution](https://github.com/OpenRefine/OpenRefine/issues/590) is not particularly intuitive: You have to fix your Privacy and Security settings.


## Where should you get help?

You're always welcome to ask your instructors for help. When you're stuck on a technical problem ("Am I on the right track with my pitch?" is not a technical problem; "Why is QGIS drawing San Francisco's shapefiles in the middle of the bay?" is a technical problem) consider opening [a new issue](https://github.com/ucb-dataj/2018/issues). It's good practice.

Other good places to get help:

*   [NICAR-L](https://www.ire.org/resource-center/listservs/subscribe-nicar-l/) is indispensable for connecting with other journalists who are doing innovative data and interactive reporting. Get on the list now.
*   [Stack Overflow](https://stackoverflow.com) is an excellent place to ask specific programming questions, but expect a lot of huffing and puffing if you aren't following the advice here about how to ask good questions (or Stack Overflow's own [excellent post on the same](https://stackoverflow.com/help/how-to-ask).
* 	Tweet questions. Tag them #dataskills
* 	Join [gis.stackoverflow.com](https://gis.stackoverflow.com) – that is where you're going to get help for QGIS and PostGIS question.

