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

  def test_link_and_modified
    name = "dummy page name"
    modified = Time.now
    
    pg = OpenStruct.new
    pg.name = name
    pg.modified = modified

    expected = %Q!<a href="#{ref_name(name)}" !
    expected << %Q!class="#{@format.modified_class(modified)}">#{h(name)}</a> !
    expected << "(#{h(@format.modified(modified))})"
    expected = HTree.parse(expected)
    
    assert_equal(expected, HTree.parse(@format.link_and_modified(pg)))
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

  def test_locale
    env = {
      "locales" => ["en"],
    }
    format = RWiki::PageFormat.new(env)
    
    msg_id = "navi|home"
    if defined?(:Locale)
      msg_str = "Home"
    else
      msg_str = "home"
    end
    
    assert_equal(msg_id, format.N_(msg_id))
    assert_equal(msg_str, format.s_(msg_id))
  end
end
