#!/usr/bin/env ruby

require "fileutils"
require "test/unit"

if ARGV[0] && /\A-/ !~ ARGV[0]
  tests = ARGV[0]
else
  tests = 'test/test_*.rb'
end

$LOAD_PATH.unshift("./lib")
$LOAD_PATH.unshift("./test")
$LOAD_PATH.unshift("./test-unit-ext/lib")

require "rw-config"
# require "test-unit-ext"

ENV["GETTEXT_PATH"] = File.join("data", "locale")

Dir.glob(tests) do |test|
  begin
    require test
  rescue LoadError
    puts "Can't load: #{test}: #{$!.message}"
  end
end

if Test::Unit::AutoRunner.respond_to?(:standalone?)
  exit Test::Unit::AutoRunner.run(false, File.dirname($0))
else
  exit Test::Unit::AutoRunner.run($0, File.dirname($0))
end
