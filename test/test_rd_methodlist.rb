require "rd-test-util"

require "rwiki/rd/rd2rwiki-lib"

class TestRDMethodList < Test::Unit::TestCase
  include RDTestUtil

  def test_method_list_dt
    expected = HTree.parse(%Q|<dl>\n<dt><a name="test" id="test"></a><code>test</code><!-- RDLabel: "test" --></dt>\n</dl>|)
    actual = HTree.parse(parse_rd("--- test"))
    assert_equal(expected, actual)
  end

  def test_method_list_dt_dd
    expected = HTree.parse(%Q|<dl>\n<dt><a name="test" id="test"></a><code>test</code><!-- RDLabel: "test" --></dt>\n<dd>\n<p>body</p></dd>\n</dl>|)
    actual = HTree.parse(parse_rd("--- test\n    body"))
    assert_equal(expected, actual)
  end

  def test_method_list_with_trailing_link
    expected = HTree.parse(%Q~<dl>\n<dt><a name="Hash.2enew" id="Hash.2enew"></a><code>Hash.new {|<var>hash</var>, <var>key</var>| ...}</code><!-- RDLabel: "Hash.new" --> (<a href="rw-cgi.rb?cmd=view;name=ruby+1.7+feature">ruby 1.7 feature</a>)</dt>\n<dd>\n<p>body</p></dd>\n</dl>~)
    actual = HTree.parse(parse_rd("--- Hash.new {|hash, key| ...}        ((<ruby 1.7 feature>))\n    body"))
    assert_equal(expected, actual)
  end

end

