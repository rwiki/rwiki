require 'rwiki/rwiki'
require 'rwiki/rd/rddoc'

module RWiki
  module BTS
    class PropLoader
      def load(content)
	doc = BTSDocument.new(content.tree)
	prop = doc.to_prop
	prop[:name] = content.name
	prop
      end

      class BTSDocument < RDDoc::SectionDocument
	def summary
	  text = first_child(@doc.root, RD::TextBlock)
	  return nil unless text
	  as_str(text.content)
	end

	def make_summary(str)
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
	    prop[:summary] = make_summary(s)
	  end
	  
	  each_section do |head, content|
	    next unless head
	    title = as_str(head.title).strip.downcase
	    if head.level == 2 && ['status', '状態'].include?(title)
	      StatusSection.new(prop).apply_Section(content)
	    elsif head.level == 2 && title == 'history'
	      HistorySection.new(prop).apply_Section(content)
	    elsif head.level >= 2 && ['test', '試験'].include?(title)
	      TestSection.new(prop).apply_Section(content)
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
	  when '分類', 'class'
	    @prop[:class] = value
	  end
	end

	def apply_status(value)
	  case value.downcase
	  when 'open'
	    @prop[:status] = 'open'
	  when 'close'
	    @prop[:status] = 'close'
	  else
	    nil
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
	  first = first_child(item)
	  return unless RD::TextBlock === first
	  str = as_str(first.content).strip
	  if /^Q:/ =~ str
	    apply_Q(item)
	  elsif /^A:/ =~ str
	    apply_A(item)
	  end
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
      end
    end

    ##
    class IndexSection < RWiki::Section
      def initialize(config, name, base_name, item_section)
	super(config, name)
	@format = IndexFormat
	@page = IndexPage
	@base_name = base_name
	@item_section = item_section
      end
      attr_reader :base_name, :item_section
    end

    class IndexPage < RWiki::Page
      def initialize(name, book, section) 
	super(name, book, section)
	@index_tmpl = ERB.new(IndexTmpl)
      end

      def bts_items(remove_empty=false)
	item_section = @section.item_section
	ary = links.sort.reverse.find_all { |nm|
	  item_section.match?(nm)
	}
	item = ary.collect { |nm| @book[nm].prop(:bts) }
	item.compact
	
	if remove_empty
	  item = item.delete_if { |it| empty_content?(it) }
	end

	item
      end

      def empty_content?(prop)
	return true unless prop
	return true unless prop[:summary]
	return true if /empty item/ =~ prop[:summary]
	false
      end

      def desc_page
	@book[@name + '-desc']
      end

      def index_dirty?
	newer = hot_links[0]
	return true if newer.nil?
	return false unless @book.include_name?(newer)
	mod = @book[newer].modified || Time.at(1)
	return false unless mod > self.modified
	return true
      end

      IndexTmpl = <<EOS
= <%= @name %>

* ((<<%=new_name%>>)) ... [empty] empty item
<% 
  ary.each do |bts| 
%>
* ((<<%=bts[:name]%>>)) ... [<%=bts[:class]%>] <%=bts[:summary]%>
<% 
  end 
%>
EOS

      def make_index
	ary = bts_items(true)

	if ary.size > 0
	  new_name = ary[0][:name].succ
	else
	  new_name = @section.base_name
	end

	self.src = @index_tmpl.result(binding)
      end

      def view_html(env = {}, &block)
	bts ,= block ? block.call('bts') : nil
	
	make_index if index_dirty?

	case bts
	when 'concat'
	  return ConcatFormat.new(env, &block).view(self)
	when 'table'
	  return TableFormat.new(env, &block).view(self)
	else
	  return @format.new(env, &block).view(self)
	end
      end
    end

    class ItemSection < RWiki::Section
      def initialize(config, pattern)
	super(config, pattern)
	add_prop_loader(:bts, BTS::PropLoader.new)
	add_default_src_proc(method(:default_src))
      end
      
      RWiki::ERbLoader.new('default_src(name)', 'bts-item.erd').load(self)
    end

    class TableFormat < RWiki::PageFormat
      @rhtml = { :view => RWiki::ERbLoader.new('view(pg)', 'bts-table.rhtml')}
      reload_rhtml

      class Col
	def initialize(bts)
	  @bts = bts
	end
	
	def status_fig(status)
	  case status[:status]
	  when 'open'
	    '■'
	  when 'close'
	    '○'
	  else
	    '？'
	  end
	end

	def color
	  case @bts[:status]
	  when 'open'
	    '#ffaaaa'
	  when 'close'
	    '#aaaaaa'
	  else
	    '#ffffff'
	  end
	end

	def name
	  @bts[:name]
	end

	def head
	  [status_fig(@bts), @bts[:name], @bts[:class]].join(' ')	
	end

	def date_str(time)
	  if Time === time 
	    time.strftime("%m-%d")
	  else
	    time.to_s
	  end
	end

	def date
	  s = date_str(@bts[:open])
	  e = date_str(@bts[:done] || @bts[:close]) 
	  s + '..' + e
	end

	def charge
	  @bts[:charge]
	end

	def summary
	  @bts[:class]
	end
      end

      def matrix(pg)
	items = pg.bts_items(true).reverse.collect { |x| Col.new(x) }
	rows = []
	while (items.size > 0) 
	  rows.push(items[0,5])
	  items[0,5] = nil
	end
	rows
      end
    end

    class IndexFormat < RWiki::PageFormat
      @rhtml = {}
      @rhtml[:view] = RWiki::ERbLoader.new('view(pg)', 'bts-index.rhtml')
      reload_rhtml
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
