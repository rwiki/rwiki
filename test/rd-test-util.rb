require "test/unit"

require "erb"
require "htree"

require "rwiki/content"
require "rwiki/rw-lib"

module RDTestUtil

  include ERB::Util

  def parse_rd(rd)
    content = RWiki::Content.new("test", rd)
    content.body_erb.result(binding).strip
  end

  def to_attr(hash)
    hash.collect do |key, value|
      "#{h key}='#{h value}'"
    end.join(" ")
  end
  
  def a(href, content, attrs)
    "<a href='#{h href}' #{to_attr(attrs)}>#{h content}</a>"
  end

  def img(src, alt=src, title=alt, klass="inline")
    attrs = {
      'src' => src,
      'alt' => alt,
      'title' => title,
      'class' => klass,
    }
    "<img #{to_attr(attrs)}/>"
  end

  def ref_url(url)
    h(url)
  end

  def ref_name(name, params={}, cmd="view")
    program = "rw-cgi.rb"
    req = RWiki::Request.new(cmd, name)
    page_url = "#{program}?"
    page_url << req.query
    page_url << params.collect{|k, v| ";#{u(k)}=#{u(v)}"}.join('')
    ref_url(page_url)
  end

  def get_unique_anchor(label)
    label
  end
end
