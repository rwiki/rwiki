# -*- indent-tabs-mode: nil -*-
require "cgi"
require "rd/rdvisitor"
require "rd/version"
require "rwiki/gettext"
require "rwiki/rw-lib"
require "rwiki/rd/ext/refer"
require "rwiki/rd/ext/inline-verbatim"
require "rwiki/rd/ext/block-verbatim"

module RD
  class Reference
    class RWikiLabel < Label
      attr_reader :wikiname
      attr_reader :anchor
      alias element_label wikiname
      alias to_label wikiname

      def initialize(wikiname, anchor = nil)
        @wikiname = wikiname
        @anchor = anchor
      end

      def to_a
        return [@wikiname, @anchor]
      end

      def to_s
        if @anchor
          return @wikiname + '/' + @anchor
        else
          return @wikiname
        end
      end

      def RWikiLabel.new_from_RDLabel(rdlabel)
        return RWikilabel.new(nil) if
          rdlabel.element_label.nil? && rdlabel.filename.nil?

        if rdlabel.filename
          if /\S/ === rdlabel.element_label
            return RWikiLabel.new(rdlabel.filename, rdlabel.element_label)
          else
            return RWikiLabel.new(rdlabel.filename)
          end
        else
          return RWikiLabel.new(rdlabel.element_label)
        end
      end

      def result_of_apply_method_of(visitor, reference, children)
        visitor.apply_to_Reference_with_RWikiLabel(reference, children)
      end

      def self.replace_label(reference)
        if reference.label.is_a? Reference::RDLabel
          new_label = RWikiLabel.new_from_RDLabel(reference.label)
        else
          new_label = reference.label
        end

        reference.label = new_label
      end
    end
  end
end


module RD
  class RD2RWikiVisitor < RDVisitor

    class VisitorError < StandardError
    end
    
    include MethodParse
    extend RWiki::GetText
    include RWiki::GetText

    SYSTEM_NAME = "RDtool -- RD2RWikiVisitor"
    SYSTEM_VERSION = "Based on RD2HTMLVisitor $Version: 0.6.11$" #"
    VERSION = Version.new_from_version_string(SYSTEM_NAME, SYSTEM_VERSION)

    def self.version
      VERSION
    end

    # must-have constants
    OUTPUT_SUFFIX = "html"
    INCLUDE_SUFFIX = ["html"]

    METACHAR = { "<" => "&lt;", ">" => "&gt;", "&" => "&amp;" }

    EXTENSIONS = {
      :refer => [s_("extension|refer"), Ext::Refer],
      :inline_verbatim => [s_("extension|inline_verbatim"), Ext::InlineVerbatim],
      :block_verbatim => [s_("extension|block_verbatim"), Ext::BlockVerbatim],
    }

    attr(:css, true)
    attr(:charset, true)
    alias charcode charset
    alias charcode= charset=
    attr(:lang, true)
    attr(:title, true)
    attr(:html_link_rel, nil)
    attr(:html_link_rev, nil)
    # output external Label file.
    attr(:output_rbl, true)

    attr_reader(:links)
    attr_reader(:method_list)

    def initialize
      @css = nil
      @charset = nil
      @lang = nil
      @title = nil
      @html_link_rel = {}
      @html_link_rev = {}

      @output_rbl = nil

      # For RWiki
      @links = []
      @method_list = []

      init_extensions
      super
    end

    def init_extensions
      @installed_extensions = {}
      EXTENSIONS.each do |ext_type, (ext_type_name, klass)|
        @installed_extensions[ext_type] =  klass.new
      end
    end
    private :init_extensions

    def visit(tree)
      # prepare_labels(tree, "label-")
      tree.find_all{|i| i.is_a? Reference }.each do |i|
        Reference::RWikiLabel.replace_label(i)
      end
      tmp = super(tree)
      # make_rbl_file(@filename) if @output_rbl and @filename
      tmp
    end

    def visit_partial_inline(ary)
      ary.find_all{|i| i.is_a? Reference }.each do |i|
        Reference::RWikiLabel.replace_label(i)
      end
      visit_children(ary)
    end

    def url_ext_refer(url, content)
      href = "<%= ref_url(#{url.to_s.dump}) %>"
      %Q|<a href="#{href}" class="external">#{content}</a>|
    end

    # Creates content for RWiki, not a full-HTML instance.
    def apply_to_DocumentElement(element, content)
      content = content.join("\n")
      # title = document_title        # Not used for now.

      %Q|#{content}#{make_foottext_erb}\n|
    end

    def document_title
      return @title if @title
      return @filename if @filename
      return ARGF.filename if ARGF.filename != "-"
      "Untitled"
    end
    private :document_title

    def apply_to_Headline(element, title)
      %Q!<h#{element.level}>! <<
        %Q!#{a_name_id(element, title)}! <<
        %Q!</h#{element.level}>!
    end

    def apply_to_Include(element)
      filename = element.filename
      if element.respond_to?(:rest)
        filename << element.rest
      else
        raise VisitorError.new(_("Include is prohibited."))
      end
      unless @links.include? [filename, nil]
        @links.push [filename, nil]
      end
      <<-"ERB"
