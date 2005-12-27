#!/usr/bin/ruby -Ku
# interface/wikirpc.rb -- WikiRPC standalone interface
#
# Copyright (c) 2005 Kazuhiro NISHIYAMA
#
# You can redistribute it and/or modify it under the same terms as Ruby.

require 'optparse'
require 'rwiki/wikirpc/handler'
require 'xmlrpc/server'

log_level = WEBrick::Log::INFO
rwiki_uri = 'druby://localhost:8470'
wikirpc_servlet_path = '/RPC2'
webrick_options = {
  :AddressFamily => Socket::AF_INET,
  :Port => 1818
}
rwikilet_path = false

ARGV.options do |opts|
  opts.on("--log-level=LEVEL") {|level|
    log_level = WEBrick::Log.const_get(level.upcase)
  }
  opts.on("--rwiki-uri=URI") {|rwiki_uri|}
  opts.on("--servlet-path=PATH") {|wikirpc_servlet_path|}
  opts.on("--webrick-port=PORT", Integer) {|webrick_options[:Port]|}
  opts.on("--with-rwikilet=PATH") {|rwikilet_path|}

  opts.parse!
end

if /localhost/ =~ rwiki_uri
  DRb.start_service('druby://localhost:0') # localhost only
else
  DRb.start_service
end

webrick_options[:Logger] = WEBrick::Log.new(STDERR, log_level)
rwiki = DRbObject.new_with_uri(rwiki_uri)
#s = XMLRPC::Server.new(port, '127.0.0.1')

s = XMLRPC::WEBrickServlet.new
RWiki::WikiRPC::Handler.init_handlers(s, rwiki)
httpserver = WEBrick::HTTPServer.new(webrick_options)
if rwikilet_path
  require 'rwiki/service'
  require 'rwiki/rwikilet'

  service = RWiki::Service.new(rwiki, log_level)
  httpserver.mount(rwikilet_path, WEBrick::RWikilet, service)
end
httpserver.mount(wikirpc_servlet_path, s)
trap(:INT) { httpserver.shutdown }
trap(:HUP) { httpserver.shutdown }
httpserver.start
