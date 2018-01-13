
# Asking Good Questions
If you challenge yourself (and you should challenge yourself), you're bound to get stuck. If you aren't hitting walls and getting stuck, you aren't trying hard enough. Technology is changing constantly, so learning how to ask the right questions and get help with new tools is probably more important than actually learning how to use any one tool well today. <!--more-->

ProPublica's Sisi Wei has a great [intro to asking questions](https://www.propublica.org/nerds/how-to-ask-programming-questions).

Questions like these are hard to answer:


> I've been trying for the past couple of hours to figure out what exactly I'm doing wrong with the  assignment. My spreadsheet is attached -- can you tell me what I'm doing wrong?

or

> The cookies didn't come out at all! Help!

or

> I want to start putting together my map, but the QGIS doesn't seem to be working on my computer. Do you know why?

or

> I can't seem to make R work... I tried creating a dataframe and it doesn't work. Nothing happens, it just keeps loading with no results...

or

> I've been looking for a kml file for Russia and this is the closest I've gotten but there's still a glitch: https://www.google.com/fusiontables/DataSource?docid=… Please help! I would really like to pitch this today.

or

> I can't install Tableau! I tried, but the download is just broken.

All I know is that you're baking cookies, or using QGIS. Or Fusion Tables. I don't know what you've tried, I don't know what happens when you try it, I don't know what you thought was going to happen. I don't know what "glitch" I should be looking for. So I don't know enough to help you. A good question will include all of this:

*   What steps will reproduce the problem? (Sometimes this means actually walking through the steps again, until you reach the problem.)
*   If you're working with code or data, I probably need to see your data to reproduce the problem! Put your code or data into a [gist](http://gist.github.com) or [pastebin](http://paste.debian.net/) and include a link with your question.
*   What is the expected output?
*   What do you see instead?
*   What version of the software are you using?
*   If you're working with something online, like a WordPress Plugin, you also want to try it in at least two browsers and include the name and version of the browsers you've tried it in.
*   For software that's installed on your computer, like QGIS or R, be sure to include your operating system and the version. (not just “Mac” but Mac OSX Jaguar)

Walk me through it, step by step. Don't just say "I followed the instructions," describe the instructions you followed. You're aiming for something like this:

> I can't seem to make Slidedeck work! I selected "Add a Slide" and chose "Image Slide." I tried uploading an image from my computer first and got as far as clicking "Upload Photo" button. It looked like it was starting to upload the photo -- the blue bar appeared with the image's file size -- but then it just hung there. I waited for ten minutes. When that didn't work, I tried adding some images directly to the media library and adding them to my slideshow that way. I can see the image but when I click "Apply" to save the slide, the slideshow says "Loading ... We're decking out your content." It never actually loads.

Or perhaps...

> I can download Refine just fine, but when I try to actually open it, I get an error that says the file is corrupted: "OpenRefine is damaged and can't be opened. You should move it to the Trash" -- I've downloaded it three time from three different browsers and I keep getting the same error.

(If you are actually getting that particular error, [the solution](https://github.com/OpenRefine/OpenRefine/issues/590) is not particularly intuitive: You have to fix your Privacy and Security settings.


## Where should you get help?

You're always welcome to ask your instructors for help. When you're stuck on a technical challenge ("Am I on the right track with my pitch?" is not a technical problem. "Why is QGIS drawing San Francisco's zipfiles in the middle of the bay?" is a technical problem.) consider opening [a new issue](https://github.com/ucb-dataj/2018/issues). It's good practice.

Other good places to get help:

*   [NICAR-L][1] is indispensable for connecting with other journalists who are doing innovative data and interactive reporting. Get on the list now.
*   [Stack Overflow][3] is an excellent place to ask specific programming questions, but expect a lot of huffing and puffing if you aren't following the advice here about how to ask good questions (or Stack Overflow's own [excellent post on the same](https://stackoverflow.com/help/how-to-ask).
* 	Tweet questions. Tag them #dataskills
* 	Join [gis.stackoverflow.com](http://gis.stackoverflow.com) – that is where you're going to get help for QGIS and PostGIS question.
*	<!--On campus, have free access to an incredible wealth of instructional videos from Lynda.com -- visit [iplogin.lynda.com](http://iplogin.lynda.com) to connect.  Detailed instructions on getting setup at  <http://tech.journalism.cuny.edu/documentation/accessing-lynda/-->.

[1]: http://www.ire.org/resource-center/listservs/subscribe-nicar-l/
[3]: http://stackoverflow.com
