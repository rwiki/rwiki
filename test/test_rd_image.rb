require "rd-test-util"

require "rwiki/rd/ext/refer-image"

class TestRDImage < Test::Unit::TestCase
  include RDTestUtil

  def test_inline_img
    uri = "http://www.ruby-lang.org/image/title.gif"

    expected = HTree.parse("<p>#{img(uri, uri)}</p>")
    actual = HTree.parse(parse_rd("(('img:#{uri}'))"))
    assert_equal(expected, actual)

    actual = HTree.parse(parse_rd(%Q[((<"img:#{uri}">))]))
    assert_equal(expected, actual)
  end

  def test_inline_img_with_alt
    uri = "http://www.ruby-lang.org/image/title.gif"
    alt = "Ruby Title"

    expected = HTree.parse("<p>#{img(uri, alt)}</p>")
    actual = HTree.parse(parse_rd(%Q[((<#{alt}|"img:#{uri}">))]))
    assert_equal(expected, actual)
  end

  def test_block_img
    uri = "http://www.ruby-lang.org/image/title.gif"

    expected = HTree.parse("<p>#{img(uri, uri)}</p>")
    actual = HTree.parse(parse_rd(<<-IMG))
  # img
  # src = #{uri}
IMG
    assert_equal(expected, actual)

    actual = HTree.parse(parse_rd(<<-IMG))
  # image
  # src = #{uri}
IMG
    assert_equal(expected, actual)
  end

  def test_block_img_with_alt
    uri = "http://www.ruby-lang.org/image/title.gif"
    alt = "Ruby Title"

    expected = HTree.parse("<p>#{img(uri, alt)}</p>")
    actual = HTree.parse(parse_rd(<<-IMG))
  # image
  # src = #{uri}
  # desc = #{alt}
IMG
    assert_equal(expected, actual)

    actual = HTree.parse(parse_rd(<<-IMG))
  # image
  # src = #{uri}
  # description = #{alt}
IMG
    assert_equal(expected, actual)

    actual = HTree.parse(parse_rd(<<-IMG))
  # image
  # src = #{uri}
  # desc = #{alt} XXX
  # description = #{alt}
IMG
    assert_equal(expected, actual)
  end

  def test_block_img_with_class
    uri = "http://www.ruby-lang.org/image/title.gif"
    alt = "Ruby Title"
    klass = "right"
    
    expected = HTree.parse("<p>#{img(uri, alt, klass)}</p>")
    actual = HTree.parse(parse_rd(<<-IMG))
  # image
  # src = #{uri}
  # desc = #{alt}
  # class = #{klass}
IMG
    assert_equal(expected, actual)
  end

  def test_img_allow
    uri = "http://example.com/a.jpg"
    expected = HTree.parse("<p>#{img(uri)}</p>")
    actual = HTree.parse(parse_rd("(('img:#{uri}'))"))
    assert_equal(expected, actual)

    uri = "https://example.com/a.png"
    expected = HTree.parse("<p>#{img(uri)}</p>")
    actual = HTree.parse(parse_rd("(('img:#{uri}'))"))
    assert_equal(expected, actual)
  end

  def test_img_deny
    uri = "title.gif"
    expected = HTree.parse("<p>img:#{uri}</p>")
    actual = HTree.parse(parse_rd("(('img:#{uri}'))"))
    assert_equal(expected, actual)

    uri = "ftp://example.com/title.gif"
    expected = HTree.parse("<p>img:#{uri}</p>")
    actual = HTree.parse(parse_rd("(('img:#{uri}'))"))
    assert_equal(expected, actual)
  end

  def test_block_img_deny
    expected = HTree.parse("<pre>\n# img\n</pre>")
    actual = HTree.parse(parse_rd("  # img"))
    assert_equal(expected, actual)

    actual = HTree.parse(parse_rd("\n  # img"))
    assert_equal(expected, actual)

    actual = HTree.parse(parse_rd("  # img\n"))
    assert_equal(expected, actual)

    actual = HTree.parse(parse_rd("\n  # img\n"))
    assert_equal(expected, actual)
  end

end

