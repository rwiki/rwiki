
module RWiki
  # RWiki Server setup
  ## Page
  ADDRESS = "rubyist ML"
  MAILTO = "mailto:rubyist@freeml.com"
  CSS = "style.css"
  #LANG = nil
  LANG = 'ja'
  CHARSET = nil

  ## Service
  DB_DIR = "../man-rd-ja"
  CACHE_DIR = "../cache/man-ja"
  #TOP_NAME = "Ruby\245\352\245\325\245\241\245\354\245\363\245\271\245\336\245\313\245\345\245\242\245\353" # euc-jp
  #TITLE = "Ruby\245\352\245\325\245\241\245\354\245\363\245\271\245\336\245\313\245\345\245\242\245\353" # euc-jp

  require 'rwiki/encode'
  ::RWiki::Encode.use_punycode
  TOP_NAME = 'p-Ruby-jk4cg4ntfpd9dsdscui9h' # utf-8 and p_encode
  #TOP_NAME = "Ruby\343\203\252\343\203\225\343\202\241\343\203\254\343\203\263\343\202\271\343\203\236\343\203\213\343\203\245\343\202\242\343\203\253" # utf-8
  TITLE = "Ruby\343\203\252\343\203\225\343\202\241\343\203\254\343\203\263\343\202\271\343\203\236\343\203\213\343\203\245\343\202\242\343\203\253" # utf-8
  DRB_URI = "druby://localhost:7429"

  AVAILABLE_LOCALES = ["ja", "en"]
end
