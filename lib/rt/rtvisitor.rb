#!/usr/bin/ruby
=begin
rtvisitor.rb
$Id: rtvisitor.rb,v 1.1 2004/04/06 01:41:42 kou Exp $
=end
require 'rt/rtparser'

module RT
  class RTVisitor
    def each_cell(ary)
      ary.each do |x|
        if x.class == RT::RTCell
          yield x
        else
        end
      end
    end
    private :each_cell
    
    def initialize
    end
    attr_reader :rt, :header, :body, :caption
    attr_accessor :filename, :charcode
    
    def self.visit(parsed)
      self::new.visit(parsed)
    end

    def visit(parsed)
      @filename = @charset = nil
      @rt = parsed
      @header = @rt.header
      @body = @rt.body
      @caption = @rt.config['caption']

      setup +
        visit_Caption +
        visit_Header +
        visit_Body +
        teardown
    end
    
    def setup
      ""
    end
    
    def teardown
      ""
    end
    
    def visit_Caption
      ""
    end
    
    def visit_Header
      ""
    end
    
    def visit_Body
      ""
    end
  end
end



      
      
