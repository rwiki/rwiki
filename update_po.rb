#!/usr/bin/env ruby

require "find"

langs = %w(ja en)
po_dir = "po"
pot = File.join(po_dir, "rwiki.pot")
erb_pot = File.join(po_dir, "rwiki_erb.pot")
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

system("rm", "-r", "-f", pot)
system("rgettext", *(rbs + ["-o", pot]))
system("xgettext", *(erb_xgettext_options + erbs))

File.open(pot, "a") do |out|
  File.open(erb_pot, "r") do |f|
    out.puts
    out.print(f.read)
  end
end

langs.each do |lang|
  po = File.join(po_dir, "#{lang}.po")
  mo = File.join(po_dir, "#{lang}.mo")
  if File.exist?(po)
    system("msgmerge", "-U", po, pot)
  else
    system("cp", po, pot)
  end
  system("msgfmt", "-o", mo, po)
end
