#!/usr/bin/env ruby

$LOAD_PATH.unshift(Dir.pwd)

require "po/config"
require "po/common"

LANGS.each do |lang|
  po = File.join(PO_DIR, "#{lang}.po")
  mo = File.join(PO_DIR, "#{lang}.mo")
  run("msgfmt", "-o", mo, po)
end
