require 'test/unit'
require 'htree'

require 'rw-config'

require 'rwiki/rwiki'
require 'rwiki/db/mock'

class TestPreview < Test::Unit::TestCase

  def setup
    @db = RWiki::DB::Mock.new
    RWiki::BookConfig.default.db = @db
    RWiki::Book.section_list.clear
    @book = RWiki::Book.new
    @page = @book["top"]
  end

  def test_preview
    title = "title"
    expected = HTree.parse(title).extract_text
    src = "= #{title}\n"
    h1 = "{http://www.w3.org/1999/xhtml}h1"
    title_html = nil
    
    assert_nil(@page.src)
    html = HTree.parse(@page.preview_html(src))
    
    html.traverse_element(h1) {|title_html| break}
    assert_equal(expected, title_html.extract_text)
    
    assert_nil(@page.src)
  end

end
