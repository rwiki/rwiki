#!/usr/bin/ruby1.8

require 'rwiki/cgiapp'

$KCODE = 'EUC'	# SETUP
rwiki_uri = 'druby://localhost:8470'	# SETUP
rwiki_log_dir = '/var/tmp' 		# SETUP

DRb.start_service()
rwiki = DRbObject.new( nil, rwiki_uri )

cgi = CGI.new

if %r!\A/(.+).html\z! === cgi.path_info.to_s
  pagename = $1
else
  pagename = "top"
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
