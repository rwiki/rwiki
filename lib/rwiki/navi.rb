# -*- indent-tabs-mode: nil -*-

module RWiki

  class Navi

    def initialize(formatter, db)
      @formatter = formatter
      @db = db
    end

    def <=>(other)
      self.priority <=> other.priority
    end

    def navi_view(*args, &block)
      @formatter.navi_view(*args, &block)
    end
    
    def in_header?(border)
      priority >= border
    end

    def always_header?
      if @formatter.respond_to?(:always_header?)
        @formatter.always_header?
      end
    end
    
    def update!
      @db.update!(name)
    end

    def priority
      @db[name]
    end

    def name
      @formatter.name
    end

  end

end
