require "rd-test-util"

require "rwiki/rd/ext/interwikiname"

class TestRDExtInterWikiName < Test::Unit::TestCase
  include RDTestUtil

  def teardown
    ::RD::Ext::Refer.init_InterWikiName
  end

  def test_ext_refer_InterWikiName_with_dollar1
    category = "TestRubyForge"
    name = "ruby"
    ::RD::Ext::Refer.add_InterWikiName(category, "http://rubyforge.org/projects/$1/")
    uri = "http://rubyforge.org/projects/#{name}/"
    attrs = {"class" => "external"}
    content = "[#{category}:#{name}]"

    expected = HTree.parse("<p>#{a(uri, content, attrs)}</p>")
    actual = HTree.parse(parse_rd("((<#{category}:#{name}>))"))
    assert_equal(expected, actual)
  end

  def test_ext_refer_InterWikiName_without_dollar1
    category = "TestRAA"
    name = "ruby"
    ::RD::Ext::Refer.add_InterWikiName(category, "http://raa.ruby-lang.org/project/")
    uri = "http://raa.ruby-lang.org/project/#{name}"
    attrs = {"class" => "external"}
    content = "[#{category}:#{name}]"

    expected = HTree.parse("<p>#{a(uri, content, attrs)}</p>")
    actual = HTree.parse(parse_rd("((<#{category}:#{name}>))"))
    assert_equal(expected, actual)
  end

end
