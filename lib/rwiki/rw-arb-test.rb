require 'drb/drb'
require 'rwiki/rw-lib'

src = <<EOS

list = RWiki::Page.collect do |pg|
  "* " + pg.name
end

here.src = "=ARb\n" + list.join("\n")
here.links

EOS

DRb.start_service()
rwiki = DRbObject.new(nil, 'druby://localhost:8470')

p rwiki.eval_arb(src)
