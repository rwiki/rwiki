RWiki::Version.regist('rwiki/inline-recent', '2004-02-09')

module RWiki
  class PageFormat
    @rhtml[:inline_recent] = ERBLoader.new('inline_recent(pg)', 'inline-recent.rhtml')
  end
end
