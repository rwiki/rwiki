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

end

