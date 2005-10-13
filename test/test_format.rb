require 'rw-config'
require 'rwiki/format'

require 'rd-test-util'
require 'rw-test-util'
require 'ostruct'

class TestFormat < Test::Unit::TestCase
  include RDTestUtil
  include RWTestUtil

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
    assert_equal(expected, modified(Time.now - diff))
  end

  # -1 of negative diff is for processing time.
  def test_modified
    assert_equal('-', modified(nil))
    assert_equal("0m", modified(Time.now))
    assert_modified("0m", 59)
    assert_modified("-0m", -59)
    assert_modified("1m", 60)
    assert_modified("-1m", -60-1)
    assert_modified("1m", 90)
    assert_modified("-1m", -90)
    assert_modified("1m", 119)
    assert_modified("-1m", -119)
    assert_modified("2m", 120)
    assert_modified("-2m", -120-1)
    assert_modified("60m", 60*60)
    assert_modified("-60m", -60*60-1)
    assert_modified("1h", 61*60)
    assert_modified("-1h", -61*60-1)
    assert_modified("24h", 24*60*60)
    assert_modified("-24h", -24*60*60-1)
    assert_modified("24h", 25*60*60-1)
    assert_modified("-24h", -25*60*60)
    assert_modified("1d", 25*60*60)
    assert_modified("-1d", -25*60*60-1)
    assert_modified("365d", 365*24*60*60)
    assert_modified("-365d", -365*24*60*60-1)
    assert_modified("1y(366d)", 366*24*60*60)
    assert_modified("-1y(-366d)", -366*24*60*60-1)
  end

  def assert_modified_class(expected, diff)
    assert_equal(expected, modified_class(Time.now - diff))
  end

  # -1 of negative diff is for processing time.
  def test_modified_class
    assert_equal('dangling', modified_class(nil))
    assert_equal("modified-hour", modified_class(Time.now))
    assert_modified_class("modified-hour", 59)
    assert_modified_class("modified-future", -59)
    assert_modified_class("modified-hour", 60*60)
    assert_modified_class("modified-future", -60*60-1)
    assert_modified_class("modified-today", 61*60)
    assert_modified_class("modified-future", -61*60-1)
    assert_modified_class("modified-today", 24*60*60)
    assert_modified_class("modified-future", -24*60*60-1)
    assert_modified_class("modified-today", 25*60*60-1)
    assert_modified_class("modified-future", -25*60*60)
    assert_modified_class("modified-month", 25*60*60)
    assert_modified_class("modified-future", -25*60*60-1)
    assert_modified_class("modified-year", 365*24*60*60)
    assert_modified_class("modified-future", -365*24*60*60-1)
    assert_modified_class("modified-old", 366*24*60*60)
    assert_modified_class("modified-future", -366*24*60*60-1)
  end

  def test_link_and_modified
    name = "dummy page name"
    modified = Time.now
    
    pg = OpenStruct.new
    pg.name = name
    pg.modified = modified

    expected = %Q!<a href="#{ref_name(name)}"!
    expected << %Q! title="#{h(name)} (#{modified(modified)})"!
    expected << %Q! class="#{modified_class(modified)}">#{h(name)}</a>!
    expected << " (#{h(modified(modified))})"
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

  def pagename_to_filename(name)
    name = name.gsub(/([^a-zA-Z0-9.-]+)/n) do
      '_' + $1.unpack('H2' * $1.size).join('_').upcase
    end
    sprintf("%s.html", name)
  end

  def test_ref_name_with_format_string
    env = {}
    env['static_view'] = true
    env['ref_name'] = '%2$s.html'
    env['full_ref_name'] = 'full/%2$s.html'
    format = RWiki::PageFormat.new(env)
    actual = format.ref_name('test name%_')
    assert_equal('test%20name%25_.html', actual)
    actual = format.full_ref_name('test name%_')
    assert_equal('full/test%20name%25_.html', actual)
  end

  def test_ref_name_with_proc
    ref_name_proc = proc do |cmd, name, params|
      pagename_to_filename(name)
    end
    full_ref_name_proc = proc do |cmd, name, params|
      'full/' + pagename_to_filename(name)
    end
    env = {}
    env['static_view'] = true
    env['ref_name'] = ref_name_proc
    env['full_ref_name'] = full_ref_name_proc
    format = RWiki::PageFormat.new(env)
    actual = format.ref_name('test name%_')
    assert_equal('test_20name_25_5F.html', actual)
    actual = format.full_ref_name('test name%_')
    assert_equal('full/test_20name_25_5F.html', actual)
  end

  def test_ref_name_type_underline_html
    env = {}
    env['static_view'] = true
    env['ref_name'] = env['full_ref_name'] = :underline_html
    format = RWiki::PageFormat.new(env)
    actual = format.ref_name('test name%_')
    assert_equal('test_20name_25_5F.html', actual)
    actual = format.full_ref_name('test name%_')
    assert_equal('./test_20name_25_5F.html', actual)
  end

  def test_locale
    env = {
      "locales" => ["en"],
    }
    format = RWiki::PageFormat.new(env)
    
    msg_id = "navi|home"
    if defined?(Locale)
      msg_str = "Home"
    else
      msg_str = "home"
    end
    
    assert_equal(msg_id, format.N_(msg_id))
    assert_equal(msg_str, format.s_(msg_id))
  end

  def test_limit_number
    limit_key = "pages"
    limit_num = "50"
    default_num = 30
    max = 100
    
    num, range, have_more = @format.limit_number(limit_key, default_num, max)
    expected_num = default_num
    assert_equal(expected_num, num)
    assert_equal(0...expected_num, range)
    assert(have_more)

    
    env = {
      'base' => "rw-cgi.rb"
    }
    var = {
      limit_key => form_data(limit_num, (limit_num.to_i + 30).to_s),
    }
    format = RWiki::PageFormat.new(env) {|key| var[key]}

    num, range, have_more = format.limit_number(limit_key, default_num, max)
    expected_num = limit_num.to_i
    assert_equal(expected_num, num)
    assert_equal(0...expected_num, range)
    assert(have_more)

    
    var = {
      limit_key => form_data(max.to_s),
    }
    format = RWiki::PageFormat.new(env) {|key| var[key]}

    num, range, have_more = format.limit_number(limit_key, default_num, max)
    expected_num = max
    assert_equal(expected_num, num)
    assert_equal(0...expected_num, range)
    assert(!have_more)

    
    var = {
      limit_key => form_data((max - 1).to_s),
    }
    format = RWiki::PageFormat.new(env) {|key| var[key]}

    num, range, have_more = format.limit_number(limit_key, default_num, max)
    expected_num = max - 1
    assert_equal(expected_num, num)
    assert_equal(0...expected_num, range)
    assert(have_more)

    
    var = {
      limit_key => form_data("-1"),
    }
    format = RWiki::PageFormat.new(env) {|key| var[key]}

    num, range, have_more = format.limit_number(limit_key, default_num, max)
    expected_num = -1
    assert_equal(-1, num)
    assert_equal(0..-1, range)
    assert(!have_more)
  end

  private
  def modified(t)
    RWiki::ModifiedFormatter.modified(t)
  end

  def modified_class(t)
    RWiki::ModifiedFormatter.modified_class(t)
  end
end
