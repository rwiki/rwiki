#!/usr/bin/env ruby

require "find"

langs = %w(ja en)

def run(command, *args)
  unless system(command, *args)
    STDERR.puts("can't run command: #{command} #{args.join(' ')}")
    exit(1)
  end
end

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

run("rm", "-r", "-f", pot)
run("rgettext", *(rbs + ["-o", pot]))
run("xgettext", *(erb_xgettext_options + erbs))

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
    run("msgmerge", "-U", po, pot)
  else
    run("cp", po, pot)
  end
  run("msgfmt", "-o", mo, po)
end
