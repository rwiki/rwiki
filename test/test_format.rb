require 'rw-config'
require 'rwiki/format'

require 'rd-test-util'
require 'ostruct'

class TestFormat < Test::Unit::TestCase
  include RDTestUtil

  def setup
    env = {
      'base' => "rw-cgi.rb"
    }
    @format = RWiki::PageFormat.new(env)
  end

  def teardown
  end

  def test_navi_view
    pg = OpenStruct.new
    pg.name = "dummy page name"
    title = "dummy title"
    referer = nil

    expected = HTree.parse(%Q!<span class="navi">[<a href="#{ref_name(pg.name)}">#{h title}</a>]</span>!)
    actual = HTree.parse(@format.navi_view(pg, title, referer))
    assert_equal(expected, actual)
  end

  def assert_modified(expected, diff)
    assert_equal(expected, @format.modified(Time.now - diff))
  end

  def test_modified
    assert_equal('-', @format.modified(nil))
    assert_equal("0m", @format.modified(Time.now))
    assert_modified("1m", 61)
    assert_modified("1m", 90)
    assert_modified("1m", 119)
    assert_modified("2m", 121)
    assert_modified("60m", 60*60)
    assert_modified("1h", 61*60)
    assert_modified("24h", 24*60*60)
    assert_modified("24h", 25*60*60-1)
    assert_modified("1d", 25*60*60+1)
    assert_modified("367d", 367*24*60*60)
  end

  def test_ref_name
    expected = ref_name("test name")
    actual = @format.ref_name("test name")
    assert_equal(expected, actual)

    expected = ref_name('test name <&">', 'key <&">;'=>'value <&">;')
    actual = @format.ref_name('test name <&">', 'key <&">;'=>'value <&">;')
    assert_equal(expected, actual)

    expected = ref_name('test name <&">', {}, 'edit')
    actual = @format.ref_name('test name <&">', {}, 'edit')
    assert_equal(expected, actual)
  end
end

