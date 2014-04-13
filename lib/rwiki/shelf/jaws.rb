# -*- coding: utf-8 -*-
require 'amazon/ecs'

class JAws
  class Item
    def initialize(node)
      @asin = as_text(node, 'ASIN')
      @product_name = as_text(node, 'ItemAttributes/Title')
      @authors = []
      artist = as_text(node, 'ItemAttributes/Artist')
      @authors << artist if artist
      author = as_text(node, 'ItemAttributes/Author')
      @authors << author if author

      @manufacturer = as_text(node, "ItemAttributes/Manufacturer")
      @release_date =
        as_text(node, 'ItemAttributes/ReleaseDate') || 
        as_text(node, 'ItemAttributes/PublicationDate')

      @product_group = as_text(node, 'ItemAttributes/ProductGroup')

      @image_url = as_text(node, 'MediumImage/URL')
      @url = as_text(node, 'DetailPageURL')
    end

    attr_reader :product_name, :asin, :authors, :manufacturer, :release_date
    attr_reader :image_url, :url, :product_group

    def as_text(node, path)
      node.get_element(path).elem.text rescue nil
    end
  end

  def initialize
  end

  def asin_search(asin)
    res = Amazon::Ecs.item_lookup(asin,
                                  response_group: 'ItemAttributes,Images')    
    res.items.collect do |node|
      Item.new(node)
    end
  end

  def blended_search(text)
    res = Amazon::Ecs.item_search(text, 
                                  search_index: 'All',
                                  response_group: 'ItemAttributes,Images')

    product = Hash.new {|h, k| h[k] = []}
    res.items.collect do |node|
      item = Item.new(node)
      product[item.product_group] << item
    end
    product.keys.sort.collect {|key| [key, product[key]]}
  end
end

if __FILE__ == $0
  require 'pp'

  load(File.expand_path('~/.amazon_ecs.rb'))  
  
  jaws = JAws.new
  items = jaws.asin_search('B000EAV848')
  pp items

  items = jaws.asin_search('193435693X')
  pp items

  prod = jaws.blended_search('どくさいみん光線')

  prod.each do |k, v|
    puts "== " + k
    v.each do |i|
      puts "* #{i.product_name}"
    end
  end
end
