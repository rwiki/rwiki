# -*- indent-tabs-mode: nil -*-

require "rwiki/rw-lib"
require "rwiki/erbloader"
require "rwiki/gettext"

module RWiki
  class PageFormat
    include ERB::Util
    include GetText

    @@address = ADDRESS
    @@mailto = MAILTO
    if defined?(ICON)
      @@icon = ICON
      @@icon_type = defined?(ICON_TYPE) ? ICON_TYPE : nil
      @@icon_type ||= 'image/x-icon'
    else
      @@icon = nil
    end
    @@css = CSS
    @@title = TITLE
    @@lang = LANG || KCode.lang
    @@charset = CHARSET || KCode.charset

    def navi_view(pg, title, referer)
      %Q[<span class="navi">[<a href="#{ ref_name(pg.name) }">#{ h title }</a>]</span>]
    end

    def modified(t)
      return '-' unless t
      dif = (Time.now - t).to_i
      dif = dif / 60
      return "#{dif}m" if dif <= 60
      dif = dif / 60
      return "#{dif}h" if dif <= 24
      dif = dif / 24
      return "#{dif}d"
    end

    def modified_class(t)
      return 'dangling' unless t
      dif = (Time.now - t).to_i
      dif = dif / 60
      return "modified-hour" if dif <= 60
      dif = dif / 60
      return "modified-today" if dif <= 24
      dif = dif / 24
      return "modified-month" if dif <= 30
      return "modified-year" if dif <= 365
      return "modified-old"
    end

    def initialize(env = {}, &block)
      @env = env
      @block = block
      @env[:tabindex] ||= 0
    end

    def var(key)
      @block ? @block.call(key) : []
    end

    def get_var(name, default='')
      val, = var(name)
      val || default
    end

    def env(key)
      @env[key]
    end

    def ref_url(url)
      h(url)
    end

    def ref_name(name, params = {}, cmd = 'view')
      page_url =
        if env('ref_name').is_a?(String)
          sprintf(env('ref_name'), u(cmd), u(name))
        elsif env('ref_name')
          env('ref_name').call(cmd, name, params)
        else
          program = env('base')
          req = Request.new(cmd, name)
          program.to_s + "?" + req.query +
            params.collect{|k,v| ";#{u(k)}=#{u(v)}" }.join('')
        end
      ref_url(page_url)
    end

    def full_ref_name(name, params = {}, cmd = 'view')
      page_url =
        if env('full_ref_name').is_a?(String)
          sprintf(env('full_ref_name'), u(cmd), u(name))
        elsif env('full_ref_name')
          env('full_ref_name').call(cmd, name)
        else
          "#{env('base_url')}?#{Request.new(cmd, name).query}" <<
            params.collect{|k,v| ";#{u(k)}=#{u(v)}" }.join('')
        end
      ref_url(page_url)
    end

    def form_action
      env('base')
    end

    def form_hidden(name, cmd = 'view')
      # req = Request.new(cmd, name) ???
      %Q[<input type="hidden" name="cmd" value="#{cmd}" />] +
        %Q[<input type="hidden" name="name" value="#{h(name)}" />]
    end

    def body(pg, opt = {})
      str = pg.body_erb.result(binding)
      if opt.has_key?(:key)
        # Copy keys from UI side.
        keys = opt[:key].collect { |i| i.dup }
        str = hilighten(str, keys)
      end
      %Q[<div class="body">#{str}</div>]
    end

    def link_and_modified(pg, params={})
      %Q[<a href="#{ref_name(pg.name, params)}">#{h(pg.name)}</a> (#{h(modified(pg.modified))})]
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
        %Q[<span class="hotbar">#{ '*' * idx }</span>]
      else
        ''
      end
    end

    def tabindex
      @env[:tabindex] += 1
      %Q[tabindex="#{@env[:tabindex]}"]
    end

    @rhtml = {}
    @rhtml[:header] = ERBLoader.new('header(pg)', 'header.rhtml')
    @rhtml[:navi] = ERBLoader.new('navi(pg)', 'navi.rhtml')
    @rhtml[:footer] = ERBLoader.new('footer(pg)', 'footer.rhtml')
    @rhtml[:view] = ERBLoader.new('view(pg)', 'view.rhtml')
    @rhtml[:edit] = ERBLoader.new('edit(pg)', 'edit.rhtml')
    @rhtml[:submit] = ERBLoader.new('submit(pg)', 'submit.rhtml')
    @rhtml[:emphasize] = ERBLoader.new('emphasize(pg)', 'emphasize.rhtml')
    @rhtml[:error] = ERBLoader.new('error(pg)', 'err.rhtml')
    @rhtml[:src] = ERBLoader.new('src(pg)', 'src.rhtml')


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
            %Q[<em class="hilight">#{$1}</em>]
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
  end

end
