require 'rwiki/page'

module RWiki
  class Page
    def body_erb
      make_content(db[@name]).body_erb
    end

    def src(rev=nil)
      if rev.nil?
        db[@name]
      else
        db[@name, rev]
      end
    end

    alias org_update_src update_src

    def update_src(v)
      return org_update_src(v)
    ensure
      @src = nil
      @body_erb = nil
    end
  end
end

