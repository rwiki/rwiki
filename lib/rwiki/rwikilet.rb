# -*- indent-tabs-mode: nil -*-
require "rwiki/webrick"

module WEBrick
  class RWikilet < WEBrick::HTTPServlet::AbstractServlet
    include RWiki::WEBrickSupport
  end
end
