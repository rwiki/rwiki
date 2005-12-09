require 'rw-test-util'

require 'rw-config'

require 'rwiki/rwiki'
require 'rwiki/service'

class TestService < Test::Unit::TestCase

  def setup
    @service = RWiki::Service.new(nil)
  end

  def test_locales
    assert_equal(["ja", "ja"], normalize_locales(["ja", "JA"]))
    assert_equal(["ja", "ja_JP"], normalize_locales(["ja", "ja-JP"]))
    assert_equal(["ja", "ja_JP"], normalize_locales(["ja", "ja_jp"]))
    assert_equal(["ja", "ja_JP"], normalize_locales(["ja", "ja-jp"]))
    assert_equal(["ja", "ja_JP"], normalize_locales(["ja", "JA-jp"]))
    assert_equal(["ja", "ja_JP"], normalize_locales(["ja", "JA-JP"]))
    assert_equal(["ja", "ja_JP"], normalize_locales(["ja", "JA_JP"]))
  end

  def normalize_locales(locales)
    @service.funcall(:normalize_locales, locales)
  end
end
