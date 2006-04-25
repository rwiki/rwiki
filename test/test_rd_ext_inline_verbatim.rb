require "rd-test-util"

require 'rwiki/rd/ext/inline-verbatim'

class TestRDExtInlineVerbatim < Test::Unit::TestCase
  include RDTestUtil

  def test_ext_inline_verb_erb_escape
    source = "(('<%= 1 + 1 %>'))"
    expected_source = "<p>&lt;%= 1 + 1 %&gt;</p>"
    expected = HTree.parse(expected_source)
    actual = HTree.parse(parse_rd(source))
    assert_equal(expected, actual)
  end
end
