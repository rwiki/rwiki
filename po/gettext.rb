#!/usr/bin/env ruby

require "find"
require "fileutils"

$LOAD_PATH.unshift(Dir.pwd)

require "po/config"
require "po/common"

erb_xgettext_options = [
  "-k_", "-kN_",
  "-kn_:1,2", "-ks_",
  "--force-po",
  "--omit-header",
  "-j",
  "-o", POT,
  "-L", "PHP",
]
rbs = []
erbs = []

Find.find(File.join("lib", "rwiki")) do |file|
  Find.prune if /\.svn$/ =~ file
  if File.file?(file)
    if /\.rb$/ =~ file
      rbs << file
    else
      erbs << file
    end
  end
end

FileUtils.rm_f(POT)
run("rgettext", *(rbs + ["-o", POT]))
run("xgettext", *(erb_xgettext_options + erbs))

LANGS.each do |lang|
  po = File.join(PO_DIR, "#{lang}.po")
  if File.exist?(po)
    run("msgmerge", "-U", po, POT)
  else
    FileUtils.cp(POT, po)
  end
end
