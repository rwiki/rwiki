= How to install

== Requirements

* ((*Ruby*))
  * Installation of ruby/1.6 series is a prerequisite for RWiki.

(1) Check your version of Ruby; update if necessary. 

     $ ruby -v

(2) Check Ruby's library search path.  I recommend that you install RWiki, 
    and any additionally required libraries, within a library directory 
    that exists in Ruby's search path. Otherwise, there is another step. 
    You will have to set your environment, so that it includes your 
    personal library directory. 

     $ ruby -e 'p $:'

  * Do you have a current version of Ruby?
 
  * Have you selected (or created) a directory where RWiki will be installed? 

Note: In the following instructions I will use /home/nahi/lib/ruby as 
the example. Use whatever directory you have selected.

Good, let us proceed!

* RWiki requires the following libraries:
  * ((<RAA:druby - distributed ruby>)) (2.0.0)
  * ((<RAA:ERB>)) (2.0.2)
  * ((<RAA:Devel::Logger>)) (1.2.0)
  * ((<RAA:RDtool>)) (0.6.10)
    * ((<RAA:OptionParser>))
    * ((<RAA:Racc>))
    * ((<RAA:strscan>))

((*Caution*)): You must install the required libraries before installing 
RWiki. Some of these required libraries may exist already on your system, 
particularly if you previously installed ((<RAA:ruby-sumo>)).

(1) You must have /home/nahi/lib/ruby and /home/nahi/bin directories 
    to proceed. Create them, if necessary. 