<% 
  filename = #{filename.dump}
  @included ||= {}
  if @included.include?(filename)
%><p class="include-error">
<%= sprintf(_("already included page: `%s'"), filename) %>
</p><%
  else
    @included[filename] = true
    if inc_page = pg.book[filename] and not inc_page.empty?
%><div class="include">
<p class="include-filename">
<a href="<%= ref_name(filename) %>"><%=h filename%></a>
</p>
<%= body(inc_page) %>
</div><%
    else
%><p class="include-error">
<%= sprintf(_("page not found: `<a href='%s'>%s</a>'"), ref_name(filename), filename) %>
</p><%
    end
  end
%>
      ERB
    end

    def apply_to_TextBlock(element, content)
      content = content.join("")
      if (is_this_textblock_only_one_block_of_parent_listitem?(element) or
          is_this_textblock_only_one_block_other_than_sublists_in_parent_listitem?(element))
        content.chomp
      else
        %Q|<p>#{content.chomp}</p>|        # <br />#{content}\n ?
      end
    end

    def is_this_textblock_only_one_block_of_parent_listitem?(element)
      (element.parent.is_a?(ItemListItem) or
       element.parent.is_a?(EnumListItem)) and
        consist_of_one_textblock?(element.parent)
    end

    def is_this_textblock_only_one_block_other_than_sublists_in_parent_listitem?(element)
      (element.parent.is_a?(ItemListItem) or
       element.parent.is_a?(EnumListItem)) and
        consist_of_one_textblock_and_sublists(element.parent)
    end

    def consist_of_one_textblock_and_sublists(element)
      i = 0
      element.each_child do |child|
        if i == 0
          return false unless child.is_a?(TextBlock)
        else
          return false unless child.is_a?(List)
        end
        i += 1
      end
      return true
    end

    def apply_to_Verbatim(element)
      content = []
      element.each_line do |i|
        content.push(apply_to_String(i))
      end
      content_str = content.join("")
      /\A#\s*([^\n]+)\s*(?:\n.*)?\z/m =~ content_str
      apply_to_extension(:block_verbatim, $1, content_str)
    end

    def apply_to_ItemList(element, items)
      %Q|<ul>\n#{items.join("\n").chomp}\n</ul>|
    end

    def apply_to_EnumList(element, items)
      %Q|<ol>\n#{items.join("\n").chomp}\n</ol>|
    end

    def apply_to_DescList(element, items)
      %Q|<dl>\n#{items.join("\n").chomp}\n</dl>|
    end

    def apply_to_MethodList(element, items)
      %Q|<dl>\n#{items.join("\n").chomp}\n</dl>|
    end

    def apply_to_ItemListItem(element, content)
      %Q|<li>#{content.join("\n").chomp}</li>|
    end

    def apply_to_EnumListItem(element, content)
      %Q|<li>#{content.join("\n").chomp}</li>|
    end

    def consist_of_one_textblock?(listitem)
      listitem.content.size == 1 and listitem.content[0].is_a?(TextBlock)
    end
    private :consist_of_one_textblock?

    def apply_to_DescListItem(element, term, description)
      %Q|<dt>#{a_name_id(element, term)}</dt>| <<
        if description.empty?
          ''
        else
          %Q|\n<dd>\n#{description.join("\n").chomp}\n</dd>|
        end
    end

    def apply_to_MethodListItem(element, term, description)
      term = parse_method(term, element)  # maybe: term -> element.term
      term_in_code = %Q!<code>#{term}</code>!
      %Q!<dt>#{a_name_id(element, term_in_code)}</dt>! <<
        if description.empty?
          ''
        else
          %Q!\n<dd>\n#{description.join("\n")}</dd>!
        end
    end

    def apply_to_StringElement(element)
      apply_to_String(element.content)
    end

    def apply_to_Emphasis(element, content)
      %Q|<em>#{content.join("")}</em>|
    end

    def apply_to_Code(element, content)
      %Q|<code>#{content.join("")}</code>|
    end

    def apply_to_Var(element, content)
      %Q|<var>#{content.join("")}</var>|
    end

    def apply_to_Keyboard(element, content)
      %Q|<kbd>#{content.join("")}</kbd>|
    end

    def apply_to_Index(element, content)
      a_name_id(element, content.join(''), element.to_label)
    end

    def apply_to_Reference_with_RWikiLabel(element, content)
      content = content.join("")
      apply_to_extension(:refer, element.label, content)
    end

    def apply_to_Reference_with_URL(element, content)
      url_ext_refer(element.label.url, content.join(""))
    end

    def apply_to_Footnote(element, content)
      # /[\s\S]/ is equal to /./m
      <<-"ERB".chomp
