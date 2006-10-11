require 'test/unit'

require 'rw-config'

require 'rwiki/rwiki'
require 'rwiki/db/mock'
require 'rwiki/shelf/shelf'

class TestShelf < Test::Unit::TestCase
  def setup
    @db = RWiki::DB::Mock.new
    RWiki::BookConfig.default.db = @db
    RWiki::Book.section_list.clear
    @shelf_section = RWiki::Shelf::AsinSection.new(nil)
    RWiki::Book.section_list.push(@shelf_section)
    @book = RWiki::Book.new
  end

  def teardown
  end

  def test_core
    top = @book['top']
    assert_equal(nil, top.src)
    top.src = "= Top\n"
    assert_equal("= Top\n", top.src)
  end

  def test_asin
    asin = "4756139612"
    top = @book[RWiki::TOP_NAME]
    top.src = "= Top\n((<asin:#{asin}>))"

    druby = @book["asin:#{asin}"]
    assert_equal(@shelf_section, druby.section)
    prop = druby.prop(:shelf)
    assert_not_nil(prop)
    assert_equal(asin, prop[:asin])
    # assert_equal('2001/10', prop[:release_date])

    top.src = "= Top\n"
    save_src = druby.src
    druby.src = ''
    prop = druby.prop(:shelf)
    assert_nil(prop)

    druby.src = save_src
    prop = druby.prop(:shelf)
    assert_not_nil(prop)
    assert_equal(asin, prop[:asin])
    # assert_equal('2001/10', prop[:release_date])
  end

  def test_edit
    asin = 'asin:4756139612'
    druby = @book[asin]
    default_src = @book.default_src(druby.name)
    expected = HTree.parse(default_src).extract_text
    textarea = "{http://www.w3.org/1999/xhtml}textarea"
    textarea_html = nil
    
    assert(default_src, druby.src)

    html = HTree.parse(druby.edit_html)
    html.traverse_element(textarea) {|textarea_html| break}
    assert_equal(expected, textarea_html.extract_text)
  end

  def test_orphan
    asin = 'asin:4274066096'
    druby2 = @book[asin]

    @book[RWiki::TOP_NAME].src = "((<#{asin}>))"
    
    default_src = @book.default_src(druby2.name)
    assert(default_src, druby2.src)

    @book[RWiki::TOP_NAME].src = "asin"
    @book.very_dirty
    @book.gc
    
    druby2 = @book[asin]
    assert(druby2.orphan?)
    assert(!druby2.empty?)

    expired_time = Time.now - druby2.section.expires
    druby2.instance_variable_set(:@modified, expired_time)
    assert(druby2.empty?)

    expired_time = Time.now - druby2.section.expires
    druby2.instance_variable_set(:@modified, expired_time)
    @book[RWiki::TOP_NAME].src = "((<#{asin}>))"
    assert(!druby2.orphan?)
    assert(!druby2.empty?)
    
    @book[RWiki::TOP_NAME].src = asin
    @book.very_dirty
    @book.gc
    assert(!@book.include_name?(asin))
    assert(@book.orphan.include?(asin))
    druby2 = @book[asin]
    assert(@book.include_name?(asin))
    assert(@book.orphan.include?(asin))

    @db.touch(druby2.name, Time.now - druby2.section.expires)
    @book.very_dirty
    @book.gc
    druby2 = @book[asin]
    assert(druby2.empty?)
  end

end
