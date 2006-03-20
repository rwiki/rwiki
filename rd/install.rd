= install

Install ((<RWiki>))

== Requirements¡¥

* Ruby Interpreter 
  ruby-1.8.4 

* RWiki
  * ((<RAA:RWiki>))

* Library
  * ((<RAA:RDtool>)) (0.6.20)

== Install RWiki

=== Install RWiki library

 $ tar xzvf rwiki-2.x.tar.gz
 $ cd rwiki-2.x
 $ sudo ruby install.rb

=== Start RWiki Server

 [Terminal1]
 $ cd site
 $ ruby -Ke -dv rwiki.rb

=== Start WEBrick Interface

 [Terminal2]
 $ cd interface
 $ ruby -Ke rw-webrick.rb

Let see http://localhost:1818

=== Setup CGI Interface

CGI Inteface is here.
 interface/rw-cgi.rb


 FIXME