<%
  @foottexts ||= []
  content = #{content.to_s.gsub(/%>/, '%%>').dump}
  footmark_anchor = get_unique_anchor("footmark-\#{@foottexts.size+1}")
  foottext_anchor = get_unique_anchor("footnote-\#{@foottexts.size+1}")
  foottext = %Q!<a name="\#{foottext_anchor}" id="\#{foottext_anchor}"! <<
    %Q! class="foottext" href="\\\#\#{footmark_anchor}">! <<
    %Q!<sup><small>*\#{@foottexts.size+1}</small></sup></a>! <<
    %Q!<small>\#{content}</small><br />!
  @foottexts.push(foottext)
  title = content.gsub(/%%%>/, '')
  title.gsub!(/<%[\\s\\S]*?(?!%)[\\s\\S]%%>/, '')
  title.gsub!(/<[\\s\\S]*?>/, '')
  title.sub!(/\A([\\s\\S]{80})[\s\S]{4,}/, '\\1...')
%><a name="<%=footmark_anchor%>" id="<%=footmark_anchor%>" class="footnote"
  title="<%=CGI.escapeHTML(title)%>"
  href="\#<%=foottext_anchor%>"><sup><small>*<%=@foottexts.size%></small></sup></a>
      ERB
    end

    def apply_to_Verb(element)
      content = apply_to_String(element.content)
      apply_to_extension(:inline_verbatim, element_label(element), content)
    end

    def sp2nbsp(str)
      str.gsub(/\s/, "&nbsp;")
    end
    private :sp2nbsp

    def apply_to_String(element)
      meta_char_escape(element)
    end

    def parse_method(method, element)
      klass, kind, method, args = MethodParse.analize_method(method)

      # method == "$."
      if method.empty?
        klass, method = nil, klass + '.'
      end
      if /^\$/ === method
        kind = :global_variable
      end

      unless method == "self"
        rwiki_method(element, klass, kind, method)
      end

      case kind
      when :function, :global_variable
        klass = kind = nil
      else
        kind = MethodParse.kind2str(kind)
      end

      args = '' if args.nil?
      args.gsub!(/&?\w+;?/){ |m|
        if /&\w+;/ =~ m then m else '<var>'+m+'</var>' end }

      case method
      when "self"
        klass, kind, method, args = MethodParse.analize_method(args)
        rwiki_method(element, klass, kind, method)
        "#{klass}#{kind}<var>self</var> #{method}#{args}"
      when "[]"
        args.strip!
        args.sub!(/^\((.*)\)$/, '\\1')
        "#{klass}#{kind}[#{args}]"
      when "[]="
        args.delete!(' ')
        args.sub!(/^\((.*)\)$/, '\\1')
        ary = args.split(/,/)

        case ary.length
        when 1
          val = '<var>val</var>'
        when 2
          args, val = *ary
        when 3
          args, val = ary[0, 2].join(', '), ary[2]
        end

        "#{klass}#{kind}[#{args}] = #{val}"
      else
        "#{klass}#{kind}#{method}#{args}"
      end
    end
    private :parse_method

    def meta_char_escape(str)
      str.gsub(/[<>&]/) {
        METACHAR[$&]
      }
    end
    private :meta_char_escape

    def hyphen_escape(str)
      str.gsub(/--/, "&shy;&shy;")
    end

    def make_foottext_erb
      # when footnotes nest, footnote_index grows in loop
      <<-"ERB"
