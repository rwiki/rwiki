# -*- indent-tabs-mode: nil -*-

require "rwiki/format"
require "iconv"

module RWiki
  module Transitional
    class RedirectFormat < ::RWiki::PageFormat
      @rhtml = {}
      @rhtml[:redirect] = RWiki::ERBLoader.new('redirect(pg)', 'transitional/redirect.rhtml')
      reload_rhtml
    end
  end
end
