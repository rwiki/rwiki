require 'rwiki/rd/ext/block-verbatim'
require 'tempfile'

module RD
  module Ext
    class BlockVerbatim
      extend RWiki::GetText

      @@enscript_highlight = `enscript --help-highlight`.scan(/^Name: (\w+)/)
      @@enscript_highlight.flatten!

      unless @@enscript_highlight.empty?
        def ext_block_verb_enscript(label, content, visitor)
          return nil unless /^enscript (\w+)$/i =~ label
          highlight_lang = $1
          return unless @@enscript_highlight.include?(highlight_lang)
          delete_first_line!(content)
          highlight_lang.untaint
          file = Tempfile.new("rwiki-enscript")
          file.write(CGI.unescapeHTML(content))
          file.close
          html = `enscript --color --language=html --highlight=#{highlight_lang} -o - #{file.path}`
          file.close(true)
          html.sub!(/.*?<PRE/m, '<pre class="enscript"')
          if %r!<ADDRESS>.*</ADDRESS>! =~ html
            address = $&
          end
          html.sub!(%r!</PRE>.*!m, "</pre>\n<!-- #{address} -->")
          html.gsub!(%r!</?[^<>]+>!) { $&.downcase }
          html
        end
        def self.about_ext_block_verb_enscript
          h(_("If first line is `\# enscript LANG', filtered by `enscript --color --language=html --highlight=LANG -o - -'. (supported LANG: #{@@enscript_highlight.join(', ')})"))
        end
      end

    end # BlockVerbatim
  end # Ext
end # RD

