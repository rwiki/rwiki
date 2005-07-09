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
    @page = @book["page"]
  end

  def test_top
    assert(@book.find{|page| page.name == RWiki::TOP_NAME})
  end
  
  def test_edit
    expected = HTree.parse(@book.default_src(@page.name)).extract_text
    textarea = "{http://www.w3.org/1999/xhtml}textarea"
    textarea_html = nil
    
    assert_nil(@page.src)

    html = HTree.parse(@page.edit_html)
    html.traverse_element(textarea) {|textarea_html| break}
    assert_equal(expected, textarea_html.extract_text)
    
    src = "XXX\n"
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

  def test_search
    page1 = 'page1'
    page2 = 'page2'
    src1 = 'a b c'
    src2 = 'a  b  c'
    @book[page1].src = src1
    @book[page2].src = src2
    @book['search'].src = "((<#{page1}>)) ((<#{page2}>))"

    assert_equal([page1, page2],
                 @book.search_body([/a/, /b/]).collect{|pg| pg.name})
    assert_equal([page1],
                 @book.search_body([/a b/]).collect{|pg| pg.name})
  end

  def test_search_view
    page1 = 'page1'
    page2 = 'page2'
    src1 = 'a b c'
    src2 = 'a  b  c'
    @book[page1].src = src1
    @book[page2].src = src2
    search = @book['search']
    search.src = "((<#{page1}>)) ((<#{page2}>))"

    params = {'key' => "a b"}
    expected = [page1, page2]
    as = collect_em_a_link_from_div_tree(search.view_html{|key| params[key]})
    assert_equal(expected.sort, as.sort)
    
    params = {'key' => "'a b'"}
    expected = [page1]
    as = collect_em_a_link_from_div_tree(search.view_html{|key| params[key]})
    assert_equal(expected.sort, as.sort)
  end

  def test_edit_view
    @book["edit"].src = ""
    edit_description_as = collect_edit_description_as(@page.edit_html)
    assert(edit_description_as.empty?)

    @book["edit"].src = "edit"
    edit_description_as = collect_edit_description_as(@page.edit_html)
    assert_equal(2, edit_description_as.size)
  end

  def test_orphan
    alive_pages = %w(alive1 alive2)
    orphan_pages = %w(orphan1 orphan2)
    src = alive_pages.collect{|name| "((<#{name}>))"}.join("\n")
    @book[RWiki::TOP_NAME].src = src

    (alive_pages + orphan_pages).each do |name|
      @book[name].src = "((<#{RWiki::TOP_NAME}>))"
    end

    assert_equal(orphan_pages.sort, @book.orphan.sort)
  end
  
  private
  def collect_em_a_link_from_div_tree(html)
    div_tag = "{http://www.w3.org/1999/xhtml}div"
    a_tag = "{http://www.w3.org/1999/xhtml}a"
    class_attr = HTree::Name.new(nil, '', 'class')
    href_attr = HTree::Name.new(nil, '', 'href')

    div_tree = nil
    as = []
    
    parsed_html = HTree.parse(html)
    parsed_html.traverse_element(div_tag) do |div|
      div_tree = div if div.attributes[class_attr].to_s == "tree"
    end
    div_tree.traverse_element(a_tag) do |a|
      as << a.extract_text.to_s if /em=/ =~ a.attributes[href_attr].to_s
    end
    as
  end

  def collect_edit_description_as(html)
    a_tag = "{http://www.w3.org/1999/xhtml}a"
    href_attr = HTree::Name.new(nil, '', 'href')
    id_attr = HTree::Name.new(nil, '', 'id')

    as = []
    parsed_html = HTree.parse(html)
    parsed_html.traverse_element(a_tag) do |a|
      if a.attributes[id_attr].to_s == "edit-description" or
          a.attributes[href_attr].to_s == "#edit-description"
        as << a
      end
    end
    as
  end
  
end
