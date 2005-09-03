require 'rwiki/rd/ext/block-verbatim'
require 'tempfile'

RWiki::Version.regist('rwiki/rd/ext/enscript', '$Id$')

module RD
  module Ext
    class BlockVerbatim
      extend RWiki::GetText

      @@enscript_highlight = `enscript --help-highlight`.scan(/^Name: (\w+)/)
      @@enscript_highlight.flatten!

      def self.enscript_available?
        not @@enscript_highlight.empty?
      end
      
      if enscript_available?
        def ext_block_verb_enscript(label, content, visitor)
          return nil unless /^enscript (\w+)$/i =~ label
          highlight_lang = $1
          return unless @@enscript_highlight.include?(highlight_lang)
          delete_first_line!(content)
          highlight_lang.untaint
          file = Tempfile.new("rwiki-enscript")
          file.write(CGI.unescapeHTML(content))
          file.close
          args = [
            "--color", "--language=html", "--highlight=#{highlight_lang}",
            "-o", "-", file.path,
          ]
          html = `enscript #{args.join(" ")}`
          file.close(true)
          html.gsub!(%r!</?[^<>]+>!) { $&.downcase }
          html.sub!(/.*?<pre/m, '<pre class="enscript"')
          if %r!<address>.*</address>! =~ html
            address = $&
          end
          html.gsub!(/<b>/, '<span style="font-weight: bold">')
          html.gsub!(/<font color="([^\"]+)">/, '<span style="color: \1">')
          html.gsub!(/<\/(b|font)>/, '</span>')
          html.sub!(/<\/pre>.*/m, "</pre>\n<!-- #{address} -->")
          html
        end
        def self.about_ext_block_verb_enscript
          h(_("If first line is `\# enscript LANG', filtered by `enscript --color --language=html --highlight=LANG -o - -'. (supported LANG: #{@@enscript_highlight.join(', ')})"))
        end
      end

    end # BlockVerbatim
  end # Ext
end # RD
