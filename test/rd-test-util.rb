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

  def a(href, content, attrs)
    attrs = attrs.collect do |key, value|
      "#{h(key)}='#{h value}'"
    end.join(" ")
    "<a href='#{h href}' #{attrs}>#{h content}</a>"
  end

  def img(src, alt=src, klass="inline")
    "<img src='#{h src}' alt='#{h alt}' class='#{h klass}'/>"
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

end
