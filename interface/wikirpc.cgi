#!/usr/bin/ruby -Ku
# interface/wikirpc.cgi -- WikiRPC CGI interface
#
# Copyright (c) 2005 Kazuhiro NISHIYAMA
#
# You can redistribute it and/or modify it under the same terms as Ruby.

require 'rwiki/wikirpc/handler'
require 'xmlrpc/server'

rwiki_uri = 'druby://localhost:8470'	# SETUP

DRb.start_service('druby://localhost:0')
rwiki = DRbObject.new_with_uri(rwiki_uri)

if defined?(MOD_RUBY)
  # mod_ruby
  s = XMLRPC::ModRubyServer.new
elsif ENV.key?("GATEWAY_INTERFACE")
  # CGI
  s = XMLRPC::CGIServer.new
end

RWiki::WikiRPC::Handler.init_handlers(s, rwiki)
s.serve
