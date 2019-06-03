
module RWiki
  DB_DIR = 'groonga_db'
  CACHE_DIR = 'cache'
  TOP_NAME = 'top'
  DRB_URI = 'druby://:8470'
end

require 'rwiki/rwiki'
require 'rwiki/front'
require 'rwiki/recent'

book = RWiki::Book.new
DRb.start_service(RWiki::DRB_URI, book.front)
puts DRb.uri

require 'webrick'

http_server = WEBrick::HTTPServer.new(
  :Port => 8000,
  :HTTPVersion => WEBrick::HTTPVersion.new('1.1'),
  :AccessLog => [[open(IO::NULL, 'w'), '']]
)

service = RWiki::Service.new(book.front)
http_server.mount_proc('/') do |req, res|
  service.serve(req, res)
end

http_server.start
