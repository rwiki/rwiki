require "rd-test-case"

require "rwiki/rd/ext/refer"

class TestRDExtRefer < RDTestCase

  def test_ext_refer_RAA
    name = "RWiki"
    uri = "http://raa.ruby-lang.org/project/#{name}"
    attrs = {"class" => "external"}
    content = "[RAA:#{name}]"
    
    expected = HTree.parse("<p>#{a(uri, content, attrs)}</p>")
    actual = HTree.parse(parse_rd("((<RAA:#{name}>))"))
    assert_equal(expected, actual)
  end
end
