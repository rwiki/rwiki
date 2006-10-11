# -*- indent-tabs-mode: nil -*-

require 'amazon/search'

# for ruby-amazon-0.9.2
module Amazon
  module Search
    module Blended
      class Response
        def parse
	  @products = @product_lines = []

	  doc = REXML::Document.new(self).elements['BlendedSearch']

	  get_args(doc)

	  doc.elements.each('ProductLine') do |line|

	    mode = line.elements['Mode'].text
            relevance_element = line.elements['RelevanceRank']
	    relevance = relevance_element ? relevance_element.text.to_i : nil
	    product_line = Amazon::ProductLine.new(mode, relevance)

	    product_line.products = Amazon::Search::Response.new(
				      line.elements['ProductInfo']).products

	    @product_lines << product_line

	  end
	  self
        end
      end
    end
  end
end

class AmazonWebService
  class << self
    def devtag_filename
      File.expand_path("~/.amazon_key")
    end

    def have_devtag_file?
      File.exist?(devtag_filename)
    end
  end
  
  def initialize(tag = 'ilikeruby-22', locale = 'us')
    @devtag = get_devtag
    @tag = tag
    @locale = locale
    @search = Amazon::Search::Request.new(@devtag, @tag, @locale)
    @blended = Amazon::Search::Blended::Request.new(@devtag, @tag, @locale)
  end

  def asin_search(asin)
    @search.asin_search(asin) do |detail|
      return detail
    end
  end

  def keyword_search(text)
    ary = []
    @search.keyword_search(text, 'books', true) do |detail|
      ary << detail
    end
    ary
  rescue Amazon::Search::Request::SearchError
    []
  end

  def blended_search(text)
    ary = []
    @blended.search(text) do |product_line|
      ary << product_line
    end
    ary
  rescue Amazon::Search::Request::SearchError
    []
  end

  private
  def get_devtag
    File.open(self.class.devtag_filename) do |fp|
      return fp.read.chomp
    end
  end
end

class AmazonCoJp < AmazonWebService
  def initialize(tag = 'ilikeruby-22')
    super(tag, 'jp')
  end
end