(2) ((*druby*)). Does it exist in your selected directory? If not, 
    get the archive; extract it to a source directory; change to 
    the source directory; and:

     $ cp -pr lib/* /home/nahi/lib/ruby

(3) ((*erb*)). Does it exist in your selected directory? If not, 
    get the archive; extract it to a source directory; change to 
    the source directory; and:

     $ cp -p lib/* /home/nahi/lib/ruby

(4) ((*Devel::Logger*)). Does it exist in your selected directory? 
    If not, get the archive; extract it to a source directory; 
    change to the source directory; and:

     $ cp -p lib/* /home/nahi/lib/ruby

(5) ((*Racc*)). Does it exist in your selected directory? If not, 
    get the archive; extract it to a source directory; change to 
    the source directory; and, install it to whatever directory 
    you have selected as your base directory:

     $ ruby setup.rb config --bin-dir=/home/nahi/bin --rb-dir=/home/nahi/lib/ruby --so-dir=/home/nahi/lib/ruby
     $ ruby setup.rb setup
     $ ruby setup.rb install
     $ ruby setup.rb clean
     $ rm -rf config.save ext/cparse/Makefile

(6) ((*strscan*)). Does it exist in your selected directory? If not, 
    get the archive; extract it to a source directory; change to the 
    source directory; and, install it to whatever directory you have 
    selected as your base directory:

     $ ruby install.rb config --bin-dir=/home/nahi/bin --rb-dir=/home/nahi/lib/ruby --so-dir=/home/nahi/lib/ruby
     $ ruby install.rb setup
     $ ruby install.rb install
     $ ruby install.rb clean
     $ rm -f config.save ext/strscanso/Makefile

(7) ((*optparse*)). Does it exist in your selected directory? If not, 
    get the archive; extract it to a source directory; change to the 
    source directory; and:

     $ cp -p optparse.rb /home/nahi/lib/ruby

(8) ((*rdtool*)). 

((*Caution*)): The sequence of installing the required libraries 
is somewhat important. You must install Racc before you install rdtool. 

  * Does it exist in your selected directory? If not, get the archive;
    extract it to a source directory; and, change to the source directory. 

  * Now you must configure the Makefile, so that rdtool installs to 
    whatever directory you have selected as your base directory:

     $ ruby rdtoolconf.rb

     $ vi Makefile        # Change Makefile
     BIN_DIR = /home/nahi/bin
     SITE_RUBY = /home/nahi/lib/ruby
     RD_DIR = /home/nahi/lib/ruby/rd

     $ make install install-rmi2html
     $ make clean

Okay, that is all of the required libraries. You now may proceed 
with installation of RWiki.

== RWiki installation

  * Do you have all the required libraries installed?
  * Do you know what directory is your CGI directory?

Good, let us proceed!

* RWiki
  * ((<RAA:RWiki>))

(1) Get the package and extract it.

(2) Install library

     $ sudo ruby install.rb
     $ cp -pr lib/* /home/nahi/lib/ruby

(3) Install code
     $ cd site
     $ cp *.* /home/nahi/lib/ruby/lib

(4) Install CGI. (In these instructions '~/public' is the system's 
    CGI directory. You should copy rw-cgi.rb to your CGI directory.)

     $ cd ..
     $ cp interface/rw-cgi.rb ~/public

(5) After you have copied rw-cgi.rb to your CGI directory, go to that 
    directory, change the permission, and edit rw-cgi.rb with your 
    favorite editor:

     $ cd ~/public/
     $ chmod 755 rw-cgi.rb
     $ vi rw-cgi.rb

(6) Now configure ((*rw-cgi.rb*)). Insert a new line (substitute the 
    directory you selected) as line two in rw-cgi.rb:

     $:.unshift('/home/nahi/lib/ruby/lib')

(7) Edit the lines containing the comment 'SETUP'. Note: If you want 
    to accept dial-in and telnet access, you should set the KCODE 
    variable to "SJIS." Otherwise, leave it set at "EUC." Please 
    edit these lines in rw-cgi.rb according to your personal specifications:

     $KCODE = 'EUC'  # SETUP
     rwiki_uri = 'druby://localhost:8470'    # SETUP
     rwiki_log_dir = '/var/tmp'              # SETUP

(8) Last you must configure ((*rw-config.rb*)). Note: ((<W3C Internationalization|URL:http://www.w3.org/International/O-charset-lang.html>)) 
    has more information about LANG and CHARSET variables. 
    Please edit the lines in rw-config.rb according to your 
    personal specifications:

     $ cd /home/nahi/lib/ruby/lib
     $ vi rw-config.rb


     ## Page 
     ADDRESS = 'Your Name'
     MAILTO = 'mailto:YourEmailAddress'
     CSS = 'http://divip.sourceforge.jp/rubyStyle.css'
     LANG = nil
     CHARSET = nil
  
     ## Service
     DB_DIR = '../rd'
     TOP_NAME = 'top'
     TITLE = 'Your Wiki Site Name'
     DRB_URI = 'druby://localhost:8470'

(9) ((*Optional*)): If Ruby's library search path does NOT include 
    your personal library directory, you must set environment. 
    Below are two different ways this is done; it depends upon your 
    operating system. 

     $ setenv RUBYLIB /home/nahi/lib/ruby

    or

     $ RUBYLIB=$RUBYLIB:"/home/nahi/lib/ruby"
     $ export RUBYLIB

== RWiki operation

  * Have you you configured ((*rw-cgi.rb*))?

  * Have you configured ((*rw-config.rb*))?

  * Are all executables in Ruby's library search path?

Good, let us proceed!

(1) Start the rwiki server, which should be located in 
    /home/nahi/lib/ruby/lib, or wherever you selected:

    debug mode ..

     $ ruby -dv rwiki.rb

    or daemon mode 

     $ ruby rwiki.rb

(2) Open rw-cgi.rb with your web browser. You now should be able to 
    edit the top page of your new RWiki!


== Troubleshooting 

: ((*Environment*))
    One daemon process is made in a certain machine.
    It is necessary to allocate one port number to this daemon. 
    (The port number is spesified by RWIKI_URI.)

    Note: This RWiki daemon eats the memory considerably. 
    (It is proportional to the size of pages now).

    You must set the environment for CGI program when you use CGI interface.
    You must set the environment for mail processing program 
    (postfix, sendmail, etc.) when you use mail interface.

: ((*Why the blessed RWiki sentence Insecure operation to my `require'?*))
    When you run your Ruby script on mod_ruby environment, 
    the following type of error occurs unless the libraries which the script 
    requires are on the search list (path) of the Ruby libraries:

        /home/nahi/public_html/rw-cgi.mrb:20:in `require': Insecure operation - require (SecurityError)
                from /home/nahi/public_html/rw-cgi.mrb:20

    rw-cgi.rb conditions the search list (path) of the libraries using $RWIKI_DIR.
    Try setup $RWIKI_DIR by hand.

: ((*Why I meet parse error?*))

    What kind of?
    If it's on such as `@@acl' or `@@cgi_name', that's probably because
    you would run RWiki on ruby-1.4 (or earlier).
     * RWiki has class variables (@@???).

    Only on the CGI interface (rw-cgi.rb),
    it would work on ruby-1.4 with your secret hack on rw-lib.rb.
    In this case, I may recommend you to use dRuby-1.2 series.

: ((*CGI doesn't wake up.*))

    Does RWikiCGIApp.log say "No address associated with hostname"?

    Don't write down DRB_URI on $RWIKI_URI of rw-config.rb AS IS.
    $RWIKI_URI of rw-cgi.rb should be the address of the RWiki server
    (rwiki.rb) in the CGI's point of the path.
    For example:
        $RWIKI_URI = 'druby://localhost:8470'


== Thanks

* NaHi
* JWS

