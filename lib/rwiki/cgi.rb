require 'webrick/cgi'

require 'rwiki/webrick'

module RWiki
  class CGI < WEBrick::CGI
    include WEBrickSupport
  end
end
