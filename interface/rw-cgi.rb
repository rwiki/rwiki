#!/usr/local/bin/ruby

require 'drb/drb'

require 'rwiki/cgi'
require 'rwiki/service'

$KCODE = 'EUC'	# SETUP
rwiki_uri = 'druby://localhost:8470'	# SETUP
rwiki_log_file = '/var/tmp/rw-cgi.log' 		# SETUP

DRb.start_service()
log_level = Logger::Severity::INFO
rwiki = DRbObject.new_with_uri(rwiki_uri)
service = RWiki::Service.new(rwiki, log_level)
service.set_log(rwiki_log_file, 'weekly')
cgi = RWiki::CGI.new({}, service)
cgi.start
