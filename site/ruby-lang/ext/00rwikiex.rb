#$LOAD_PATH.push '/var/lib/ruby-man/rwikiex'
#$LOAD_PATH.uniq!

require 'rwiki/db/cvs'
RWiki::BookConfig.default.db = RWiki::DB::CVS.new(RWiki::DB_DIR)
