# -*- indent-tabs-mode: nil -*-
# rwiki.rb
#
# Copyright (c) 2000-2003 Masatoshi SEKI
#
# rwiki.rb is copyrighted free software by Masatoshi SEKI.
# You can redistribute it and/or modify it under the same term as Ruby.

require 'rwiki/rw-lib'
require 'rwiki/page'
require 'rwiki/format'
require 'rwiki/section'
require 'rwiki/book'
require 'rwiki/navi'
require 'rwiki/edit'
require 'rwiki/search'
require 'rwiki/src'
require 'rwiki/db/file'
require 'rwiki/gettext'
require 'rwiki/pagemodule'

module RWiki

  Version.regist('rwiki server', '$Id$')

  BookConfig.default.db = DB::File.new(DB_DIR)
  BookConfig.default.format = PageFormat
  BookConfig.default.page = Page
  BookConfig.default.add_default_src_proc(proc {|name| "= #{name}\n\n"})

  navi_to_home = Object.new
  class << navi_to_home
    include URLGenerator

    def env(key)
      @env[key]
    end
    
    def navi_view(title, pg, env = {}, &block)
      @env = env
      %Q|<span class="navi">[<a href="#{ref_name(name, {'navi' => name})}">#{title}</a>]</span>|
    end
    
    def name
      TOP_NAME
    end
    
    def always_header?
      false
    end
  end

  navi_to_link = Object.new
  class << navi_to_link
    def navi_view(title, pg, env = {}, &block)
      %Q|<span class="navi">[<a href="#link">#{ title }</a>]</span>|
    end
    def name
      "link"
    end
    def always_header?
      true
    end
  end

  [
    [nil, navi_to_home, s_('navi|home')],
    [nil, navi_to_link, s_('navi|link')],
    ['help', NaviFormat, s_('navi|help')],
  ].each do |args|
    install_page_module(*args)
  end

  def self.reload_rhtml
    ObjectSpace.each_object(Class) do |o|
      o.reload_rhtml if o.ancestors.include?(PageFormat)
    end
  end
end
