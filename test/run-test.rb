#!/usr/bin/env ruby

require "fileutils"
require "test/unit"

tests = ARGV[0] || 'test/test_*.rb'

$LOAD_PATH.unshift("./lib")
$LOAD_PATH.unshift("./test")

ENV["GETTEXT_PATH"] = "./locale"

Dir.glob(tests) do |test|
  begin
    require test
  rescue LoadError
    puts "Can't load: #{test}"
  end
end

exit Test::Unit::AutoRunner.run($0, File.dirname($0))
