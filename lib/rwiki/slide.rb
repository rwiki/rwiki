require 'rwiki/rwiki'
require 'rwiki/slide-prop'
require 'rwiki/slide-view'

RWiki::Version.regist('slide', '2003-08-04')

config = RWiki::BookConfig.default
config.format = Slide::SlideFormat
config.add_prop_loader(:slide, Slide::SlideIndexLoader.new)

slide_navi = Object.new
def slide_navi.navi_view(title, pg, env = {}, &block)
  env = env.dup
  env[:slide_navi] ||= true
  begin
    orig_format = pg.format
    pg.format = Slide::SlideFormat
    pg.navi_view(title, pg, env, &block)
  ensure
    pg.format = orig_format
  end
end

RWiki::PageModuleLeft.unshift([nil, slide_navi, 'Slide'])
