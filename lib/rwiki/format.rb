# -*- indent-tabs-mode: nil -*-

require "rwiki/rw-lib"
require "rwiki/erbloader"
require "rwiki/gettext"
require "rwiki/hooks"
require "rwiki/static_view_filename"

module RWiki

  module URLGenerator
    include ERB::Util
    include StaticView

    def ref_url(url)
      h(url)
    end

    def ref_name(name, params = {}, cmd = 'view')
      name_type = env('ref_name')
      page_url =
        if name_type
          if env('ref_name').is_a?(String)
            sprintf(env('ref_name'), u(cmd), u(name))
          elsif name_type.is_a?(Symbol)
            if StaticView.instance_methods(false).include?(name_type.to_s)
              __send__(name_type, name)
            else
              raise "unknown ref_name type: #{name_type}"
            end
          else
            env('ref_name').call(cmd, name, params)
          end
        else
          program = env('base')
          req = Request.new(cmd, name)
          program.to_s + "?" + req.query +
            params.collect{|k,v| ";#{u(k)}=#{u(v)}" }.join('')
        end
      ref_url(page_url)
    end

    def full_ref_name(name, params = {}, cmd = 'view')
      name_type = env('full_ref_name')
      page_url =
        if name_type
          if name_type.is_a?(String)
            sprintf(name_type, u(cmd), u(name))
          elsif name_type.is_a?(Symbol)
            if StaticView.instance_methods(false).include?(name_type.to_s)
              './' + __send__(name_type, name)
            else
              raise "unknown full_ref_name type: #{name_type}"
            end
          else
            env('full_ref_name').call(cmd, name, params)
          end
        else
          "#{env('base_url')}?#{Request.new(cmd, name).query}" <<
            params.collect{|k,v| ";#{u(k)}=#{u(v)}" }.join('')
        end
      ref_url(page_url)
    end
  end

  robots_hook = Hooks::Hook.new
  def robots_hook.to_html(pg, format)
    if format.get_var("cmd") != "view"
      %Q!<meta name="ROBOTS" content="NOINDEX,NOFOLLOW" />!
    end
  end
  Hooks.install_header_hook(robots_hook)

  refresh_hook = Hooks::Hook.new
  def refresh_hook.to_html(pg, format)
    if format.get_var("cmd") == "submit" and
        format.get_var("preview", nil).nil? and
        format.get_var("rename", nil).nil?
      content = "2;url=&quot;#{format.ref_name(pg.name)}&quot;"
      %Q!<meta http-equiv="refresh" content="#{content}" />!
    end
  end
  Hooks.install_header_hook(refresh_hook)

  # ex. MAILTO = 'mailto:rwiki@mail.example.net'
  if MAILTO
    mail_to_hook = Hooks::Hook.new
    def mail_to_hook.to_html(pg, format)
      %Q!<link rev="made" href="#{h MAILTO}" />!
    end
    Hooks.install_header_hook(mail_to_hook)
  end

  # ex. CSS = 'rwiki.css'
  if CSS
    css_hook = Hooks::Hook.new
    def css_hook.to_html(pg, format)
      %Q!<meta http-equiv="Content-Style-Type" content="text/css" />\n! +
        %Q!<link rel="stylesheet" type="text/css" href="#{h CSS}" />!
    end
    Hooks.install_header_hook(css_hook)
  end

  # ex.
  # ICON = 'favicon.ico'
  # ICON_TYPE = 'image/x-icon'
  if defined?(ICON) and defined?(ICON_TYPE)
    icon_hook = Hooks::Hook.new
    def icon_hook.to_html(pg, format)
      %Q!<link href="#{h ICON}" rel="icon" type="#{h ICON_TYPE}" />!
    end
    Hooks.install_header_hook(icon_hook)
  end

  # ex. SHORTCUT_ICON = 'favicon.ico'
  if defined?(SHORTCUT_ICON)
    shortcut_icon_hook = Hooks::Hook.new
    def shortcut_icon_hook.to_html(pg, format)
      %Q!<link href="#{h SHORTCUT_ICON}" rel="shortcut icon" />!
    end
    Hooks.install_header_hook(shortcut_icon_hook)
  end

  class UniqueAnchorGenerator
    def initialize
      @labels = []
    end

    def get_unique_anchor(anchor)
      if @labels.include?(anchor)
        c = 2
        while @labels.include?("#{anchor}_#{c}") do
          c += 1
        end
        anchor = "#{anchor}_#{c}"
      end
      @labels.push(anchor)
      anchor
    end

    def get_name_id(anchor)
      anchor = get_unique_anchor(anchor)
      %Q!name="#{anchor}" id="#{anchor}"!
    end
  end

  module ModifiedFormatter
    module_function
    def parse_modified(t)
      if t.nil?
        nil
      else
        diff = (Time.now - t).to_i
        positive = diff >= 0

        diff = diff.abs / 60
        return [:minute, positive, diff] if diff <= 60
        diff = diff / 60
        return [:hour, positive, diff] if diff <= 24
        diff = diff / 24
        day_diff = diff
        return [:day, positive, diff, day_diff] if diff <= 30
        diff = diff / 30
        return [:month, positive, diff, day_diff] if day_diff <= 365
        return [:year, positive, day_diff / 365, day_diff]
      end
    end

    def modified(t)
      unit, positive, diff, day_diff = parse_modified(t)
      return '-' unless unit

      sign = positive ? "" : "-"
      case unit
      when :minute
        "#{sign}#{diff}m"
      when :hour
        "#{sign}#{diff}h"
      when :day, :month
        "#{sign}#{day_diff}d"
      when :year
        "#{sign}#{diff}y(#{sign}#{day_diff}d)"
      end
    end

    def modified_class(t)
      unit, positive, = parse_modified(t)
      return 'dangling' unless unit

      if positive
        case unit
        when :minute
          "modified-hour"
        when :hour
          "modified-today"
        when :day
          "modified-month"
        when :month
          "modified-year"
        when :year
          "modified-old"
        end
      else
        "modified-future"
      end
    end
  end

  class PageFormat
    include URLGenerator
    include GetTextMixin
    include ModifiedFormatter
    include Hooks

    @@address = ADDRESS
    @@mailto = MAILTO
    @@css = CSS
    @@title = TITLE
    @@charset = CHARSET || 'utf-8'

    def address; @@address; end
    def mailto; @@mailto; end
    def charset; @@charset; end

    def image
      constant_value(:IMAGE)
    end

    def favicon
      constant_value(:FAVICON)
    end

    def favicon_size
      constant_value(:FAVICON_SIZE)
    end

    def rss_css
      constant_value(:RSS_CSS)
    end

    def navi_view(pg, title, referer)
      %Q!<span class="navi">[<a href="#{ ref_name(pg.name) }">#{ h title }</a>]</span>!
    end

    def initialize(env = {}, &block)
      @env = env
      @block = block
      @anchor_generator = UniqueAnchorGenerator.new
      @env[:tabindex] ||= 0
      init_gettext(locales, [])
    end

    def var(key)
      @block ? @block.call(key) : nil
    end

    def get_var(name, default=WEBrick::HTTPUtils::FormData.new)
      var(name) || default
    end

    def env(key)
      @env[key]
    end

    def limit_number(key, default, max)
      num = get_var(key, default).to_i
      range = Range.new(0, num, 0 < num)
      [num, range, (0...max).include?(num)]
    end

    def locales
      env("locales") || []
    end

    def form_action
      env('base')
    end

    def form_hidden(name, cmd = 'view')
      # req = Request.new(cmd, name) ???
      %Q!<input type="hidden" name="cmd" value="#{cmd}" />! +
        %Q!<input type="hidden" name="name" value="#{h(name)}" />!
    end

    def body(pg, opt = {})
      str = pg.body_erb.result(binding)
      if opt.has_key?(:key)
        # Copy keys from UI side.
        keys = opt[:key].list.collect { |i| i.dup }
        str = hilighten(str, keys)
      end
      %Q!<div class="body">#{str}</div>!
    end

    def preview_body(pg, src)
      str = pg.make_content(src).body_erb.result(binding)
      %Q!<div class="body">#{str}</div>!
    end

    def link(pg, params={})
      attrs = [
        %Q!href="#{ref_name(pg.name, params)}"!,
        %Q!title="#{h(pg.name)} (#{modified(pg.modified)})"!,
        %Q!class="#{modified_class(pg.modified)}"!,
      ].join(" ")
      "<a #{attrs}>#{h(pg.name)}</a>"
    end

    def link_and_modified(pg, params={})
      "#{link(pg, params)} (#{h(modified(pg.modified))})"
    end

    # For backward compatibility.
    def get_unique_anchor(anchor)
      @anchor_generator.get_unique_anchor(anchor)
    end

    def anchor_to_name_id(anchor)
      @anchor_generator.get_name_id(anchor)
    end

    MaxModTimeIdx = 10
    def hotbar(modTime)
      idx = if modTime.is_a?(Time)
          ( MaxModTimeIdx + 1 ) / (( Time.now - modTime ) / 86400 + 1 ).to_f
        else
          modTime
        end.to_i
      if ( idx < 0 )
        idx = 0
      end
      if 0 < idx
        %Q!<span class="hotbar">#{ '*' * idx }</span>!
      else
        ''
      end
    end

    def tabindex
      @env[:tabindex] += 1
      %Q!tabindex="#{@env[:tabindex]}"!
    end

    @rhtml = {}
    @rhtml[:header] = ERBLoader.new('header(pg)', 'header.rhtml')
    @rhtml[:navi] = ERBLoader.new('navi(pg)', 'navi.rhtml')
    @rhtml[:footer] = ERBLoader.new('footer(pg)', 'footer.rhtml')
    @rhtml[:view] = ERBLoader.new('view(pg)', 'view.rhtml')
    @rhtml[:edit] = ERBLoader.new('edit(pg, rev=nil)', 'edit.rhtml')
    @rhtml[:edit_form] = ERBLoader.new('edit_form(pg, src, rev=nil)', 'edit_form.rhtml')
    @rhtml[:submit] = ERBLoader.new('submit(pg)', 'submit.rhtml')
    @rhtml[:preview] = ERBLoader.new('preview(pg, src)', 'preview.rhtml')
    @rhtml[:emphasize] = ERBLoader.new('emphasize(pg)', 'emphasize.rhtml')
    @rhtml[:error] = ERBLoader.new('error(pg)', 'err.rhtml')
    @rhtml[:src] = ERBLoader.new('src(pg, rev)', 'src.rhtml')

    def self.reload_rhtml
      if @rhtml.nil?
        return
      end
      @rhtml.each do |k, v|
        v.reload(self)
      end
    end

    reload_rhtml

    private
    def hilighten(str, keywords)
      hilighted = str.dup
      keywords.each do |key|
        re = Regexp.new('(' << Regexp.escape(h(key)) << ')', Regexp::IGNORECASE)
        hilighted.gsub!(/([^<]*)(<[^>]*>)?/) {
          body, tag = $1, $2
          body.gsub(re) {
            %Q!<em class="hilight">#{$1}</em>!
          } << ( tag || "" )
        }
      end
      hilighted
    end

    def erb_result(pg, erb_or_str, opt={})
      if String === erb_or_str
        str = erb_or_str
        return str unless str.include?('<%')
        erb = ERB.new(str)
      else
        erb = erb_or_str
      end
      erb.result(binding)
    end

    def revert_link(name, rev)
      title = _("revert")
      param = {
        "rev" => rev,
        "commit_log" => _("revert to revision %s") % rev,
      }
      %Q!<a href="#{ref_name(name, param, 'edit')}">#{h(title)}</a>!
    end

    def src_link(name, rev)
      param = {
        "rev" => rev,
      }
      %Q[<a href="#{ref_name(name, param, 'src')}">#{rev}</a>]
    end

    def revisions_around(logs, current)
      index = nil
      logs.each_with_index do |log, i|
        if log.revision == current
          index = i
          break
        end
      end

      if index
        prev_log = logs[index + 1]
        next_rev = index - 1
        if next_rev < 0
          next_log = nil
        else
          next_log = logs[next_rev]
        end
        [prev_log && prev_log.revision, next_log && next_log.revision]
      else
        [nil, nil]
      end
    end

    def constant_value(name)
      RWiki.const_defined?(name) ? RWiki.const_get(name) : nil
    end

    def message(pg)
      result = nil
      name, info = get_var('message', [])
      generator = "message_#{name}"
      if respond_to?(generator, true)
        result = funcall(generator, pg, *info)
      else
        result = name
      end
      result = "<p class='message'>#{result}</p>" if result
      result
    end

    def message_new_name_is_empty(pg)
      _("new name is empty!")
    end

    def message_destination_page_is_exist(pg, new_name)
      _("destination page(%s) is exist!") % link(pg.book[new_name])
    end
  end
end
