#!/usr/bin/env ruby

$LOAD_PATH.unshift(Dir.pwd)

require "fileutils"
require "po/config"
require "po/common"

LANGS.each do |lang|
  po = File.join(PO_DIR, "#{lang}.po")
  mo_dir = File.join("data", "locale", lang, "LC_MESSAGES")
  mo = File.join(mo_dir, "#{BASE_NAME}.mo")
  FileUtils.mkdir_p(mo_dir)
  run("msgfmt", "-o", mo, po)
end
