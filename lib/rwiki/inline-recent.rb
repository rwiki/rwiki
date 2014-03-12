module RWiki
  class PageFormat
    @rhtml[:inline_recent] = ERBLoader.new('inline_recent(pg)', 'inline-recent.rhtml')
  end
end
