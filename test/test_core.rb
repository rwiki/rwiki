require 'test/unit'
require 'htree'

require 'rw-config'

require 'rwiki/rwiki'
require 'rwiki/db/mock'

class TestCore < Test::Unit::TestCase

  def setup
    @db = RWiki::DB::Mock.new
    RWiki::BookConfig.default.db = @db
    RWiki::Book.section_list.clear
    @book = RWiki::Book.new
    @top_name = RWiki::TOP_NAME
    @top = @book[@top_name]
    @page = @book["page"]
  end

  def test_edit
    expected = HTree.parse(@book.default_src(@page.name)).extract_text
    textarea = "{http://www.w3.org/1999/xhtml}textarea"
    textarea_html = nil
    
    assert_nil(@page.src)

    html = HTree.parse(@page.edit_html)
    html.traverse_element(textarea) {|textarea_html| break}
    assert_equal(expected, textarea_html.extract_text)
    
    src = "XXX"
    expected = HTree.parse(src).extract_text

    @page.src = src
    html = HTree.parse(@page.edit_html)
    html.traverse_element(textarea) {|textarea_html| break}
    assert_equal(expected, textarea_html.extract_text)
  end
  
  def test_preview
    title = "title"
    expected = HTree.parse(title).extract_text
    src = "= #{title}\n"
    h1 = "{http://www.w3.org/1999/xhtml}h1"
    title_html = nil
    
    assert_nil(@page.src)
    html = HTree.parse(@page.preview_html(src))

    first_h1 = true
    html.traverse_element(h1) do |title_html|
      if first_h1
        first_h1 = false
        next
      else
        break
      end
    end
    assert_equal(expected, title_html.extract_text)
    
    assert_nil(@page.src)
  end

  def test_title
    src = "= #{@page.name}\n"
    @page.src = src
    def @page.title
      name + "-title"
    end
    expected = HTree.parse("#{RWiki::TITLE} - #{@page.title}").extract_text
    
    title_tag = "{http://www.w3.org/1999/xhtml}title"
    title_html = nil
    
    html = HTree.parse(@page.view_html)
    html.traverse_element(title_tag) {|title_html| break}
    assert_equal(expected, title_html.extract_text)

    html = HTree.parse(@page.edit_html)
    html.traverse_element(title_tag) {|title_html| break}
    assert_equal(expected, title_html.extract_text)

    html = HTree.parse(@page.submit_html)
    html.traverse_element(title_tag) {|title_html| break}
    assert_equal(expected, title_html.extract_text)

    html = HTree.parse(@page.preview_html("dummy source"))
    html.traverse_element(title_tag) {|title_html| break}
    assert_equal(expected, title_html.extract_text)

    html = HTree.parse(@page.emphatic_html)
    html.traverse_element(title_tag) {|title_html| break}
    assert_equal(expected, title_html.extract_text)

    html = HTree.parse(@page.error_html)
    html.traverse_element(title_tag) {|title_html| break}
    assert_equal(expected, title_html.extract_text)

    html = HTree.parse(@page.src_html)
    html.traverse_element(title_tag) {|title_html| break}
    assert_equal(expected, title_html.extract_text)

    html = HTree.parse(@page.body_html)
    html.traverse_element(title_tag) {|title_html| break}
    assert_equal(expected, title_html.extract_text)
  end
  
end
