require 'arb/block'

RWiki::Version.regist('rwiki/arb', '2001-5-29 boko')

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
