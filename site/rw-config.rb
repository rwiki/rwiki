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
  MAILTO = 'mailto:seki@ruby-lang.org'
  CSS = nil
  LANG = 'ja'
  CHARSET = nil

  ## Service
  DB_DIR = '../rd'
  CACHE_DIR = 'cache'
  TOP_NAME = 'top'
  TITLE = 'RWiki'
  DRB_URI = 'druby://:8470'
end

