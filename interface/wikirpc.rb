#!/usr/bin/ruby

require 'rwiki/wikirpcapp'
require 'xmlrpc/server'

$KCODE = 'UTF8'
rwiki_uri = 'druby://localhost:8470'	# SETUP
port = 8080	# SETUP

DRb.start_service()
rwiki = DRbObject.new( nil, rwiki_uri )
rwiki_rpc = RWikiRPC.new( rwiki )

s = XMLRPC::Server.new(port)
s.add_handler("wiki", rwiki_rpc)
s.serve
