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

  def test_ext_refer_FreeML
    name = "rubyist"
    number = "%07d" % 1
    uri = "http://www.freeml.com/message/#{name}@freeml.com/#{number}"
    number = number.to_i.to_s
    attrs = {"class" => "external"}
    content = "[#{name}:#{number}]"

    expected = HTree.parse("<p>#{a(uri, content, attrs)}</p>")
    actual = HTree.parse(parse_rd("((<#{name}:#{number}>))"))
    assert_equal(expected, actual)
  end

  def test_ext_refer_ruby_tracker
    [
      ["ruby-Bugs", 1698],
      ["ruby-Requests", 1699],
      ["ruby-Patches", 1700],
    ].each do |name, atid|
      number = 1
      params = {
        "func" => "detail",
        "aid" => number,
        "group_id" => 426,
        "atid" => atid,
      }.collect {|k, v| "#{k}=#{v}"}.join("&")
      uri = "http://rubyforge.org/tracker/?#{params}"
      attrs = {"class" => "external"}
      content = "[#{name}:##{number}]"

      expected = HTree.parse("<p>#{a(uri, content, attrs)}</p>")
      actual = HTree.parse(parse_rd("((<#{name}:#{number}>))"))
      assert_equal(expected, actual)
    end
  end

end
