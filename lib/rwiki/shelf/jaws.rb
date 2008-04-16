require 'open-uri'
require 'erb'
require 'rexml/document'
require 'pp'

class JAws
  class Item
    def initialize(node)
      @asin = as_text(node, 'ASIN')

      attr = node.elements["ItemAttributes"]
      @product_name = as_text(attr, "Title")
      @authors = []
      attr.elements.each('Creator') {|x| @authors << x.text}

      @manufacturer = as_text(attr, "Manufacturer")
      @release_date = as_text(attr, 'ReleaseDate') || as_text(attr, 'PublicationDate')
      @product_group = as_text(attr, 'ProductGroup')

      @image_url = as_text(node, 'MediumImage/URL')
      @url = as_text(node, 'DetailPageURL')
    end

    attr_reader :product_name, :asin, :authors, :manufacturer, :release_date
    attr_reader :image_url, :url, :product_group

    def as_text(node, path)
      node.elements[path].text rescue nil
    end
  end

  AWS = 'http://webservices.amazon.co.jp/onca/xml'
  def initialize(tag = 'ilikeruby-22')
    @token = get_token
    @associate = tag
    @base_param = {
      'Service' => 'AWSECommerceService', 
      'AWSAccessKeyId' => @token
    }
    @base_param['AssociateTag'] = @associate  if @associate
  end

  def has_token?
    ! @token.empty?
  end

  def asin_search(asin)
    str = item_lookup(asin)
    REXML::Document.new(str).elements.each("ItemLookupResponse/Items/Item") do |element|
      return Item.new(element)
    end
    nil
  end

  def blended_search(text)
    str = item_search(text)
    prod = Hash.new {|h, k| h[k] = []}
    REXML::Document.new(str).elements.each("ItemSearchResponse/Items/Item") do |element|
      item = JAws::Item.new(element)
      prod[item.product_group] << item
    end
    prod.keys.sort.collect {|key| [key, prod[key]]}
  end

  private
  def item_lookup(asin)
    get({ 'Operation' => 'ItemLookup',
	  'ResponseGroup' => 'Medium',
	  'ItemId' => asin })
  end

  def item_search(text)
    get({ 'Keywords' => text,
	  'Operation' => 'ItemSearch',
	  'SearchIndex' => 'Blended',
	  'ResponseGroup' => 'Medium' })
  end

  def make_query(hash)
    uri = URI.parse(AWS)
    uri.query = base_param.update(hash).collect {|k, v|
      "#{ERB::Util.u(k)}=#{ERB::Util.u(v)}"
    }.join("&")
    uri.to_s
  end

  def base_param
    @base_param.dup
  end

  def get(hash)
    uri = make_query(hash)
    open(uri) {|fp| fp.read}
  end

  def get_token
    @token = File.read(token_fname).chomp
  end
  
  def token_fname
    File.expand_path("~/.aws_key")
  end
end

if __FILE__ == $0
  amazon = JAws.new(nil)

  prod = amazon.blended_search('Bento')

  prod.each do |k, v|
    puts "== " + k
    v.each do |i|
      puts "* #{i.product_name}"
    end
  end

  asin = amazon.asin_search('B000EAV848')
  pp asin
end
