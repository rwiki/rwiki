require 'arb/block'

RWiki::Version.regist('rwiki/arb', '$Id$')

module RWiki
  class Front
    def eval_arb(src)
      block = ARb::ARbBlock.new(src)
      block.run
      block.value
    end
  end
end

ARb::ARbObject.new('here', RWiki::Page['arb-box'])
