require 'rwiki/rwiki'
require 'rwiki/rd/rddoc'

module RWiki
  module StoryCard
    class PropLoader
      def load(content)
	doc = StoryCardDocument.new(content.tree)
	prop = doc.to_prop
	prop[:name] = content.name
	prop
      end

      class StoryCardDocument < RDDoc::SectionDocument
	def summary
	  text = first_child(@doc.root, RD::TextBlock)
	  return nil unless text
	  as_str(text.content)
	end
	
	def delete_tail(str)
	  str = str.split("\n").collect {|s| s.strip}.join(" ")

	  return nil if str.size == 0

	  ary = str.split("")
	  return str if ary.size <= 40
	  ary[0,40].join("") + "..."
	end

	def to_prop
	  prop = {}

	  s = summary
	  if s
	    prop["summary"] = s
	    prop[:summary] = delete_tail(s)
	  end

	  each_section do |head, content|
	    next unless head
	    title = as_str(head.title).strip.downcase
	    if head.level == 2 && ['status', '状態'].include?(title)
	      StatusSection.new(prop).apply_Section(content)
	    elsif head.level == 2 && title == 'history'
	      HistorySection.new(prop).apply_Section(content)
	    elsif head.level >= 2 && ['test', '試験'].include?(title)
	      test = TestSection.new(prop)
              test.apply_Section(content)
              test.build_inline_html
	    end
	  end
	  prop
	end
      end

      class StatusSection < RDDoc::PropSection
	def apply_Prop(key, value)
	  super(key, value)
	  case key.downcase
	  when '担当', 'サイン', 'charge', 'sign'
	    @prop[:sign] = value
	  when '状態', 'status'
	    apply_status(value)
	  when 'カード', '種類', 'card', 'kind'
	    apply_card_type(value)
	  when 'イテレーション', 'iteration'
	    apply_iteration(value)
	  when '見積', 'estimation'
	    apply_estimation(value)
	  end
	end

	def apply_card_type(value)
	  case value.downcase
	  when 'タスク', 'task'
	    @prop[:card_type] = :task
	  when 'バグ', 'bug'
	    @prop[:card_type] = :bug
	  when 'ストーリー', 'story'
	    @prop[:card_type] = :story
	  else 
	    nil
	  end
	end
	
	def apply_status(value)
	  case value.downcase
	  when 'open'
	    @prop[:status] = :open
	  when 'close'
	    @prop[:status] = :close
	  when 'discard'
	    @prop[:status] = :discard
	  end
	end

	def apply_iteration(value)
	  @prop[:iteration] = value.to_i unless value.empty?
	end
	
	def apply_estimation(value)
	  ary = value.split('/')
	  begin
	    @prop[:estimation] = ary[0].to_f if ary[0]
	  rescue
	  end
	  begin
	    @prop[:actual] = ary[1].to_f if ary[1]
	  rescue
	  end
	end
      end

      class HistorySection < RDDoc::HistorySection
	def apply_History(time, who, value)
	  @prop[:history] ||= []
	  @prop[:history].push([time, who, value])

	  case value.downcase
	  when 'open'
	    @prop[:open] = time
	  when 'close'
	    @prop[:close] = time
	  when 'ok', 'ng'
	    apply_Test(time, value) if ['test', 'uft'].include?(who.downcase)
	  end
	end

	def apply_Test(time, value)
	  case value.strip.downcase
	  when 'ok'
	    v = true
	  when 'ng'
	    v = false
	  else
	    v = false
	  end

	  @prop[:test_result] ||= {}
	  @prop[:test_result][time] = v
	end
      end

      class TestSection < RDDoc::PropSection

	def initialize(prop = {})
	  super(prop)
	  @curr_q = nil
	  @v = RD::RD2RWikiVisitor.new
	end

	def apply_ItemListItem(item)
	  first = first_Child(item)
	  return unless RD::TextBlock === first
	  str = as_str(first.content).strip
	  if /^Q:/ =~ str
	    apply_Q(item)
	  elsif /^A:/ =~ str
	    apply_A(item)
	  else
	    apply_QA(item)
	  end
	end

	def add_prop_test(it)
	  prop[:test] ||= []
	  prop[:test] << it
	end

	def apply_QA(item)
	  if @curr_q
	    add_prop_test([to_html(@curr_q)]) 
	    @curr_q = nil
	  end
	  add_prop_test([to_html(item)])
	end
	
	def apply_Q(item)
	  @curr_q = item
	end

	def apply_A(item)
	  if @curr_q
	    prop[:test] ||= []
	    prop[:test] << create_QA(@curr_q, item)
	    @curr_q = nil
	  end
	end

	def create_QA(q, a)
	  [to_html(q), to_html(a)]
	end
	
	def to_html(item)
	  return "" unless item
	  @v.visit_children(item).join("")
	end

        def build_inline_html
          prop[:test_inline] = ''
          return unless prop[:test]
          prop[:test_inline] << '<ul>'
          prop[:test].each do |qa|
            qa.each do |str|
              prop[:test_inline] << '<li>' + str + '</li>'
            end
          end
          prop[:test_inline] << '</ul>'
        end
      end
    end

    class IndexLoader < PropLoader
      def load(content)
	doc = StoryIndexDocument.new(content.tree)
	prop = doc.to_prop
	prop[:name] = content.name
	prop
      end

      class StoryIndexSection < RDDoc::PropSection
	def apply_ItemListItem(item)
	  size = 0
	  value = nil
	  item.each_child do |e|
	    size += 1
	    break if size > 1
	    case e
	    when RD::TextBlock
	      ee = first_child(e, Object)
	      if RD::Reference === ee 
		if RD::Reference::RWikiLabel === ee.label
		  @prop[:index] ||= []
		  @prop[:index] << ee.label.wikiname
		end
	      end
	    end
	  end
	end
      end

      class StoryIndexDocument < RDDoc::SectionDocument
	def to_prop
	  prop = {}
	  ary = []
	  each_section do |head, content|
	    next unless head
	    title = as_str(head.title).strip
	    if head.level == 2 && as_str(head.title).strip == 'story-card' 
	      StoryIndexSection.new(prop).apply_Section(content)
	    end
	  end
	  prop
	end
      end
    end

    class IndexSection < RWiki::Section
      def initialize(config, name, base_name, item_section)
	super(config, name)
	@page = IndexPage
	add_prop_loader(:story_index, IndexLoader.new)
	@base_name = base_name
	@item_section = item_section
      end
      attr_reader :item_section, :base_name
    end

    class DBFindAllContent < RWiki::Content
      def initialize(name, db, section)
        @db = db
        @section = section
        super(name, " DBFindAllContent #{name}\n")
      end

      def set_src(src)
        @src = src
        begin
          parse()
        rescue
	  @body = "<h1>DBFindAllContent Error</h1>\n"
	  @body << "<pre>#{h($!)}</pre>\n"
	end
        @body_erb = ERB.new(@body.to_s)
      end

      def parse
        @links = @db.find_all {|x| @section.match?(x)}.sort.reverse
        @links.unshift(@links[0].succ)
        @tree = nil
        @body = "<p>edit me, if you want to see this index</p>"
      end
    end

    class SimpleRDContent < RWiki::Content
      def set_src(src)
        @src = src
        begin
          parse()
        rescue
	  @body = "<h1>SimpleRDContent Error</h1>\n"
	  @body << "<pre>#{h($!)}</pre>\n"
	end
        @body_erb = ERB.new(@body.to_s)
      end

      def parse
        @links = @src.scan(/\(\(\<(.*?)\>\)\)/).collect {|x| x[0]}.uniq
        @tree = nil
        @body = "<p>edit me, if you want to see this index</p>"
      end
    end

    class IndexPage < RWiki::Page
      def initialize(name, book, section) 
	super(name, book, section)
	@index_tmpl = ERB.new(IndexTmpl)
        @cached_item = nil
        @cached_item_removed = nil
      end

      def make_content(v)
        DBFindAllContent.new(@name, db, @section.item_section)
      end

      IndexTmpl = <<EOS
