#!/usr/bin/ruby -Ke

$LOAD_PATH.unshift "/var/lib/ruby-man/lib"

require 'drb/drb'

require 'rwiki/cgi'
require 'rwiki/service'

rwiki_uri = "druby://localhost:8726"
rwiki_log_file = "/var/lib/ruby-man/log/install-en.log"

DRb.start_service("druby://localhost:0")
log_level = Logger::Severity::INFO
rwiki = DRbObject.new_with_uri(rwiki_uri)
service = RWiki::Service.new(rwiki, log_level)
service.set_log(rwiki_log_file, 'weekly')
cgi = RWiki::CGI.new({}, service)
cgi.start
