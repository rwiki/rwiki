#!/usr/bin/env ruby

require "test/unit"

tests = 'test/test_*.rb'

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
