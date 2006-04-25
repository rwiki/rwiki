= install

Install ((<RWiki>))

== Requirements¡¥

* Ruby Interpreter 
  ruby-1.8.4 

* RWiki
  * ((<RAA:RWiki>))

* Library
  * ((<RAA:RDtool>)) (0.6.20)

== Suggestions for fun

* Libraries

  * ...


== Install RWiki

RWiki is usually constructed by two or more processes. The
processes are RWiki server and various interfaces. (CGI,
WEBrick, e-mail and so on)

First, we install RWiki server and some libraries which is
used by various interfaces. Next, we examine a configuration
of RWiki server and interfaces.

=== Install RWiki library

 $ tar xzvf rwiki-2.x.tar.gz
 $ cd rwiki-2.x
 $ sudo ruby install.rb

=== Start RWiki Server

There is a template of RWiki server in site/ directory.
site/rwiki.rb is a standard RWiki server.
First, we start the server for experiment.

 [Terminal1]
 $ cd site
 $ ruby -Ke -dv rwiki.rb

=== Start WEBrick Interface

We use RWiki by using various interfaces: CGI, WEBrick, mail
and so on. To confirm RWiki server is working or not, we
start HTTP server powered by WEBrick. WEBrick interface is
easy to use rather than other interfaces.

 [Terminal2]
 $ cd interface
 $ ruby -Ke rw-webrick.rb

Now, we can see default page by accessing
http://localhost:1818 with a Web browser.

=== Setup CGI Interface

CGI Inteface is here.
 interface/rw-cgi.rb

We need to setup interpreter name in the first line and the
lines which have "#SETUP" for our environment.
Next, we need to setup CGI for our HTTP server and try
rw-cgi.rb.

NOTE: Any old rw-cgi.rb doesn't have backward compatibility
for the latest RWiki server. We need to re-setup our CGI
interface if we version up from old RWiki.

=== Configure RWiki server

Let's configure RWiki server.
Some configurations are modified in site/rw-config.rb.
The following is important configurations list in
rw-config.rb:
  * contact address/name in footer - MAILTO/ADDRESS
  * the URI of CSS - CSS
  * the place of data files - DB_DIR
  * top page name - TOP_NAME
  * the port used by server - DRB_URI

We can customize a lot by modifying site/rwiki.rb.

=== Deployment RWiki server

RWiki server runs as daemon if -d option ($DEBUG) isn't
presented.

 $ ruby -Ke rwiki.rb

We run RWiki server without -d option after some experiment.

