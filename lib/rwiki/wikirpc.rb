require 'iconv'
require 'rwiki/front'

module RWiki
  module WikiRPC
    @@iconv_to_utf8 =
      case $KCODE
      when 'EUC'
        Iconv.new('UTF-8', 'EUC-JP')
      when 'SJIS'
        Iconv.new('UTF-8', 'CP932')
      else
        Iconv.new('UTF-8', 'UTF-8')
      end

    @@iconv_from_utf8 =
      case $KCODE
      when 'EUC'
        Iconv.new('EUC-JP', 'UTF-8')
      when 'SJIS'
        Iconv.new('CP932', 'UTF-8')
      else
        Iconv.new('UTF-8', 'UTF-8')
      end

    def recent_changes_info_utf8(time)
      @book.recent_changes.select do |pg|
        pg.modified and time <= pg.modified
      end.collect do |pg|
        {
          'name' => @@iconv_to_utf8.iconv(pg.name) << @@iconv_to_utf8.iconv(nil),
          'lastModified' => pg.modified.utc,
          #'author' => "",
          "version" => -1, # pg.version,
        }
      end
    end

    def page_src_utf8(pagename)
      pagename = @@iconv_from_utf8.iconv(pagename)
      pagename << @@iconv_from_utf8.iconv(nil)
      pg = page(pagename)
      return nil if pg.empty?
      @@iconv_to_utf8.iconv(pg.src) << @@iconv_to_utf8.iconv(nil)
    end

    def page_html_utf8(pagename, env, &block)
      pagename = @@iconv_from_utf8.iconv(pagename)
      pagename << @@iconv_from_utf8.iconv(nil)
      pg = page(pagename)
      return nil if pg.empty?
      html = pg.view_html(env, &block)
      @@iconv_to_utf8.iconv(html) << @@iconv_to_utf8.iconv(nil)
    end

    def all_pages_utf8
      @book.collect do |pg|
        @@iconv_to_utf8.iconv(pg.name) << @@iconv_to_utf8.iconv(nil)
      end
    end

    def page_info_utf8(pagename)
      pagename = @@iconv_from_utf8.iconv(pagename)
      pagename << @@iconv_from_utf8.iconv(nil)
      pg = page(pagename)
      return nil if pg.empty?
      {
        'name' => @@iconv_to_utf8.iconv(pg.name) << @@iconv_to_utf8.iconv(nil),
        'lastModified' => pg.modified.utc,
        #'author' => "",
        "version" => -1, # pg.version,
      }
    end

    def list_links_info_utf8(pagename)
      pagename = @@iconv_from_utf8.iconv(pagename)
      pagename << @@iconv_from_utf8.iconv(nil)
      pg = page(pagename)
      return nil if pg.empty?
      pg.hot_links.collect do |pg_name|
        {
          'page' => @@iconv_to_utf8.iconv(pg_name) << @@iconv_to_utf8.iconv(nil),
          'type' => 'local',
          #'href' => '',
        }
      end
    end

    def list_revlinks_utf8(pagename)
      pagename = @@iconv_from_utf8.iconv(pagename)
      pagename << @@iconv_from_utf8.iconv(nil)
      pg = page(pagename)
      return nil if pg.empty?
      pg.hot_revlinks.collect do |pg_name|
        @@iconv_to_utf8.iconv(pg_name) << @@iconv_to_utf8.iconv(nil)
      end
    end
  end

  class Front
    include WikiRPC
  end
end
