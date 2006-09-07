module Kernel
  unless methods.include?("funcall")
    def funcall(*args, &block)
      __send__(*args, &block)
    end
  end
end

module RWiki
  # RWiki Server setup
  ## Page
  ADDRESS = 'Test Address'
  MAILTO = 'mailto:test@example.net'
  CSS = 'rwiki.css'
  LANG = nil
  CHARSET = nil

  ## Service
  DB_DIR = 'test/rd'
  TOP_NAME = 'test top'
  TITLE = 'Test RWiki'
  DRB_URI = 'druby://:8470'

  AVAILABLE_LOCALES = ["ja", "en"]
end
