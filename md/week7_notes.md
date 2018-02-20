

Baseline concepts for databases:

* Postgres operates on a server/client model. R actually has a server mode, but that's a red herring and we're not going there. But when you set up Postgres, you're definitely setting up a "server" and a "client" -- at the same time.

In general we think about a "server" as a computer over there that is running some software, hanging out, waiting for someone to ask for something. And a "client" is our computer that is optimized for asking. We open a web browser (which is a client) and ask for a web page. The browser negotiates the technical maze to get the right file from the web server and display it.

But technically, your own computer can be server and client at the same time.

So we're actually going to establish a postgres server, and connect to it with a client, and then query it.  
