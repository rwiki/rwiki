#!/usr/local/bin/ruby

require 'cgi'
require 'tofu/cgicontext'
require 'tofu/proxy'
require 'rwiki/tofu'

$KCODE = 'EUC'	# SETUP
rwiki_uri = 'druby://localhost:8470'	# SETUP

cgi = CGI.new

DRb.start_service()
rwiki = DRbObject.new(nil, rwiki_uri)
cntxt = Tofu::CGIContext.new(cgi)

rwiki_service = RWiki::TofuService.new(rwiki)
rwiki_service.do_GET(cntxt)

cntxt.close