<%
  @foottexts ||= []
  unless @foottexts.empty?
%><hr /><% footnote_index = 0 %>
<p class="foottext">
<%
    while footnote_index < @foottexts.size
%><%=  ERB.new(@foottexts[footnote_index], nil, nil, '_erbout_in_fn').result(binding) %>
<%
      footnote_index += 1
    end %></p><%
  end
%>
      ERB
    end
    private :make_foottext_erb

    # RWiki Part
    private

    def label2anchor(label)
      if /\A[A-Za-z]/ !~ label
        label = 'a' << label
      end
      label.gsub(/([^A-Za-z0-9\-_]+)/n) {
        '.' + $1.unpack('H2' * $1.size).join('.')
      }
    end

    def a_name_id(element, content, label = nil)
      label ||= hyphen_escape(element.label)
      anchor = label2anchor(label)
      title = content.to_s
      if /\A<a/ =~ title
        ret = title.sub(/\A<a/, %Q|<a <%=anchor_to_name_id(#{anchor.dump})%>|)
      else
        ret = title.sub(/\A([^<>]?)/, %Q|<a <%=anchor_to_name_id(#{anchor.dump})%>>\\&</a>|)
      end
      if label
        ret << %Q|<!-- RDLabel: "#{label}" -->|
      else
        ''
      end
    end

    def apply_to_extension(ext_type, label, content)
      result = nil
      if @installed_extensions.has_key?(ext_type)
        result = @installed_extensions[ext_type].apply(label, content, self)
      end
      if result.nil? and
          respond_to?("default_ext_#{ext_type}", true)
        result = __send__("default_ext_#{ext_type}", label, content)
      end
      if result.nil?
        $stderr.puts "[BUG] [#{label}] #{ext_type} extension isn't installed."
      end
      result
    end

    def element_label(element)
      case element
      when RDElement
        element.to_label
      else
        element
      end
    end

    def rwiki_method(element, klass, kind, method)
      @method_list.push [element_label(element), klass, kind, method]
    end

    def rwiki_refer(label)
      @links.push label.to_a unless @links.include? label.to_a
      if label.anchor
        "<%= label_wikiname = #{label.wikiname.dump};" +
          "ref_name(label_wikiname) if label_wikiname != pg.name %>" +
          "\##{label2anchor(label.anchor)}"
      else
        "<%= ref_name(#{label.wikiname.dump}) %>"
      end
    end

    def rwiki_mod(label)
      meta_char_escape(label) + " (<%= modified(pg.book[#{label.dump}].modified)%>)"
    end

    def rwiki_mod_class(label)
      "<%=h modified_class(pg.book[#{label.dump}].modified)%>"
    end

    def default_ext_refer(label, content)
      ref = rwiki_refer(label)
      mod = rwiki_mod(label.wikiname)
      cls = rwiki_mod_class(label.wikiname)
      %Q|<a href="#{ref}" title="#{mod}" class="#{cls}">#{content}</a>|
    end

    def default_ext_inline_verbatim(label, content)
      %Q!#{content}!
    end

    def default_ext_block_verbatim(label, content)
      %Q!<pre>\n#{content}</pre>\n!
    end
  end # RD2RWikiVisitor
end # RD

$Visitor_Class = RD::RD2RWikiVisitor
