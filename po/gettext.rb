#!/usr/bin/env ruby

require "find"

$LOAD_PATH.unshift(Dir.pwd)

require "po/config"
require "po/common"

erb_pot = File.join(PO_DIR, "rwiki_erb.pot")
erb_xgettext_options = [
  "-k_", "-kN_",
  "--force-po",
  "--omit-header",
  "-o", erb_pot,
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

run("rm", "-r", "-f", POT)
run("rgettext", *(rbs + ["-o", POT]))
run("xgettext", *(erb_xgettext_options + erbs))

File.open(POT, "a") do |out|
  File.open(erb_pot, "r") do |f|
    out.puts
    out.print(f.read)
  end
end
