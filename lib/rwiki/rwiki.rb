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
require 'rwiki/navi'
require 'rwiki/edit'
require 'rwiki/search'
require 'rwiki/src'
require 'rwiki/db/file'
require 'rwiki/gettext'
require 'rwiki/pagemodule'

module RWiki

  N_('home')
  N_('link')
  N_('help')

  Version.regist('rwiki server', '2003-12-28 2.1.0')

  BookConfig.default.db = DB::File.new(DB_DIR)
  BookConfig.default.format = PageFormat
  BookConfig.default.page = Page
  BookConfig.default.add_default_src_proc(proc {|name| "= #{name}\n\n"})
  
  navi_to_link = Object.new
  class << navi_to_link
    def navi_view(title, pg, env = {}, &block)
      %Q[<span class="navi">[<a href="#link">#{ title }</a>]</span>]
    end
    def name
      "link"
    end
    def always_header?
      true
    end
  end

  [
    [TOP_NAME, NaviFormat, _('home')],
    [nil, navi_to_link, _('link')],
    ['help', NaviFormat, _('help')],
  ].each do |args|
    install_page_module(*args)
  end

  def self.reload_rhtml
    ObjectSpace.each_object(Class) do |o|
      o.reload_rhtml if o.ancestors.include?(PageFormat)
    end
  end
end
