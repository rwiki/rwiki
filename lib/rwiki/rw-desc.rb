# rw-desc.rb -- Handling a document for RWiki written in some grammar.
#
# Copyright (c) 2000 Masatoshi SEKI and NAKAMURA, Hiroshi
#
# rw-desc.rb is copyrighted free software by Masatoshi SEKI and NAKAMURA, Hiroshi.
# You can redistribute it and/or modify it under the same term as Ruby.


# PURPOSE
#   Handling a document for RWiki written in some grammar.
module RWikiDesc
  # REQUIRE
  #   body.is_a?( String ) or
  #     ( body.is_a?( Array ) and ( body.empty? or body[-1].is_a?( String )))
  def initialize( body = nil )
    @body = nil
    self.body = body
  end

  # REQUIRE
  #   body.is_a?( String ) or
  #     ( body.is_a?( Array ) and ( body.empty? or body[-1].is_a?( String )))
  def parse( body )
    raise NotImplementError.new( "Method 'parse' not implemented." )
  end

  def retrieve
    raise NotImplementError.new( "Method 'retrieve' not implemented." )
  end

  # PROMISE
  #   __ret == nil or ( __ret.is_s?( String) && /\n$/ =~ __ret )
  def body
    if @body
      @body.join()
    else
      nil
    end
  end

  # REQUIRE
  #   body.is_a?( String ) or
  #     ( body.is_a?( Array ) and ( body.empty? or body[-1].is_a?( String )))
  def body=( body )
    if body
      @body = Array.new
      body.each do | line |
        @body.push( line )
      end
      @body[ -1 ] << "\n" unless /\n$/ =~ @body[ -1 ]
    else
      @body = nil
    end
  end
end


# PURPOSE
#   RWikiDesc utility module.
module RWikiDescUtil
  # REQUIRE
  #   body.is_a?( String ) or
  #     ( body.is_a?( Array ) and ( body.empty? or body[-1].is_a?( String )))
  def parse( body )
    aDesc = self.new
    aDesc.parse( body )
    aDesc
  end
end


# PURPOSE
#   RD-like grammar for e-mail.
class RWikiDescRDMail; include RWikiDesc; extend RWikiDescUtil
  def parse( body )
    if !body
      @body = nil
    else
      @body = Array.new
      state = :OUTSIDE
      body.each do | line |
        case line
        when /^=begin$/
	  if state == :OUTSIDE
            state = :INSIDE
	    next
	  end
        when /^=end$/
          if state == :INSIDE
            state = :OUTSIDE
	    next
	  end
        end
        @body.push( line ) if state == :INSIDE
      end
      if state == :INSIDE
        @body = nil
      end
    end
  end

  def retrieve
    "=begin\n#{ self.body }=end\n"
  end
end


# PURPOSE
#   RD-like grammar for Web form.
class RWikiDescRDWebForm; include RWikiDesc; extend RWikiDescUtil
  def parse( body )
    if !body
      @body = nil
    else
      @body = Array.new
      body.each do | line |
        @body.push( line )
      end
    end
  end

  def retrieve
    self.body || ''
  end
end

