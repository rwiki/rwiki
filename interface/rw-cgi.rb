#!/usr/local/bin/ruby

require 'rwiki/cgiapp'

$KCODE = 'EUC'	# SETUP
rwiki_uri = 'druby://localhost:8470'	# SETUP
rwiki_log_dir = '/var/tmp' 		# SETUP

DRb.start_service()
rwiki = DRbObject.new( nil, rwiki_uri )
app = RWikiCGIApp.new( rwiki, rwiki_log_dir ).start()

