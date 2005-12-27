#!/usr/bin/ruby
require 'optparse'
require 'pp'
require 'xmlrpc/client'

wikirpc_uri = "http://localhost:1818/RPC2"
$opt = Hash.new
ARGV.options do |opts|
  opts.on("--wikirpc-uri=URI") {|wikirpc_uri|}
  opts.on("--verbose") {|$opt[:VERBOSE]|}
  opts.parse!
end

$wiki = XMLRPC::Client.new2(wikirpc_uri).proxy("wiki")
def t(code)
  puts "{#{code}}:"
  result = eval(code)
  if $opt[:VERBOSE]
    pp result
  else
    puts "success"
  end
rescue XMLRPC::FaultException => e
  puts "#{e.inspect}:\n#{e.faultCode}: #{e.faultString}"
rescue
  p $!
end

page = 'recent'
put_test_page = 'putPage test'
attachmentName = 'test'
t %{ $wiki.getRecentChanges(Time.now - 24*60*60) }
t %{ $wiki.getRPCVersionSupported() }
t %{ $wiki.getPage('#{page}') }
t %{ $wiki.getPageVersion('#{page}', 1) }
t %{ $wiki.getPageHTML('#{page}') }
t %{ $wiki.getPageHTMLVersion('#{page}', 1) }
t %{ $wiki.getAllPages }
t %{ $wiki.getPageInfo('#{page}') }
t %{ $wiki.getPageInfoVersion('#{page}', 1) }
t %{ $wiki.listLinks('#{page}') }
t %{ $wiki.getBackLinks('#{page}') }
t %{ $wiki.putPage('#{put_test_page}','putPage test', Hash.new)  }
t %{ $wiki.listAttachments('#{page}') }
t %{ $wiki.getAttachment('#{attachmentName}') }
t %{ $wiki.putAttachment('#{put_test_page}', XMLRPC::Base64.new('putAttachment test')) }
