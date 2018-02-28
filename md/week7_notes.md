

Baseline concepts for databases:

* Postgres operates on a server/client model. R actually has a server mode, but that's a red herring and we're not going there. But when you set up Postgres, you're definitely setting up a "server" and a "client" -- at the same time.

In general we think about a "server" as a computer over there that is running some software, hanging out, waiting for someone to ask for something. And a "client" is our computer that is optimized for asking. We open a web browser (which is a client) and ask for a web page. The browser negotiates the technical maze to get the right file from the web server and display it.

But technically, your own computer can be server and client at the same time.

So we're actually going to establish a postgres server, and connect to it with a client, and then run queries. There are a lot of other things you can do with postgres -- store the data that underlies a content management system, for instance, but we're not going there.  

* Users: if you're writing applications, database roles (aka users) get a lot more important. If you're working with Posgres on a server, you're going to need to deal with defining and restricting roles. But if you're accessing a database on your own computer there's literally no reason to add that to your learning curve. So we're skipping it, but I want to make sure that I own that we're skipping it.

## Create Statements

Posgres isn't going to automatically read your csv and decide on data types. You have to define those manually.
