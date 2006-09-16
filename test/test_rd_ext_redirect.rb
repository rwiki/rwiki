require "rd-test-util"

require 'rwiki/rd/ext/redirect'

class TestRDExtBlockVerbatim < Test::Unit::TestCase
  include RDTestUtil

  def test_ext_block_verb_redirect
    source = <<-'EOS'
  # REDIRECT StringIO
EOS

    uri = ref_name('StringIO')
    expected_source = <<-EOS.rstrip
<p><a href="#{h uri}">Click here and go to `#{h uri}'</a></p>
<script type="text/javascript"><!--
location.href = "#{h uri}";
//--></script>
EOS
    
    expected = HTree.parse(expected_source)
    actual = HTree.parse(parse_rd(source))
    assert_equal(expected, actual)
  end

  def test_ext_block_verb_redirect_xss
    source = <<-'EOS'
  # REDIRECT <s>test</s>
EOS

    actual = parse_rd(source)
    assert_no_match(/<s>/, actual)
  end
end
