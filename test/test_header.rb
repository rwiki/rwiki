require "rd-test-util"

require 'rw-config'
require "rwiki/format"

class TestHooks < Test::Unit::TestCase
  include RDTestUtil

  def test_header_hooks
    # FIX ME
    Hooks.header_hooks.each do |hook|
    end
  end

end

