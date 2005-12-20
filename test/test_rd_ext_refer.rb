require "rd-test-util"

require "rwiki/rd/ext/refer"

class TestRDExtRefer < Test::Unit::TestCase
  include RDTestUtil

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

  def test_ext_refer_atdot_w3ml
    name = "yarv-dev"
    number = 1
    uri = "http://www.atdot.net/~ko1/w3ml/w3ml.cgi/#{name}/msg/#{number}"
    number = number.to_i.to_s
    attrs = {"class" => "external"}
    content = "[#{name}:#{number}]"

    expected = HTree.parse("<p>#{a(uri, content, attrs)}</p>")
    actual = HTree.parse(parse_rd("((<#{name}:#{number}>))"))
    assert_equal(expected, actual)
  end

  def test_ext_refer_ruby_cvs_16000
    name = "ruby-cvs"
    number = 16000
    uri = "http://www.atdot.net/~ko1/w3ml/w3ml.cgi/#{name}/msg/#{number}"
    number = number.to_i.to_s
    attrs = {"class" => "external"}
    content = "[#{name}:#{number}]"

    expected = HTree.parse("<p>#{a(uri, content, attrs)}</p>")
    actual = HTree.parse(parse_rd("((<#{name}:#{number}>))"))
    assert_equal(expected, actual)
  end

  def test_ext_refer_ruby_cvs_oniguruma
    name = "ruby-cvs"
    repository = "oniguruma"
    uri = "http://www.ruby-lang.org/cgi-bin/cvsweb.cgi/#{repository}"
    attrs = {"class" => "external"}
    content = "[#{name}:#{repository}]"

    expected = HTree.parse("<p>#{a(uri, content, attrs)}</p>")
    actual = HTree.parse(parse_rd("((<#{name}:#{repository}>))"))
    assert_equal(expected, actual)
  end

  def test_ext_refer_ruby_src_README_EXT
    name = "ruby-src"
    file = "README.EXT"
    uri = "http://www.ruby-lang.org/cgi-bin/cvsweb.cgi/ruby/#{file}?rev=HEAD"
    attrs = {"class" => "external"}
    content = "[#{name}:#{file}]"

    expected = HTree.parse("<p>#{a(uri, content, attrs)}</p>")
    actual = HTree.parse(parse_rd("((<#{name}:#{file}>))"))
    assert_equal(expected, actual)
  end

  def test_ext_refer_ruby_win32ML
    name = "ruby-win32"
    number = 1
    content = "[#{name}:#{number}]"

    expected = HTree.parse("<p>#{content}</p>")
    actual = HTree.parse(parse_rd("((<#{name}:#{number}>))"))
    assert_equal(expected, actual)
  end

  def test_ext_refer_RFC
    number = 2822
    uri = "http://www.ring.gr.jp/archives/doc/RFC/rfc#{number}.txt"
    attrs = {"class" => "external"}
    content = "RFC #{number}"

    expected = HTree.parse("<p>#{a(uri, content, attrs)}</p>")
    actual = HTree.parse(parse_rd("((<RFC:#{number}>))"))
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
