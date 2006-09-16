require 'rwiki/rd/ext/block-verbatim'

RWiki::Version.regist('rwiki/rd/ext/redirect', '$Id$')

module RD
  module Ext
    class BlockVerbatim
      extend RWiki::GetText

      def ext_block_verb_redirect(label, content, visitor)
        return nil unless /^REDIRECT (.+)$/ =~ label
        pagename = $1
        url = "<%=h ref_name(#{pagename.dump})%>"
        <<-"RHTML"
<p><a href="#{url}">Click here and go to `#{url}'</a></p>
<script type="text/javascript"><!--
location.href = "#{url}";
//--></script>
        RHTML
      end
      def self.about_ext_block_verb_redirect
        h(_("If first line is `# REDIRECT PageName', redirect to PageName."))
      end

    end # BlockVerbatim
  end # Ext
end # RD
