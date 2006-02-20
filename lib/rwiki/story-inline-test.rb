require 'erb'
require 'rwiki/rd/ext/base'

module RD
  module Ext
    class InlineVerbatim
    def test_result_form(name)
      <<EOS
<%
  now = Time.now
  today = Time.local(now.year, now.month, now.day)
  it = pg.book['#{name}'].prop(:story)

  if it
    begin
      v = it[:test_result][today]
      ok_selected = v ? "selected" : ""
      ng_selected = v == false ? "selected" : ""
    rescue
      ok_selected = ""
      ng_selected = ""
    end
%> 
      <form action="<%= form_action() %>" method="get">
        <input type="hidden" name="cmd" value="view" />
        <input type="hidden" name="name" value="<%=u(it[:name])%>" />
        <input type="hidden" name="story" value="test" />
        <select name="testresult" onchange="this.form.submit()">
         <option value="">-</option>
         <option value="OK" <%=ok_selected%>>OK</option>
         <option value="NG" <%=ng_selected%>>NG</option>
        </select>
        <input type="submit" value="Set" />
       </form>
<%
  end
%>
EOS
    end

    def ext_inline_verb_test(label, content, visitor)
      label = label.to_s
      return nil unless /^test:\s*(.+)$/ =~ label
      name = $1
      # @links.push name.to_a unless @links.include?(name.to_a)
      visitor.links.push name.to_a unless visitor.links.include?(name.to_a)
      ref = %Q[<%= ref_name('#{CGI.escapeHTML(name)}')%>]
      anchor = %Q[<a href="#{ref}">#{CGI.escapeHTML(name)}</a>]
      %Q[<h3>#{anchor}</h3><%= pg.book['#{name}'].prop(:story)[:test_inline] rescue '' %>] + test_result_form(name)
    end
    def self.about_ext_inline_verb_test
      h(%Q!inline story test (example: (('test:name')))!)
    end
  end
end
end

# RD::RD2RWikiVisitor.install_extension
