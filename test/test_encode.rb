require 'test/unit'
require 'rwiki/encode'

class TestRWikiEncode < Test::Unit::TestCase
  PunycodeMark = ::RWiki::Encode::PunycodeMark
  PunycodeMarkHex = "1A"

  def teardown
    ::RWiki::Encode.no_punycode
  end

  def assert_p_encode(expected, actual)
    assert_equal(expected, ::RWiki::Encode.p_encode(actual))
  end
  def test_p_encode
    assert_p_encode("info", "info")
    assert_p_encode(" ", " ")
    assert_p_encode("p-", "p-")
    assert_p_encode("123", "123")
    assert_p_encode("#{PunycodeMark}\000-", "\x00")
    assert_p_encode("#{PunycodeMark}", "")
    assert_p_encode("#{PunycodeMark}#{PunycodeMark}-", "#{PunycodeMark}")
    assert_p_encode("#{PunycodeMark}l8j", "\343\201\202")
  end

  def assert_p_decode(expected, actual)
    assert_equal(expected, ::RWiki::Encode.p_decode(actual))
  end
  def test_p_decode
    assert_p_decode("info", "info")
    assert_p_decode(" ", " ")
    assert_p_decode("p-", "p-")
    assert_p_decode("123", "123")
    assert_p_decode("\n", "#{PunycodeMark}\n-")
    assert_p_decode("", "#{PunycodeMark}")
    assert_p_decode("#{PunycodeMark}", "#{PunycodeMark}#{PunycodeMark}-")
    assert_p_decode("\343\201\202", "#{PunycodeMark}l8j")
  end

  def assert_dot_encode(expected, actual)
    assert_equal(expected, ::RWiki::Encode.dot_encode(actual))
  end
  def test_dot_encode
    assert_dot_encode("info", "info")
    assert_dot_encode("a.20", " ")
    assert_dot_encode("p-", "p-")
    assert_dot_encode("a123", "123")
    assert_dot_encode("a.e3.81.82", "\343\201\202")
  end

  def assert_dot_decode(expected, actual)
    assert_equal(expected, ::RWiki::Encode.dot_decode(actual))
  end
  def test_dot_decode
    assert_dot_decode("info", "info")
    assert_dot_decode("a ", "a.20")
    assert_dot_decode(" ", ".20")
    assert_dot_decode("p-", "p-")
    assert_dot_decode("a123", "a123")
    assert_dot_decode("123", "123")
    assert_dot_decode("a\343\201\202", "a.e3.81.82")
    assert_dot_decode("\343\201\202", ".e3.81.82")
  end

  def assert_url_escape(expected, actual)
    assert_equal(expected, ::RWiki::Encode.url_escape(actual))
  end
  def test_url_escape
    assert_url_escape("info", "info")
    assert_url_escape("+", " ")
    assert_url_escape("%25", "%")
    assert_url_escape("p-", "p-")
    assert_url_escape("123", "123")
    assert_url_escape("%E3%81%82", "\343\201\202")
  end

  def assert_label2anchor(expected, actual)
    assert_equal(expected, ::RWiki::Encode.label2anchor(actual))
  end
  def test_label2anchor
    assert_label2anchor("a.2e", ".")
    assert_label2anchor("a.e3.81.82", "\343\201\202")
    ::RWiki::Encode.use_punycode
    assert_label2anchor("a.2e", ".")
    assert_label2anchor("p.#{PunycodeMarkHex.downcase}l8j", "\343\201\202")
    ::RWiki::Encode.no_punycode
    assert_label2anchor("a.2e", ".")
    assert_label2anchor("a.e3.81.82", "\343\201\202")
  end

  def assert_name_escape(expected, actual)
    assert_equal(expected, ::RWiki::Encode.name_escape(actual))
  end
  def test_name_escape
    assert_name_escape("%25", "%")
    assert_name_escape("%E3%81%82", "\343\201\202")
    ::RWiki::Encode.use_punycode
    assert_name_escape("%25", "%")
    assert_name_escape("p%#{PunycodeMarkHex}l8j", "\343\201\202")
    ::RWiki::Encode.no_punycode
    assert_name_escape("%25", "%")
    assert_name_escape("%E3%81%82", "\343\201\202")
  end

  def assert_name_unescape(expected, actual)
    assert_equal(expected, ::RWiki::Encode.name_unescape(actual))
  end
  def test_name_unescape
    assert_name_unescape("#{PunycodeMark}l8j", "#{PunycodeMark}l8j")
    ::RWiki::Encode.use_punycode
    assert_name_unescape("\343\201\202", "#{PunycodeMark}l8j")
    ::RWiki::Encode.no_punycode
    assert_name_unescape("#{PunycodeMark}l8j", "#{PunycodeMark}l8j")
  end

  def test_geta_escape
    actual = "\0"
    assert_equal('&#x3013;', ::RWiki::Encode.geta_escape(actual))
    assert_equal("\0", actual)
  end

  def test_geta_escape!
    actual = "\0"
    assert_equal('&#x3013;', ::RWiki::Encode.geta_escape!(actual))
    assert_equal('&#x3013;', actual)
  end
end