= <%= @name %>

== story-card

* ((<<%=new_name%>>)) empty item
EOS

      def add_link(from)
        @cached_item = nil
        @cached_item_removed = nil
        super(from)
      end

      def make_index_if_dirty
        @book.synchronize do
          make_index if index_dirty?
        end
      end

      def view_html(env = {}, &block)
	story ,= block ? block.call('story') : nil

        make_index_if_dirty

        @book.synchronize do	
          case story
          when 'update'
            make_index
            return @format.new(env, &block).view(self)
          when 'table'
            return StoryCardTableFormat.new(env, &block).view(self)
          when 'plan'
            return StoryCardPlanFormat.new(env, &block).view(self)
          when 'test'
            test_name ,= block ? block.call('testname') : nil
            test_result ,= block ? block.call('testresult') : nil
            if test_name && test_result
              add_test_result(test_name, test_result) 
            end
            return StoryCardTestFormat.new(env, &block).view(self)
          when 'plain'
            return @format.new(env, &block).view(self)
          else # 'plan'
            return StoryCardPlanFormat.new(env, &block).view(self)
          end
        end
      end

      def index_dirty?
        @cached_item.nil? || @cached_item_removed.nil?
      end

      def items_one(remove_empty=false)
        if index_dirty?
          item = @links.collect {|pg| @book[pg].prop(:story)}.compact
          @cached_item = item
          @cached_item_removed = item.delete_if {|story| empty_story?(story)}
        end
        remove_empty ? @cached_item_removed : @cached_item
      end

      def make_index
        @cached_item = nil
        @cached_item_removed = nil
	ary = items_one(true)

	if ary.size > 0
	  new_name = ary[0][:name]
	else
	  new_name = @section.base_name
	end

	self.src = @index_tmpl.result(binding)
      end

      def complex_items(remove_empty=false)
        return [] unless complex_story?
        ary = []
        include_page.links.each do |index|
          page = @book[index]
          begin
            next if page.complex_story?
          rescue
            next
          end
          ary = ary + page.items(remove_empty)
        end
        ary
      end

      def items(remove_empty=false)
        items_one(remove_empty) + complex_items(remove_empty)
      end

      def empty_story?(story)
	return true unless story
	return true unless story[:summary]
	return true if /empty item/ =~ story[:summary]
	false
      end

      def desc_page
	@book[@name + '-desc']
      end

      def complex_story?
        @book.include_name?(@name + '-include')
      end

      def include_page
        @book[@name + '-include']
      end
      
      def find_empty_story
        ary = items(true)
        if ary.size > 0
          ary[0][:name].succ
        else
          @section.base_name
        end
      end

      def add_test_result(name, value)
	return unless %w(OK NG).include?(value)
	page = @book[name]
	return unless ItemPage === page
	page.add_test_result(value)
      end
    end

    class ItemSection < RWiki::Section
      def initialize(config, pattern)
	super(config, pattern)
	@page = ItemPage
	add_prop_loader(:story, PropLoader.new)
	add_default_src_proc(method(:default_src))
      end

      RWiki::ERBLoader.new('default_src(name)', 'story-item.erd').load(self)
    end

    class ItemPage < RWiki::Page
      def title
        story = prop(:story)
        summary = story ? story[:summary] : nil
        if summary
          "#{name} - #{summary}"
        else
          name
        end
      end

      def view_html(env = {}, &block)
	story ,= block ? block.call('story') : nil

	case story
	when 'test'
	  test_result ,= block ? block.call('testresult') : nil
	  if test_result
	    add_test_result(test_result) 
	  end
        end

        super
      end

      def add_test_result(value)
	new_history = "* #{Time.now.strftime('%Y-%m-%d')} TEST: #{value}"

	src = self.src.split("\n")
	ary = []
	status = nil
	src.each do |line|
	  if status == nil
	    status = :history_head if /^==\s*history\s*$/ =~ line
	  elsif status == :history_head
	    status = :history_items if /^\*/ =~ line
	  elsif status == :history_items
	    if line.strip.size == 0
	      ary << new_history 
	      status = :done
	    end
	  end
	  ary << line
	end
	ary << new_history if status == :history_items
	ary << ''
	self.src = ary.join("\n")
      end
    end
    
    class StoryCardIndexFormat < RWiki::PageFormat
      @rhtml = {}
      @rhtml[:view] = RWiki::ERBLoader.new('view(pg)', 'story-index.rhtml')
      @rhtml[:control] = RWiki::ERBLoader.new('control(pg)', 'story-control.rhtml')
      @rhtml[:footer] = RWiki::ERBLoader.new('footer(pg)', 'story-footer.rhtml')
      reload_rhtml
    end

    class StoryCardTableFormat < StoryCardIndexFormat
      @rhtml = { :view => RWiki::ERBLoader.new('view(pg)', 'story-table.rhtml')}
      reload_rhtml

      def make_matrix(pg)
	items = pg.items(true).find_all { |story|
	  story[:test_result] && story[:test_result].size > 0
	}

	matrix = {}

	items.each do |story|
	  story[:test_result].each do |time, value|
	    matrix[time] ||= {}
	    matrix[time][story[:name]] = value
	  end
	end
	
	[ items.collect{|story| story[:name]}.sort, matrix.keys.sort, matrix]
      end
    end

    class StoryCardTestFormat < StoryCardIndexFormat
      @rhtml = { :view => RWiki::ERBLoader.new('view(pg)', 'story-test.rhtml')}
      reload_rhtml
      
      def view_html(env = {}, &block)
	@iter ,= block ? block.call('iter') : false
	@format.new(env, &block).view(self)
      end

      def items(pg, iter)
	ary = pg.items(true).find_all { |story|
	  if story.include?(:test) 
	    if iter 
	      story[:iteration] && story[:iteration] <= iter
	    else
	      true
	    end
	  else
	    false
	  end
	}
	ary.sort { |a, b| 
	  v = a[:iteration].to_i <=> b[:iteration].to_i
	  v = a[:card_type].to_s <=> b[:card_type].to_s if v == 0
	  v = a[:name] <=> b[:name] if v == 0
	  v 
	}
      end
    end

    class StoryCardPlanFormat < StoryCardIndexFormat
      @rhtml = { :view => RWiki::ERBLoader.new('view(pg)', 'story-plan.rhtml')}
      reload_rhtml

      def items(pg, card_type)
	ary = pg.items(true).find_all { |story|
	  story[:card_type] == card_type
	}

	ary.sort { |a, b| 
	  v = (b[:iteration] || 0xffff) <=> (a[:iteration] || 0xffff)
	  v = a[:name] <=> b[:name] if v == 0
	  v
	}
      end

      def open_iteration_items(pg)
        iter = {}
        ary = pg.items(true)
        ary.each do |story|
          iter[story[:iteration]] = true if story[:status] == :open
        end
        ary.find_all do |story|
          iter[story[:iteration]]
        end
      end

      def order_by_iteration_sort_proc(key)
        [-1 * key[:iteration],
          key[:card_type],
          key[:status],
          # key[:sign],
          key[:name]]
      end

      def order_by_iteration(ary,
                             card_type_order = [:story, :bug, :task],
                             status_order = [:done, :open, :close])
        cards = ary.sort_by { |a|
          key = {}
          key[:iteration] = a[:iteration] || 0xffff
          key[:card_type] = card_type_order.index(a[:card_type]) || 0
          key[:status] = status_order.index(a[:status]) || 0xffff
          key[:sign] = a[:sign] || ''
          key[:name] = a[:name]
          order_by_iteration_sort_proc(key)
        }
	
	last = nil
	estimation = 0
	actual = 0
        return if cards.size == 0
	card = cards[0]
	iteration = card[:iteration]
	card_type = card[:card_type]
	yield(:new_iteration, iteration)
	yield(:new_card_type, card_type)
	cards.each do |card|
	  if iteration  != card[:iteration]
	    yield(:total, [estimation, actual])
	    yield(:new_iteration, card[:iteration])
	    yield(:new_card_type, card[:card_type])
	    estimation = 0
	    actual = 0
	  elsif card_type != card[:card_type]
	    yield(:total, [estimation, actual])
	    yield(:new_card_type, card[:card_type])
	    estimation = 0
	    actual = 0
	  end
	  yield(:card, card)
	  estimation += card[:estimation] if card[:estimation]
	  actual += card[:actual] if card[:actual]
	  iteration = card[:iteration]
	  card_type = card[:card_type]
	end
	yield(:total, [estimation, actual])
      end
    end

    def install(name, base_name, pattern)
      item_section = ItemSection.new(nil, pattern)
      RWiki::Book.section_list.push(item_section)
      index_section = IndexSection.new(nil, name, base_name, item_section)
      RWiki::Book.section_list.push(index_section)
    end
    module_function :install
  end
end

