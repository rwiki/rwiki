# rw-config.rb
#
# Copyright (c) 2000, 2002 Masatoshi SEKI
#
# rw-config.rb is copyrighted free software by Masatoshi SEKI.
# You can redistribute it and/or modify it under the same term as Ruby.

module RWiki
  # RWiki Server setup
  ## Page
  ADDRESS = 'Masatoshi SEKI'
  MAILTO = 'mailto:m_seki@mva.biglobe.ne.jp'
  CSS = 'http://divip.sourceforge.jp/rubyStyle.css'
  LANG = nil
  CHARSET = nil

  ## Service
  DB_DIR = '../rd'
  TOP_NAME = 'top'
  TITLE = 'RWiki'
  DRB_URI = 'druby://:8470'

  AVAILABLE_LOCALES = ["ja", "en"]

  # FAVICON = "http://example.com/XXX.png"
  # FAVICON_SIZE = "small"

  # RSS_CSS = "http://example.com/rss.css"
end

