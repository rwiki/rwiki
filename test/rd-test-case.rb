require "test/unit"

require "erb"
require "htree"

require "rwiki/content"

class RDTestCase < Test::Unit::TestCase

  include ERB::Util
  
  def default_test
    # This class isn't tested
  end

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
  
end
