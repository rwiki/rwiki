# -*- indent-tabs-mode: nil -*-

module RDDoc
  module TreeUtil
    def as_str(ary)
      ary.collect { |e| e.to_label }.join('')
    end

    def nth_child(tree, klass, n)
      return nil if n < 0
      found = nil
      tree.each_child do |e|
        if klass === e
          if n == 0 
            found = e
            break
          end
          n -= 1
        end
      end
      return found
    end

    def first_child(tree, klass=Object)
      nth_Child(tree, klass, 0)
    end

    def nth_Child(tree, klass, n)
      nth_child(tree, klass, n)
    end

    def first_Child(tree, klass=Object)
      first_child(tree, klass)
    end
    
    def to_html(node)
      return "" unless node
      # node.accept(RD::RD2RWikiVisitor.new)
      tree = RD::Tree.new(RD::DocumentStructure::RD, "", [])
      tree.root = RD::DocumentElement.new
      tree.root.add_child(node)
      RD::RD2RWikiVisitor.new.visit(tree)
    end
  end

  class SectionDocument
    include TreeUtil

    def initialize(doc)
      @doc = doc
    end

    def each_section
      headline = nil
      ary = nil
      @doc.root.each_child do |e|
        case e
        when RD::Headline
          yield(headline, ary) if ary
          headline = e
          ary = []
        else
          ary ||= []
          ary << e
        end
      end
      yield(headline, ary) if ary && ary.size > 0
    end
  end

  class PropSection
    include TreeUtil

    def initialize(prop = {})
      @prop = prop
    end
    attr_reader :prop

    def apply_Section(content)
      content.each do |e|
        if RD::ItemList === e
          apply_ItemList(e) 
        end
      end
    end

    def apply_ItemList(itemlist)
      itemlist.each_child do |item|
        apply_ItemListItem(item)
      end
    end

    def apply_ItemListItem(item)
      size = 0
      value = nil
      item.each_child do |e|
        size += 1
        break if size > 1
        case e
        when RD::TextBlock
          value = as_str(e.content)
        end
      end
      apply_Item(value.chomp.strip) if size == 1 && value
    end
    
    def apply_Item(str)
      if /^(.+?):\s*(.*)$/ =~ str
        apply_Prop($1.strip, $2.strip)
      end
    end

    def apply_Prop(key, value)
      @prop[key] = value
    end
  end

  class HistorySection < PropSection
    def apply_Prop(key, value)
      if /^(\d+)-(\d+)-(\d+)\s+(.+)$/ =~ key
        time = Time.local($1.to_i, $2.to_i, $3.to_i)
        who = $4
        
        apply_History(time, who, value)
      end
    end

    def apply_History(time, who, value)
      @prop[:history] ||= []
      @prop[:history].push([time, who, value])
    end
  end
end


