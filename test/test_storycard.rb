require 'test/unit'
require 'rw-config'
require 'rwiki/rwiki'
require 'rwiki/db/mock'
require 'rwiki/storycard'
require 'time'

class TestStoryCardItem < Test::Unit::TestCase
  def setup
    @db = RWiki::DB::Mock.new
    RWiki::BookConfig.default.db = @db
    RWiki::Book.section_list.clear
    @item_section = RWiki::StoryCard::ItemSection.new(nil, /^rw-\d+$/)
    RWiki::Book.section_list.push(@item_section)
    @book = RWiki::Book.new
  end

  def teardown
  end

  def rw_0001
    <<SRC
= rw-0001

Hello, World.

== status

* 種類: story
* イテレーション: 2
* サイン: ((<seki>))
* 状態: open
* 見積: 0.5 / 0.2

== description

Hello, Wrold.

== test

* Q: Hello
* A: World

== history

* 2004-11-24 rwiki: open
* 2004-11-25 rwiki: close
* 2004-11-26 rwiki: open
SRC
  end

  def test_core
    page = @book['rw-0001']
    page.src = rw_0001
    prop = page.prop(:story)
    assert(prop != nil)
    assert_equal('Hello, World.', prop[:summary])
    assert_equal('rw-0001', prop[:name])
    assert_equal(:story, prop[:card_type])
    assert_equal(2, prop[:iteration])
    assert_equal('seki', prop[:sign])
    assert_equal(:open, prop[:status])
    assert_equal(0.2, prop[:actual])
    assert_equal(0.5, prop[:estimation])
    assert_equal([['Q: Hello', 'A: World']], prop[:test])
    assert_equal(Time.parse('2004-11-26'), prop[:open])
    assert_equal(Time.parse('2004-11-25'), prop[:close])
    history = prop[:history]
    assert_equal([Time.parse('2004-11-24'), 'rwiki', 'open'], history[0])
    assert_equal([Time.parse('2004-11-25'), 'rwiki', 'close'], history[1])
    assert_equal([Time.parse('2004-11-26'), 'rwiki', 'open'], history[2])
  end

  def rw_0002(card_type)
    <<SRC
= rw-0002

Hello, World.

== status

* 種類: #{card_type}
* イテレーション: 2
* サイン: ((<seki>))
* 状態: open
* 見積: 0.5 / 0.2

== description

Hello, Wrold.

== history

* 2004-11-24 rwiki: open
SRC
  end

  def test_card_type
    page = @book['rw-0002']
    page.src = rw_0002('story     ')
    prop = page.prop(:story)
    assert(prop != nil)
    assert_equal(:story, prop[:card_type])

    page.src = rw_0002('   task')
    prop = page.prop(:story)
    assert(prop != nil)
    assert_equal(:task, prop[:card_type])

    page.src = rw_0002('bug')
    prop = page.prop(:story)
    assert(prop != nil)
    assert_equal(:bug, prop[:card_type])

    page.src = rw_0002('')
    prop = page.prop(:story)
    assert(prop != nil)
    assert_equal(nil, prop[:card_type])

    page.src = rw_0002('story / task / bag')
    prop = page.prop(:story)
    assert(prop != nil)
    assert_equal(nil, prop[:card_type])
  end

  def rw_0003(summary)
    <<SRC
= rw-0002

#{summary}

== status

* 種類: story
* イテレーション: 2
* サイン: ((<seki>))
* 状態: open
* 見積: 0.5 / 0.2

== description

Hello, Again.

== history

* 2004-11-24 rwiki: open
SRC
  end

  def test_summary
    page = @book['rw-0003']
    page.src = rw_0003('Hello, World.')
    prop = page.prop(:story)
    assert(prop != nil)
    assert_equal('Hello, World.', prop[:summary])
  end

  def test_summary_too_long
    page = @book['rw-0003']
    long = 'long ' * 40
    page.src = rw_0003(long)
    prop = page.prop(:story)
    assert(prop != nil)
    assert_equal('long long long long long long long long ...', prop[:summary])
  end

  def test_summary_empty
    page = @book['rw-0003']
    page.src = rw_0003('')
    prop = page.prop(:story)
    assert(prop != nil)
    assert_equal('Hello, Again.', prop[:summary])

    src = <<SRC
= rw-0002

== status

* 種類: story
* イテレーション: 2
* サイン: ((<seki>))
* 状態: open
* 見積: 0.5 / 0.2

== description

== history

* 2004-11-24 rwiki: open
SRC

    page.src = src
    prop = page.prop(:story)
    assert(prop != nil)
    assert_equal(nil, prop[:summary])
  end
end
