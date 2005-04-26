#!/usr/bin/env ruby

require "fileutils"
require "test/unit"

tests = ARGV[0] || 'test/test_*.rb'

$LOAD_PATH.unshift("./lib")
$LOAD_PATH.unshift("./test")

require "rw-config"

ENV["GETTEXT_PATH"] = File.join("data", "locale")

Dir.glob(tests) do |test|
  begin
    require test
  rescue LoadError
    puts "Can't load: #{test}: #{$!.message}"
  end
end

exit Test::Unit::AutoRunner.run(false, File.dirname($0))
