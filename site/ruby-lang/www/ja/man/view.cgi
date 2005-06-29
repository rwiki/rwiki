#!/usr/local/bin/ruby1.8.1 -Ke

$LOAD_PATH.unshift "/var/lib/ruby-man/lib"

require 'rwiki/cgiapp'

rwiki_uri = "druby://localhost:7429" # ja/man
#rwiki_uri = "druby://localhost:8725" # ja/install

#$KCODE = 'EUC'	# SETUP

DRb.start_service("druby://localhost:0")
rwiki = DRbObject.new( nil, rwiki_uri )

cgi = CGI.new

case cgi.path_info.to_s
when %r!\A/(.+).html\z!
  pagename = $1
when '/style.css'
  cgi.out("status" => "REDIRECT", "Location" => "http://www.ruby-lang.org/ja/man/style.css") {
    %Q!<a href="../style.css">style.css</a>!
  } 
when %r|\A(?!/)|
  uri = "http://www.ruby-lang.org/ja/man/view/"
  cgi.out("status" => "REDIRECT", "Location" => uri) {
    %Q!<a href="#{uri}">#{uri}</a>!
  } 
else
  #pagename = "top"
  pagename = "Ruby\245\352\245\325\245\241\245\354\245\363\245\271\245\336\245\313\245\345\245\242\245\353"
end
page = rwiki.page(pagename)

if page.empty?
  cgi.out { "`#{pagename}' not found." }
  exit
end

env = {
        'static_view' => true,
        'ref_name' => '%2$s.html',
        'full_ref_name' =>
        RWiki::Request.base_url( ENV ) + '/%2$s.html',
}
res = Hash.new
res[ 'last-modified' ] = page.modified.httpdate if page.modified
res[ 'content-type' ] = "text/html; charset=euc-jp"
cgi.out(res) { page.static_view_html(env) }
