require 'rwiki/rd/ext/inline-verbatim'

RWiki::Version.register('rwiki/rd/ext/entity', '$Id$')

module RD
  module Ext
    class InlineVerbatim
      
      def ext_inline_verb_entity_reference(label, content, visitor)
        label = label.to_s
        return nil unless /^&([^;]+);(.*)$/ =~ label
        return nil unless Entity::TABLE.include?($1)

        key = $1
        rest = $2
        if rest.empty?
          Entity::TABLE[key]
        else
          rest = visitor.apply_to_Verb(RD::Verb.new(rest))
          Entity::TABLE[key] + rest
        end
      end

      def self.about_ext_inline_verb_entity_reference
        Entity::ABOUT
      end
    end

    module Entity
      TABLE = {
        # angle with down zig-zag arrow
        "angzarr" => "&#x0237C;",
        # circle, mid below
        "cirmid" => "&#x02AEF;",
        # left, curved, down arrow
        "cudarrl" => "&#x02938;",
        # right, curved, down arrow
        "cudarrr" => "&#x02935;",
        # /curvearrowleft A: left curved arrow
        "cularr" => "&#x021B6;",
        # curved left arrow with plus
        "cularrp" => "&#x0293D;",
        # /curvearrowright A: rt curved arrow
        "curarr" => "&#x021B7;",
        # curved right arrow with minus
        "curarrm" => "&#x0293C;",
        # down two-headed arrow
        "Darr" => "&#x021A1;",
        # /Downarrow A: down dbl arrow
        "dArr" => "&#x021D3;",
        # /downdownarrows A: two down arrows
        "ddarr" => "&#x021CA;",
        # right arrow with dotted stem
        "DDotrahd" => "&#x02911;",
        # down fish tail
        "dfisht" => "&#x0297F;",
        # down harpoon-left, down harpoon-right
        "dHar" => "&#x02965;",
        # /downharpoonleft A: dn harpoon-left
        "dharl" => "&#x021C3;",
        # /downharpoonright A: down harpoon-rt
        "dharr" => "&#x021C2;",
        # down arrow, up arrow
        "duarr" => "&#x021F5;",
        # down harp, up harp
        "duhar" => "&#x0296F;",
        # right long zig-zag arrow
        "dzigrarr" => "&#x027FF;",
        # equal, right arrow below
        "erarr" => "&#x02971;",
        # /Leftrightarrow A: l&r dbl arrow
        "hArr" => "&#x021D4;",
        # /leftrightarrow A: l&r arrow
        "harr" => "&#x02194;",
        # left and right arrow with a circle
        "harrcir" => "&#x02948;",
        # /leftrightsquigarrow A: l&r arr-wavy
        "harrw" => "&#x021AD;",
        # horizontal open arrow
        "hoarr" => "&#x021FF;",
        # image of
        "imof" => "&#x022B7;",
        # /Lleftarrow A: left triple arrow
        "lAarr" => "&#x021DA;",
        # /twoheadleftarrow A:
        "Larr" => "&#x0219E;",
        # left arrow-bar, filled square
        "larrbfs" => "&#x0291F;",
        # left arrow, filled square
        "larrfs" => "&#x0291D;",
        # /hookleftarrow A: left arrow-hooked
        "larrhk" => "&#x021A9;",
        # /looparrowleft A: left arrow-looped
        "larrlp" => "&#x021AB;",
        # left arrow, plus
        "larrpl" => "&#x02939;",
        # left arrow, similar
        "larrsim" => "&#x02973;",
        # /leftarrowtail A: left arrow-tailed
        "larrtl" => "&#x021A2;",
        # left double arrow-tail
        "lAtail" => "&#x0291B;",
        # left arrow-tail
        "latail" => "&#x02919;",
        # left doubly broken arrow
        "lBarr" => "&#x0290E;",
        # left broken arrow
        "lbarr" => "&#x0290C;",
        # left down curved arrow
        "ldca" => "&#x02936;",
        # left harpoon-down over right harpoon-down
        "ldrdhar" => "&#x02967;",
        # left-down-right-up harpoon
        "ldrushar" => "&#x0294B;",
        # left down angled arrow
        "ldsh" => "&#x021B2;",
        # left fish tail
        "lfisht" => "&#x0297C;",
        # left harpoon-up over left harpoon-down
        "lHar" => "&#x02962;",
        # /leftharpoondown A: l harpoon-down
        "lhard" => "&#x021BD;",
        # /leftharpoonup A: left harpoon-up
        "lharu" => "&#x021BC;",
        # left harpoon-up over long dash
        "lharul" => "&#x0296A;",
        # /leftleftarrows A: two left arrows
        "llarr" => "&#x021C7;",
        # left harpoon-down below long dash
        "llhard" => "&#x0296B;",
        # left open arrow
        "loarr" => "&#x021FD;",
        # /leftrightarrows A: l arr over r arr
        "lrarr" => "&#x021C6;",
        # /leftrightharpoons A: l harp over r
        "lrhar" => "&#x021CB;",
        # right harpoon-down below long dash
        "lrhard" => "&#x0296D;",
        # /Lsh A:
        "lsh" => "&#x021B0;",
        # left-up-right-down harpoon
        "lurdshar" => "&#x0294A;",
        # left harpoon-up over right harpoon-up
        "luruhar" => "&#x02966;",
        # twoheaded mapsto
        "Map" => "&#x02905;",
        # /mapsto A:
        "map" => "&#x021A6;",
        # mid, circle below
        "midcir" => "&#x02AF0;",
        # /multimap A:
        "mumap" => "&#x022B8;",
        # NE arrow-hooked
        "nearhk" => "&#x02924;",
        # NE pointing dbl arrow
        "neArr" => "&#x021D7;",
        # /nearrow A: NE pointing arrow
        "nearr" => "&#x02197;",
        # /toea A: NE & SE arrows
        "nesear" => "&#x02928;",
        # /nLeftrightarrow A: not l&r dbl arr
        "nhArr" => "&#x021CE;",
        # /nleftrightarrow A: not l&r arrow
        "nharr" => "&#x021AE;",
        # /nLeftarrow A: not implied by
        "nlArr" => "&#x021CD;",
        # /nleftarrow A: not left arrow
        "nlarr" => "&#x0219A;",
        # /nRightarrow A: not implies
        "nrArr" => "&#x021CF;",
        # /nrightarrow A: not right arrow
        "nrarr" => "&#x0219B;",
        # not right arrow-curved
        "nrarrc" => "&#x02933;&#x00338;",
        # not right arrow-wavy
        "nrarrw" => "&#x0219D;&#x00338;",
        # not, vert, left and right double arrow
        "nvHarr" => "&#x02904;",
        # not, vert, left double arrow
        "nvlArr" => "&#x02902;",
        # not, vert, right double arrow
        "nvrArr" => "&#x02903;",
        # NW arrow-hooked
        "nwarhk" => "&#x02923;",
        # NW pointing dbl arrow
        "nwArr" => "&#x021D6;",
        # /nwarrow A: NW pointing arrow
        "nwarr" => "&#x02196;",
        # NW & NE arrows
        "nwnear" => "&#x02927;",
        # /circlearrowleft A: l arr in circle
        "olarr" => "&#x021BA;",
        # /circlearrowright A: r arr in circle
        "orarr" => "&#x021BB;",
        # original of
        "origof" => "&#x022B6;",
        # /Rrightarrow A: right triple arrow
        "rAarr" => "&#x021DB;",
        # /twoheadrightarrow A:
        "Rarr" => "&#x021A0;",
        # approximate, right arrow above
        "rarrap" => "&#x02975;",
        # right arrow-bar, filled square
        "rarrbfs" => "&#x02920;",
        # right arrow-curved
        "rarrc" => "&#x02933;",
        # right arrow, filled square
        "rarrfs" => "&#x0291E;",
        # /hookrightarrow A: rt arrow-hooked
        "rarrhk" => "&#x021AA;",
        # /looparrowright A: rt arrow-looped
        "rarrlp" => "&#x021AC;",
        # right arrow, plus
        "rarrpl" => "&#x02945;",
        # right arrow, similar
        "rarrsim" => "&#x02974;",
        # right two-headed arrow with tail
        "Rarrtl" => "&#x02916;",
        # /rightarrowtail A: rt arrow-tailed
        "rarrtl" => "&#x021A3;",
        # /rightsquigarrow A: rt arrow-wavy
        "rarrw" => "&#x0219D;",
        # right double arrow-tail
        "rAtail" => "&#x0291C;",
        # right arrow-tail
        "ratail" => "&#x0291A;",
        # /drbkarow A: twoheaded right broken arrow
        "RBarr" => "&#x02910;",
        # /dbkarow A: right doubly broken arrow
        "rBarr" => "&#x0290F;",
        # /bkarow A: right broken arrow
        "rbarr" => "&#x0290D;",
        # right down curved arrow
        "rdca" => "&#x02937;",
        # right harpoon-down over left harpoon-down
        "rdldhar" => "&#x02969;",
        # right down angled arrow
        "rdsh" => "&#x021B3;",
        # right fish tail
        "rfisht" => "&#x0297D;",
        # right harpoon-up over right harpoon-down
        "rHar" => "&#x02964;",
        # /rightharpoondown A: rt harpoon-down
        "rhard" => "&#x021C1;",
        # /rightharpoonup A: rt harpoon-up
        "rharu" => "&#x021C0;",
        # right harpoon-up over long dash
        "rharul" => "&#x0296C;",
        # /rightleftarrows A: r arr over l arr
        "rlarr" => "&#x021C4;",
        # /rightleftharpoons A: r harp over l
        "rlhar" => "&#x021CC;",
        # right open arrow
        "roarr" => "&#x021FE;",
        # /rightrightarrows A: two rt arrows
        "rrarr" => "&#x021C9;",
        # /Rsh A:
        "rsh" => "&#x021B1;",
        # right harpoon-up over left harpoon-up
        "ruluhar" => "&#x02968;",
        # /hksearow A: SE arrow-hooken
        "searhk" => "&#x02925;",
        # SE pointing dbl arrow
        "seArr" => "&#x021D8;",
        # /searrow A: SE pointing arrow
        "searr" => "&#x02198;",
        # /tosa A: SE & SW arrows
        "seswar" => "&#x02929;",
        # similar, right arrow below
        "simrarr" => "&#x02972;",
        # short left arrow
        "slarr" => "&#x02190;",
        # short right arrow
        "srarr" => "&#x02192;",
        # /hkswarow A: SW arrow-hooked
        "swarhk" => "&#x02926;",
        # SW pointing dbl arrow
        "swArr" => "&#x021D9;",
        # /swarrow A: SW pointing arrow
        "swarr" => "&#x02199;",
        # SW & NW arrows
        "swnwar" => "&#x0292A;",
        # up two-headed arrow
        "Uarr" => "&#x0219F;",
        # /Uparrow A: up dbl arrow
        "uArr" => "&#x021D1;",
        # up two-headed arrow above circle
        "Uarrocir" => "&#x02949;",
        # up arrow, down arrow
        "udarr" => "&#x021C5;",
        # up harp, down harp
        "udhar" => "&#x0296E;",
        # up fish tail
        "ufisht" => "&#x0297E;",
        # up harpoon-left, up harpoon-right
        "uHar" => "&#x02963;",
        # /upharpoonleft A: up harpoon-left
        "uharl" => "&#x021BF;",
        # /upharpoonright /restriction A: up harp-r
        "uharr" => "&#x021BE;",
        # /upuparrows A: two up arrows
        "uuarr" => "&#x021C8;",
        # /Updownarrow A: up&down dbl arrow
        "vArr" => "&#x021D5;",
        # /updownarrow A: up&down arrow
        "varr" => "&#x02195;",
        # /Longleftrightarrow A: long l&r dbl arr
        "xhArr" => "&#x027FA;",
        # /longleftrightarrow A: long l&r arr
        "xharr" => "&#x027F7;",
        # /Longleftarrow A: long l dbl arrow
        "xlArr" => "&#x027F8;",
        # /longleftarrow A: long left arrow
        "xlarr" => "&#x027F5;",
        # /longmapsto A:
        "xmap" => "&#x027FC;",
        # /Longrightarrow A: long rt dbl arr
        "xrArr" => "&#x027F9;",
        # /longrightarrow A: long right arrow
        "xrarr" => "&#x027F6;",
        # right zig-zag arrow
        "zigrarr" => "&#x021DD;",
        # most positive
        "ac" => "&#x0223E;",
        # most positive, two lines below
        "acE" => "&#x0223E;&#x00333;",
        # /amalg B: amalgamation or coproduct
        "amalg" => "&#x02A3F;",
        # bar, vee
        "barvee" => "&#x022BD;",
        # /doublebarwedge B: log and, dbl bar above
        "Barwed" => "&#x02306;",
        # /barwedge B: logical and, bar above
        "barwed" => "&#x02305;",
        # reverse solidus in square
        "bsolb" => "&#x029C5;",
        # /Cap /doublecap B: dbl intersection
        "Cap" => "&#x022D2;",
        # intersection, and
        "capand" => "&#x02A44;",
        # intersection, bar, union
        "capbrcup" => "&#x02A49;",
        # intersection, intersection, joined
        "capcap" => "&#x02A4B;",
        # intersection above union
        "capcup" => "&#x02A47;",
        # intersection, with dot
        "capdot" => "&#x02A40;",
        # intersection, serifs
        "caps" => "&#x02229;&#x0FE00;",
        # closed intersection, serifs
        "ccaps" => "&#x02A4D;",
        # closed union, serifs
        "ccups" => "&#x02A4C;",
        # closed union, serifs, smash product
        "ccupssm" => "&#x02A50;",
        # /coprod L: coproduct operator
        "coprod" => "&#x02210;",
        # /Cup /doublecup B: dbl union
        "Cup" => "&#x022D3;",
        # union, bar, intersection
        "cupbrcap" => "&#x02A48;",
        # union above intersection
        "cupcap" => "&#x02A46;",
        # union, union, joined
        "cupcup" => "&#x02A4A;",
        # union, with dot
        "cupdot" => "&#x0228D;",
        # union, or
        "cupor" => "&#x02A45;",
        # union, serifs
        "cups" => "&#x0222A;&#x0FE00;",
        # /curlyvee B: curly logical or
        "cuvee" => "&#x022CE;",
        # /curlywedge B: curly logical and
        "cuwed" => "&#x022CF;",
        # /ddagger B: double dagger relation
        "Dagger" => "&#x02021;",
        # /dagger B: dagger relation
        "dagger" => "&#x02020;",
        # /diamond B: open diamond
        "diam" => "&#x022C4;",
        # /divideontimes B: division on times
        "divonx" => "&#x022C7;",
        # equal, plus
        "eplus" => "&#x02A71;",
        # hermitian conjugate matrix
        "hercon" => "&#x022B9;",
        # /intercal B: intercal
        "intcal" => "&#x022BA;",
        # /intprod
        "iprod" => "&#x02A3C;",
        # plus sign in left half circle
        "loplus" => "&#x02A2D;",
        # multiply sign in left half circle
        "lotimes" => "&#x02A34;",
        # /leftthreetimes B:
        "lthree" => "&#x022CB;",
        # /ltimes B: times sign, left closed
        "ltimes" => "&#x022C9;",
        # /ast B: asterisk
        "midast" => "&#x0002A;",
        # /boxminus B: minus sign in box
        "minusb" => "&#x0229F;",
        # /dotminus B: minus sign, dot above
        "minusd" => "&#x02238;",
        # minus sign, dot below
        "minusdu" => "&#x02A2A;",
        # bar, intersection
        "ncap" => "&#x02A43;",
        # bar, union
        "ncup" => "&#x02A42;",
        # /circledast B: asterisk in circle
        "oast" => "&#x0229B;",
        # /circledcirc B: small circle in circle
        "ocir" => "&#x0229A;",
        # /circleddash B: hyphen in circle
        "odash" => "&#x0229D;",
        # divide in circle
        "odiv" => "&#x02A38;",
        # /odot B: middle dot in circle
        "odot" => "&#x02299;",
        # dot, solidus, dot in circle
        "odsold" => "&#x029BC;",
        # filled circle in circle
        "ofcir" => "&#x029BF;",
        # greater-than in circle
        "ogt" => "&#x029C1;",
        # circle with horizontal bar
        "ohbar" => "&#x029B5;",
        # large circle in circle
        "olcir" => "&#x029BE;",
        # less-than in circle
        "olt" => "&#x029C0;",
        # vertical bar in circle
        "omid" => "&#x029B6;",
        # /ominus B: minus sign in circle
        "ominus" => "&#x02296;",
        # parallel in circle
        "opar" => "&#x029B7;",
        # perpendicular in circle
        "operp" => "&#x029B9;",
        # /oplus B: plus sign in circle
        "oplus" => "&#x02295;",
        # /oslash B: solidus in circle
        "osol" => "&#x02298;",
        # multiply sign in double circle
        "Otimes" => "&#x02A37;",
        # /otimes B: multiply sign in circle
        "otimes" => "&#x02297;",
        # multiply sign in circle, circumflex accent
        "otimesas" => "&#x02A36;",
        # circle with vertical bar
        "ovbar" => "&#x0233D;",
        # plus, circumflex accent above
        "plusacir" => "&#x02A23;",
        # /boxplus B: plus sign in box
        "plusb" => "&#x0229E;",
        # plus, small circle above
        "pluscir" => "&#x02A22;",
        # /dotplus B: plus sign, dot above
        "plusdo" => "&#x02214;",
        # plus sign, dot below
        "plusdu" => "&#x02A25;",
        # plus, equals
        "pluse" => "&#x02A72;",
        # plus, similar below
        "plussim" => "&#x02A26;",
        # plus, two; Nim-addition
        "plustwo" => "&#x02A27;",
        # /prod L: product operator
        "prod" => "&#x0220F;",
        # reverse most positive, line below
        "race" => "&#x029DA;",
        # plus sign in right half circle
        "roplus" => "&#x02A2E;",
        # multiply sign in right half circle
        "rotimes" => "&#x02A35;",
        # /rightthreetimes B:
        "rthree" => "&#x022CC;",
        # /rtimes B: times sign, right closed
        "rtimes" => "&#x022CA;",
        # /cdot B: small middle dot
        "sdot" => "&#x022C5;",
        # /dotsquare /boxdot B: small dot in box
        "sdotb" => "&#x022A1;",
        # /setminus B: reverse solidus
        "setmn" => "&#x02216;",
        # plus, similar above
        "simplus" => "&#x02A24;",
        # smash product
        "smashp" => "&#x02A33;",
        # solidus in square
        "solb" => "&#x029C4;",
        # /sqcap B: square intersection
        "sqcap" => "&#x02293;",
        # square intersection, serifs
        "sqcaps" => "&#x02293;&#x0FE00;",
        # /sqcup B: square union
        "sqcup" => "&#x02294;",
        # square union, serifs
        "sqcups" => "&#x02294;&#x0FE00;",
        # /smallsetminus B: sm reverse solidus
        "ssetmn" => "&#x02216;",
        # /star B: small star, filled
        "sstarf" => "&#x022C6;",
        # subset, with dot
        "subdot" => "&#x02ABD;",
        # /sum L: summation operator
        "sum" => "&#x02211;",
        # superset, with dot
        "supdot" => "&#x02ABE;",
        # /boxtimes B: multiply sign in box
        "timesb" => "&#x022A0;",
        # multiply sign, bar below
        "timesbar" => "&#x02A31;",
        # times, dot
        "timesd" => "&#x02A30;",
        # dot in triangle
        "tridot" => "&#x025EC;",
        # minus in triangle
        "triminus" => "&#x02A3A;",
        # plus in triangle
        "triplus" => "&#x02A39;",
        # triangle, serifs at bottom
        "trisb" => "&#x029CD;",
        # multiply in triangle
        "tritime" => "&#x02A3B;",
        # /uplus B: plus sign in union
        "uplus" => "&#x0228E;",
        # /veebar B: logical or, bar below
        "veebar" => "&#x022BB;",
        # wedge, bar below
        "wedbar" => "&#x02A5F;",
        # /wr B: wreath product
        "wreath" => "&#x02240;",
        # /bigcap L: intersection operator
        "xcap" => "&#x022C2;",
        # /bigcirc B: large circle
        "xcirc" => "&#x025EF;",
        # /bigcup L: union operator
        "xcup" => "&#x022C3;",
        # /bigtriangledown B: big dn tri, open
        "xdtri" => "&#x025BD;",
        # /bigodot L: circle dot operator
        "xodot" => "&#x02A00;",
        # /bigoplus L: circle plus operator
        "xoplus" => "&#x02A01;",
        # /bigotimes L: circle times operator
        "xotime" => "&#x02A02;",
        # /bigsqcup L: square union operator
        "xsqcup" => "&#x02A06;",
        # /biguplus L:
        "xuplus" => "&#x02A04;",
        # /bigtriangleup B: big up tri, open
        "xutri" => "&#x025B3;",
        # /bigvee L: logical and operator
        "xvee" => "&#x022C1;",
        # /bigwedge L: logical or operator
        "xwedge" => "&#x022C0;",
        # /llcorner O: lower left corner
        "dlcorn" => "&#x0231E;",
        # /lrcorner C: lower right corner
        "drcorn" => "&#x0231F;",
        # dbl left parenthesis, greater
        "gtlPar" => "&#x02995;",
        # left angle, dot
        "langd" => "&#x02991;",
        # left bracket, equal
        "lbrke" => "&#x0298B;",
        # left bracket, solidus bottom corner
        "lbrksld" => "&#x0298F;",
        # left bracket, solidus top corner
        "lbrkslu" => "&#x0298D;",
        # /lceil O: left ceiling
        "lceil" => "&#x02308;",
        # /lfloor O: left floor
        "lfloor" => "&#x0230A;",
        # /lmoustache
        "lmoust" => "&#x023B0;",
        # O: left parenthesis, lt
        "lparlt" => "&#x02993;",
        # dbl right parenthesis, less
        "ltrPar" => "&#x02996;",
        # right angle, dot
        "rangd" => "&#x02992;",
        # right bracket, equal
        "rbrke" => "&#x0298C;",
        # right bracket, solidus bottom corner
        "rbrksld" => "&#x0298E;",
        # right bracket, solidus top corner
        "rbrkslu" => "&#x02990;",
        # /rceil C: right ceiling
        "rceil" => "&#x02309;",
        # /rfloor C: right floor
        "rfloor" => "&#x0230B;",
        # /rmoustache
        "rmoust" => "&#x023B1;",
        # C: right paren, gt
        "rpargt" => "&#x02994;",
        # /ulcorner O: upper left corner
        "ulcorn" => "&#x0231C;",
        # /urcorner C: upper right corner
        "urcorn" => "&#x0231D;",
        # /gnapprox N: greater, not approximate
        "gnap" => "&#x02A8A;",
        # /gneqq N: greater, not dbl equals
        "gnE" => "&#x02269;",
        # /gneq N: greater, not equals
        "gne" => "&#x02A88;",
        # /gnsim N: greater, not similar
        "gnsim" => "&#x022E7;",
        # /gvertneqq N: gt, vert, not dbl eq
        "gvnE" => "&#x02269;&#x0FE00;",
        # /lnapprox N: less, not approximate
        "lnap" => "&#x02A89;",
        # /lneqq N: less, not double equals
        "lnE" => "&#x02268;",
        # /lneq N: less, not equals
        "lne" => "&#x02A87;",
        # /lnsim N: less, not similar
        "lnsim" => "&#x022E6;",
        # /lvertneqq N: less, vert, not dbl eq
        "lvnE" => "&#x02268;&#x0FE00;",
        # /napprox N: not approximate
        "nap" => "&#x02249;",
        # not approximately equal or equal to
        "napE" => "&#x02A70;&#x00338;",
        # not approximately identical to
        "napid" => "&#x0224B;&#x00338;",
        # /ncong N: not congruent with
        "ncong" => "&#x02247;",
        # not congruent, dot
        "ncongdot" => "&#x02A6D;&#x00338;",
        # /nequiv N: not identical with
        "nequiv" => "&#x02262;",
        # /ngeqq N: not greater, dbl equals
        "ngE" => "&#x02267;&#x00338;",
        # /ngeq N: not greater-than-or-equal
        "nge" => "&#x02271;",
        # /ngeqslant N: not gt-or-eq, slanted
        "nges" => "&#x02A7E;&#x00338;",
        # not triple greater than
        "nGg" => "&#x022D9;&#x00338;",
        # not greater, similar
        "ngsim" => "&#x02275;",
        # not, vert, much greater than
        "nGt" => "&#x0226B;&#x020D2;",
        # /ngtr N: not greater-than
        "ngt" => "&#x0226F;",
        # not much greater than, variant
        "nGtv" => "&#x0226B;&#x00338;",
        # /nleqq N: not less, dbl equals
        "nlE" => "&#x02266;&#x00338;",
        # /nleq N: not less-than-or-equal
        "nle" => "&#x02270;",
        # /nleqslant N: not less-or-eq, slant
        "nles" => "&#x02A7D;&#x00338;",
        # not triple less than
        "nLl" => "&#x022D8;&#x00338;",
        # not less, similar
        "nlsim" => "&#x02274;",
        # not, vert, much less than
        "nLt" => "&#x0226A;&#x020D2;",
        # /nless N: not less-than
        "nlt" => "&#x0226E;",
        # /ntriangleleft N: not left triangle
        "nltri" => "&#x022EA;",
        # /ntrianglelefteq N: not l tri, eq
        "nltrie" => "&#x022EC;",
        # not much less than, variant
        "nLtv" => "&#x0226A;&#x00338;",
        # /nmid
        "nmid" => "&#x02224;",
        # /nparallel N: not parallel
        "npar" => "&#x02226;",
        # /nprec N: not precedes
        "npr" => "&#x02280;",
        # not curly precedes, eq
        "nprcue" => "&#x022E0;",
        # /npreceq N: not precedes, equals
        "npre" => "&#x02AAF;&#x00338;",
        # /ntriangleright N: not rt triangle
        "nrtri" => "&#x022EB;",
        # /ntrianglerighteq N: not r tri, eq
        "nrtrie" => "&#x022ED;",
        # /nsucc N: not succeeds
        "nsc" => "&#x02281;",
        # not succeeds, curly eq
        "nsccue" => "&#x022E1;",
        # /nsucceq N: not succeeds, equals
        "nsce" => "&#x02AB0;&#x00338;",
        # /nsim N: not similar
        "nsim" => "&#x02241;",
        # /nsimeq N: not similar, equals
        "nsime" => "&#x02244;",
        # /nshortmid
        "nsmid" => "&#x02224;",
        # /nshortparallel N: not short par
        "nspar" => "&#x02226;",
        # not, square subset, equals
        "nsqsube" => "&#x022E2;",
        # not, square superset, equals
        "nsqsupe" => "&#x022E3;",
        # not subset
        "nsub" => "&#x02284;",
        # /nsubseteqq N: not subset, dbl eq
        "nsubE" => "&#x02AC5;&#x00338;",
        # /nsubseteq N: not subset, equals
        "nsube" => "&#x02288;",
        # not superset
        "nsup" => "&#x02285;",
        # /nsupseteqq N: not superset, dbl eq
        "nsupE" => "&#x02AC6;&#x00338;",
        # /nsupseteq N: not superset, equals
        "nsupe" => "&#x02289;",
        # not greater, less
        "ntgl" => "&#x02279;",
        # not less, greater
        "ntlg" => "&#x02278;",
        # not, vert, approximate
        "nvap" => "&#x0224D;&#x020D2;",
        # /nVDash N: not dbl vert, dbl dash
        "nVDash" => "&#x022AF;",
        # /nVdash N: not dbl vertical, dash
        "nVdash" => "&#x022AE;",
        # /nvDash N: not vertical, dbl dash
        "nvDash" => "&#x022AD;",
        # /nvdash N: not vertical, dash
        "nvdash" => "&#x022AC;",
        # not, vert, greater-than-or-equal
        "nvge" => "&#x02265;&#x020D2;",
        # not, vert, greater-than
        "nvgt" => "&#x0003E;&#x020D2;",
        # not, vert, less-than-or-equal
        "nvle" => "&#x02264;&#x020D2;",
        # not, vert, less-than
        "nvlt" => "&#x0003C;&#x020D2;",
        # not, vert, left triangle, equals
        "nvltrie" => "&#x022B4;&#x020D2;",
        # not, vert, right triangle, equals
        "nvrtrie" => "&#x022B5;&#x020D2;",
        # not, vert, similar
        "nvsim" => "&#x0223C;&#x020D2;",
        # parallel, similar
        "parsim" => "&#x02AF3;",
        # /precnapprox N: precedes, not approx
        "prnap" => "&#x02AB9;",
        # /precneqq N: precedes, not dbl eq
        "prnE" => "&#x02AB5;",
        # /precnsim N: precedes, not similar
        "prnsim" => "&#x022E8;",
        # reverse /nmid
        "rnmid" => "&#x02AEE;",
        # /succnapprox N: succeeds, not approx
        "scnap" => "&#x02ABA;",
        # /succneqq N: succeeds, not dbl eq
        "scnE" => "&#x02AB6;",
        # /succnsim N: succeeds, not similar
        "scnsim" => "&#x022E9;",
        # similar, not equals
        "simne" => "&#x02246;",
        # solidus, bar through
        "solbar" => "&#x0233F;",
        # /subsetneqq N: subset, not dbl eq
        "subnE" => "&#x02ACB;",
        # /subsetneq N: subset, not equals
        "subne" => "&#x0228A;",
        # /supsetneqq N: superset, not dbl eq
        "supnE" => "&#x02ACC;",
        # /supsetneq N: superset, not equals
        "supne" => "&#x0228B;",
        # /nsubset N: not subset, var
        "vnsub" => "&#x02282;&#x020D2;",
        # /nsupset N: not superset, var
        "vnsup" => "&#x02283;&#x020D2;",
        # /varsubsetneqq N: subset not dbl eq, var
        "vsubnE" => "&#x02ACB;&#x0FE00;",
        # /varsubsetneq N: subset, not eq, var
        "vsubne" => "&#x0228A;&#x0FE00;",
        # /varsupsetneqq N: super not dbl eq, var
        "vsupnE" => "&#x02ACC;&#x0FE00;",
        # /varsupsetneq N: superset, not eq, var
        "vsupne" => "&#x0228B;&#x0FE00;",
        # /angle - angle
        "ang" => "&#x02220;",
        # angle, equal
        "ange" => "&#x029A4;",
        # /measuredangle - angle-measured
        "angmsd" => "&#x02221;",
        # angle-measured, arrow, up, right
        "angmsdaa" => "&#x029A8;",
        # angle-measured, arrow, up, left
        "angmsdab" => "&#x029A9;",
        # angle-measured, arrow, down, right
        "angmsdac" => "&#x029AA;",
        # angle-measured, arrow, down, left
        "angmsdad" => "&#x029AB;",
        # angle-measured, arrow, right, up
        "angmsdae" => "&#x029AC;",
        # angle-measured, arrow, left, up
        "angmsdaf" => "&#x029AD;",
        # angle-measured, arrow, right, down
        "angmsdag" => "&#x029AE;",
        # angle-measured, arrow, left, down
        "angmsdah" => "&#x029AF;",
        # right angle-measured
        "angrtvb" => "&#x022BE;",
        # right angle-measured, dot
        "angrtvbd" => "&#x0299D;",
        # bottom square bracket
        "bbrk" => "&#x023B5;",
        # bottom above top square bracket
        "bbrktbrk" => "&#x023B6;",
        # reversed circle, slash
        "bemptyv" => "&#x029B0;",
        # /beth - beth, Hebrew
        "beth" => "&#x02136;",
        # two joined squares
        "boxbox" => "&#x029C9;",
        # /backprime - reverse prime
        "bprime" => "&#x02035;",
        # reverse semi-colon
        "bsemi" => "&#x0204F;",
        # circle, slash, small circle above
        "cemptyv" => "&#x029B2;",
        # circle, two horizontal stroked to the right
        "cirE" => "&#x029C3;",
        # circle, small circle to the right
        "cirscir" => "&#x029C2;",
        # /complement - complement sign
        "comp" => "&#x02201;",
        # /daleth - daleth, Hebrew
        "daleth" => "&#x02138;",
        # circle, slash, bar above
        "demptyv" => "&#x029B1;",
        # /ell - cursive small l
        "ell" => "&#x02113;",
        # /emptyset - zero, slash
        "empty" => "&#x02205;",
        # /varnothing - circle, slash
        "emptyv" => "&#x02205;",
        # /gimel - gimel, Hebrew
        "gimel" => "&#x02137;",
        # inverted iota
        "iiota" => "&#x02129;",
        # /Im - imaginary
        "image" => "&#x02111;",
        # /imath - small i, no dot
        "imath" => "&#x00131;",
        # /jmath - small j, no dot
        "jmath" => "&#x0006A;",
        # circle, slash, left arrow above
        "laemptyv" => "&#x029B4;",
        # lower left triangle
        "lltri" => "&#x025FA;",
        # lower right triangle
        "lrtri" => "&#x022BF;",
        # /mho - conductance
        "mho" => "&#x02127;",
        # not, vert, angle
        "nang" => "&#x02220;&#x020D2;",
        # /nexists - negated exists
        "nexist" => "&#x02204;",
        # /circledS - capital S in circle
        "oS" => "&#x024C8;",
        # /hbar - Planck's over 2pi
        "planck" => "&#x0210F;",
        # /hslash - variant Planck's over 2pi
        "plankv" => "&#x0210F;",
        # circle, slash, right arrow above
        "raemptyv" => "&#x029B3;",
        # reverse angle, equal
        "range" => "&#x029A5;",
        # /Re - real
        "real" => "&#x0211C;",
        # top square bracket
        "tbrk" => "&#x023B4;",
        # trapezium
        "trpezium" => "&#x0FFFD;",
        # upper left triangle
        "ultri" => "&#x025F8;",
        # upper right triangle
        "urtri" => "&#x025F9;",
        # vertical zig-zag line
        "vzigzag" => "&#x0299A;",
        # /wp - Weierstrass p
        "weierp" => "&#x02118;",
        # approximately equal or equal to
        "apE" => "&#x02A70;",
        # /approxeq R: approximate, equals
        "ape" => "&#x0224A;",
        # approximately identical to
        "apid" => "&#x0224B;",
        # /asymp R: asymptotically equal to
        "asymp" => "&#x02248;",
        # vert, dbl bar (over)
        "Barv" => "&#x02AE7;",
        # /backcong R: reverse congruent
        "bcong" => "&#x0224C;",
        # /backepsilon R: such that
        "bepsi" => "&#x003F6;",
        # /bowtie R:
        "bowtie" => "&#x022C8;",
        # /backsim R: reverse similar
        "bsim" => "&#x0223D;",
        # /backsimeq R: reverse similar, eq
        "bsime" => "&#x022CD;",
        # reverse solidus, subset
        "bsolhsub" => "&#x0005C;&#x02282;",
        # /Bumpeq R: bumpy equals
        "bump" => "&#x0224E;",
        # bump, equals
        "bumpE" => "&#x02AAE;",
        # /bumpeq R: bumpy equals, equals
        "bumpe" => "&#x0224F;",
        # /circeq R: circle, equals
        "cire" => "&#x02257;",
        # /Colon, two colons
        "Colon" => "&#x02237;",
        # double colon, equals
        "Colone" => "&#x02A74;",
        # /coloneq R: colon, equals
        "colone" => "&#x02254;",
        # congruent, dot
        "congdot" => "&#x02A6D;",
        # subset, closed
        "csub" => "&#x02ACF;",
        # subset, closed, equals
        "csube" => "&#x02AD1;",
        # superset, closed
        "csup" => "&#x02AD0;",
        # superset, closed, equals
        "csupe" => "&#x02AD2;",
        # /curlyeqprec R: curly eq, precedes
        "cuepr" => "&#x022DE;",
        # /curlyeqsucc R: curly eq, succeeds
        "cuesc" => "&#x022DF;",
        # dbl dash, vertical
        "Dashv" => "&#x02AE4;",
        # /dashv R: dash, vertical
        "dashv" => "&#x022A3;",
        # equal, asterisk above
        "easter" => "&#x02A6E;",
        # /eqcirc R: circle on equals sign
        "ecir" => "&#x02256;",
        # /eqcolon R: equals, colon
        "ecolon" => "&#x02255;",
        # /ddotseq R: equal with four dots
        "eDDot" => "&#x02A77;",
        # /doteqdot /Doteq R: eq, even dots
        "eDot" => "&#x02251;",
        # /fallingdotseq R: eq, falling dots
        "efDot" => "&#x02252;",
        # equal-or-greater
        "eg" => "&#x02A9A;",
        # /eqslantgtr R: equal-or-gtr, slanted
        "egs" => "&#x02A96;",
        # equal-or-greater, slanted, dot inside
        "egsdot" => "&#x02A98;",
        # equal-or-less
        "el" => "&#x02A99;",
        # /eqslantless R: eq-or-less, slanted
        "els" => "&#x02A95;",
        # equal-or-less, slanted, dot inside
        "elsdot" => "&#x02A97;",
        # /questeq R: equal with questionmark
        "equest" => "&#x0225F;",
        # equivalent, four dots above
        "equivDD" => "&#x02A78;",
        # /risingdotseq R: eq, rising dots
        "erDot" => "&#x02253;",
        # /doteq R: equals, single dot above
        "esdot" => "&#x02250;",
        # equal, similar
        "Esim" => "&#x02A73;",
        # /esim R: equals, similar
        "esim" => "&#x02242;",
        # /pitchfork R: pitchfork
        "fork" => "&#x022D4;",
        # fork, variant
        "forkv" => "&#x02AD9;",
        # /frown R: down curve
        "frown" => "&#x02322;",
        # /gtrapprox R: greater, approximate
        "gap" => "&#x02A86;",
        # /geqq R: greater, double equals
        "gE" => "&#x02267;",
        # /gtreqqless R: gt, dbl equals, less
        "gEl" => "&#x02A8C;",
        # /gtreqless R: greater, equals, less
        "gel" => "&#x022DB;",
        # /geqslant R: gt-or-equal, slanted
        "ges" => "&#x02A7E;",
        # greater than, closed by curve, equal, slanted
        "gescc" => "&#x02AA9;",
        # greater-than-or-equal, slanted, dot inside
        "gesdot" => "&#x02A80;",
        # greater-than-or-equal, slanted, dot above
        "gesdoto" => "&#x02A82;",
        # greater-than-or-equal, slanted, dot above left
        "gesdotol" => "&#x02A84;",
        # greater, equal, slanted, less
        "gesl" => "&#x022DB;&#x0FE00;",
        # greater, equal, slanted, less, equal, slanted
        "gesles" => "&#x02A94;",
        # /ggg /Gg /gggtr R: triple gtr-than
        "Gg" => "&#x022D9;",
        # /gtrless R: greater, less
        "gl" => "&#x02277;",
        # greater, less, apart
        "gla" => "&#x02AA5;",
        # greater, less, equal
        "glE" => "&#x02A92;",
        # greater, less, overlapping
        "glj" => "&#x02AA4;",
        # /gtrsim R: greater, similar
        "gsim" => "&#x02273;",
        # greater, similar, equal
        "gsime" => "&#x02A8E;",
        # greater, similar, less
        "gsiml" => "&#x02A90;",
        # /gg R: dbl greater-than sign
        "Gt" => "&#x0226B;",
        # greater than, closed by curve
        "gtcc" => "&#x02AA7;",
        # greater than, circle inside
        "gtcir" => "&#x02A7A;",
        # /gtrdot R: greater than, with dot
        "gtdot" => "&#x022D7;",
        # greater than, questionmark above
        "gtquest" => "&#x02A7C;",
        # greater than, right arrow
        "gtrarr" => "&#x02978;",
        # homothetic
        "homtht" => "&#x0223B;",
        # /lessapprox R: less, approximate
        "lap" => "&#x02A85;",
        # larger than
        "lat" => "&#x02AAB;",
        # larger than or equal
        "late" => "&#x02AAD;",
        # larger than or equal, slanted
        "lates" => "&#x02AAD;&#x0FE00;",
        # /leqq R: less, double equals
        "lE" => "&#x02266;",
        # /lesseqqgtr R: less, dbl eq, greater
        "lEg" => "&#x02A8B;",
        # /lesseqgtr R: less, eq, greater
        "leg" => "&#x022DA;",
        # /leqslant R: less-than-or-eq, slant
        "les" => "&#x02A7D;",
        # less than, closed by curve, equal, slanted
        "lescc" => "&#x02AA8;",
        # less-than-or-equal, slanted, dot inside
        "lesdot" => "&#x02A7F;",
        # less-than-or-equal, slanted, dot above
        "lesdoto" => "&#x02A81;",
        # less-than-or-equal, slanted, dot above right
        "lesdotor" => "&#x02A83;",
        # less, equal, slanted, greater
        "lesg" => "&#x022DA;&#x0FE00;",
        # less, equal, slanted, greater, equal, slanted
        "lesges" => "&#x02A93;",
        # /lessgtr R: less, greater
        "lg" => "&#x02276;",
        # less, greater, equal
        "lgE" => "&#x02A91;",
        # /Ll /lll /llless R: triple less-than
        "Ll" => "&#x022D8;",
        # /lesssim R: less, similar
        "lsim" => "&#x02272;",
        # less, similar, equal
        "lsime" => "&#x02A8D;",
        # less, similar, greater
        "lsimg" => "&#x02A8F;",
        # /ll R: double less-than sign
        "Lt" => "&#x0226A;",
        # less than, closed by curve
        "ltcc" => "&#x02AA6;",
        # less than, circle inside
        "ltcir" => "&#x02A79;",
        # /lessdot R: less than, with dot
        "ltdot" => "&#x022D6;",
        # less than, left arrow
        "ltlarr" => "&#x02976;",
        # less than, questionmark above
        "ltquest" => "&#x02A7B;",
        # /trianglelefteq R: left triangle, eq
        "ltrie" => "&#x022B4;",
        # minus, comma above
        "mcomma" => "&#x02A29;",
        # minus with four dots, geometric properties
        "mDDot" => "&#x0223A;",
        # /mid R:
        "mid" => "&#x02223;",
        # /mlcp
        "mlcp" => "&#x02ADB;",
        # /models R:
        "models" => "&#x022A7;",
        # most positive
        "mstpos" => "&#x0223E;",
        # dbl precedes
        "Pr" => "&#x02ABB;",
        # /prec R: precedes
        "pr" => "&#x0227A;",
        # /precapprox R: precedes, approximate
        "prap" => "&#x02AB7;",
        # /preccurlyeq R: precedes, curly eq
        "prcue" => "&#x0227C;",
        # precedes, dbl equals
        "prE" => "&#x02AB3;",
        # /preceq R: precedes, equals
        "pre" => "&#x02AAF;",
        # /precsim R: precedes, similar
        "prsim" => "&#x0227E;",
        # element precedes under relation
        "prurel" => "&#x022B0;",
        # /ratio
        "ratio" => "&#x02236;",
        # /trianglerighteq R: right tri, eq
        "rtrie" => "&#x022B5;",
        # right triangle above left triangle
        "rtriltri" => "&#x029CE;",
        # dbl succeeds
        "Sc" => "&#x02ABC;",
        # /succ R: succeeds
        "sc" => "&#x0227B;",
        # /succapprox R: succeeds, approximate
        "scap" => "&#x02AB8;",
        # /succcurlyeq R: succeeds, curly eq
        "sccue" => "&#x0227D;",
        # succeeds, dbl equals
        "scE" => "&#x02AB4;",
        # /succeq R: succeeds, equals
        "sce" => "&#x02AB0;",
        # /succsim R: succeeds, similar
        "scsim" => "&#x0227F;",
        # equal, dot below
        "sdote" => "&#x02A66;",
        # /smallfrown R: small down curve
        "sfrown" => "&#x02322;",
        # similar, greater
        "simg" => "&#x02A9E;",
        # similar, greater, equal
        "simgE" => "&#x02AA0;",
        # similar, less
        "siml" => "&#x02A9D;",
        # similar, less, equal
        "simlE" => "&#x02A9F;",
        # /shortmid R:
        "smid" => "&#x02223;",
        # /smile R: up curve
        "smile" => "&#x02323;",
        # smaller than
        "smt" => "&#x02AAA;",
        # smaller than or equal
        "smte" => "&#x02AAC;",
        # smaller than or equal, slanted
        "smtes" => "&#x02AAC;&#x0FE00;",
        # /shortparallel R: short parallel
        "spar" => "&#x02225;",
        # /sqsubset R: square subset
        "sqsub" => "&#x0228F;",
        # /sqsubseteq R: square subset, equals
        "sqsube" => "&#x02291;",
        # /sqsupset R: square superset
        "sqsup" => "&#x02290;",
        # /sqsupseteq R: square superset, eq
        "sqsupe" => "&#x02292;",
        # /smallsmile R: small up curve
        "ssmile" => "&#x02323;",
        # /Subset R: double subset
        "Sub" => "&#x022D0;",
        # /subseteqq R: subset, dbl equals
        "subE" => "&#x02AC5;",
        # subset, equals, dot
        "subedot" => "&#x02AC3;",
        # subset, multiply
        "submult" => "&#x02AC1;",
        # subset, plus
        "subplus" => "&#x02ABF;",
        # subset, right arrow
        "subrarr" => "&#x02979;",
        # subset, similar
        "subsim" => "&#x02AC7;",
        # subset above subset
        "subsub" => "&#x02AD5;",
        # subset above superset
        "subsup" => "&#x02AD3;",
        # /Supset R: dbl superset
        "Sup" => "&#x022D1;",
        # superset, subset, dash joining them
        "supdsub" => "&#x02AD8;",
        # /supseteqq R: superset, dbl equals
        "supE" => "&#x02AC6;",
        # superset, equals, dot
        "supedot" => "&#x02AC4;",
        # superset, solidus
        "suphsol" => "&#x02283;&#x0002F;",
        # superset, subset
        "suphsub" => "&#x02AD7;",
        # superset, left arrow
        "suplarr" => "&#x0297B;",
        # superset, multiply
        "supmult" => "&#x02AC2;",
        # superset, plus
        "supplus" => "&#x02AC0;",
        # superset, similar
        "supsim" => "&#x02AC8;",
        # superset above subset
        "supsub" => "&#x02AD4;",
        # superset above superset
        "supsup" => "&#x02AD6;",
        # /thickapprox R: thick approximate
        "thkap" => "&#x02248;",
        # /thicksim R: thick similar
        "thksim" => "&#x0223C;",
        # fork with top
        "topfork" => "&#x02ADA;",
        # /triangleq R: triangle, equals
        "trie" => "&#x0225C;",
        # /between R: between
        "twixt" => "&#x0226C;",
        # dbl vert, bar (under)
        "Vbar" => "&#x02AEB;",
        # vert, dbl bar (under)
        "vBar" => "&#x02AE8;",
        # dbl bar, vert over and under
        "vBarv" => "&#x02AE9;",
        # dbl vert, dbl dash
        "VDash" => "&#x022AB;",
        # /Vdash R: dbl vertical, dash
        "Vdash" => "&#x022A9;",
        # /vDash R: vertical, dbl dash
        "vDash" => "&#x022A8;",
        # /vdash R: vertical, dash
        "vdash" => "&#x022A2;",
        # vertical, dash (long)
        "Vdashl" => "&#x02AE6;",
        # /vartriangleleft R: l tri, open, var
        "vltri" => "&#x022B2;",
        # /varpropto R: proportional, variant
        "vprop" => "&#x0221D;",
        # /vartriangleright R: r tri, open, var
        "vrtri" => "&#x022B3;",
        # /Vvdash R: triple vertical, dash
        "Vvdash" => "&#x022AA;",
        # lower left quadrant
        "boxDL" => "&#x02557;",
        # lower left quadrant
        "boxDl" => "&#x02556;",
        # lower left quadrant
        "boxdL" => "&#x02555;",
        # lower left quadrant
        "boxdl" => "&#x02510;",
        # lower right quadrant
        "boxDR" => "&#x02554;",
        # lower right quadrant
        "boxDr" => "&#x02553;",
        # lower right quadrant
        "boxdR" => "&#x02552;",
        # lower right quadrant
        "boxdr" => "&#x0250C;",
        # horizontal line
        "boxH" => "&#x02550;",
        # horizontal line
        "boxh" => "&#x02500;",
        # lower left and right quadrants
        "boxHD" => "&#x02566;",
        # lower left and right quadrants
        "boxHd" => "&#x02564;",
        # lower left and right quadrants
        "boxhD" => "&#x02565;",
        # lower left and right quadrants
        "boxhd" => "&#x0252C;",
        # upper left and right quadrants
        "boxHU" => "&#x02569;",
        # upper left and right quadrants
        "boxHu" => "&#x02567;",
        # upper left and right quadrants
        "boxhU" => "&#x02568;",
        # upper left and right quadrants
        "boxhu" => "&#x02534;",
        # upper left quadrant
        "boxUL" => "&#x0255D;",
        # upper left quadrant
        "boxUl" => "&#x0255C;",
        # upper left quadrant
        "boxuL" => "&#x0255B;",
        # upper left quadrant
        "boxul" => "&#x02518;",
        # upper right quadrant
        "boxUR" => "&#x0255A;",
        # upper right quadrant
        "boxUr" => "&#x02559;",
        # upper right quadrant
        "boxuR" => "&#x02558;",
        # upper right quadrant
        "boxur" => "&#x02514;",
        # vertical line
        "boxV" => "&#x02551;",
        # vertical line
        "boxv" => "&#x02502;",
        # all four quadrants
        "boxVH" => "&#x0256C;",
        # all four quadrants
        "boxVh" => "&#x0256B;",
        # all four quadrants
        "boxvH" => "&#x0256A;",
        # all four quadrants
        "boxvh" => "&#x0253C;",
        # upper and lower left quadrants
        "boxVL" => "&#x02563;",
        # upper and lower left quadrants
        "boxVl" => "&#x02562;",
        # upper and lower left quadrants
        "boxvL" => "&#x02561;",
        # upper and lower left quadrants
        "boxvl" => "&#x02524;",
        # upper and lower right quadrants
        "boxVR" => "&#x02560;",
        # upper and lower right quadrants
        "boxVr" => "&#x0255F;",
        # upper and lower right quadrants
        "boxvR" => "&#x0255E;",
        # upper and lower right quadrants
        "boxvr" => "&#x0251C;",
        # =capital A, Cyrillic
        "Acy" => "&#x00410;",
        # =small a, Cyrillic
        "acy" => "&#x00430;",
        # =capital BE, Cyrillic
        "Bcy" => "&#x00411;",
        # =small be, Cyrillic
        "bcy" => "&#x00431;",
        # =capital CHE, Cyrillic
        "CHcy" => "&#x00427;",
        # =small che, Cyrillic
        "chcy" => "&#x00447;",
        # =capital DE, Cyrillic
        "Dcy" => "&#x00414;",
        # =small de, Cyrillic
        "dcy" => "&#x00434;",
        # =capital E, Cyrillic
        "Ecy" => "&#x0042D;",
        # =small e, Cyrillic
        "ecy" => "&#x0044D;",
        # =capital EF, Cyrillic
        "Fcy" => "&#x00424;",
        # =small ef, Cyrillic
        "fcy" => "&#x00444;",
        # =capital GHE, Cyrillic
        "Gcy" => "&#x00413;",
        # =small ghe, Cyrillic
        "gcy" => "&#x00433;",
        # =capital HARD sign, Cyrillic
        "HARDcy" => "&#x0042A;",
        # =small hard sign, Cyrillic
        "hardcy" => "&#x0044A;",
        # =capital I, Cyrillic
        "Icy" => "&#x00418;",
        # =small i, Cyrillic
        "icy" => "&#x00438;",
        # =capital IE, Cyrillic
        "IEcy" => "&#x00415;",
        # =small ie, Cyrillic
        "iecy" => "&#x00435;",
        # =capital IO, Russian
        "IOcy" => "&#x00401;",
        # =small io, Russian
        "iocy" => "&#x00451;",
        # =capital short I, Cyrillic
        "Jcy" => "&#x00419;",
        # =small short i, Cyrillic
        "jcy" => "&#x00439;",
        # =capital KA, Cyrillic
        "Kcy" => "&#x0041A;",
        # =small ka, Cyrillic
        "kcy" => "&#x0043A;",
        # =capital HA, Cyrillic
        "KHcy" => "&#x00425;",
        # =small ha, Cyrillic
        "khcy" => "&#x00445;",
        # =capital EL, Cyrillic
        "Lcy" => "&#x0041B;",
        # =small el, Cyrillic
        "lcy" => "&#x0043B;",
        # =capital EM, Cyrillic
        "Mcy" => "&#x0041C;",
        # =small em, Cyrillic
        "mcy" => "&#x0043C;",
        # =capital EN, Cyrillic
        "Ncy" => "&#x0041D;",
        # =small en, Cyrillic
        "ncy" => "&#x0043D;",
        # =numero sign
        "numero" => "&#x02116;",
        # =capital O, Cyrillic
        "Ocy" => "&#x0041E;",
        # =small o, Cyrillic
        "ocy" => "&#x0043E;",
        # =capital PE, Cyrillic
        "Pcy" => "&#x0041F;",
        # =small pe, Cyrillic
        "pcy" => "&#x0043F;",
        # =capital ER, Cyrillic
        "Rcy" => "&#x00420;",
        # =small er, Cyrillic
        "rcy" => "&#x00440;",
        # =capital ES, Cyrillic
        "Scy" => "&#x00421;",
        # =small es, Cyrillic
        "scy" => "&#x00441;",
        # =capital SHCHA, Cyrillic
        "SHCHcy" => "&#x00429;",
        # =small shcha, Cyrillic
        "shchcy" => "&#x00449;",
        # =capital SHA, Cyrillic
        "SHcy" => "&#x00428;",
        # =small sha, Cyrillic
        "shcy" => "&#x00448;",
        # =capital SOFT sign, Cyrillic
        "SOFTcy" => "&#x0042C;",
        # =small soft sign, Cyrillic
        "softcy" => "&#x0044C;",
        # =capital TE, Cyrillic
        "Tcy" => "&#x00422;",
        # =small te, Cyrillic
        "tcy" => "&#x00442;",
        # =capital TSE, Cyrillic
        "TScy" => "&#x00426;",
        # =small tse, Cyrillic
        "tscy" => "&#x00446;",
        # =capital U, Cyrillic
        "Ucy" => "&#x00423;",
        # =small u, Cyrillic
        "ucy" => "&#x00443;",
        # =capital VE, Cyrillic
        "Vcy" => "&#x00412;",
        # =small ve, Cyrillic
        "vcy" => "&#x00432;",
        # =capital YA, Cyrillic
        "YAcy" => "&#x0042F;",
        # =small ya, Cyrillic
        "yacy" => "&#x0044F;",
        # =capital YERU, Cyrillic
        "Ycy" => "&#x0042B;",
        # =small yeru, Cyrillic
        "ycy" => "&#x0044B;",
        # =capital YU, Cyrillic
        "YUcy" => "&#x0042E;",
        # =small yu, Cyrillic
        "yucy" => "&#x0044E;",
        # =capital ZE, Cyrillic
        "Zcy" => "&#x00417;",
        # =small ze, Cyrillic
        "zcy" => "&#x00437;",
        # =capital ZHE, Cyrillic
        "ZHcy" => "&#x00416;",
        # =small zhe, Cyrillic
        "zhcy" => "&#x00436;",
        # =capital DJE, Serbian
        "DJcy" => "&#x00402;",
        # =small dje, Serbian
        "djcy" => "&#x00452;",
        # =capital DSE, Macedonian
        "DScy" => "&#x00405;",
        # =small dse, Macedonian
        "dscy" => "&#x00455;",
        # =capital dze, Serbian
        "DZcy" => "&#x0040F;",
        # =small dze, Serbian
        "dzcy" => "&#x0045F;",
        # =capital GJE Macedonian
        "GJcy" => "&#x00403;",
        # =small gje, Macedonian
        "gjcy" => "&#x00453;",
        # =capital I, Ukrainian
        "Iukcy" => "&#x00406;",
        # =small i, Ukrainian
        "iukcy" => "&#x00456;",
        # =capital JE, Serbian
        "Jsercy" => "&#x00408;",
        # =small je, Serbian
        "jsercy" => "&#x00458;",
        # =capital JE, Ukrainian
        "Jukcy" => "&#x00404;",
        # =small je, Ukrainian
        "jukcy" => "&#x00454;",
        # =capital KJE, Macedonian
        "KJcy" => "&#x0040C;",
        # =small kje Macedonian
        "kjcy" => "&#x0045C;",
        # =capital LJE, Serbian
        "LJcy" => "&#x00409;",
        # =small lje, Serbian
        "ljcy" => "&#x00459;",
        # =capital NJE, Serbian
        "NJcy" => "&#x0040A;",
        # =small nje, Serbian
        "njcy" => "&#x0045A;",
        # =capital TSHE, Serbian
        "TSHcy" => "&#x0040B;",
        # =small tshe, Serbian
        "tshcy" => "&#x0045B;",
        # =capital U, Byelorussian
        "Ubrcy" => "&#x0040E;",
        # =small u, Byelorussian
        "ubrcy" => "&#x0045E;",
        # =capital YI, Ukrainian
        "YIcy" => "&#x00407;",
        # =small yi, Ukrainian
        "yicy" => "&#x00457;",
        # =acute accent
        "acute" => "&#x000B4;",
        # =breve
        "breve" => "&#x002D8;",
        # =caron
        "caron" => "&#x002C7;",
        # =cedilla
        "cedil" => "&#x000B8;",
        # circumflex accent
        "circ" => "&#x002C6;",
        # =double acute accent
        "dblac" => "&#x002DD;",
        # =dieresis
        "die" => "&#x000A8;",
        # =dot above
        "dot" => "&#x002D9;",
        # =grave accent
        "grave" => "&#x00060;",
        # =macron
        "macr" => "&#x000AF;",
        # =ogonek
        "ogon" => "&#x002DB;",
        # =ring
        "ring" => "&#x002DA;",
        # =tilde
        "tilde" => "&#x002DC;",
        # =umlaut mark
        "uml" => "&#x000A8;",
        # /alpha small alpha, Greek
        "alpha" => "&#x003B1;",
        # /beta small beta, Greek
        "beta" => "&#x003B2;",
        # /chi small chi, Greek
        "chi" => "&#x003C7;",
        # /Delta capital Delta, Greek
        "Delta" => "&#x00394;",
        # /delta small delta, Greek
        "delta" => "&#x003B4;",
        # /straightepsilon, small epsilon, Greek
        "epsi" => "&#x003F5;",
        # /varepsilon
        "epsiv" => "&#x003B5;",
        # /eta small eta, Greek
        "eta" => "&#x003B7;",
        # /Gamma capital Gamma, Greek
        "Gamma" => "&#x00393;",
        # /gamma small gamma, Greek
        "gamma" => "&#x003B3;",
        # capital digamma
        "Gammad" => "&#x003DC;",
        # /digamma
        "gammad" => "&#x003DD;",
        # /iota small iota, Greek
        "iota" => "&#x003B9;",
        # /kappa small kappa, Greek
        "kappa" => "&#x003BA;",
        # /varkappa
        "kappav" => "&#x003F0;",
        # /Lambda capital Lambda, Greek
        "Lambda" => "&#x0039B;",
        # /lambda small lambda, Greek
        "lambda" => "&#x003BB;",
        # /mu small mu, Greek
        "mu" => "&#x003BC;",
        # /nu small nu, Greek
        "nu" => "&#x003BD;",
        # /Omega capital Omega, Greek
        "Omega" => "&#x003A9;",
        # /omega small omega, Greek
        "omega" => "&#x003C9;",
        # /Phi capital Phi, Greek
        "Phi" => "&#x003A6;",
        # /straightphi - small phi, Greek
        "phi" => "&#x003D5;",
        # /varphi - curly or open phi
        "phiv" => "&#x003C6;",
        # /Pi capital Pi, Greek
        "Pi" => "&#x003A0;",
        # /pi small pi, Greek
        "pi" => "&#x003C0;",
        # /varpi
        "piv" => "&#x003D6;",
        # /Psi capital Psi, Greek
        "Psi" => "&#x003A8;",
        # /psi small psi, Greek
        "psi" => "&#x003C8;",
        # /rho small rho, Greek
        "rho" => "&#x003C1;",
        # /varrho
        "rhov" => "&#x003F1;",
        # /Sigma capital Sigma, Greek
        "Sigma" => "&#x003A3;",
        # /sigma small sigma, Greek
        "sigma" => "&#x003C3;",
        # /varsigma
        "sigmav" => "&#x003C2;",
        # /tau small tau, Greek
        "tau" => "&#x003C4;",
        # /Theta capital Theta, Greek
        "Theta" => "&#x00398;",
        # /theta straight theta, small theta, Greek
        "theta" => "&#x003B8;",
        # /vartheta - curly or open theta
        "thetav" => "&#x003D1;",
        # /Upsilon capital Upsilon, Greek
        "Upsi" => "&#x003D2;",
        # /upsilon small upsilon, Greek
        "upsi" => "&#x003C5;",
        # /Xi capital Xi, Greek
        "Xi" => "&#x0039E;",
        # /xi small xi, Greek
        "xi" => "&#x003BE;",
        # /zeta small zeta, Greek
        "zeta" => "&#x003B6;",
        # =capital A, acute accent
        "Aacute" => "&#x000C1;",
        # =small a, acute accent
        "aacute" => "&#x000E1;",
        # =capital A, circumflex accent
        "Acirc" => "&#x000C2;",
        # =small a, circumflex accent
        "acirc" => "&#x000E2;",
        # =capital AE diphthong (ligature)
        "AElig" => "&#x000C6;",
        # =small ae diphthong (ligature)
        "aelig" => "&#x000E6;",
        # =capital A, grave accent
        "Agrave" => "&#x000C0;",
        # =small a, grave accent
        "agrave" => "&#x000E0;",
        # =capital A, ring
        "Aring" => "&#x000C5;",
        # =small a, ring
        "aring" => "&#x000E5;",
        # =capital A, tilde
        "Atilde" => "&#x000C3;",
        # =small a, tilde
        "atilde" => "&#x000E3;",
        # =capital A, dieresis or umlaut mark
        "Auml" => "&#x000C4;",
        # =small a, dieresis or umlaut mark
        "auml" => "&#x000E4;",
        # =capital C, cedilla
        "Ccedil" => "&#x000C7;",
        # =small c, cedilla
        "ccedil" => "&#x000E7;",
        # =capital E, acute accent
        "Eacute" => "&#x000C9;",
        # =small e, acute accent
        "eacute" => "&#x000E9;",
        # =capital E, circumflex accent
        "Ecirc" => "&#x000CA;",
        # =small e, circumflex accent
        "ecirc" => "&#x000EA;",
        # =capital E, grave accent
        "Egrave" => "&#x000C8;",
        # =small e, grave accent
        "egrave" => "&#x000E8;",
        # =capital Eth, Icelandic
        "ETH" => "&#x000D0;",
        # =small eth, Icelandic
        "eth" => "&#x000F0;",
        # =capital E, dieresis or umlaut mark
        "Euml" => "&#x000CB;",
        # =small e, dieresis or umlaut mark
        "euml" => "&#x000EB;",
        # =capital I, acute accent
        "Iacute" => "&#x000CD;",
        # =small i, acute accent
        "iacute" => "&#x000ED;",
        # =capital I, circumflex accent
        "Icirc" => "&#x000CE;",
        # =small i, circumflex accent
        "icirc" => "&#x000EE;",
        # =capital I, grave accent
        "Igrave" => "&#x000CC;",
        # =small i, grave accent
        "igrave" => "&#x000EC;",
        # =capital I, dieresis or umlaut mark
        "Iuml" => "&#x000CF;",
        # =small i, dieresis or umlaut mark
        "iuml" => "&#x000EF;",
        # =capital N, tilde
        "Ntilde" => "&#x000D1;",
        # =small n, tilde
        "ntilde" => "&#x000F1;",
        # =capital O, acute accent
        "Oacute" => "&#x000D3;",
        # =small o, acute accent
        "oacute" => "&#x000F3;",
        # =capital O, circumflex accent
        "Ocirc" => "&#x000D4;",
        # =small o, circumflex accent
        "ocirc" => "&#x000F4;",
        # =capital O, grave accent
        "Ograve" => "&#x000D2;",
        # =small o, grave accent
        "ograve" => "&#x000F2;",
        # =capital O, slash
        "Oslash" => "&#x000D8;",
        # latin small letter o with stroke
        "oslash" => "&#x000F8;",
        # =capital O, tilde
        "Otilde" => "&#x000D5;",
        # =small o, tilde
        "otilde" => "&#x000F5;",
        # =capital O, dieresis or umlaut mark
        "Ouml" => "&#x000D6;",
        # =small o, dieresis or umlaut mark
        "ouml" => "&#x000F6;",
        # =small sharp s, German (sz ligature)
        "szlig" => "&#x000DF;",
        # =capital THORN, Icelandic
        "THORN" => "&#x000DE;",
        # =small thorn, Icelandic
        "thorn" => "&#x000FE;",
        # =capital U, acute accent
        "Uacute" => "&#x000DA;",
        # =small u, acute accent
        "uacute" => "&#x000FA;",
        # =capital U, circumflex accent
        "Ucirc" => "&#x000DB;",
        # =small u, circumflex accent
        "ucirc" => "&#x000FB;",
        # =capital U, grave accent
        "Ugrave" => "&#x000D9;",
        # =small u, grave accent
        "ugrave" => "&#x000F9;",
        # =capital U, dieresis or umlaut mark
        "Uuml" => "&#x000DC;",
        # =small u, dieresis or umlaut mark
        "uuml" => "&#x000FC;",
        # =capital Y, acute accent
        "Yacute" => "&#x000DD;",
        # =small y, acute accent
        "yacute" => "&#x000FD;",
        # =small y, dieresis or umlaut mark
        "yuml" => "&#x000FF;",
        # =capital A, breve
        "Abreve" => "&#x00102;",
        # =small a, breve
        "abreve" => "&#x00103;",
        # =capital A, macron
        "Amacr" => "&#x00100;",
        # =small a, macron
        "amacr" => "&#x00101;",
        # =capital A, ogonek
        "Aogon" => "&#x00104;",
        # =small a, ogonek
        "aogon" => "&#x00105;",
        # =capital C, acute accent
        "Cacute" => "&#x00106;",
        # =small c, acute accent
        "cacute" => "&#x00107;",
        # =capital C, caron
        "Ccaron" => "&#x0010C;",
        # =small c, caron
        "ccaron" => "&#x0010D;",
        # =capital C, circumflex accent
        "Ccirc" => "&#x00108;",
        # =small c, circumflex accent
        "ccirc" => "&#x00109;",
        # =capital C, dot above
        "Cdot" => "&#x0010A;",
        # =small c, dot above
        "cdot" => "&#x0010B;",
        # =capital D, caron
        "Dcaron" => "&#x0010E;",
        # =small d, caron
        "dcaron" => "&#x0010F;",
        # =capital D, stroke
        "Dstrok" => "&#x00110;",
        # =small d, stroke
        "dstrok" => "&#x00111;",
        # =capital E, caron
        "Ecaron" => "&#x0011A;",
        # =small e, caron
        "ecaron" => "&#x0011B;",
        # =capital E, dot above
        "Edot" => "&#x00116;",
        # =small e, dot above
        "edot" => "&#x00117;",
        # =capital E, macron
        "Emacr" => "&#x00112;",
        # =small e, macron
        "emacr" => "&#x00113;",
        # =capital ENG, Lapp
        "ENG" => "&#x0014A;",
        # =small eng, Lapp
        "eng" => "&#x0014B;",
        # =capital E, ogonek
        "Eogon" => "&#x00118;",
        # =small e, ogonek
        "eogon" => "&#x00119;",
        # =small g, acute accent
        "gacute" => "&#x001F5;",
        # =capital G, breve
        "Gbreve" => "&#x0011E;",
        # =small g, breve
        "gbreve" => "&#x0011F;",
        # =capital G, cedilla
        "Gcedil" => "&#x00122;",
        # =capital G, circumflex accent
        "Gcirc" => "&#x0011C;",
        # =small g, circumflex accent
        "gcirc" => "&#x0011D;",
        # =capital G, dot above
        "Gdot" => "&#x00120;",
        # =small g, dot above
        "gdot" => "&#x00121;",
        # =capital H, circumflex accent
        "Hcirc" => "&#x00124;",
        # =small h, circumflex accent
        "hcirc" => "&#x00125;",
        # =capital H, stroke
        "Hstrok" => "&#x00126;",
        # =small h, stroke
        "hstrok" => "&#x00127;",
        # =capital I, dot above
        "Idot" => "&#x00130;",
        # =capital IJ ligature
        "IJlig" => "&#x00132;",
        # =small ij ligature
        "ijlig" => "&#x00133;",
        # =capital I, macron
        "Imacr" => "&#x0012A;",
        # =small i, macron
        "imacr" => "&#x0012B;",
        # =small i without dot
        "inodot" => "&#x00131;",
        # =capital I, ogonek
        "Iogon" => "&#x0012E;",
        # =small i, ogonek
        "iogon" => "&#x0012F;",
        # =capital I, tilde
        "Itilde" => "&#x00128;",
        # =small i, tilde
        "itilde" => "&#x00129;",
        # =capital J, circumflex accent
        "Jcirc" => "&#x00134;",
        # =small j, circumflex accent
        "jcirc" => "&#x00135;",
        # =capital K, cedilla
        "Kcedil" => "&#x00136;",
        # =small k, cedilla
        "kcedil" => "&#x00137;",
        # =small k, Greenlandic
        "kgreen" => "&#x00138;",
        # =capital L, acute accent
        "Lacute" => "&#x00139;",
        # =small l, acute accent
        "lacute" => "&#x0013A;",
        # =capital L, caron
        "Lcaron" => "&#x0013D;",
        # =small l, caron
        "lcaron" => "&#x0013E;",
        # =capital L, cedilla
        "Lcedil" => "&#x0013B;",
        # =small l, cedilla
        "lcedil" => "&#x0013C;",
        # =capital L, middle dot
        "Lmidot" => "&#x0013F;",
        # =small l, middle dot
        "lmidot" => "&#x00140;",
        # =capital L, stroke
        "Lstrok" => "&#x00141;",
        # =small l, stroke
        "lstrok" => "&#x00142;",
        # =capital N, acute accent
        "Nacute" => "&#x00143;",
        # =small n, acute accent
        "nacute" => "&#x00144;",
        # =small n, apostrophe
        "napos" => "&#x00149;",
        # =capital N, caron
        "Ncaron" => "&#x00147;",
        # =small n, caron
        "ncaron" => "&#x00148;",
        # =capital N, cedilla
        "Ncedil" => "&#x00145;",
        # =small n, cedilla
        "ncedil" => "&#x00146;",
        # =capital O, double acute accent
        "Odblac" => "&#x00150;",
        # =small o, double acute accent
        "odblac" => "&#x00151;",
        # =capital OE ligature
        "OElig" => "&#x00152;",
        # =small oe ligature
        "oelig" => "&#x00153;",
        # =capital O, macron
        "Omacr" => "&#x0014C;",
        # =small o, macron
        "omacr" => "&#x0014D;",
        # =capital R, acute accent
        "Racute" => "&#x00154;",
        # =small r, acute accent
        "racute" => "&#x00155;",
        # =capital R, caron
        "Rcaron" => "&#x00158;",
        # =small r, caron
        "rcaron" => "&#x00159;",
        # =capital R, cedilla
        "Rcedil" => "&#x00156;",
        # =small r, cedilla
        "rcedil" => "&#x00157;",
        # =capital S, acute accent
        "Sacute" => "&#x0015A;",
        # =small s, acute accent
        "sacute" => "&#x0015B;",
        # =capital S, caron
        "Scaron" => "&#x00160;",
        # =small s, caron
        "scaron" => "&#x00161;",
        # =capital S, cedilla
        "Scedil" => "&#x0015E;",
        # =small s, cedilla
        "scedil" => "&#x0015F;",
        # =capital S, circumflex accent
        "Scirc" => "&#x0015C;",
        # =small s, circumflex accent
        "scirc" => "&#x0015D;",
        # =capital T, caron
        "Tcaron" => "&#x00164;",
        # =small t, caron
        "tcaron" => "&#x00165;",
        # =capital T, cedilla
        "Tcedil" => "&#x00162;",
        # =small t, cedilla
        "tcedil" => "&#x00163;",
        # =capital T, stroke
        "Tstrok" => "&#x00166;",
        # =small t, stroke
        "tstrok" => "&#x00167;",
        # =capital U, breve
        "Ubreve" => "&#x0016C;",
        # =small u, breve
        "ubreve" => "&#x0016D;",
        # =capital U, double acute accent
        "Udblac" => "&#x00170;",
        # =small u, double acute accent
        "udblac" => "&#x00171;",
        # =capital U, macron
        "Umacr" => "&#x0016A;",
        # =small u, macron
        "umacr" => "&#x0016B;",
        # =capital U, ogonek
        "Uogon" => "&#x00172;",
        # =small u, ogonek
        "uogon" => "&#x00173;",
        # =capital U, ring
        "Uring" => "&#x0016E;",
        # =small u, ring
        "uring" => "&#x0016F;",
        # =capital U, tilde
        "Utilde" => "&#x00168;",
        # =small u, tilde
        "utilde" => "&#x00169;",
        # =capital W, circumflex accent
        "Wcirc" => "&#x00174;",
        # =small w, circumflex accent
        "wcirc" => "&#x00175;",
        # =capital Y, circumflex accent
        "Ycirc" => "&#x00176;",
        # =small y, circumflex accent
        "ycirc" => "&#x00177;",
        # =capital Y, dieresis or umlaut mark
        "Yuml" => "&#x00178;",
        # =capital Z, acute accent
        "Zacute" => "&#x00179;",
        # =small z, acute accent
        "zacute" => "&#x0017A;",
        # =capital Z, caron
        "Zcaron" => "&#x0017D;",
        # =small z, caron
        "zcaron" => "&#x0017E;",
        # =capital Z, dot above
        "Zdot" => "&#x0017B;",
        # =small z, dot above
        "zdot" => "&#x0017C;",
        # /frak A, upper case a
        "Afr" => "&#x1D504;",
        # /frak a, lower case a
        "afr" => "&#x1D51E;",
        # /frak B, upper case b
        "Bfr" => "&#x1D505;",
        # /frak b, lower case b
        "bfr" => "&#x1D51F;",
        # /frak C, upper case c
        "Cfr" => "&#x0212D;",
        # /frak c, lower case c
        "cfr" => "&#x1D520;",
        # /frak D, upper case d
        "Dfr" => "&#x1D507;",
        # /frak d, lower case d
        "dfr" => "&#x1D521;",
        # /frak E, upper case e
        "Efr" => "&#x1D508;",
        # /frak e, lower case e
        "efr" => "&#x1D522;",
        # /frak F, upper case f
        "Ffr" => "&#x1D509;",
        # /frak f, lower case f
        "ffr" => "&#x1D523;",
        # /frak G, upper case g
        "Gfr" => "&#x1D50A;",
        # /frak g, lower case g
        "gfr" => "&#x1D524;",
        # /frak H, upper case h
        "Hfr" => "&#x0210C;",
        # /frak h, lower case h
        "hfr" => "&#x1D525;",
        # /frak I, upper case i
        "Ifr" => "&#x02111;",
        # /frak i, lower case i
        "ifr" => "&#x1D526;",
        # /frak J, upper case j
        "Jfr" => "&#x1D50D;",
        # /frak j, lower case j
        "jfr" => "&#x1D527;",
        # /frak K, upper case k
        "Kfr" => "&#x1D50E;",
        # /frak k, lower case k
        "kfr" => "&#x1D528;",
        # /frak L, upper case l
        "Lfr" => "&#x1D50F;",
        # /frak l, lower case l
        "lfr" => "&#x1D529;",
        # /frak M, upper case m
        "Mfr" => "&#x1D510;",
        # /frak m, lower case m
        "mfr" => "&#x1D52A;",
        # /frak N, upper case n
        "Nfr" => "&#x1D511;",
        # /frak n, lower case n
        "nfr" => "&#x1D52B;",
        # /frak O, upper case o
        "Ofr" => "&#x1D512;",
        # /frak o, lower case o
        "ofr" => "&#x1D52C;",
        # /frak P, upper case p
        "Pfr" => "&#x1D513;",
        # /frak p, lower case p
        "pfr" => "&#x1D52D;",
        # /frak Q, upper case q
        "Qfr" => "&#x1D514;",
        # /frak q, lower case q
        "qfr" => "&#x1D52E;",
        # /frak R, upper case r
        "Rfr" => "&#x0211C;",
        # /frak r, lower case r
        "rfr" => "&#x1D52F;",
        # /frak S, upper case s
        "Sfr" => "&#x1D516;",
        # /frak s, lower case s
        "sfr" => "&#x1D530;",
        # /frak T, upper case t
        "Tfr" => "&#x1D517;",
        # /frak t, lower case t
        "tfr" => "&#x1D531;",
        # /frak U, upper case u
        "Ufr" => "&#x1D518;",
        # /frak u, lower case u
        "ufr" => "&#x1D532;",
        # /frak V, upper case v
        "Vfr" => "&#x1D519;",
        # /frak v, lower case v
        "vfr" => "&#x1D533;",
        # /frak W, upper case w
        "Wfr" => "&#x1D51A;",
        # /frak w, lower case w
        "wfr" => "&#x1D534;",
        # /frak X, upper case x
        "Xfr" => "&#x1D51B;",
        # /frak x, lower case x
        "xfr" => "&#x1D535;",
        # /frak Y, upper case y
        "Yfr" => "&#x1D51C;",
        # /frak y, lower case y
        "yfr" => "&#x1D536;",
        # /frak Z, upper case z
        "Zfr" => "&#x02128;",
        # /frak z, lower case z
        "zfr" => "&#x1D537;",
        # /Bbb A, open face A
        "Aopf" => "&#x1D538;",
        # /Bbb B, open face B
        "Bopf" => "&#x1D539;",
        # /Bbb C, open face C
        "Copf" => "&#x02102;",
        # /Bbb D, open face D
        "Dopf" => "&#x1D53B;",
        # /Bbb E, open face E
        "Eopf" => "&#x1D53C;",
        # /Bbb F, open face F
        "Fopf" => "&#x1D53D;",
        # /Bbb G, open face G
        "Gopf" => "&#x1D53E;",
        # /Bbb H, open face H
        "Hopf" => "&#x0210D;",
        # /Bbb I, open face I
        "Iopf" => "&#x1D540;",
        # /Bbb J, open face J
        "Jopf" => "&#x1D541;",
        # /Bbb K, open face K
        "Kopf" => "&#x1D542;",
        # /Bbb L, open face L
        "Lopf" => "&#x1D543;",
        # /Bbb M, open face M
        "Mopf" => "&#x1D544;",
        # /Bbb N, open face N
        "Nopf" => "&#x02115;",
        # /Bbb O, open face O
        "Oopf" => "&#x1D546;",
        # /Bbb P, open face P
        "Popf" => "&#x02119;",
        # /Bbb Q, open face Q
        "Qopf" => "&#x0211A;",
        # /Bbb R, open face R
        "Ropf" => "&#x0211D;",
        # /Bbb S, open face S
        "Sopf" => "&#x1D54A;",
        # /Bbb T, open face T
        "Topf" => "&#x1D54B;",
        # /Bbb U, open face U
        "Uopf" => "&#x1D54C;",
        # /Bbb V, open face V
        "Vopf" => "&#x1D54D;",
        # /Bbb W, open face W
        "Wopf" => "&#x1D54E;",
        # /Bbb X, open face X
        "Xopf" => "&#x1D54F;",
        # /Bbb Y, open face Y
        "Yopf" => "&#x1D550;",
        # /Bbb Z, open face Z
        "Zopf" => "&#x02124;",
        # /scr A, script letter A
        "Ascr" => "&#x1D49C;",
        # /scr a, script letter a
        "ascr" => "&#x1D4B6;",
        # /scr B, script letter B
        "Bscr" => "&#x0212C;",
        # /scr b, script letter b
        "bscr" => "&#x1D4B7;",
        # /scr C, script letter C
        "Cscr" => "&#x1D49E;",
        # /scr c, script letter c
        "cscr" => "&#x1D4B8;",
        # /scr D, script letter D
        "Dscr" => "&#x1D49F;",
        # /scr d, script letter d
        "dscr" => "&#x1D4B9;",
        # /scr E, script letter E
        "Escr" => "&#x02130;",
        # /scr e, script letter e
        "escr" => "&#x0212F;",
        # /scr F, script letter F
        "Fscr" => "&#x02131;",
        # /scr f, script letter f
        "fscr" => "&#x1D4BB;",
        # /scr G, script letter G
        "Gscr" => "&#x1D4A2;",
        # /scr g, script letter g
        "gscr" => "&#x0210A;",
        # /scr H, script letter H
        "Hscr" => "&#x0210B;",
        # /scr h, script letter h
        "hscr" => "&#x1D4BD;",
        # /scr I, script letter I
        "Iscr" => "&#x02110;",
        # /scr i, script letter i
        "iscr" => "&#x1D4BE;",
        # /scr J, script letter J
        "Jscr" => "&#x1D4A5;",
        # /scr j, script letter j
        "jscr" => "&#x1D4BF;",
        # /scr K, script letter K
        "Kscr" => "&#x1D4A6;",
        # /scr k, script letter k
        "kscr" => "&#x1D4C0;",
        # /scr L, script letter L
        "Lscr" => "&#x02112;",
        # /scr l, script letter l
        "lscr" => "&#x1D4C1;",
        # /scr M, script letter M
        "Mscr" => "&#x02133;",
        # /scr m, script letter m
        "mscr" => "&#x1D4C2;",
        # /scr N, script letter N
        "Nscr" => "&#x1D4A9;",
        # /scr n, script letter n
        "nscr" => "&#x1D4C3;",
        # /scr O, script letter O
        "Oscr" => "&#x1D4AA;",
        # /scr o, script letter o
        "oscr" => "&#x02134;",
        # /scr P, script letter P
        "Pscr" => "&#x1D4AB;",
        # /scr p, script letter p
        "pscr" => "&#x1D4C5;",
        # /scr Q, script letter Q
        "Qscr" => "&#x1D4AC;",
        # /scr q, script letter q
        "qscr" => "&#x1D4C6;",
        # /scr R, script letter R
        "Rscr" => "&#x0211B;",
        # /scr r, script letter r
        "rscr" => "&#x1D4C7;",
        # /scr S, script letter S
        "Sscr" => "&#x1D4AE;",
        # /scr s, script letter s
        "sscr" => "&#x1D4C8;",
        # /scr T, script letter T
        "Tscr" => "&#x1D4AF;",
        # /scr t, script letter t
        "tscr" => "&#x1D4C9;",
        # /scr U, script letter U
        "Uscr" => "&#x1D4B0;",
        # /scr u, script letter u
        "uscr" => "&#x1D4CA;",
        # /scr V, script letter V
        "Vscr" => "&#x1D4B1;",
        # /scr v, script letter v
        "vscr" => "&#x1D4CB;",
        # /scr W, script letter W
        "Wscr" => "&#x1D4B2;",
        # /scr w, script letter w
        "wscr" => "&#x1D4CC;",
        # /scr X, script letter X
        "Xscr" => "&#x1D4B3;",
        # /scr x, script letter x
        "xscr" => "&#x1D4CD;",
        # /scr Y, script letter Y
        "Yscr" => "&#x1D4B4;",
        # /scr y, script letter y
        "yscr" => "&#x1D4CE;",
        # /scr Z, script letter Z
        "Zscr" => "&#x1D4B5;",
        # /scr z, script letter z
        "zscr" => "&#x1D4CF;",
        # =ampersand
        "amp" => "&#38;",
        # =apostrophe
        "apos" => "&#x00027;",
        # /ast B: =asterisk
        "ast" => "&#x0002A;",
        # =broken (vertical) bar
        "brvbar" => "&#x000A6;",
        # /backslash =reverse solidus
        "bsol" => "&#x0005C;",
        # =cent sign
        "cent" => "&#x000A2;",
        # /colon P:
        "colon" => "&#x0003A;",
        # P: =comma
        "comma" => "&#x0002C;",
        # =commercial at
        "commat" => "&#x00040;",
        # =copyright sign
        "copy" => "&#x000A9;",
        # =general currency sign
        "curren" => "&#x000A4;",
        # /downarrow A: =downward arrow
        "darr" => "&#x02193;",
        # =degree sign
        "deg" => "&#x000B0;",
        # /div B: =divide sign
        "divide" => "&#x000F7;",
        # =dollar sign
        "dollar" => "&#x00024;",
        # =equals sign R:
        "equals" => "&#x0003D;",
        # =exclamation mark
        "excl" => "&#x00021;",
        # =fraction one-half
        "frac12" => "&#x000BD;",
        # =fraction one-quarter
        "frac14" => "&#x000BC;",
        # =fraction one-eighth
        "frac18" => "&#x0215B;",
        # =fraction three-quarters
        "frac34" => "&#x000BE;",
        # =fraction three-eighths
        "frac38" => "&#x0215C;",
        # =fraction five-eighths
        "frac58" => "&#x0215D;",
        # =fraction seven-eighths
        "frac78" => "&#x0215E;",
        # =greater-than sign R:
        "gt" => "&#x0003E;",
        # =fraction one-half
        "half" => "&#x000BD;",
        # =horizontal bar
        "horbar" => "&#x02015;",
        # =hyphen
        "hyphen" => "&#x02010;",
        # =inverted exclamation mark
        "iexcl" => "&#x000A1;",
        # =inverted question mark
        "iquest" => "&#x000BF;",
        # =angle quotation mark, left
        "laquo" => "&#x000AB;",
        # /leftarrow /gets A: =leftward arrow
        "larr" => "&#x02190;",
        # /lbrace O: =left curly bracket
        "lcub" => "&#x0007B;",
        # =double quotation mark, left
        "ldquo" => "&#x0201C;",
        # =low line
        "lowbar" => "&#x0005F;",
        # O: =left parenthesis
        "lpar" => "&#x00028;",
        # /lbrack O: =left square bracket
        "lsqb" => "&#x0005B;",
        # =single quotation mark, left
        "lsquo" => "&#x02018;",
        # =less-than sign R:
        "lt" => "&#60;",
        # =micro sign
        "micro" => "&#x000B5;",
        # /centerdot B: =middle dot
        "middot" => "&#x000B7;",
        # =no break (required) space
        "nbsp" => "&#x000A0;",
        # /neg /lnot =not sign
        "not" => "&#x000AC;",
        # =number sign
        "num" => "&#x00023;",
        # =ohm sign
        "ohm" => "&#x02126;",
        # =ordinal indicator, feminine
        "ordf" => "&#x000AA;",
        # =ordinal indicator, masculine
        "ordm" => "&#x000BA;",
        # =pilcrow (paragraph sign)
        "para" => "&#x000B6;",
        # =percent sign
        "percnt" => "&#x00025;",
        # =full stop, period
        "period" => "&#x0002E;",
        # =plus sign B:
        "plus" => "&#x0002B;",
        # /pm B: =plus-or-minus sign
        "plusmn" => "&#x000B1;",
        # =pound sign
        "pound" => "&#x000A3;",
        # =question mark
        "quest" => "&#x0003F;",
        # =quotation mark
        "quot" => "&#x00022;",
        # =angle quotation mark, right
        "raquo" => "&#x000BB;",
        # /rightarrow /to A: =rightward arrow
        "rarr" => "&#x02192;",
        # /rbrace C: =right curly bracket
        "rcub" => "&#x0007D;",
        # =double quotation mark, right
        "rdquo" => "&#x0201D;",
        # /circledR =registered sign
        "reg" => "&#x000AE;",
        # C: =right parenthesis
        "rpar" => "&#x00029;",
        # /rbrack C: =right square bracket
        "rsqb" => "&#x0005D;",
        # =single quotation mark, right
        "rsquo" => "&#x02019;",
        # =section sign
        "sect" => "&#x000A7;",
        # =semicolon P:
        "semi" => "&#x0003B;",
        # =soft hyphen
        "shy" => "&#x000AD;",
        # =solidus
        "sol" => "&#x0002F;",
        # =music note (sung text sign)
        "sung" => "&#x0266A;",
        # =superscript one
        "sup1" => "&#x000B9;",
        # =superscript two
        "sup2" => "&#x000B2;",
        # =superscript three
        "sup3" => "&#x000B3;",
        # /times B: =multiply sign
        "times" => "&#x000D7;",
        # =trade mark sign
        "trade" => "&#x02122;",
        # /uparrow A: =upward arrow
        "uarr" => "&#x02191;",
        # /vert =vertical bar
        "verbar" => "&#x0007C;",
        # /yen =yen sign
        "yen" => "&#x000A5;",
        # =significant blank symbol
        "blank" => "&#x02423;",
        # =50% shaded block
        "blk12" => "&#x02592;",
        # =25% shaded block
        "blk14" => "&#x02591;",
        # =75% shaded block
        "blk34" => "&#x02593;",
        # =full block
        "block" => "&#x02588;",
        # /bullet B: =round bullet, filled
        "bull" => "&#x02022;",
        # =caret (insertion mark)
        "caret" => "&#x02041;",
        # /checkmark =tick, check mark
        "check" => "&#x02713;",
        # /circ B: =circle, open
        "cir" => "&#x025CB;",
        # /clubsuit =club suit symbol
        "clubs" => "&#x02663;",
        # =sound recording copyright sign
        "copysr" => "&#x02117;",
        # =ballot cross
        "cross" => "&#x02717;",
        # /ddagger B: =double dagger
        "Dagger" => "&#x02021;",
        # /dagger B: =dagger
        "dagger" => "&#x02020;",
        # =hyphen (true graphic)
        "dash" => "&#x02010;",
        # /diamondsuit =diamond suit symbol
        "diams" => "&#x02666;",
        # downward left crop mark
        "dlcrop" => "&#x0230D;",
        # downward right crop mark
        "drcrop" => "&#x0230C;",
        # /triangledown =down triangle, open
        "dtri" => "&#x025BF;",
        # /blacktriangledown =dn tri, filled
        "dtrif" => "&#x025BE;",
        # =em space
        "emsp" => "&#x02003;",
        # =1/3-em space
        "emsp13" => "&#x02004;",
        # =1/4-em space
        "emsp14" => "&#x02005;",
        # =en space (1/2-em)
        "ensp" => "&#x02002;",
        # =female symbol
        "female" => "&#x02640;",
        # small ffi ligature
        "ffilig" => "&#x0FB03;",
        # small ff ligature
        "fflig" => "&#x0FB00;",
        # small ffl ligature
        "ffllig" => "&#x0FB04;",
        # small fi ligature
        "filig" => "&#x0FB01;",
        # /flat =musical flat
        "flat" => "&#x0266D;",
        # small fl ligature
        "fllig" => "&#x0FB02;",
        # =fraction one-third
        "frac13" => "&#x02153;",
        # =fraction one-fifth
        "frac15" => "&#x02155;",
        # =fraction one-sixth
        "frac16" => "&#x02159;",
        # =fraction two-thirds
        "frac23" => "&#x02154;",
        # =fraction two-fifths
        "frac25" => "&#x02156;",
        # =fraction three-fifths
        "frac35" => "&#x02157;",
        # =fraction four-fifths
        "frac45" => "&#x02158;",
        # =fraction five-sixths
        "frac56" => "&#x0215A;",
        # =hair space
        "hairsp" => "&#x0200A;",
        # /heartsuit =heart suit symbol
        "hearts" => "&#x02665;",
        # =ellipsis (horizontal)
        "hellip" => "&#x02026;",
        # rectangle, filled (hyphen bullet)
        "hybull" => "&#x02043;",
        # =in-care-of symbol
        "incare" => "&#x02105;",
        # =rising dbl quote, left (low)
        "ldquor" => "&#x0201E;",
        # =lower half block
        "lhblk" => "&#x02584;",
        # /lozenge - lozenge or total mark
        "loz" => "&#x025CA;",
        # /blacklozenge - lozenge, filled
        "lozf" => "&#x029EB;",
        # =rising single quote, left (low)
        "lsquor" => "&#x0201A;",
        # /triangleleft B: l triangle, open
        "ltri" => "&#x025C3;",
        # /blacktriangleleft R: =l tri, filled
        "ltrif" => "&#x025C2;",
        # =male symbol
        "male" => "&#x02642;",
        # /maltese =maltese cross
        "malt" => "&#x02720;",
        # =histogram marker
        "marker" => "&#x025AE;",
        # =em dash
        "mdash" => "&#x02014;",
        # em leader
        "mldr" => "&#x02026;",
        # /natural - music natural
        "natur" => "&#x0266E;",
        # =en dash
        "ndash" => "&#x02013;",
        # =double baseline dot (en leader)
        "nldr" => "&#x02025;",
        # =digit space (width of a number)
        "numsp" => "&#x02007;",
        # =telephone symbol
        "phone" => "&#x0260E;",
        # =punctuation space (width of comma)
        "puncsp" => "&#x02008;",
        # rising dbl quote, right (high)
        "rdquor" => "&#x0201D;",
        # =rectangle, open
        "rect" => "&#x025AD;",
        # rising single quote, right (high)
        "rsquor" => "&#x02019;",
        # /triangleright B: r triangle, open
        "rtri" => "&#x025B9;",
        # /blacktriangleright R: =r tri, filled
        "rtrif" => "&#x025B8;",
        # pharmaceutical prescription (Rx)
        "rx" => "&#x0211E;",
        # sextile (6-pointed star)
        "sext" => "&#x02736;",
        # /sharp =musical sharp
        "sharp" => "&#x0266F;",
        # /spadesuit =spades suit symbol
        "spades" => "&#x02660;",
        # =square, open
        "squ" => "&#x025A1;",
        # /blacksquare =sq bullet, filled
        "squf" => "&#x025AA;",
        # =star, open
        "star" => "&#x02606;",
        # /bigstar - star, filled
        "starf" => "&#x02605;",
        # register mark or target
        "target" => "&#x02316;",
        # =telephone recorder symbol
        "telrec" => "&#x02315;",
        # =thin space (1/6-em)
        "thinsp" => "&#x02009;",
        # =upper half block
        "uhblk" => "&#x02580;",
        # upward left crop mark
        "ulcrop" => "&#x0230F;",
        # upward right crop mark
        "urcrop" => "&#x0230E;",
        # /triangle =up triangle, open
        "utri" => "&#x025B5;",
        # /blacktriangle =up tri, filled
        "utrif" => "&#x025B4;",
        # vertical ellipsis
        "vellip" => "&#x022EE;",
        # ac current
        "acd" => "&#x0223F;",
        # /aleph aleph, Hebrew
        "aleph" => "&#x02135;",
        # dbl logical and
        "And" => "&#x02A53;",
        # /wedge /land B: logical and
        "and" => "&#x02227;",
        # two logical and
        "andand" => "&#x02A55;",
        # and, horizontal dash
        "andd" => "&#x02A5C;",
        # sloping large and
        "andslope" => "&#x02A58;",
        # and with middle stem
        "andv" => "&#x02A5A;",
        # right (90 degree) angle
        "angrt" => "&#x0221F;",
        # /sphericalangle angle-spherical
        "angsph" => "&#x02222;",
        # Angstrom capital A, ring
        "angst" => "&#x0212B;",
        # /approx R: approximate
        "ap" => "&#x02248;",
        # approximate, circumflex accent
        "apacir" => "&#x02A6F;",
        # contour integral, anti-clockwise
        "awconint" => "&#x02233;",
        # anti clock-wise integration
        "awint" => "&#x02A11;",
        # /because R: because
        "becaus" => "&#x02235;",
        # Bernoulli function (script capital B)
        "bernou" => "&#x0212C;",
        # reverse not equal
        "bne" => "&#x0003D;&#x020E5;",
        # reverse not equivalent
        "bnequiv" => "&#x02261;&#x020E5;",
        # reverse not with two horizontal strokes
        "bNot" => "&#x02AED;",
        # reverse not
        "bnot" => "&#x02310;",
        # /bot bottom
        "bottom" => "&#x022A5;",
        # /cap B: intersection
        "cap" => "&#x02229;",
        # triple contour integral operator
        "Cconint" => "&#x02230;",
        # circulation function
        "cirfnint" => "&#x02A10;",
        # /circ B: composite function (small circle)
        "compfn" => "&#x02218;",
        # /cong R: congruent with
        "cong" => "&#x02245;",
        # double contour integral operator
        "Conint" => "&#x0222F;",
        # /oint L: contour integral operator
        "conint" => "&#x0222E;",
        # /cdots, three dots, centered
        "ctdot" => "&#x022EF;",
        # /cup B: union or logical sum
        "cup" => "&#x0222A;",
        # contour integral, clockwise
        "cwconint" => "&#x02232;",
        # clockwise integral
        "cwint" => "&#x02231;",
        # cylindricity
        "cylcty" => "&#x0232D;",
        # set membership, long horizontal stroke
        "disin" => "&#x022F2;",
        # dieresis or umlaut mark
        "Dot" => "&#x000A8;",
        # solidus, bar above
        "dsol" => "&#x029F6;",
        # /ddots, three dots, descending
        "dtdot" => "&#x022F1;",
        # large downward pointing angle
        "dwangle" => "&#x029A6;",
        # electrical intersection
        "elinters" => "&#x0FFFD;",
        # parallel, equal; equal or parallel
        "epar" => "&#x022D5;",
        # parallel, slanted, equal; homothetically congruent to
        "eparsl" => "&#x029E3;",
        # /equiv R: identical with
        "equiv" => "&#x02261;",
        # equivalent, equal; congruent and parallel
        "eqvparsl" => "&#x029E5;",
        # /exists at least one exists
        "exist" => "&#x02203;",
        # flatness
        "fltns" => "&#x025B1;",
        # function of (italic small f)
        "fnof" => "&#x00192;",
        # /forall for all
        "forall" => "&#x02200;",
        # finite part integral
        "fpartint" => "&#x02A0D;",
        # /geq /ge R: greater-than-or-equal
        "ge" => "&#x02265;",
        # Hamiltonian (script capital H)
        "hamilt" => "&#x0210B;",
        # /iff if and only if
        "iff" => "&#x021D4;",
        # infinity sign, incomplete
        "iinfin" => "&#x029DC;",
        # impedance
        "imped" => "&#x001B5;",
        # /infty infinity
        "infin" => "&#x0221E;",
        # tie, infinity
        "infintie" => "&#x029DD;",
        # double integral operator
        "Int" => "&#x0222C;",
        # /int L: integral operator
        "int" => "&#x0222B;",
        # integral, left arrow with hook
        "intlarhk" => "&#x02A17;",
        # /in R: set membership
        "isin" => "&#x02208;",
        # set membership, dot above
        "isindot" => "&#x022F5;",
        # set membership, two horizontal strokes
        "isinE" => "&#x022F9;",
        # set membership, vertical bar on horizontal stroke
        "isins" => "&#x022F4;",
        # large set membership, vertical bar on horizontal stroke
        "isinsv" => "&#x022F3;",
        # set membership, variant
        "isinv" => "&#x02208;",
        # Lagrangian (script capital L)
        "lagran" => "&#x02112;",
        # left angle bracket, double
        "Lang" => "&#x0300A;",
        # /langle O: left angle bracket
        "lang" => "&#x02329;",
        # /Leftarrow A: is implied by
        "lArr" => "&#x021D0;",
        # left broken bracket
        "lbbrk" => "&#x03014;",
        # /leq /le R: less-than-or-equal
        "le" => "&#x02264;",
        # left open angular bracket
        "loang" => "&#x03018;",
        # left open bracket
        "lobrk" => "&#x0301A;",
        # left open parenthesis
        "lopar" => "&#x02985;",
        # low asterisk
        "lowast" => "&#x02217;",
        # B: minus sign
        "minus" => "&#x02212;",
        # /mp B: minus-or-plus sign
        "mnplus" => "&#x02213;",
        # /nabla del, Hamilton operator
        "nabla" => "&#x02207;",
        # /ne /neq R: not equal
        "ne" => "&#x02260;",
        # not equal, dot
        "nedot" => "&#x02250;&#x00338;",
        # not, horizontal, parallel
        "nhpar" => "&#x02AF2;",
        # /ni /owns R: contains
        "ni" => "&#x0220B;",
        # contains, vertical bar on horizontal stroke
        "nis" => "&#x022FC;",
        # contains, long horizontal stroke
        "nisd" => "&#x022FA;",
        # contains, variant
        "niv" => "&#x0220B;",
        # not with two horizontal strokes
        "Not" => "&#x02AEC;",
        # /notin N: negated set membership
        "notin" => "&#x02209;",
        # negated set membership, dot above
        "notindot" => "&#x022F5;&#x00338;",
        # negated set membership, two horizontal strokes
        "notinE" => "&#x022F9;&#x00338;",
        # negated set membership, variant
        "notinva" => "&#x02209;",
        # negated set membership, variant
        "notinvb" => "&#x022F7;",
        # negated set membership, variant
        "notinvc" => "&#x022F6;",
        # negated contains
        "notni" => "&#x0220C;",
        # negated contains, variant
        "notniva" => "&#x0220C;",
        # contains, variant
        "notnivb" => "&#x022FE;",
        # contains, variant
        "notnivc" => "&#x022FD;",
        # not parallel, slanted
        "nparsl" => "&#x02AFD;&#x020E5;",
        # not partial differential
        "npart" => "&#x02202;&#x00338;",
        # line integration, not including the pole
        "npolint" => "&#x02A14;",
        # not, vert, infinity
        "nvinfin" => "&#x029DE;",
        # circle, cross
        "olcross" => "&#x029BB;",
        # dbl logical or
        "Or" => "&#x02A54;",
        # /vee /lor B: logical or
        "or" => "&#x02228;",
        # or, horizontal dash
        "ord" => "&#x02A5D;",
        # order of (script small o)
        "order" => "&#x02134;",
        # two logical or
        "oror" => "&#x02A56;",
        # sloping large or
        "orslope" => "&#x02A57;",
        # or with middle stem
        "orv" => "&#x02A5B;",
        # /parallel R: parallel
        "par" => "&#x02225;",
        # parallel, slanted
        "parsl" => "&#x02AFD;",
        # /partial partial differential
        "part" => "&#x02202;",
        # per thousand
        "permil" => "&#x02030;",
        # /perp R: perpendicular
        "perp" => "&#x022A5;",
        # per 10 thousand
        "pertenk" => "&#x02031;",
        # physics M-matrix (script capital M)
        "phmmat" => "&#x02133;",
        # integral around a point operator
        "pointint" => "&#x02A15;",
        # double prime or second
        "Prime" => "&#x02033;",
        # /prime prime or minute
        "prime" => "&#x02032;",
        # all-around profile
        "profalar" => "&#x0232E;",
        # profile of a line
        "profline" => "&#x02312;",
        # profile of a surface
        "profsurf" => "&#x02313;",
        # /propto R: is proportional to
        "prop" => "&#x0221D;",
        # /iiiint quadruple integral operator
        "qint" => "&#x02A0C;",
        # quadruple prime
        "qprime" => "&#x02057;",
        # quaternion integral operator
        "quatint" => "&#x02A16;",
        # /surd radical
        "radic" => "&#x0221A;",
        # right angle bracket, double
        "Rang" => "&#x0300B;",
        # /rangle C: right angle bracket
        "rang" => "&#x0232A;",
        # /Rightarrow A: implies
        "rArr" => "&#x021D2;",
        # right broken bracket
        "rbbrk" => "&#x03015;",
        # right open angular bracket
        "roang" => "&#x03019;",
        # right open bracket
        "robrk" => "&#x0301B;",
        # right open parenthesis
        "ropar" => "&#x02986;",
        # line integration, rectangular path around pole
        "rppolint" => "&#x02A12;",
        # line integration, semi-circular path around pole
        "scpolint" => "&#x02A13;",
        # /sim R: similar
        "sim" => "&#x0223C;",
        # similar, dot
        "simdot" => "&#x02A6A;",
        # /simeq R: similar, equals
        "sime" => "&#x02243;",
        # similar, parallel, slanted, equal
        "smeparsl" => "&#x029E4;",
        # /square, square
        "square" => "&#x025A1;",
        # /blacksquare, square, filled
        "squarf" => "&#x025AA;",
        # straightness
        "strns" => "&#x000AF;",
        # /subset R: subset or is implied by
        "sub" => "&#x02282;",
        # /subseteq R: subset, equals
        "sube" => "&#x02286;",
        # /supset R: superset or implies
        "sup" => "&#x02283;",
        # /supseteq R: superset, equals
        "supe" => "&#x02287;",
        # /therefore R: therefore
        "there4" => "&#x02234;",
        # /iiint triple integral operator
        "tint" => "&#x0222D;",
        # /top top
        "top" => "&#x022A4;",
        # top and bottom
        "topbot" => "&#x02336;",
        # top, circle below
        "topcir" => "&#x02AF1;",
        # triple prime
        "tprime" => "&#x02034;",
        # three dots, ascending
        "utdot" => "&#x022F0;",
        # large upward pointing angle
        "uwangle" => "&#x029A7;",
        # right angle, variant
        "vangrt" => "&#x0299C;",
        # logical or, equals
        "veeeq" => "&#x0225A;",
        # /Vert dbl vertical bar
        "Verbar" => "&#x02016;",
        # /wedgeq R: corresponds to (wedge, equals)
        "wedgeq" => "&#x02259;",
        # large contains, vertical bar on horizontal stroke
        "xnis" => "&#x022FB;",
        # alias ISOAMSO ang
        "angle" => "&#x02220;",
        # character showing function application in presentation tagging
        "ApplyFunction" => "&#x02061;",
        # alias ISOTECH ap
        "approx" => "&#x02248;",
        # alias ISOAMSR ape
        "approxeq" => "&#x0224A;",
        # assignment operator, alias ISOAMSR colone
        "Assign" => "&#x02254;",
        # alias ISOAMSR bcong
        "backcong" => "&#x0224C;",
        # alias ISOAMSR bepsi
        "backepsilon" => "&#x003F6;",
        # alias ISOAMSO bprime
        "backprime" => "&#x02035;",
        # alias ISOAMSR bsim
        "backsim" => "&#x0223D;",
        # alias ISOAMSR bsime
        "backsimeq" => "&#x022CD;",
        # alias ISOAMSB setmn
        "Backslash" => "&#x02216;",
        # alias ISOAMSB barwed
        "barwedge" => "&#x02305;",
        # alias ISOTECH becaus
        "Because" => "&#x02235;",
        # alias ISOTECH becaus
        "because" => "&#x02235;",
        # alias ISOTECH bernou
        "Bernoullis" => "&#x0212C;",
        # alias ISOAMSR twixt
        "between" => "&#x0226C;",
        # alias ISOAMSB xcap
        "bigcap" => "&#x022C2;",
        # alias ISOAMSB xcirc
        "bigcirc" => "&#x025EF;",
        # alias ISOAMSB xcup
        "bigcup" => "&#x022C3;",
        # alias ISOAMSB xodot
        "bigodot" => "&#x02A00;",
        # alias ISOAMSB xoplus
        "bigoplus" => "&#x02A01;",
        # alias ISOAMSB xotime
        "bigotimes" => "&#x02A02;",
        # alias ISOAMSB xsqcup
        "bigsqcup" => "&#x02A06;",
        # ISOPUB    starf
        "bigstar" => "&#x02605;",
        # alias ISOAMSB xdtri
        "bigtriangledown" => "&#x025BD;",
        # alias ISOAMSB xutri
        "bigtriangleup" => "&#x025B3;",
        # alias ISOAMSB xuplus
        "biguplus" => "&#x02A04;",
        # alias ISOAMSB xvee
        "bigvee" => "&#x022C1;",
        # alias ISOAMSB xwedge
        "bigwedge" => "&#x022C0;",
        # alias ISOAMSA rbarr
        "bkarow" => "&#x0290D;",
        # alias ISOPUB lozf
        "blacklozenge" => "&#x029EB;",
        # ISOTECH  squarf
        "blacksquare" => "&#x025AA;",
        # alias ISOPUB utrif
        "blacktriangle" => "&#x025B4;",
        # alias ISOPUB dtrif
        "blacktriangledown" => "&#x025BE;",
        # alias ISOPUB ltrif
        "blacktriangleleft" => "&#x025C2;",
        # alias ISOPUB rtrif
        "blacktriangleright" => "&#x025B8;",
        # alias ISOTECH bottom
        "bot" => "&#x022A5;",
        # alias ISOAMSB minusb
        "boxminus" => "&#x0229F;",
        # alias ISOAMSB plusb
        "boxplus" => "&#x0229E;",
        # alias ISOAMSB timesb
        "boxtimes" => "&#x022A0;",
        # alias ISODIA breve
        "Breve" => "&#x002D8;",
        # alias ISOPUB bull
        "bullet" => "&#x02022;",
        # alias ISOAMSR bump
        "Bumpeq" => "&#x0224E;",
        # alias ISOAMSR bumpe
        "bumpeq" => "&#x0224F;",
        # D for use in differentials, e.g., within integrals
        "CapitalDifferentialD" => "&#x02145;",
        # the non-associative ring of octonions or Cayley numbers
        "Cayleys" => "&#x0212D;",
        # alias ISODIA cedil
        "Cedilla" => "&#x000B8;",
        # alias ISONUM middot
        "CenterDot" => "&#x000B7;",
        # alias ISONUM middot
        "centerdot" => "&#x000B7;",
        # alias ISOPUB check
        "checkmark" => "&#x02713;",
        # alias ISOAMSR cire
        "circeq" => "&#x02257;",
        # alias ISOAMSA olarr
        "circlearrowleft" => "&#x021BA;",
        # alias ISOAMSA orarr
        "circlearrowright" => "&#x021BB;",
        # alias ISOAMSB oast
        "circledast" => "&#x0229B;",
        # alias ISOAMSB ocir
        "circledcirc" => "&#x0229A;",
        # alias ISOAMSB odash
        "circleddash" => "&#x0229D;",
        # alias ISOAMSB odot
        "CircleDot" => "&#x02299;",
        # alias ISONUM reg
        "circledR" => "&#x000AE;",
        # alias ISOAMSO oS
        "circledS" => "&#x024C8;",
        # alias ISOAMSB ominus
        "CircleMinus" => "&#x02296;",
        # alias ISOAMSB oplus
        "CirclePlus" => "&#x02295;",
        # alias ISOAMSB otimes
        "CircleTimes" => "&#x02297;",
        # alias ISOTECH cwconint
        "ClockwiseContourIntegral" => "&#x02232;",
        # alias ISONUM rdquo
        "CloseCurlyDoubleQuote" => "&#x0201D;",
        # alias ISONUM rsquo
        "CloseCurlyQuote" => "&#x02019;",
        # ISOPUB    clubs
        "clubsuit" => "&#x02663;",
        # alias ISOAMSR colone
        "coloneq" => "&#x02254;",
        # alias ISOAMSO comp
        "complement" => "&#x02201;",
        # the field of complex numbers
        "complexes" => "&#x02102;",
        # alias ISOTECH equiv
        "Congruent" => "&#x02261;",
        # alias ISOTECH conint
        "ContourIntegral" => "&#x0222E;",
        # alias ISOAMSB coprod
        "Coproduct" => "&#x02210;",
        # alias ISOTECH awconint
        "CounterClockwiseContourIntegral" => "&#x02233;",
        # alias asympeq
        "CupCap" => "&#x0224D;",
        # alias ISOAMSR cuepr
        "curlyeqprec" => "&#x022DE;",
        # alias ISOAMSR cuesc
        "curlyeqsucc" => "&#x022DF;",
        # alias ISOAMSB cuvee
        "curlyvee" => "&#x022CE;",
        # alias ISOAMSB cuwed
        "curlywedge" => "&#x022CF;",
        # alias ISOAMSA cularr
        "curvearrowleft" => "&#x021B6;",
        # alias ISOAMSA curarr
        "curvearrowright" => "&#x021B7;",
        # alias ISOAMSA rBarr
        "dbkarow" => "&#x0290F;",
        # alias ISOPUB Dagger
        "ddagger" => "&#x02021;",
        # alias ISOAMSR eDDot
        "ddotseq" => "&#x02A77;",
        # alias ISOTECH nabla
        "Del" => "&#x02207;",
        # alias ISODIA acute
        "DiacriticalAcute" => "&#x000B4;",
        # alias ISODIA dot
        "DiacriticalDot" => "&#x002D9;",
        # alias ISODIA dblac
        "DiacriticalDoubleAcute" => "&#x002DD;",
        # alias ISODIA grave
        "DiacriticalGrave" => "&#x00060;",
        # alias ISODIA tilde
        "DiacriticalTilde" => "&#x002DC;",
        # alias ISOAMSB diam
        "Diamond" => "&#x022C4;",
        # alias ISOAMSB diam
        "diamond" => "&#x022C4;",
        # ISOPUB    diams
        "diamondsuit" => "&#x02666;",
        # d for use in differentials, e.g., within integrals
        "DifferentialD" => "&#x02146;",
        # alias ISOGRK3 gammad
        "digamma" => "&#x003DD;",
        # alias ISONUM divide
        "div" => "&#x000F7;",
        # alias ISOAMSB divonx
        "divideontimes" => "&#x022C7;",
        # alias ISOAMSR esdot
        "doteq" => "&#x02250;",
        # alias ISOAMSR eDot
        "doteqdot" => "&#x02251;",
        # alias ISOAMSR esdot
        "DotEqual" => "&#x02250;",
        # alias ISOAMSB minusd
        "dotminus" => "&#x02238;",
        # alias ISOAMSB plusdo
        "dotplus" => "&#x02214;",
        # alias ISOAMSB sdotb
        "dotsquare" => "&#x022A1;",
        # alias ISOAMSB Barwed
        "doublebarwedge" => "&#x02306;",
        # alias ISOTECH Conint
        "DoubleContourIntegral" => "&#x0222F;",
        # alias ISODIA die
        "DoubleDot" => "&#x000A8;",
        # alias ISOAMSA dArr
        "DoubleDownArrow" => "&#x021D3;",
        # alias ISOTECH lArr
        "DoubleLeftArrow" => "&#x021D0;",
        # alias ISOAMSA hArr
        "DoubleLeftRightArrow" => "&#x021D4;",
        # alias for  &Dashv;
        "DoubleLeftTee" => "&#x02AE4;",
        # alias ISOAMSA xlArr
        "DoubleLongLeftArrow" => "&#x027F8;",
        # alias ISOAMSA xhArr
        "DoubleLongLeftRightArrow" => "&#x027FA;",
        # alias ISOAMSA xrArr
        "DoubleLongRightArrow" => "&#x027F9;",
        # alias ISOTECH rArr
        "DoubleRightArrow" => "&#x021D2;",
        # alias ISOAMSR vDash
        "DoubleRightTee" => "&#x022A8;",
        # alias ISOAMSA uArr
        "DoubleUpArrow" => "&#x021D1;",
        # alias ISOAMSA vArr
        "DoubleUpDownArrow" => "&#x021D5;",
        # alias ISOTECH par
        "DoubleVerticalBar" => "&#x02225;",
        # alias ISONUM darr
        "DownArrow" => "&#x02193;",
        # alias ISOAMSA dArr
        "Downarrow" => "&#x021D3;",
        # alias ISONUM darr
        "downarrow" => "&#x02193;",
        # alias ISOAMSA duarr
        "DownArrowUpArrow" => "&#x021F5;",
        # alias ISOAMSA ddarr
        "downdownarrows" => "&#x021CA;",
        # alias ISOAMSA dharl
        "downharpoonleft" => "&#x021C3;",
        # alias ISOAMSA dharr
        "downharpoonright" => "&#x021C2;",
        # alias ISOAMSA lhard
        "DownLeftVector" => "&#x021BD;",
        # alias ISOAMSA rhard
        "DownRightVector" => "&#x021C1;",
        # alias ISOTECH top
        "DownTee" => "&#x022A4;",
        # alias for mapstodown
        "DownTeeArrow" => "&#x021A7;",
        # alias ISOAMSA RBarr
        "drbkarow" => "&#x02910;",
        # alias ISOTECH isinv
        "Element" => "&#x02208;",
        # alias ISOAMSO empty
        "emptyset" => "&#x02205;",
        # alias ISOAMSR ecir
        "eqcirc" => "&#x02256;",
        # alias ISOAMSR ecolon
        "eqcolon" => "&#x02255;",
        # alias ISOAMSR esim
        "eqsim" => "&#x02242;",
        # alias ISOAMSR egs
        "eqslantgtr" => "&#x02A96;",
        # alias ISOAMSR els
        "eqslantless" => "&#x02A95;",
        # alias ISOAMSR esim
        "EqualTilde" => "&#x02242;",
        # alias ISOAMSA rlhar
        "Equilibrium" => "&#x021CC;",
        # alias ISOTECH exist
        "Exists" => "&#x02203;",
        # expectation (operator)
        "expectation" => "&#x02130;",
        # e use for the exponential base of the natural logarithms
        "ExponentialE" => "&#x02147;",
        # base of the Napierian logarithms
        "exponentiale" => "&#x02147;",
        # alias ISOAMSR efDot
        "fallingdotseq" => "&#x02252;",
        # alias ISOTECH forall
        "ForAll" => "&#x02200;",
        # Fourier transform
        "Fouriertrf" => "&#x02131;",
        # alias ISOTECH ge
        "geq" => "&#x02265;",
        # alias ISOAMSR gE
        "geqq" => "&#x02267;",
        # alias ISOAMSR ges
        "geqslant" => "&#x02A7E;",
        # alias ISOAMSR Gt
        "gg" => "&#x0226B;",
        # alias ISOAMSR Gg
        "ggg" => "&#x022D9;",
        # alias ISOAMSN gnap
        "gnapprox" => "&#x02A8A;",
        # alias ISOAMSN gne
        "gneq" => "&#x02A88;",
        # alias ISOAMSN gnE
        "gneqq" => "&#x02269;",
        # alias ISOTECH ge
        "GreaterEqual" => "&#x02265;",
        # alias ISOAMSR gel
        "GreaterEqualLess" => "&#x022DB;",
        # alias ISOAMSR gE
        "GreaterFullEqual" => "&#x02267;",
        # alias ISOAMSR gl
        "GreaterLess" => "&#x02277;",
        # alias ISOAMSR ges
        "GreaterSlantEqual" => "&#x02A7E;",
        # alias ISOAMSR gsim
        "GreaterTilde" => "&#x02273;",
        # alias ISOAMSR gap
        "gtrapprox" => "&#x02A86;",
        # alias ISOAMSR gtdot
        "gtrdot" => "&#x022D7;",
        # alias ISOAMSR gel
        "gtreqless" => "&#x022DB;",
        # alias ISOAMSR gEl
        "gtreqqless" => "&#x02A8C;",
        # alias ISOAMSR gl
        "gtrless" => "&#x02277;",
        # alias ISOAMSR gsim
        "gtrsim" => "&#x02273;",
        # alias ISOAMSN gvnE
        "gvertneqq" => "&#x02269;&#x0FE00;",
        # alias ISODIA caron
        "Hacek" => "&#x002C7;",
        # alias ISOAMSO plank
        "hbar" => "&#x0210F;",
        # ISOPUB hearts
        "heartsuit" => "&#x02665;",
        # Hilbert space
        "HilbertSpace" => "&#x0210B;",
        # alias ISOAMSA searhk
        "hksearow" => "&#x02925;",
        # alias ISOAMSA swarhk
        "hkswarow" => "&#x02926;",
        # alias ISOAMSA larrhk
        "hookleftarrow" => "&#x021A9;",
        # alias ISOAMSA rarrhk
        "hookrightarrow" => "&#x021AA;",
        # alias ISOAMSO plankv
        "hslash" => "&#x0210F;",
        # alias ISOAMSR bump
        "HumpDownHump" => "&#x0224E;",
        # alias ISOAMSR bumpe
        "HumpEqual" => "&#x0224F;",
        # alias ISOTECH qint
        "iiiint" => "&#x02A0C;",
        # alias ISOTECH tint
        "iiint" => "&#x0222D;",
        # alias ISOAMSO image
        "Im" => "&#x02111;",
        # i for use as a square root of -1
        "ImaginaryI" => "&#x02148;",
        # the geometric imaginary line
        "imagline" => "&#x02110;",
        # alias ISOAMSO image
        "imagpart" => "&#x02111;",
        # alias ISOTECH rArr
        "Implies" => "&#x021D2;",
        # ISOTECH   isin
        "in" => "&#x02208;",
        # the ring of integers
        "integers" => "&#x02124;",
        # alias ISOTECH int
        "Integral" => "&#x0222B;",
        # alias ISOAMSB intcal
        "intercal" => "&#x022BA;",
        # alias ISOAMSB xcap
        "Intersection" => "&#x022C2;",
        # alias ISOAMSB iprod
        "intprod" => "&#x02A3C;",
        # used as a separator, e.g., in indices
        "InvisibleComma" => "&#x02063;",
        # marks multiplication when it is understood without a mark
        "InvisibleTimes" => "&#x02062;",
        # alias ISOTECH lang
        "langle" => "&#x02329;",
        # Laplace transform
        "Laplacetrf" => "&#x02112;",
        # alias ISONUM lcub
        "lbrace" => "&#x0007B;",
        # alias ISONUM lsqb
        "lbrack" => "&#x0005B;",
        # alias ISOTECH lang
        "LeftAngleBracket" => "&#x02329;",
        # alias ISONUM larr
        "LeftArrow" => "&#x02190;",
        # alias ISOTECH lArr
        "Leftarrow" => "&#x021D0;",
        # alias ISONUM larr
        "leftarrow" => "&#x02190;",
        # alias for larrb
        "LeftArrowBar" => "&#x021E4;",
        # alias ISOAMSA lrarr
        "LeftArrowRightArrow" => "&#x021C6;",
        # alias ISOAMSA larrtl
        "leftarrowtail" => "&#x021A2;",
        # alias ISOAMSC lceil
        "LeftCeiling" => "&#x02308;",
        # left double bracket delimiter
        "LeftDoubleBracket" => "&#x0301A;",
        # alias ISOAMSA dharl
        "LeftDownVector" => "&#x021C3;",
        # alias ISOAMSC lfloor
        "LeftFloor" => "&#x0230A;",
        # alias ISOAMSA lhard
        "leftharpoondown" => "&#x021BD;",
        # alias ISOAMSA lharu
        "leftharpoonup" => "&#x021BC;",
        # alias ISOAMSA llarr
        "leftleftarrows" => "&#x021C7;",
        # alias ISOAMSA harr
        "LeftRightArrow" => "&#x02194;",
        # alias ISOAMSA hArr
        "Leftrightarrow" => "&#x021D4;",
        # alias ISOAMSA harr
        "leftrightarrow" => "&#x02194;",
        # alias ISOAMSA lrarr
        "leftrightarrows" => "&#x021C6;",
        # alias ISOAMSA lrhar
        "leftrightharpoons" => "&#x021CB;",
        # alias ISOAMSA harrw
        "leftrightsquigarrow" => "&#x021AD;",
        # alias ISOAMSR dashv
        "LeftTee" => "&#x022A3;",
        # alias for mapstoleft
        "LeftTeeArrow" => "&#x021A4;",
        # alias ISOAMSB lthree
        "leftthreetimes" => "&#x022CB;",
        # alias ISOAMSR vltri
        "LeftTriangle" => "&#x022B2;",
        # alias ISOAMSR ltrie
        "LeftTriangleEqual" => "&#x022B4;",
        # alias ISOAMSA uharl
        "LeftUpVector" => "&#x021BF;",
        # alias ISOAMSA lharu
        "LeftVector" => "&#x021BC;",
        # alias ISOTECH le
        "leq" => "&#x02264;",
        # alias ISOAMSR lE
        "leqq" => "&#x02266;",
        # alias ISOAMSR les
        "leqslant" => "&#x02A7D;",
        # alias ISOAMSR lap
        "lessapprox" => "&#x02A85;",
        # alias ISOAMSR ltdot
        "lessdot" => "&#x022D6;",
        # alias ISOAMSR leg
        "lesseqgtr" => "&#x022DA;",
        # alias ISOAMSR lEg
        "lesseqqgtr" => "&#x02A8B;",
        # alias ISOAMSR leg
        "LessEqualGreater" => "&#x022DA;",
        # alias ISOAMSR lE
        "LessFullEqual" => "&#x02266;",
        # alias ISOAMSR lg
        "LessGreater" => "&#x02276;",
        # alias ISOAMSR lg
        "lessgtr" => "&#x02276;",
        # alias ISOAMSR lsim
        "lesssim" => "&#x02272;",
        # alias ISOAMSR les
        "LessSlantEqual" => "&#x02A7D;",
        # alias ISOAMSR lsim
        "LessTilde" => "&#x02272;",
        # alias ISOAMSR Lt
        "ll" => "&#x0226A;",
        # alias ISOAMSC dlcorn
        "llcorner" => "&#x0231E;",
        # alias ISOAMSA lAarr
        "Lleftarrow" => "&#x021DA;",
        # alias ISOAMSC lmoust
        "lmoustache" => "&#x023B0;",
        # alias ISOAMSN lnap
        "lnapprox" => "&#x02A89;",
        # alias ISOAMSN lne
        "lneq" => "&#x02A87;",
        # alias ISOAMSN lnE
        "lneqq" => "&#x02268;",
        # alias ISOAMSA xlarr
        "LongLeftArrow" => "&#x027F5;",
        # alias ISOAMSA xlArr
        "Longleftarrow" => "&#x027F8;",
        # alias ISOAMSA xlarr
        "longleftarrow" => "&#x027F5;",
        # alias ISOAMSA xharr
        "LongLeftRightArrow" => "&#x027F7;",
        # alias ISOAMSA xhArr
        "Longleftrightarrow" => "&#x027FA;",
        # alias ISOAMSA xharr
        "longleftrightarrow" => "&#x027F7;",
        # alias ISOAMSA xmap
        "longmapsto" => "&#x027FC;",
        # alias ISOAMSA xrarr
        "LongRightArrow" => "&#x027F6;",
        # alias ISOAMSA xrArr
        "Longrightarrow" => "&#x027F9;",
        # alias ISOAMSA xrarr
        "longrightarrow" => "&#x027F6;",
        # alias ISOAMSA larrlp
        "looparrowleft" => "&#x021AB;",
        # alias ISOAMSA rarrlp
        "looparrowright" => "&#x021AC;",
        # alias ISOAMSA swarr
        "LowerLeftArrow" => "&#x02199;",
        # alias ISOAMSA searr
        "LowerRightArrow" => "&#x02198;",
        # alias ISOPUB loz
        "lozenge" => "&#x025CA;",
        # alias ISOAMSC drcorn
        "lrcorner" => "&#x0231F;",
        # alias ISOAMSA lsh
        "Lsh" => "&#x021B0;",
        # alias ISOAMSN lvnE
        "lvertneqq" => "&#x02268;&#x0FE00;",
        # alias ISOPUB malt
        "maltese" => "&#x02720;",
        # alias ISOAMSA map
        "mapsto" => "&#x021A6;",
        # alias ISOAMSO angmsd
        "measuredangle" => "&#x02221;",
        # Mellin transform
        "Mellintrf" => "&#x02133;",
        # alias ISOTECH mnplus
        "MinusPlus" => "&#x02213;",
        # alias ISOTECH mnplus
        "mp" => "&#x02213;",
        # alias ISOAMSA mumap
        "multimap" => "&#x022B8;",
        # alias ISOAMSN nap
        "napprox" => "&#x02249;",
        # alias ISOPUB natur
        "natural" => "&#x0266E;",
        # the semi-ring of natural numbers
        "naturals" => "&#x02115;",
        # alias ISOAMSA nearr
        "nearrow" => "&#x02197;",
        # space of width -4/18 em
        "NegativeMediumSpace" => "&#x0200B;",
        # space of width -5/18 em
        "NegativeThickSpace" => "&#x0200B;",
        # space of width -3/18 em
        "NegativeThinSpace" => "&#x0200B;",
        # space of width -1/18 em
        "NegativeVeryThinSpace" => "&#x0200B;",
        # alias ISOAMSR Gt
        "NestedGreaterGreater" => "&#x0226B;",
        # alias ISOAMSR Lt
        "NestedLessLess" => "&#x0226A;",
        # alias ISOAMSO nexist
        "nexists" => "&#x02204;",
        # alias ISOAMSN nge
        "ngeq" => "&#x02271;",
        # alias ISOAMSN ngE
        "ngeqq" => "&#x02267;&#x00338;",
        # alias ISOAMSN nges
        "ngeqslant" => "&#x02A7E;&#x00338;",
        # alias ISOAMSN ngt
        "ngtr" => "&#x0226F;",
        # alias ISOAMSA nlArr
        "nLeftarrow" => "&#x021CD;",
        # alias ISOAMSA nlarr
        "nleftarrow" => "&#x0219A;",
        # alias ISOAMSA nhArr
        "nLeftrightarrow" => "&#x021CE;",
        # alias ISOAMSA nharr
        "nleftrightarrow" => "&#x021AE;",
        # alias ISOAMSN nle
        "nleq" => "&#x02270;",
        # alias ISOAMSN nlE
        "nleqq" => "&#x02266;&#x00338;",
        # alias ISOAMSN nles
        "nleqslant" => "&#x02A7D;&#x00338;",
        # alias ISOAMSN nlt
        "nless" => "&#x0226E;",
        # alias ISONUM nbsp
        "NonBreakingSpace" => "&#x000A0;",
        # alias ISOAMSN nequiv
        "NotCongruent" => "&#x02262;",
        # alias ISOAMSN npar
        "NotDoubleVerticalBar" => "&#x02226;",
        # alias ISOTECH notin
        "NotElement" => "&#x02209;",
        # alias ISOTECH ne
        "NotEqual" => "&#x02260;",
        # alias for  &nesim;
        "NotEqualTilde" => "&#x02242;&#x00338;",
        # alias ISOAMSO nexist
        "NotExists" => "&#x02204;",
        # alias ISOAMSN ngt
        "NotGreater" => "&#x0226F;",
        # alias ISOAMSN nge
        "NotGreaterEqual" => "&#x02271;",
        # alias ISOAMSN nlE
        "NotGreaterFullEqual" => "&#x02266;&#x00338;",
        # alias ISOAMSN nGtv
        "NotGreaterGreater" => "&#x0226B;&#x00338;",
        # alias ISOAMSN ntvgl
        "NotGreaterLess" => "&#x02279;",
        # alias ISOAMSN nges
        "NotGreaterSlantEqual" => "&#x02A7E;&#x00338;",
        # alias ISOAMSN ngsim
        "NotGreaterTilde" => "&#x02275;",
        # alias for &nbump;
        "NotHumpDownHump" => "&#x0224E;&#x00338;",
        # alias ISOAMSN nltri
        "NotLeftTriangle" => "&#x022EA;",
        # alias ISOAMSN nltrie
        "NotLeftTriangleEqual" => "&#x022EC;",
        # alias ISOAMSN nlt
        "NotLess" => "&#x0226E;",
        # alias ISOAMSN nle
        "NotLessEqual" => "&#x02270;",
        # alias ISOAMSN ntvlg
        "NotLessGreater" => "&#x02278;",
        # alias ISOAMSN nLtv
        "NotLessLess" => "&#x0226A;&#x00338;",
        # alias ISOAMSN nles
        "NotLessSlantEqual" => "&#x02A7D;&#x00338;",
        # alias ISOAMSN nlsim
        "NotLessTilde" => "&#x02274;",
        # alias ISOAMSN npr
        "NotPrecedes" => "&#x02280;",
        # alias ISOAMSN npre
        "NotPrecedesEqual" => "&#x02AAF;&#x00338;",
        # alias ISOAMSN nprcue
        "NotPrecedesSlantEqual" => "&#x022E0;",
        # alias ISOTECH notniva
        "NotReverseElement" => "&#x0220C;",
        # alias ISOAMSN nrtri
        "NotRightTriangle" => "&#x022EB;",
        # alias ISOAMSN nrtrie
        "NotRightTriangleEqual" => "&#x022ED;",
        # alias ISOAMSN nsqsube
        "NotSquareSubsetEqual" => "&#x022E2;",
        # alias ISOAMSN nsqsupe
        "NotSquareSupersetEqual" => "&#x022E3;",
        # alias ISOAMSN vnsub
        "NotSubset" => "&#x02282;&#x020D2;",
        # alias ISOAMSN nsube
        "NotSubsetEqual" => "&#x02288;",
        # alias ISOAMSN nsc
        "NotSucceeds" => "&#x02281;",
        # alias ISOAMSN nsce
        "NotSucceedsEqual" => "&#x02AB0;&#x00338;",
        # alias ISOAMSN nsccue
        "NotSucceedsSlantEqual" => "&#x022E1;",
        # alias ISOAMSN vnsup
        "NotSuperset" => "&#x02283;&#x020D2;",
        # alias ISOAMSN nsupe
        "NotSupersetEqual" => "&#x02289;",
        # alias ISOAMSN nsim
        "NotTilde" => "&#x02241;",
        # alias ISOAMSN nsime
        "NotTildeEqual" => "&#x02244;",
        # alias ISOAMSN ncong
        "NotTildeFullEqual" => "&#x02247;",
        # alias ISOAMSN nap
        "NotTildeTilde" => "&#x02249;",
        # alias ISOAMSN nmid
        "NotVerticalBar" => "&#x02224;",
        # alias ISOAMSN npar
        "nparallel" => "&#x02226;",
        # alias ISOAMSN npr
        "nprec" => "&#x02280;",
        # alias ISOAMSN npre
        "npreceq" => "&#x02AAF;&#x00338;",
        # alias ISOAMSA nrArr
        "nRightarrow" => "&#x021CF;",
        # alias ISOAMSA nrarr
        "nrightarrow" => "&#x0219B;",
        # alias ISOAMSN nsmid
        "nshortmid" => "&#x02224;",
        # alias ISOAMSN nspar
        "nshortparallel" => "&#x02226;",
        # alias ISOAMSN nsime
        "nsimeq" => "&#x02244;",
        # alias ISOAMSN vnsub
        "nsubset" => "&#x02282;&#x020D2;",
        # alias ISOAMSN nsube
        "nsubseteq" => "&#x02288;",
        # alias ISOAMSN nsubE
        "nsubseteqq" => "&#x02AC5;&#x00338;",
        # alias ISOAMSN nsc
        "nsucc" => "&#x02281;",
        # alias ISOAMSN nsce
        "nsucceq" => "&#x02AB0;&#x00338;",
        # alias ISOAMSN vnsup
        "nsupset" => "&#x02283;&#x020D2;",
        # alias ISOAMSN nsupe
        "nsupseteq" => "&#x02289;",
        # alias ISOAMSN nsupE
        "nsupseteqq" => "&#x02AC6;&#x00338;",
        # alias ISOAMSN nltri
        "ntriangleleft" => "&#x022EA;",
        # alias ISOAMSN nltrie
        "ntrianglelefteq" => "&#x022EC;",
        # alias ISOAMSN nrtri
        "ntriangleright" => "&#x022EB;",
        # alias ISOAMSN nrtrie
        "ntrianglerighteq" => "&#x022ED;",
        # alias ISOAMSA nwarr
        "nwarrow" => "&#x02196;",
        # alias ISOTECH conint
        "oint" => "&#x0222E;",
        # alias ISONUM ldquo
        "OpenCurlyDoubleQuote" => "&#x0201C;",
        # alias ISONUM lsquo
        "OpenCurlyQuote" => "&#x02018;",
        # alias ISOTECH order
        "orderof" => "&#x02134;",
        # alias ISOTECH par
        "parallel" => "&#x02225;",
        # alias ISOTECH part
        "PartialD" => "&#x02202;",
        # alias ISOAMSR fork
        "pitchfork" => "&#x022D4;",
        # alias ISONUM plusmn
        "PlusMinus" => "&#x000B1;",
        # alias ISONUM plusmn
        "pm" => "&#x000B1;",
        # the Poincare upper half-plane
        "Poincareplane" => "&#x0210C;",
        # alias ISOAMSR pr
        "prec" => "&#x0227A;",
        # alias ISOAMSR prap
        "precapprox" => "&#x02AB7;",
        # alias ISOAMSR prcue
        "preccurlyeq" => "&#x0227C;",
        # alias ISOAMSR pr
        "Precedes" => "&#x0227A;",
        # alias ISOAMSR pre
        "PrecedesEqual" => "&#x02AAF;",
        # alias ISOAMSR prcue
        "PrecedesSlantEqual" => "&#x0227C;",
        # alias ISOAMSR prsim
        "PrecedesTilde" => "&#x0227E;",
        # alias ISOAMSR pre
        "preceq" => "&#x02AAF;",
        # alias ISOAMSN prnap
        "precnapprox" => "&#x02AB9;",
        # alias ISOAMSN prnE
        "precneqq" => "&#x02AB5;",
        # alias ISOAMSN prnsim
        "precnsim" => "&#x022E8;",
        # alias ISOAMSR prsim
        "precsim" => "&#x0227E;",
        # the prime natural numbers
        "primes" => "&#x02119;",
        # alias ISOAMSR Colon
        "Proportion" => "&#x02237;",
        # alias ISOTECH prop
        "Proportional" => "&#x0221D;",
        # alias ISOTECH prop
        "propto" => "&#x0221D;",
        # the ring (skew field) of quaternions
        "quaternions" => "&#x0210D;",
        # alias ISOAMSR equest
        "questeq" => "&#x0225F;",
        # alias ISOTECH rang
        "rangle" => "&#x0232A;",
        # the field of rational numbers
        "rationals" => "&#x0211A;",
        # alias ISONUM rcub
        "rbrace" => "&#x0007D;",
        # alias ISONUM rsqb
        "rbrack" => "&#x0005D;",
        # alias ISOAMSO real
        "Re" => "&#x0211C;",
        # the geometric real line
        "realine" => "&#x0211B;",
        # alias ISOAMSO real
        "realpart" => "&#x0211C;",
        # the field of real numbers
        "reals" => "&#x0211D;",
        # alias ISOTECH niv
        "ReverseElement" => "&#x0220B;",
        # alias ISOAMSA lrhar
        "ReverseEquilibrium" => "&#x021CB;",
        # alias ISOAMSA duhar
        "ReverseUpEquilibrium" => "&#x0296F;",
        # alias ISOTECH rang
        "RightAngleBracket" => "&#x0232A;",
        # alias ISONUM rarr
        "RightArrow" => "&#x02192;",
        # alias ISOTECH rArr
        "Rightarrow" => "&#x021D2;",
        # alias ISONUM rarr
        "rightarrow" => "&#x02192;",
        # alias for rarrb
        "RightArrowBar" => "&#x021E5;",
        # alias ISOAMSA rlarr
        "RightArrowLeftArrow" => "&#x021C4;",
        # alias ISOAMSA rarrtl
        "rightarrowtail" => "&#x021A3;",
        # alias ISOAMSC rceil
        "RightCeiling" => "&#x02309;",
        # right double bracket delimiter
        "RightDoubleBracket" => "&#x0301B;",
        # alias ISOAMSA dharr
        "RightDownVector" => "&#x021C2;",
        # alias ISOAMSC rfloor
        "RightFloor" => "&#x0230B;",
        # alias ISOAMSA rhard
        "rightharpoondown" => "&#x021C1;",
        # alias ISOAMSA rharu
        "rightharpoonup" => "&#x021C0;",
        # alias ISOAMSA rlarr
        "rightleftarrows" => "&#x021C4;",
        # alias ISOAMSA rlhar
        "rightleftharpoons" => "&#x021CC;",
        # alias ISOAMSA rrarr
        "rightrightarrows" => "&#x021C9;",
        # alias ISOAMSA rarrw
        "rightsquigarrow" => "&#x0219D;",
        # alias ISOAMSR vdash
        "RightTee" => "&#x022A2;",
        # alias ISOAMSA map
        "RightTeeArrow" => "&#x021A6;",
        # alias ISOAMSB rthree
        "rightthreetimes" => "&#x022CC;",
        # alias ISOAMSR vrtri
        "RightTriangle" => "&#x022B3;",
        # alias ISOAMSR rtrie
        "RightTriangleEqual" => "&#x022B5;",
        # alias ISOAMSA uharr
        "RightUpVector" => "&#x021BE;",
        # alias ISOAMSA rharu
        "RightVector" => "&#x021C0;",
        # alias ISOAMSR erDot
        "risingdotseq" => "&#x02253;",
        # alias ISOAMSC rmoust
        "rmoustache" => "&#x023B1;",
        # alias ISOAMSA rAarr
        "Rrightarrow" => "&#x021DB;",
        # alias ISOAMSA rsh
        "Rsh" => "&#x021B1;",
        # alias ISOAMSA searr
        "searrow" => "&#x02198;",
        # alias ISOAMSB setmn
        "setminus" => "&#x02216;",
        # short down arrow
        "ShortDownArrow" => "&#x02193;",
        # alias ISOAMSA slarr
        "ShortLeftArrow" => "&#x02190;",
        # alias ISOAMSR smid
        "shortmid" => "&#x02223;",
        # alias ISOAMSR spar
        "shortparallel" => "&#x02225;",
        # alias ISOAMSA srarr
        "ShortRightArrow" => "&#x02192;",
        # short up arrow
        "ShortUpArrow" => "&#x02191;",
        # alias ISOTECH sime
        "simeq" => "&#x02243;",
        # alias ISOTECH compfn
        "SmallCircle" => "&#x02218;",
        # alias ISOAMSB ssetmn
        "smallsetminus" => "&#x02216;",
        # ISOPUB    spades
        "spadesuit" => "&#x02660;",
        # alias ISOTECH radic
        "Sqrt" => "&#x0221A;",
        # alias ISOAMSR sqsub
        "sqsubset" => "&#x0228F;",
        # alias ISOAMSR sqsube
        "sqsubseteq" => "&#x02291;",
        # alias ISOAMSR sqsup
        "sqsupset" => "&#x02290;",
        # alias ISOAMSR sqsupe
        "sqsupseteq" => "&#x02292;",
        # alias for square
        "Square" => "&#x025A1;",
        # alias ISOAMSB sqcap
        "SquareIntersection" => "&#x02293;",
        # alias ISOAMSR sqsub
        "SquareSubset" => "&#x0228F;",
        # alias ISOAMSR sqsube
        "SquareSubsetEqual" => "&#x02291;",
        # alias ISOAMSR sqsup
        "SquareSuperset" => "&#x02290;",
        # alias ISOAMSR sqsupe
        "SquareSupersetEqual" => "&#x02292;",
        # alias ISOAMSB sqcup
        "SquareUnion" => "&#x02294;",
        # alias ISOAMSB sstarf
        "Star" => "&#x022C6;",
        # alias ISOGRK3 epsi
        "straightepsilon" => "&#x003F5;",
        # alias ISOGRK3 phi
        "straightphi" => "&#x003D5;",
        # alias ISOAMSR Sub
        "Subset" => "&#x022D0;",
        # alias ISOTECH sub
        "subset" => "&#x02282;",
        # alias ISOTECH sube
        "subseteq" => "&#x02286;",
        # alias ISOAMSR subE
        "subseteqq" => "&#x02AC5;",
        # alias ISOTECH sube
        "SubsetEqual" => "&#x02286;",
        # alias ISOAMSN subne
        "subsetneq" => "&#x0228A;",
        # alias ISOAMSN subnE
        "subsetneqq" => "&#x02ACB;",
        # alias ISOAMSR sc
        "succ" => "&#x0227B;",
        # alias ISOAMSR scap
        "succapprox" => "&#x02AB8;",
        # alias ISOAMSR sccue
        "succcurlyeq" => "&#x0227D;",
        # alias ISOAMSR sc
        "Succeeds" => "&#x0227B;",
        # alias ISOAMSR sce
        "SucceedsEqual" => "&#x02AB0;",
        # alias ISOAMSR sccue
        "SucceedsSlantEqual" => "&#x0227D;",
        # alias ISOAMSR scsim
        "SucceedsTilde" => "&#x0227F;",
        # alias ISOAMSR sce
        "succeq" => "&#x02AB0;",
        # alias ISOAMSN scnap
        "succnapprox" => "&#x02ABA;",
        # alias ISOAMSN scnE
        "succneqq" => "&#x02AB6;",
        # alias ISOAMSN scnsim
        "succnsim" => "&#x022E9;",
        # alias ISOAMSR scsim
        "succsim" => "&#x0227F;",
        # ISOTECH  ni
        "SuchThat" => "&#x0220B;",
        # alias ISOAMSB sum
        "Sum" => "&#x02211;",
        # alias ISOTECH sup
        "Superset" => "&#x02283;",
        # alias ISOTECH supe
        "SupersetEqual" => "&#x02287;",
        # alias ISOAMSR Sup
        "Supset" => "&#x022D1;",
        # alias ISOTECH sup
        "supset" => "&#x02283;",
        # alias ISOTECH supe
        "supseteq" => "&#x02287;",
        # alias ISOAMSR supE
        "supseteqq" => "&#x02AC6;",
        # alias ISOAMSN supne
        "supsetneq" => "&#x0228B;",
        # alias ISOAMSN supnE
        "supsetneqq" => "&#x02ACC;",
        # alias ISOAMSA swarr
        "swarrow" => "&#x02199;",
        # alias ISOTECH there4
        "Therefore" => "&#x02234;",
        # alias ISOTECH there4
        "therefore" => "&#x02234;",
        # ISOAMSR   thkap
        "thickapprox" => "&#x02248;",
        # ISOAMSR   thksim
        "thicksim" => "&#x0223C;",
        # space of width 3/18 em alias ISOPUB thinsp
        "ThinSpace" => "&#x02009;",
        # alias ISOTECH sim
        "Tilde" => "&#x0223C;",
        # alias ISOTECH sime
        "TildeEqual" => "&#x02243;",
        # alias ISOTECH cong
        "TildeFullEqual" => "&#x02245;",
        # alias ISOTECH ap
        "TildeTilde" => "&#x02248;",
        # alias ISOAMSA nesear
        "toea" => "&#x02928;",
        # alias ISOAMSA seswar
        "tosa" => "&#x02929;",
        # alias ISOPUB utri
        "triangle" => "&#x025B5;",
        # alias ISOPUB dtri
        "triangledown" => "&#x025BF;",
        # alias ISOPUB ltri
        "triangleleft" => "&#x025C3;",
        # alias ISOAMSR ltrie
        "trianglelefteq" => "&#x022B4;",
        # alias ISOAMSR trie
        "triangleq" => "&#x0225C;",
        # alias ISOPUB rtri
        "triangleright" => "&#x025B9;",
        # alias ISOAMSR rtrie
        "trianglerighteq" => "&#x022B5;",
        # alias ISOAMSA Larr
        "twoheadleftarrow" => "&#x0219E;",
        # alias ISOAMSA Rarr
        "twoheadrightarrow" => "&#x021A0;",
        # alias ISOAMSC ulcorn
        "ulcorner" => "&#x0231C;",
        # alias ISOAMSB xcup
        "Union" => "&#x022C3;",
        # alias ISOAMSB uplus
        "UnionPlus" => "&#x0228E;",
        # alias ISONUM uarr
        "UpArrow" => "&#x02191;",
        # alias ISOAMSA uArr
        "Uparrow" => "&#x021D1;",
        # alias ISONUM uarr
        "uparrow" => "&#x02191;",
        # alias ISOAMSA udarr
        "UpArrowDownArrow" => "&#x021C5;",
        # alias ISOAMSA varr
        "UpDownArrow" => "&#x02195;",
        # alias ISOAMSA vArr
        "Updownarrow" => "&#x021D5;",
        # alias ISOAMSA varr
        "updownarrow" => "&#x02195;",
        # alias ISOAMSA udhar
        "UpEquilibrium" => "&#x0296E;",
        # alias ISOAMSA uharl
        "upharpoonleft" => "&#x021BF;",
        # alias ISOAMSA uharr
        "upharpoonright" => "&#x021BE;",
        # alias ISOAMSA nwarr
        "UpperLeftArrow" => "&#x02196;",
        # alias ISOAMSA nearr
        "UpperRightArrow" => "&#x02197;",
        # alias ISOGRK3 upsi
        "upsilon" => "&#x003C5;",
        # alias ISOTECH perp
        "UpTee" => "&#x022A5;",
        # Alias mapstoup
        "UpTeeArrow" => "&#x021A5;",
        # alias ISOAMSA uuarr
        "upuparrows" => "&#x021C8;",
        # alias ISOAMSC urcorn
        "urcorner" => "&#x0231D;",
        # alias ISOGRK3 epsiv
        "varepsilon" => "&#x003B5;",
        # alias ISOGRK3 kappav
        "varkappa" => "&#x003F0;",
        # alias ISOAMSO emptyv
        "varnothing" => "&#x02205;",
        # alias ISOGRK3 phiv
        "varphi" => "&#x003C6;",
        # alias ISOGRK3 piv
        "varpi" => "&#x003D6;",
        # alias ISOAMSR vprop
        "varpropto" => "&#x0221D;",
        # alias ISOGRK3 rhov
        "varrho" => "&#x003F1;",
        # alias ISOGRK3 sigmav
        "varsigma" => "&#x003C2;",
        # alias ISOAMSN vsubne
        "varsubsetneq" => "&#x0228A;&#x0FE00;",
        # alias ISOAMSN vsubnE
        "varsubsetneqq" => "&#x02ACB;&#x0FE00;",
        # alias ISOAMSN vsupne
        "varsupsetneq" => "&#x0228B;&#x0FE00;",
        # alias ISOAMSN vsupnE
        "varsupsetneqq" => "&#x02ACC;&#x0FE00;",
        # alias ISOGRK3 thetav
        "vartheta" => "&#x003D1;",
        # alias ISOAMSR vltri
        "vartriangleleft" => "&#x022B2;",
        # alias ISOAMSR vrtri
        "vartriangleright" => "&#x022B3;",
        # alias ISOAMSB xvee
        "Vee" => "&#x022C1;",
        # alias ISOTECH or
        "vee" => "&#x02228;",
        # alias ISOTECH Verbar
        "Vert" => "&#x02016;",
        # alias ISONUM verbar
        "vert" => "&#x0007C;",
        # alias ISOAMSR mid
        "VerticalBar" => "&#x02223;",
        # alias ISOAMSB wreath
        "VerticalTilde" => "&#x02240;",
        # space of width 1/18 em alias ISOPUB hairsp
        "VeryThinSpace" => "&#x0200A;",
        # alias ISOAMSB xwedge
        "Wedge" => "&#x022C0;",
        # alias ISOTECH and
        "wedge" => "&#x02227;",
        # alias ISOAMSO weierp
        "wp" => "&#x02118;",
        # alias ISOAMSB wreath
        "wr" => "&#x02240;",
        # zee transform
        "zeetrf" => "&#x02128;",
        # character showing function application in presentation tagging
        "af" => "&#x02061;",
        # 
        "aopf" => "&#x1D552;",
        # Old ISOAMSR asymp (for HTML compatibility)
        "asympeq" => "&#x0224D;",
        # 
        "bopf" => "&#x1D553;",
        # 
        "copf" => "&#x1D554;",
        # cross or vector product
        "Cross" => "&#x02A2F;",
        # D for use in differentials, e.g., within integrals
        "DD" => "&#x02145;",
        # d for use in differentials, e.g., within integrals
        "dd" => "&#x02146;",
        # 
        "dopf" => "&#x1D555;",
        # down arrow to bar
        "DownArrowBar" => "&#x02913;",
        # left-down-right-down harpoon
        "DownLeftRightVector" => "&#x02950;",
        # left-down harpoon from bar
        "DownLeftTeeVector" => "&#x0295E;",
        # left-down harpoon to bar
        "DownLeftVectorBar" => "&#x02956;",
        # right-down harpoon from bar
        "DownRightTeeVector" => "&#x0295F;",
        # right-down harpoon to bar
        "DownRightVectorBar" => "&#x02957;",
        # e use for the exponential base of the natural logarithms
        "ee" => "&#x02147;",
        # empty small square
        "EmptySmallSquare" => "&#x025FB;",
        # empty small square
        "EmptyVerySmallSquare" => "&#x025AB;",
        # 
        "eopf" => "&#x1D556;",
        # two consecutive equal signs
        "Equal" => "&#x02A75;",
        # filled small square
        "FilledSmallSquare" => "&#x025FC;",
        # filled very small square
        "FilledVerySmallSquare" => "&#x025AA;",
        # 
        "fopf" => "&#x1D557;",
        # 
        "gopf" => "&#x1D558;",
        # alias for GT
        "GreaterGreater" => "&#x02AA2;",
        # circumflex accent
        "Hat" => "&#x0005E;",
        # 
        "hopf" => "&#x1D559;",
        # short horizontal line
        "HorizontalLine" => "&#x02500;",
        # short form of  &InvisibleComma;
        "ic" => "&#x02063;",
        # i for use as a square root of -1
        "ii" => "&#x02148;",
        # 
        "iopf" => "&#x1D55A;",
        # marks multiplication when it is understood without a mark
        "it" => "&#x02062;",
        # 
        "jopf" => "&#x1D55B;",
        # 
        "kopf" => "&#x1D55C;",
        # leftwards arrow to bar
        "larrb" => "&#x021E4;",
        # down-left harpoon from bar
        "LeftDownTeeVector" => "&#x02961;",
        # down-left harpoon to bar
        "LeftDownVectorBar" => "&#x02959;",
        # left-up-right-up harpoon
        "LeftRightVector" => "&#x0294E;",
        # left-up harpoon from bar
        "LeftTeeVector" => "&#x0295A;",
        # left triangle, vertical bar
        "LeftTriangleBar" => "&#x029CF;",
        # up-left-down-left harpoon
        "LeftUpDownVector" => "&#x02951;",
        # up-left harpoon from bar
        "LeftUpTeeVector" => "&#x02960;",
        # up-left harpoon to bar
        "LeftUpVectorBar" => "&#x02958;",
        # left-up harpoon to bar
        "LeftVectorBar" => "&#x02952;",
        # alias for Lt
        "LessLess" => "&#x02AA1;",
        # 
        "lopf" => "&#x1D55D;",
        # downwards arrow from bar
        "mapstodown" => "&#x021A7;",
        # leftwards arrow from bar
        "mapstoleft" => "&#x021A4;",
        # upwards arrow from bar
        "mapstoup" => "&#x021A5;",
        # space of width 4/18 em
        "MediumSpace" => "&#x0205F;",
        # 
        "mopf" => "&#x1D55E;",
        # not bumpy equals
        "nbump" => "&#x0224E;&#x00338;",
        # not bumpy single equals
        "nbumpe" => "&#x0224F;&#x00338;",
        # not equal or similar
        "nesim" => "&#x02242;&#x00338;",
        # force a line break; line feed
        "NewLine" => "&#x0000A;",
        # never break line here
        "NoBreak" => "&#x02060;",
        # 
        "nopf" => "&#x1D55F;",
        # alias for &nasymp;
        "NotCupCap" => "&#x0226D;",
        # alias for &nbumpe;
        "NotHumpEqual" => "&#x0224F;&#x00338;",
        # not left triangle, vertical bar
        "NotLeftTriangleBar" => "&#x029CF;&#x00338;",
        # not double greater-than sign
        "NotNestedGreaterGreater" => "&#x02AA2;&#x00338;",
        # not double less-than sign
        "NotNestedLessLess" => "&#x02AA1;&#x00338;",
        # not vertical bar, right triangle
        "NotRightTriangleBar" => "&#x029D0;&#x00338;",
        # square not subset
        "NotSquareSubset" => "&#x0228F;&#x00338;",
        # negated set-like partial order operator
        "NotSquareSuperset" => "&#x02290;&#x00338;",
        # not succeeds or similar
        "NotSucceedsTilde" => "&#x0227F;&#x00338;",
        # 
        "oopf" => "&#x1D560;",
        # over bar
        "OverBar" => "&#x000AF;",
        # over brace
        "OverBrace" => "&#x0FE37;",
        # over bracket
        "OverBracket" => "&#x023B4;",
        # over parenthesis
        "OverParenthesis" => "&#x0FE35;",
        # the ring (skew field) of quaternions
        "planckh" => "&#x0210E;",
        # 
        "popf" => "&#x1D561;",
        # alias for &prod;
        "Product" => "&#x0220F;",
        # 
        "qopf" => "&#x1D562;",
        # leftwards arrow to bar
        "rarrb" => "&#x021E5;",
        # down-right harpoon from bar
        "RightDownTeeVector" => "&#x0295D;",
        # down-right harpoon to bar
        "RightDownVectorBar" => "&#x02955;",
        # right-up harpoon from bar
        "RightTeeVector" => "&#x0295B;",
        # vertical bar, right triangle
        "RightTriangleBar" => "&#x029D0;",
        # up-right-down-right harpoon
        "RightUpDownVector" => "&#x0294F;",
        # up-right harpoon from bar
        "RightUpTeeVector" => "&#x0295C;",
        # up-right harpoon to bar
        "RightUpVectorBar" => "&#x02954;",
        # up-right harpoon to bar
        "RightVectorBar" => "&#x02953;",
        # 
        "ropf" => "&#x1D563;",
        # round implies
        "RoundImplies" => "&#x02970;",
        # rule-delayed (colon right arrow)
        "RuleDelayed" => "&#x029F4;",
        # 
        "sopf" => "&#x1D564;",
        # tabulator stop; horizontal tabulation
        "Tab" => "&#x00009;",
        # space of width 5/18 em
        "ThickSpace" => "&#x02009;&#x0200A;&#x0200A;",
        # 
        "topf" => "&#x1D565;",
        # under brace
        "UnderBrace" => "&#x0FE38;",
        # under bracket
        "UnderBracket" => "&#x023B5;",
        # under parenthesis
        "UnderParenthesis" => "&#x0FE36;",
        # 
        "uopf" => "&#x1D566;",
        # up arrow to bar
        "UpArrowBar" => "&#x02912;",
        # ISOGRK1 Ugr, HTML4 Upsilon
        "Upsilon" => "&#x003A5;",
        # alias ISONUM verbar
        "VerticalLine" => "&#x0007C;",
        # vertical separating operator
        "VerticalSeparator" => "&#x02758;",
        # 
        "vopf" => "&#x1D567;",
        # 
        "wopf" => "&#x1D568;",
        # 
        "xopf" => "&#x1D569;",
        # 
        "yopf" => "&#x1D56A;",
        # zero width space
        "ZeroWidthSpace" => "&#x0200B;",
        # 
        "zopf" => "&#x1D56B;",
      }
      LIST = <<ENTITY_LIST
<table class="entity">
  <tr>
    <th>Name</th>
    <th>Value</th>
    <th>Result</th>
    <th>Comment</th>
  </tr>
  <tr>
    <td>angzarr</td>
    <td>&amp;#x0237C;</td>
    <td>&#x0237C;</td>
    <td>angle with down zig-zag arrow</td>
  </tr>
  <tr>
    <td>cirmid</td>
    <td>&amp;#x02AEF;</td>
    <td>&#x02AEF;</td>
    <td>circle, mid below</td>
  </tr>
  <tr>
    <td>cudarrl</td>
    <td>&amp;#x02938;</td>
    <td>&#x02938;</td>
    <td>left, curved, down arrow</td>
  </tr>
  <tr>
    <td>cudarrr</td>
    <td>&amp;#x02935;</td>
    <td>&#x02935;</td>
    <td>right, curved, down arrow</td>
  </tr>
  <tr>
    <td>cularr</td>
    <td>&amp;#x021B6;</td>
    <td>&#x021B6;</td>
    <td>/curvearrowleft A: left curved arrow</td>
  </tr>
  <tr>
    <td>cularrp</td>
    <td>&amp;#x0293D;</td>
    <td>&#x0293D;</td>
    <td>curved left arrow with plus</td>
  </tr>
  <tr>
    <td>curarr</td>
    <td>&amp;#x021B7;</td>
    <td>&#x021B7;</td>
    <td>/curvearrowright A: rt curved arrow</td>
  </tr>
  <tr>
    <td>curarrm</td>
    <td>&amp;#x0293C;</td>
    <td>&#x0293C;</td>
    <td>curved right arrow with minus</td>
  </tr>
  <tr>
    <td>Darr</td>
    <td>&amp;#x021A1;</td>
    <td>&#x021A1;</td>
    <td>down two-headed arrow</td>
  </tr>
  <tr>
    <td>dArr</td>
    <td>&amp;#x021D3;</td>
    <td>&#x021D3;</td>
    <td>/Downarrow A: down dbl arrow</td>
  </tr>
  <tr>
    <td>ddarr</td>
    <td>&amp;#x021CA;</td>
    <td>&#x021CA;</td>
    <td>/downdownarrows A: two down arrows</td>
  </tr>
  <tr>
    <td>DDotrahd</td>
    <td>&amp;#x02911;</td>
    <td>&#x02911;</td>
    <td>right arrow with dotted stem</td>
  </tr>
  <tr>
    <td>dfisht</td>
    <td>&amp;#x0297F;</td>
    <td>&#x0297F;</td>
    <td>down fish tail</td>
  </tr>
  <tr>
    <td>dHar</td>
    <td>&amp;#x02965;</td>
    <td>&#x02965;</td>
    <td>down harpoon-left, down harpoon-right</td>
  </tr>
  <tr>
    <td>dharl</td>
    <td>&amp;#x021C3;</td>
    <td>&#x021C3;</td>
    <td>/downharpoonleft A: dn harpoon-left</td>
  </tr>
  <tr>
    <td>dharr</td>
    <td>&amp;#x021C2;</td>
    <td>&#x021C2;</td>
    <td>/downharpoonright A: down harpoon-rt</td>
  </tr>
  <tr>
    <td>duarr</td>
    <td>&amp;#x021F5;</td>
    <td>&#x021F5;</td>
    <td>down arrow, up arrow</td>
  </tr>
  <tr>
    <td>duhar</td>
    <td>&amp;#x0296F;</td>
    <td>&#x0296F;</td>
    <td>down harp, up harp</td>
  </tr>
  <tr>
    <td>dzigrarr</td>
    <td>&amp;#x027FF;</td>
    <td>&#x027FF;</td>
    <td>right long zig-zag arrow</td>
  </tr>
  <tr>
    <td>erarr</td>
    <td>&amp;#x02971;</td>
    <td>&#x02971;</td>
    <td>equal, right arrow below</td>
  </tr>
  <tr>
    <td>hArr</td>
    <td>&amp;#x021D4;</td>
    <td>&#x021D4;</td>
    <td>/Leftrightarrow A: l&amp;r dbl arrow</td>
  </tr>
  <tr>
    <td>harr</td>
    <td>&amp;#x02194;</td>
    <td>&#x02194;</td>
    <td>/leftrightarrow A: l&amp;r arrow</td>
  </tr>
  <tr>
    <td>harrcir</td>
    <td>&amp;#x02948;</td>
    <td>&#x02948;</td>
    <td>left and right arrow with a circle</td>
  </tr>
  <tr>
    <td>harrw</td>
    <td>&amp;#x021AD;</td>
    <td>&#x021AD;</td>
    <td>/leftrightsquigarrow A: l&amp;r arr-wavy</td>
  </tr>
  <tr>
    <td>hoarr</td>
    <td>&amp;#x021FF;</td>
    <td>&#x021FF;</td>
    <td>horizontal open arrow</td>
  </tr>
  <tr>
    <td>imof</td>
    <td>&amp;#x022B7;</td>
    <td>&#x022B7;</td>
    <td>image of</td>
  </tr>
  <tr>
    <td>lAarr</td>
    <td>&amp;#x021DA;</td>
    <td>&#x021DA;</td>
    <td>/Lleftarrow A: left triple arrow</td>
  </tr>
  <tr>
    <td>Larr</td>
    <td>&amp;#x0219E;</td>
    <td>&#x0219E;</td>
    <td>/twoheadleftarrow A:</td>
  </tr>
  <tr>
    <td>larrbfs</td>
    <td>&amp;#x0291F;</td>
    <td>&#x0291F;</td>
    <td>left arrow-bar, filled square</td>
  </tr>
  <tr>
    <td>larrfs</td>
    <td>&amp;#x0291D;</td>
    <td>&#x0291D;</td>
    <td>left arrow, filled square</td>
  </tr>
  <tr>
    <td>larrhk</td>
    <td>&amp;#x021A9;</td>
    <td>&#x021A9;</td>
    <td>/hookleftarrow A: left arrow-hooked</td>
  </tr>
  <tr>
    <td>larrlp</td>
    <td>&amp;#x021AB;</td>
    <td>&#x021AB;</td>
    <td>/looparrowleft A: left arrow-looped</td>
  </tr>
  <tr>
    <td>larrpl</td>
    <td>&amp;#x02939;</td>
    <td>&#x02939;</td>
    <td>left arrow, plus</td>
  </tr>
  <tr>
    <td>larrsim</td>
    <td>&amp;#x02973;</td>
    <td>&#x02973;</td>
    <td>left arrow, similar</td>
  </tr>
  <tr>
    <td>larrtl</td>
    <td>&amp;#x021A2;</td>
    <td>&#x021A2;</td>
    <td>/leftarrowtail A: left arrow-tailed</td>
  </tr>
  <tr>
    <td>lAtail</td>
    <td>&amp;#x0291B;</td>
    <td>&#x0291B;</td>
    <td>left double arrow-tail</td>
  </tr>
  <tr>
    <td>latail</td>
    <td>&amp;#x02919;</td>
    <td>&#x02919;</td>
    <td>left arrow-tail</td>
  </tr>
  <tr>
    <td>lBarr</td>
    <td>&amp;#x0290E;</td>
    <td>&#x0290E;</td>
    <td>left doubly broken arrow</td>
  </tr>
  <tr>
    <td>lbarr</td>
    <td>&amp;#x0290C;</td>
    <td>&#x0290C;</td>
    <td>left broken arrow</td>
  </tr>
  <tr>
    <td>ldca</td>
    <td>&amp;#x02936;</td>
    <td>&#x02936;</td>
    <td>left down curved arrow</td>
  </tr>
  <tr>
    <td>ldrdhar</td>
    <td>&amp;#x02967;</td>
    <td>&#x02967;</td>
    <td>left harpoon-down over right harpoon-down</td>
  </tr>
  <tr>
    <td>ldrushar</td>
    <td>&amp;#x0294B;</td>
    <td>&#x0294B;</td>
    <td>left-down-right-up harpoon</td>
  </tr>
  <tr>
    <td>ldsh</td>
    <td>&amp;#x021B2;</td>
    <td>&#x021B2;</td>
    <td>left down angled arrow</td>
  </tr>
  <tr>
    <td>lfisht</td>
    <td>&amp;#x0297C;</td>
    <td>&#x0297C;</td>
    <td>left fish tail</td>
  </tr>
  <tr>
    <td>lHar</td>
    <td>&amp;#x02962;</td>
    <td>&#x02962;</td>
    <td>left harpoon-up over left harpoon-down</td>
  </tr>
  <tr>
    <td>lhard</td>
    <td>&amp;#x021BD;</td>
    <td>&#x021BD;</td>
    <td>/leftharpoondown A: l harpoon-down</td>
  </tr>
  <tr>
    <td>lharu</td>
    <td>&amp;#x021BC;</td>
    <td>&#x021BC;</td>
    <td>/leftharpoonup A: left harpoon-up</td>
  </tr>
  <tr>
    <td>lharul</td>
    <td>&amp;#x0296A;</td>
    <td>&#x0296A;</td>
    <td>left harpoon-up over long dash</td>
  </tr>
  <tr>
    <td>llarr</td>
    <td>&amp;#x021C7;</td>
    <td>&#x021C7;</td>
    <td>/leftleftarrows A: two left arrows</td>
  </tr>
  <tr>
    <td>llhard</td>
    <td>&amp;#x0296B;</td>
    <td>&#x0296B;</td>
    <td>left harpoon-down below long dash</td>
  </tr>
  <tr>
    <td>loarr</td>
    <td>&amp;#x021FD;</td>
    <td>&#x021FD;</td>
    <td>left open arrow</td>
  </tr>
  <tr>
    <td>lrarr</td>
    <td>&amp;#x021C6;</td>
    <td>&#x021C6;</td>
    <td>/leftrightarrows A: l arr over r arr</td>
  </tr>
  <tr>
    <td>lrhar</td>
    <td>&amp;#x021CB;</td>
    <td>&#x021CB;</td>
    <td>/leftrightharpoons A: l harp over r</td>
  </tr>
  <tr>
    <td>lrhard</td>
    <td>&amp;#x0296D;</td>
    <td>&#x0296D;</td>
    <td>right harpoon-down below long dash</td>
  </tr>
  <tr>
    <td>lsh</td>
    <td>&amp;#x021B0;</td>
    <td>&#x021B0;</td>
    <td>/Lsh A:</td>
  </tr>
  <tr>
    <td>lurdshar</td>
    <td>&amp;#x0294A;</td>
    <td>&#x0294A;</td>
    <td>left-up-right-down harpoon</td>
  </tr>
  <tr>
    <td>luruhar</td>
    <td>&amp;#x02966;</td>
    <td>&#x02966;</td>
    <td>left harpoon-up over right harpoon-up</td>
  </tr>
  <tr>
    <td>Map</td>
    <td>&amp;#x02905;</td>
    <td>&#x02905;</td>
    <td>twoheaded mapsto</td>
  </tr>
  <tr>
    <td>map</td>
    <td>&amp;#x021A6;</td>
    <td>&#x021A6;</td>
    <td>/mapsto A:</td>
  </tr>
  <tr>
    <td>midcir</td>
    <td>&amp;#x02AF0;</td>
    <td>&#x02AF0;</td>
    <td>mid, circle below</td>
  </tr>
  <tr>
    <td>mumap</td>
    <td>&amp;#x022B8;</td>
    <td>&#x022B8;</td>
    <td>/multimap A:</td>
  </tr>
  <tr>
    <td>nearhk</td>
    <td>&amp;#x02924;</td>
    <td>&#x02924;</td>
    <td>NE arrow-hooked</td>
  </tr>
  <tr>
    <td>neArr</td>
    <td>&amp;#x021D7;</td>
    <td>&#x021D7;</td>
    <td>NE pointing dbl arrow</td>
  </tr>
  <tr>
    <td>nearr</td>
    <td>&amp;#x02197;</td>
    <td>&#x02197;</td>
    <td>/nearrow A: NE pointing arrow</td>
  </tr>
  <tr>
    <td>nesear</td>
    <td>&amp;#x02928;</td>
    <td>&#x02928;</td>
    <td>/toea A: NE &amp; SE arrows</td>
  </tr>
  <tr>
    <td>nhArr</td>
    <td>&amp;#x021CE;</td>
    <td>&#x021CE;</td>
    <td>/nLeftrightarrow A: not l&amp;r dbl arr</td>
  </tr>
  <tr>
    <td>nharr</td>
    <td>&amp;#x021AE;</td>
    <td>&#x021AE;</td>
    <td>/nleftrightarrow A: not l&amp;r arrow</td>
  </tr>
  <tr>
    <td>nlArr</td>
    <td>&amp;#x021CD;</td>
    <td>&#x021CD;</td>
    <td>/nLeftarrow A: not implied by</td>
  </tr>
  <tr>
    <td>nlarr</td>
    <td>&amp;#x0219A;</td>
    <td>&#x0219A;</td>
    <td>/nleftarrow A: not left arrow</td>
  </tr>
  <tr>
    <td>nrArr</td>
    <td>&amp;#x021CF;</td>
    <td>&#x021CF;</td>
    <td>/nRightarrow A: not implies</td>
  </tr>
  <tr>
    <td>nrarr</td>
    <td>&amp;#x0219B;</td>
    <td>&#x0219B;</td>
    <td>/nrightarrow A: not right arrow</td>
  </tr>
  <tr>
    <td>nrarrc</td>
    <td>&amp;#x02933;&amp;#x00338;</td>
    <td>&#x02933;&#x00338;</td>
    <td>not right arrow-curved</td>
  </tr>
  <tr>
    <td>nrarrw</td>
    <td>&amp;#x0219D;&amp;#x00338;</td>
    <td>&#x0219D;&#x00338;</td>
    <td>not right arrow-wavy</td>
  </tr>
  <tr>
    <td>nvHarr</td>
    <td>&amp;#x02904;</td>
    <td>&#x02904;</td>
    <td>not, vert, left and right double arrow</td>
  </tr>
  <tr>
    <td>nvlArr</td>
    <td>&amp;#x02902;</td>
    <td>&#x02902;</td>
    <td>not, vert, left double arrow</td>
  </tr>
  <tr>
    <td>nvrArr</td>
    <td>&amp;#x02903;</td>
    <td>&#x02903;</td>
    <td>not, vert, right double arrow</td>
  </tr>
  <tr>
    <td>nwarhk</td>
    <td>&amp;#x02923;</td>
    <td>&#x02923;</td>
    <td>NW arrow-hooked</td>
  </tr>
  <tr>
    <td>nwArr</td>
    <td>&amp;#x021D6;</td>
    <td>&#x021D6;</td>
    <td>NW pointing dbl arrow</td>
  </tr>
  <tr>
    <td>nwarr</td>
    <td>&amp;#x02196;</td>
    <td>&#x02196;</td>
    <td>/nwarrow A: NW pointing arrow</td>
  </tr>
  <tr>
    <td>nwnear</td>
    <td>&amp;#x02927;</td>
    <td>&#x02927;</td>
    <td>NW &amp; NE arrows</td>
  </tr>
  <tr>
    <td>olarr</td>
    <td>&amp;#x021BA;</td>
    <td>&#x021BA;</td>
    <td>/circlearrowleft A: l arr in circle</td>
  </tr>
  <tr>
    <td>orarr</td>
    <td>&amp;#x021BB;</td>
    <td>&#x021BB;</td>
    <td>/circlearrowright A: r arr in circle</td>
  </tr>
  <tr>
    <td>origof</td>
    <td>&amp;#x022B6;</td>
    <td>&#x022B6;</td>
    <td>original of</td>
  </tr>
  <tr>
    <td>rAarr</td>
    <td>&amp;#x021DB;</td>
    <td>&#x021DB;</td>
    <td>/Rrightarrow A: right triple arrow</td>
  </tr>
  <tr>
    <td>Rarr</td>
    <td>&amp;#x021A0;</td>
    <td>&#x021A0;</td>
    <td>/twoheadrightarrow A:</td>
  </tr>
  <tr>
    <td>rarrap</td>
    <td>&amp;#x02975;</td>
    <td>&#x02975;</td>
    <td>approximate, right arrow above</td>
  </tr>
  <tr>
    <td>rarrbfs</td>
    <td>&amp;#x02920;</td>
    <td>&#x02920;</td>
    <td>right arrow-bar, filled square</td>
  </tr>
  <tr>
    <td>rarrc</td>
    <td>&amp;#x02933;</td>
    <td>&#x02933;</td>
    <td>right arrow-curved</td>
  </tr>
  <tr>
    <td>rarrfs</td>
    <td>&amp;#x0291E;</td>
    <td>&#x0291E;</td>
    <td>right arrow, filled square</td>
  </tr>
  <tr>
    <td>rarrhk</td>
    <td>&amp;#x021AA;</td>
    <td>&#x021AA;</td>
    <td>/hookrightarrow A: rt arrow-hooked</td>
  </tr>
  <tr>
    <td>rarrlp</td>
    <td>&amp;#x021AC;</td>
    <td>&#x021AC;</td>
    <td>/looparrowright A: rt arrow-looped</td>
  </tr>
  <tr>
    <td>rarrpl</td>
    <td>&amp;#x02945;</td>
    <td>&#x02945;</td>
    <td>right arrow, plus</td>
  </tr>
  <tr>
    <td>rarrsim</td>
    <td>&amp;#x02974;</td>
    <td>&#x02974;</td>
    <td>right arrow, similar</td>
  </tr>
  <tr>
    <td>Rarrtl</td>
    <td>&amp;#x02916;</td>
    <td>&#x02916;</td>
    <td>right two-headed arrow with tail</td>
  </tr>
  <tr>
    <td>rarrtl</td>
    <td>&amp;#x021A3;</td>
    <td>&#x021A3;</td>
    <td>/rightarrowtail A: rt arrow-tailed</td>
  </tr>
  <tr>
    <td>rarrw</td>
    <td>&amp;#x0219D;</td>
    <td>&#x0219D;</td>
    <td>/rightsquigarrow A: rt arrow-wavy</td>
  </tr>
  <tr>
    <td>rAtail</td>
    <td>&amp;#x0291C;</td>
    <td>&#x0291C;</td>
    <td>right double arrow-tail</td>
  </tr>
  <tr>
    <td>ratail</td>
    <td>&amp;#x0291A;</td>
    <td>&#x0291A;</td>
    <td>right arrow-tail</td>
  </tr>
  <tr>
    <td>RBarr</td>
    <td>&amp;#x02910;</td>
    <td>&#x02910;</td>
    <td>/drbkarow A: twoheaded right broken arrow</td>
  </tr>
  <tr>
    <td>rBarr</td>
    <td>&amp;#x0290F;</td>
    <td>&#x0290F;</td>
    <td>/dbkarow A: right doubly broken arrow</td>
  </tr>
  <tr>
    <td>rbarr</td>
    <td>&amp;#x0290D;</td>
    <td>&#x0290D;</td>
    <td>/bkarow A: right broken arrow</td>
  </tr>
  <tr>
    <td>rdca</td>
    <td>&amp;#x02937;</td>
    <td>&#x02937;</td>
    <td>right down curved arrow</td>
  </tr>
  <tr>
    <td>rdldhar</td>
    <td>&amp;#x02969;</td>
    <td>&#x02969;</td>
    <td>right harpoon-down over left harpoon-down</td>
  </tr>
  <tr>
    <td>rdsh</td>
    <td>&amp;#x021B3;</td>
    <td>&#x021B3;</td>
    <td>right down angled arrow</td>
  </tr>
  <tr>
    <td>rfisht</td>
    <td>&amp;#x0297D;</td>
    <td>&#x0297D;</td>
    <td>right fish tail</td>
  </tr>
  <tr>
    <td>rHar</td>
    <td>&amp;#x02964;</td>
    <td>&#x02964;</td>
    <td>right harpoon-up over right harpoon-down</td>
  </tr>
  <tr>
    <td>rhard</td>
    <td>&amp;#x021C1;</td>
    <td>&#x021C1;</td>
    <td>/rightharpoondown A: rt harpoon-down</td>
  </tr>
  <tr>
    <td>rharu</td>
    <td>&amp;#x021C0;</td>
    <td>&#x021C0;</td>
    <td>/rightharpoonup A: rt harpoon-up</td>
  </tr>
  <tr>
    <td>rharul</td>
    <td>&amp;#x0296C;</td>
    <td>&#x0296C;</td>
    <td>right harpoon-up over long dash</td>
  </tr>
  <tr>
    <td>rlarr</td>
    <td>&amp;#x021C4;</td>
    <td>&#x021C4;</td>
    <td>/rightleftarrows A: r arr over l arr</td>
  </tr>
  <tr>
    <td>rlhar</td>
    <td>&amp;#x021CC;</td>
    <td>&#x021CC;</td>
    <td>/rightleftharpoons A: r harp over l</td>
  </tr>
  <tr>
    <td>roarr</td>
    <td>&amp;#x021FE;</td>
    <td>&#x021FE;</td>
    <td>right open arrow</td>
  </tr>
  <tr>
    <td>rrarr</td>
    <td>&amp;#x021C9;</td>
    <td>&#x021C9;</td>
    <td>/rightrightarrows A: two rt arrows</td>
  </tr>
  <tr>
    <td>rsh</td>
    <td>&amp;#x021B1;</td>
    <td>&#x021B1;</td>
    <td>/Rsh A:</td>
  </tr>
  <tr>
    <td>ruluhar</td>
    <td>&amp;#x02968;</td>
    <td>&#x02968;</td>
    <td>right harpoon-up over left harpoon-up</td>
  </tr>
  <tr>
    <td>searhk</td>
    <td>&amp;#x02925;</td>
    <td>&#x02925;</td>
    <td>/hksearow A: SE arrow-hooken</td>
  </tr>
  <tr>
    <td>seArr</td>
    <td>&amp;#x021D8;</td>
    <td>&#x021D8;</td>
    <td>SE pointing dbl arrow</td>
  </tr>
  <tr>
    <td>searr</td>
    <td>&amp;#x02198;</td>
    <td>&#x02198;</td>
    <td>/searrow A: SE pointing arrow</td>
  </tr>
  <tr>
    <td>seswar</td>
    <td>&amp;#x02929;</td>
    <td>&#x02929;</td>
    <td>/tosa A: SE &amp; SW arrows</td>
  </tr>
  <tr>
    <td>simrarr</td>
    <td>&amp;#x02972;</td>
    <td>&#x02972;</td>
    <td>similar, right arrow below</td>
  </tr>
  <tr>
    <td>slarr</td>
    <td>&amp;#x02190;</td>
    <td>&#x02190;</td>
    <td>short left arrow</td>
  </tr>
  <tr>
    <td>srarr</td>
    <td>&amp;#x02192;</td>
    <td>&#x02192;</td>
    <td>short right arrow</td>
  </tr>
  <tr>
    <td>swarhk</td>
    <td>&amp;#x02926;</td>
    <td>&#x02926;</td>
    <td>/hkswarow A: SW arrow-hooked</td>
  </tr>
  <tr>
    <td>swArr</td>
    <td>&amp;#x021D9;</td>
    <td>&#x021D9;</td>
    <td>SW pointing dbl arrow</td>
  </tr>
  <tr>
    <td>swarr</td>
    <td>&amp;#x02199;</td>
    <td>&#x02199;</td>
    <td>/swarrow A: SW pointing arrow</td>
  </tr>
  <tr>
    <td>swnwar</td>
    <td>&amp;#x0292A;</td>
    <td>&#x0292A;</td>
    <td>SW &amp; NW arrows</td>
  </tr>
  <tr>
    <td>Uarr</td>
    <td>&amp;#x0219F;</td>
    <td>&#x0219F;</td>
    <td>up two-headed arrow</td>
  </tr>
  <tr>
    <td>uArr</td>
    <td>&amp;#x021D1;</td>
    <td>&#x021D1;</td>
    <td>/Uparrow A: up dbl arrow</td>
  </tr>
  <tr>
    <td>Uarrocir</td>
    <td>&amp;#x02949;</td>
    <td>&#x02949;</td>
    <td>up two-headed arrow above circle</td>
  </tr>
  <tr>
    <td>udarr</td>
    <td>&amp;#x021C5;</td>
    <td>&#x021C5;</td>
    <td>up arrow, down arrow</td>
  </tr>
  <tr>
    <td>udhar</td>
    <td>&amp;#x0296E;</td>
    <td>&#x0296E;</td>
    <td>up harp, down harp</td>
  </tr>
  <tr>
    <td>ufisht</td>
    <td>&amp;#x0297E;</td>
    <td>&#x0297E;</td>
    <td>up fish tail</td>
  </tr>
  <tr>
    <td>uHar</td>
    <td>&amp;#x02963;</td>
    <td>&#x02963;</td>
    <td>up harpoon-left, up harpoon-right</td>
  </tr>
  <tr>
    <td>uharl</td>
    <td>&amp;#x021BF;</td>
    <td>&#x021BF;</td>
    <td>/upharpoonleft A: up harpoon-left</td>
  </tr>
  <tr>
    <td>uharr</td>
    <td>&amp;#x021BE;</td>
    <td>&#x021BE;</td>
    <td>/upharpoonright /restriction A: up harp-r</td>
  </tr>
  <tr>
    <td>uuarr</td>
    <td>&amp;#x021C8;</td>
    <td>&#x021C8;</td>
    <td>/upuparrows A: two up arrows</td>
  </tr>
  <tr>
    <td>vArr</td>
    <td>&amp;#x021D5;</td>
    <td>&#x021D5;</td>
    <td>/Updownarrow A: up&amp;down dbl arrow</td>
  </tr>
  <tr>
    <td>varr</td>
    <td>&amp;#x02195;</td>
    <td>&#x02195;</td>
    <td>/updownarrow A: up&amp;down arrow</td>
  </tr>
  <tr>
    <td>xhArr</td>
    <td>&amp;#x027FA;</td>
    <td>&#x027FA;</td>
    <td>/Longleftrightarrow A: long l&amp;r dbl arr</td>
  </tr>
  <tr>
    <td>xharr</td>
    <td>&amp;#x027F7;</td>
    <td>&#x027F7;</td>
    <td>/longleftrightarrow A: long l&amp;r arr</td>
  </tr>
  <tr>
    <td>xlArr</td>
    <td>&amp;#x027F8;</td>
    <td>&#x027F8;</td>
    <td>/Longleftarrow A: long l dbl arrow</td>
  </tr>
  <tr>
    <td>xlarr</td>
    <td>&amp;#x027F5;</td>
    <td>&#x027F5;</td>
    <td>/longleftarrow A: long left arrow</td>
  </tr>
  <tr>
    <td>xmap</td>
    <td>&amp;#x027FC;</td>
    <td>&#x027FC;</td>
    <td>/longmapsto A:</td>
  </tr>
  <tr>
    <td>xrArr</td>
    <td>&amp;#x027F9;</td>
    <td>&#x027F9;</td>
    <td>/Longrightarrow A: long rt dbl arr</td>
  </tr>
  <tr>
    <td>xrarr</td>
    <td>&amp;#x027F6;</td>
    <td>&#x027F6;</td>
    <td>/longrightarrow A: long right arrow</td>
  </tr>
  <tr>
    <td>zigrarr</td>
    <td>&amp;#x021DD;</td>
    <td>&#x021DD;</td>
    <td>right zig-zag arrow</td>
  </tr>
  <tr>
    <td>ac</td>
    <td>&amp;#x0223E;</td>
    <td>&#x0223E;</td>
    <td>most positive</td>
  </tr>
  <tr>
    <td>acE</td>
    <td>&amp;#x0223E;&amp;#x00333;</td>
    <td>&#x0223E;&#x00333;</td>
    <td>most positive, two lines below</td>
  </tr>
  <tr>
    <td>amalg</td>
    <td>&amp;#x02A3F;</td>
    <td>&#x02A3F;</td>
    <td>/amalg B: amalgamation or coproduct</td>
  </tr>
  <tr>
    <td>barvee</td>
    <td>&amp;#x022BD;</td>
    <td>&#x022BD;</td>
    <td>bar, vee</td>
  </tr>
  <tr>
    <td>Barwed</td>
    <td>&amp;#x02306;</td>
    <td>&#x02306;</td>
    <td>/doublebarwedge B: log and, dbl bar above</td>
  </tr>
  <tr>
    <td>barwed</td>
    <td>&amp;#x02305;</td>
    <td>&#x02305;</td>
    <td>/barwedge B: logical and, bar above</td>
  </tr>
  <tr>
    <td>bsolb</td>
    <td>&amp;#x029C5;</td>
    <td>&#x029C5;</td>
    <td>reverse solidus in square</td>
  </tr>
  <tr>
    <td>Cap</td>
    <td>&amp;#x022D2;</td>
    <td>&#x022D2;</td>
    <td>/Cap /doublecap B: dbl intersection</td>
  </tr>
  <tr>
    <td>capand</td>
    <td>&amp;#x02A44;</td>
    <td>&#x02A44;</td>
    <td>intersection, and</td>
  </tr>
  <tr>
    <td>capbrcup</td>
    <td>&amp;#x02A49;</td>
    <td>&#x02A49;</td>
    <td>intersection, bar, union</td>
  </tr>
  <tr>
    <td>capcap</td>
    <td>&amp;#x02A4B;</td>
    <td>&#x02A4B;</td>
    <td>intersection, intersection, joined</td>
  </tr>
  <tr>
    <td>capcup</td>
    <td>&amp;#x02A47;</td>
    <td>&#x02A47;</td>
    <td>intersection above union</td>
  </tr>
  <tr>
    <td>capdot</td>
    <td>&amp;#x02A40;</td>
    <td>&#x02A40;</td>
    <td>intersection, with dot</td>
  </tr>
  <tr>
    <td>caps</td>
    <td>&amp;#x02229;&amp;#x0FE00;</td>
    <td>&#x02229;&#x0FE00;</td>
    <td>intersection, serifs</td>
  </tr>
  <tr>
    <td>ccaps</td>
    <td>&amp;#x02A4D;</td>
    <td>&#x02A4D;</td>
    <td>closed intersection, serifs</td>
  </tr>
  <tr>
    <td>ccups</td>
    <td>&amp;#x02A4C;</td>
    <td>&#x02A4C;</td>
    <td>closed union, serifs</td>
  </tr>
  <tr>
    <td>ccupssm</td>
    <td>&amp;#x02A50;</td>
    <td>&#x02A50;</td>
    <td>closed union, serifs, smash product</td>
  </tr>
  <tr>
    <td>coprod</td>
    <td>&amp;#x02210;</td>
    <td>&#x02210;</td>
    <td>/coprod L: coproduct operator</td>
  </tr>
  <tr>
    <td>Cup</td>
    <td>&amp;#x022D3;</td>
    <td>&#x022D3;</td>
    <td>/Cup /doublecup B: dbl union</td>
  </tr>
  <tr>
    <td>cupbrcap</td>
    <td>&amp;#x02A48;</td>
    <td>&#x02A48;</td>
    <td>union, bar, intersection</td>
  </tr>
  <tr>
    <td>cupcap</td>
    <td>&amp;#x02A46;</td>
    <td>&#x02A46;</td>
    <td>union above intersection</td>
  </tr>
  <tr>
    <td>cupcup</td>
    <td>&amp;#x02A4A;</td>
    <td>&#x02A4A;</td>
    <td>union, union, joined</td>
  </tr>
  <tr>
    <td>cupdot</td>
    <td>&amp;#x0228D;</td>
    <td>&#x0228D;</td>
    <td>union, with dot</td>
  </tr>
  <tr>
    <td>cupor</td>
    <td>&amp;#x02A45;</td>
    <td>&#x02A45;</td>
    <td>union, or</td>
  </tr>
  <tr>
    <td>cups</td>
    <td>&amp;#x0222A;&amp;#x0FE00;</td>
    <td>&#x0222A;&#x0FE00;</td>
    <td>union, serifs</td>
  </tr>
  <tr>
    <td>cuvee</td>
    <td>&amp;#x022CE;</td>
    <td>&#x022CE;</td>
    <td>/curlyvee B: curly logical or</td>
  </tr>
  <tr>
    <td>cuwed</td>
    <td>&amp;#x022CF;</td>
    <td>&#x022CF;</td>
    <td>/curlywedge B: curly logical and</td>
  </tr>
  <tr>
    <td>Dagger</td>
    <td>&amp;#x02021;</td>
    <td>&#x02021;</td>
    <td>/ddagger B: double dagger relation</td>
  </tr>
  <tr>
    <td>dagger</td>
    <td>&amp;#x02020;</td>
    <td>&#x02020;</td>
    <td>/dagger B: dagger relation</td>
  </tr>
  <tr>
    <td>diam</td>
    <td>&amp;#x022C4;</td>
    <td>&#x022C4;</td>
    <td>/diamond B: open diamond</td>
  </tr>
  <tr>
    <td>divonx</td>
    <td>&amp;#x022C7;</td>
    <td>&#x022C7;</td>
    <td>/divideontimes B: division on times</td>
  </tr>
  <tr>
    <td>eplus</td>
    <td>&amp;#x02A71;</td>
    <td>&#x02A71;</td>
    <td>equal, plus</td>
  </tr>
  <tr>
    <td>hercon</td>
    <td>&amp;#x022B9;</td>
    <td>&#x022B9;</td>
    <td>hermitian conjugate matrix</td>
  </tr>
  <tr>
    <td>intcal</td>
    <td>&amp;#x022BA;</td>
    <td>&#x022BA;</td>
    <td>/intercal B: intercal</td>
  </tr>
  <tr>
    <td>iprod</td>
    <td>&amp;#x02A3C;</td>
    <td>&#x02A3C;</td>
    <td>/intprod</td>
  </tr>
  <tr>
    <td>loplus</td>
    <td>&amp;#x02A2D;</td>
    <td>&#x02A2D;</td>
    <td>plus sign in left half circle</td>
  </tr>
  <tr>
    <td>lotimes</td>
    <td>&amp;#x02A34;</td>
    <td>&#x02A34;</td>
    <td>multiply sign in left half circle</td>
  </tr>
  <tr>
    <td>lthree</td>
    <td>&amp;#x022CB;</td>
    <td>&#x022CB;</td>
    <td>/leftthreetimes B:</td>
  </tr>
  <tr>
    <td>ltimes</td>
    <td>&amp;#x022C9;</td>
    <td>&#x022C9;</td>
    <td>/ltimes B: times sign, left closed</td>
  </tr>
  <tr>
    <td>midast</td>
    <td>&amp;#x0002A;</td>
    <td>&#x0002A;</td>
    <td>/ast B: asterisk</td>
  </tr>
  <tr>
    <td>minusb</td>
    <td>&amp;#x0229F;</td>
    <td>&#x0229F;</td>
    <td>/boxminus B: minus sign in box</td>
  </tr>
  <tr>
    <td>minusd</td>
    <td>&amp;#x02238;</td>
    <td>&#x02238;</td>
    <td>/dotminus B: minus sign, dot above</td>
  </tr>
  <tr>
    <td>minusdu</td>
    <td>&amp;#x02A2A;</td>
    <td>&#x02A2A;</td>
    <td>minus sign, dot below</td>
  </tr>
  <tr>
    <td>ncap</td>
    <td>&amp;#x02A43;</td>
    <td>&#x02A43;</td>
    <td>bar, intersection</td>
  </tr>
  <tr>
    <td>ncup</td>
    <td>&amp;#x02A42;</td>
    <td>&#x02A42;</td>
    <td>bar, union</td>
  </tr>
  <tr>
    <td>oast</td>
    <td>&amp;#x0229B;</td>
    <td>&#x0229B;</td>
    <td>/circledast B: asterisk in circle</td>
  </tr>
  <tr>
    <td>ocir</td>
    <td>&amp;#x0229A;</td>
    <td>&#x0229A;</td>
    <td>/circledcirc B: small circle in circle</td>
  </tr>
  <tr>
    <td>odash</td>
    <td>&amp;#x0229D;</td>
    <td>&#x0229D;</td>
    <td>/circleddash B: hyphen in circle</td>
  </tr>
  <tr>
    <td>odiv</td>
    <td>&amp;#x02A38;</td>
    <td>&#x02A38;</td>
    <td>divide in circle</td>
  </tr>
  <tr>
    <td>odot</td>
    <td>&amp;#x02299;</td>
    <td>&#x02299;</td>
    <td>/odot B: middle dot in circle</td>
  </tr>
  <tr>
    <td>odsold</td>
    <td>&amp;#x029BC;</td>
    <td>&#x029BC;</td>
    <td>dot, solidus, dot in circle</td>
  </tr>
  <tr>
    <td>ofcir</td>
    <td>&amp;#x029BF;</td>
    <td>&#x029BF;</td>
    <td>filled circle in circle</td>
  </tr>
  <tr>
    <td>ogt</td>
    <td>&amp;#x029C1;</td>
    <td>&#x029C1;</td>
    <td>greater-than in circle</td>
  </tr>
  <tr>
    <td>ohbar</td>
    <td>&amp;#x029B5;</td>
    <td>&#x029B5;</td>
    <td>circle with horizontal bar</td>
  </tr>
  <tr>
    <td>olcir</td>
    <td>&amp;#x029BE;</td>
    <td>&#x029BE;</td>
    <td>large circle in circle</td>
  </tr>
  <tr>
    <td>olt</td>
    <td>&amp;#x029C0;</td>
    <td>&#x029C0;</td>
    <td>less-than in circle</td>
  </tr>
  <tr>
    <td>omid</td>
    <td>&amp;#x029B6;</td>
    <td>&#x029B6;</td>
    <td>vertical bar in circle</td>
  </tr>
  <tr>
    <td>ominus</td>
    <td>&amp;#x02296;</td>
    <td>&#x02296;</td>
    <td>/ominus B: minus sign in circle</td>
  </tr>
  <tr>
    <td>opar</td>
    <td>&amp;#x029B7;</td>
    <td>&#x029B7;</td>
    <td>parallel in circle</td>
  </tr>
  <tr>
    <td>operp</td>
    <td>&amp;#x029B9;</td>
    <td>&#x029B9;</td>
    <td>perpendicular in circle</td>
  </tr>
  <tr>
    <td>oplus</td>
    <td>&amp;#x02295;</td>
    <td>&#x02295;</td>
    <td>/oplus B: plus sign in circle</td>
  </tr>
  <tr>
    <td>osol</td>
    <td>&amp;#x02298;</td>
    <td>&#x02298;</td>
    <td>/oslash B: solidus in circle</td>
  </tr>
  <tr>
    <td>Otimes</td>
    <td>&amp;#x02A37;</td>
    <td>&#x02A37;</td>
    <td>multiply sign in double circle</td>
  </tr>
  <tr>
    <td>otimes</td>
    <td>&amp;#x02297;</td>
    <td>&#x02297;</td>
    <td>/otimes B: multiply sign in circle</td>
  </tr>
  <tr>
    <td>otimesas</td>
    <td>&amp;#x02A36;</td>
    <td>&#x02A36;</td>
    <td>multiply sign in circle, circumflex accent</td>
  </tr>
  <tr>
    <td>ovbar</td>
    <td>&amp;#x0233D;</td>
    <td>&#x0233D;</td>
    <td>circle with vertical bar</td>
  </tr>
  <tr>
    <td>plusacir</td>
    <td>&amp;#x02A23;</td>
    <td>&#x02A23;</td>
    <td>plus, circumflex accent above</td>
  </tr>
  <tr>
    <td>plusb</td>
    <td>&amp;#x0229E;</td>
    <td>&#x0229E;</td>
    <td>/boxplus B: plus sign in box</td>
  </tr>
  <tr>
    <td>pluscir</td>
    <td>&amp;#x02A22;</td>
    <td>&#x02A22;</td>
    <td>plus, small circle above</td>
  </tr>
  <tr>
    <td>plusdo</td>
    <td>&amp;#x02214;</td>
    <td>&#x02214;</td>
    <td>/dotplus B: plus sign, dot above</td>
  </tr>
  <tr>
    <td>plusdu</td>
    <td>&amp;#x02A25;</td>
    <td>&#x02A25;</td>
    <td>plus sign, dot below</td>
  </tr>
  <tr>
    <td>pluse</td>
    <td>&amp;#x02A72;</td>
    <td>&#x02A72;</td>
    <td>plus, equals</td>
  </tr>
  <tr>
    <td>plussim</td>
    <td>&amp;#x02A26;</td>
    <td>&#x02A26;</td>
    <td>plus, similar below</td>
  </tr>
  <tr>
    <td>plustwo</td>
    <td>&amp;#x02A27;</td>
    <td>&#x02A27;</td>
    <td>plus, two; Nim-addition</td>
  </tr>
  <tr>
    <td>prod</td>
    <td>&amp;#x0220F;</td>
    <td>&#x0220F;</td>
    <td>/prod L: product operator</td>
  </tr>
  <tr>
    <td>race</td>
    <td>&amp;#x029DA;</td>
    <td>&#x029DA;</td>
    <td>reverse most positive, line below</td>
  </tr>
  <tr>
    <td>roplus</td>
    <td>&amp;#x02A2E;</td>
    <td>&#x02A2E;</td>
    <td>plus sign in right half circle</td>
  </tr>
  <tr>
    <td>rotimes</td>
    <td>&amp;#x02A35;</td>
    <td>&#x02A35;</td>
    <td>multiply sign in right half circle</td>
  </tr>
  <tr>
    <td>rthree</td>
    <td>&amp;#x022CC;</td>
    <td>&#x022CC;</td>
    <td>/rightthreetimes B:</td>
  </tr>
  <tr>
    <td>rtimes</td>
    <td>&amp;#x022CA;</td>
    <td>&#x022CA;</td>
    <td>/rtimes B: times sign, right closed</td>
  </tr>
  <tr>
    <td>sdot</td>
    <td>&amp;#x022C5;</td>
    <td>&#x022C5;</td>
    <td>/cdot B: small middle dot</td>
  </tr>
  <tr>
    <td>sdotb</td>
    <td>&amp;#x022A1;</td>
    <td>&#x022A1;</td>
    <td>/dotsquare /boxdot B: small dot in box</td>
  </tr>
  <tr>
    <td>setmn</td>
    <td>&amp;#x02216;</td>
    <td>&#x02216;</td>
    <td>/setminus B: reverse solidus</td>
  </tr>
  <tr>
    <td>simplus</td>
    <td>&amp;#x02A24;</td>
    <td>&#x02A24;</td>
    <td>plus, similar above</td>
  </tr>
  <tr>
    <td>smashp</td>
    <td>&amp;#x02A33;</td>
    <td>&#x02A33;</td>
    <td>smash product</td>
  </tr>
  <tr>
    <td>solb</td>
    <td>&amp;#x029C4;</td>
    <td>&#x029C4;</td>
    <td>solidus in square</td>
  </tr>
  <tr>
    <td>sqcap</td>
    <td>&amp;#x02293;</td>
    <td>&#x02293;</td>
    <td>/sqcap B: square intersection</td>
  </tr>
  <tr>
    <td>sqcaps</td>
    <td>&amp;#x02293;&amp;#x0FE00;</td>
    <td>&#x02293;&#x0FE00;</td>
    <td>square intersection, serifs</td>
  </tr>
  <tr>
    <td>sqcup</td>
    <td>&amp;#x02294;</td>
    <td>&#x02294;</td>
    <td>/sqcup B: square union</td>
  </tr>
  <tr>
    <td>sqcups</td>
    <td>&amp;#x02294;&amp;#x0FE00;</td>
    <td>&#x02294;&#x0FE00;</td>
    <td>square union, serifs</td>
  </tr>
  <tr>
    <td>ssetmn</td>
    <td>&amp;#x02216;</td>
    <td>&#x02216;</td>
    <td>/smallsetminus B: sm reverse solidus</td>
  </tr>
  <tr>
    <td>sstarf</td>
    <td>&amp;#x022C6;</td>
    <td>&#x022C6;</td>
    <td>/star B: small star, filled</td>
  </tr>
  <tr>
    <td>subdot</td>
    <td>&amp;#x02ABD;</td>
    <td>&#x02ABD;</td>
    <td>subset, with dot</td>
  </tr>
  <tr>
    <td>sum</td>
    <td>&amp;#x02211;</td>
    <td>&#x02211;</td>
    <td>/sum L: summation operator</td>
  </tr>
  <tr>
    <td>supdot</td>
    <td>&amp;#x02ABE;</td>
    <td>&#x02ABE;</td>
    <td>superset, with dot</td>
  </tr>
  <tr>
    <td>timesb</td>
    <td>&amp;#x022A0;</td>
    <td>&#x022A0;</td>
    <td>/boxtimes B: multiply sign in box</td>
  </tr>
  <tr>
    <td>timesbar</td>
    <td>&amp;#x02A31;</td>
    <td>&#x02A31;</td>
    <td>multiply sign, bar below</td>
  </tr>
  <tr>
    <td>timesd</td>
    <td>&amp;#x02A30;</td>
    <td>&#x02A30;</td>
    <td>times, dot</td>
  </tr>
  <tr>
    <td>tridot</td>
    <td>&amp;#x025EC;</td>
    <td>&#x025EC;</td>
    <td>dot in triangle</td>
  </tr>
  <tr>
    <td>triminus</td>
    <td>&amp;#x02A3A;</td>
    <td>&#x02A3A;</td>
    <td>minus in triangle</td>
  </tr>
  <tr>
    <td>triplus</td>
    <td>&amp;#x02A39;</td>
    <td>&#x02A39;</td>
    <td>plus in triangle</td>
  </tr>
  <tr>
    <td>trisb</td>
    <td>&amp;#x029CD;</td>
    <td>&#x029CD;</td>
    <td>triangle, serifs at bottom</td>
  </tr>
  <tr>
    <td>tritime</td>
    <td>&amp;#x02A3B;</td>
    <td>&#x02A3B;</td>
    <td>multiply in triangle</td>
  </tr>
  <tr>
    <td>uplus</td>
    <td>&amp;#x0228E;</td>
    <td>&#x0228E;</td>
    <td>/uplus B: plus sign in union</td>
  </tr>
  <tr>
    <td>veebar</td>
    <td>&amp;#x022BB;</td>
    <td>&#x022BB;</td>
    <td>/veebar B: logical or, bar below</td>
  </tr>
  <tr>
    <td>wedbar</td>
    <td>&amp;#x02A5F;</td>
    <td>&#x02A5F;</td>
    <td>wedge, bar below</td>
  </tr>
  <tr>
    <td>wreath</td>
    <td>&amp;#x02240;</td>
    <td>&#x02240;</td>
    <td>/wr B: wreath product</td>
  </tr>
  <tr>
    <td>xcap</td>
    <td>&amp;#x022C2;</td>
    <td>&#x022C2;</td>
    <td>/bigcap L: intersection operator</td>
  </tr>
  <tr>
    <td>xcirc</td>
    <td>&amp;#x025EF;</td>
    <td>&#x025EF;</td>
    <td>/bigcirc B: large circle</td>
  </tr>
  <tr>
    <td>xcup</td>
    <td>&amp;#x022C3;</td>
    <td>&#x022C3;</td>
    <td>/bigcup L: union operator</td>
  </tr>
  <tr>
    <td>xdtri</td>
    <td>&amp;#x025BD;</td>
    <td>&#x025BD;</td>
    <td>/bigtriangledown B: big dn tri, open</td>
  </tr>
  <tr>
    <td>xodot</td>
    <td>&amp;#x02A00;</td>
    <td>&#x02A00;</td>
    <td>/bigodot L: circle dot operator</td>
  </tr>
  <tr>
    <td>xoplus</td>
    <td>&amp;#x02A01;</td>
    <td>&#x02A01;</td>
    <td>/bigoplus L: circle plus operator</td>
  </tr>
  <tr>
    <td>xotime</td>
    <td>&amp;#x02A02;</td>
    <td>&#x02A02;</td>
    <td>/bigotimes L: circle times operator</td>
  </tr>
  <tr>
    <td>xsqcup</td>
    <td>&amp;#x02A06;</td>
    <td>&#x02A06;</td>
    <td>/bigsqcup L: square union operator</td>
  </tr>
  <tr>
    <td>xuplus</td>
    <td>&amp;#x02A04;</td>
    <td>&#x02A04;</td>
    <td>/biguplus L:</td>
  </tr>
  <tr>
    <td>xutri</td>
    <td>&amp;#x025B3;</td>
    <td>&#x025B3;</td>
    <td>/bigtriangleup B: big up tri, open</td>
  </tr>
  <tr>
    <td>xvee</td>
    <td>&amp;#x022C1;</td>
    <td>&#x022C1;</td>
    <td>/bigvee L: logical and operator</td>
  </tr>
  <tr>
    <td>xwedge</td>
    <td>&amp;#x022C0;</td>
    <td>&#x022C0;</td>
    <td>/bigwedge L: logical or operator</td>
  </tr>
  <tr>
    <td>dlcorn</td>
    <td>&amp;#x0231E;</td>
    <td>&#x0231E;</td>
    <td>/llcorner O: lower left corner</td>
  </tr>
  <tr>
    <td>drcorn</td>
    <td>&amp;#x0231F;</td>
    <td>&#x0231F;</td>
    <td>/lrcorner C: lower right corner</td>
  </tr>
  <tr>
    <td>gtlPar</td>
    <td>&amp;#x02995;</td>
    <td>&#x02995;</td>
    <td>dbl left parenthesis, greater</td>
  </tr>
  <tr>
    <td>langd</td>
    <td>&amp;#x02991;</td>
    <td>&#x02991;</td>
    <td>left angle, dot</td>
  </tr>
  <tr>
    <td>lbrke</td>
    <td>&amp;#x0298B;</td>
    <td>&#x0298B;</td>
    <td>left bracket, equal</td>
  </tr>
  <tr>
    <td>lbrksld</td>
    <td>&amp;#x0298F;</td>
    <td>&#x0298F;</td>
    <td>left bracket, solidus bottom corner</td>
  </tr>
  <tr>
    <td>lbrkslu</td>
    <td>&amp;#x0298D;</td>
    <td>&#x0298D;</td>
    <td>left bracket, solidus top corner</td>
  </tr>
  <tr>
    <td>lceil</td>
    <td>&amp;#x02308;</td>
    <td>&#x02308;</td>
    <td>/lceil O: left ceiling</td>
  </tr>
  <tr>
    <td>lfloor</td>
    <td>&amp;#x0230A;</td>
    <td>&#x0230A;</td>
    <td>/lfloor O: left floor</td>
  </tr>
  <tr>
    <td>lmoust</td>
    <td>&amp;#x023B0;</td>
    <td>&#x023B0;</td>
    <td>/lmoustache</td>
  </tr>
  <tr>
    <td>lparlt</td>
    <td>&amp;#x02993;</td>
    <td>&#x02993;</td>
    <td>O: left parenthesis, lt</td>
  </tr>
  <tr>
    <td>ltrPar</td>
    <td>&amp;#x02996;</td>
    <td>&#x02996;</td>
    <td>dbl right parenthesis, less</td>
  </tr>
  <tr>
    <td>rangd</td>
    <td>&amp;#x02992;</td>
    <td>&#x02992;</td>
    <td>right angle, dot</td>
  </tr>
  <tr>
    <td>rbrke</td>
    <td>&amp;#x0298C;</td>
    <td>&#x0298C;</td>
    <td>right bracket, equal</td>
  </tr>
  <tr>
    <td>rbrksld</td>
    <td>&amp;#x0298E;</td>
    <td>&#x0298E;</td>
    <td>right bracket, solidus bottom corner</td>
  </tr>
  <tr>
    <td>rbrkslu</td>
    <td>&amp;#x02990;</td>
    <td>&#x02990;</td>
    <td>right bracket, solidus top corner</td>
  </tr>
  <tr>
    <td>rceil</td>
    <td>&amp;#x02309;</td>
    <td>&#x02309;</td>
    <td>/rceil C: right ceiling</td>
  </tr>
  <tr>
    <td>rfloor</td>
    <td>&amp;#x0230B;</td>
    <td>&#x0230B;</td>
    <td>/rfloor C: right floor</td>
  </tr>
  <tr>
    <td>rmoust</td>
    <td>&amp;#x023B1;</td>
    <td>&#x023B1;</td>
    <td>/rmoustache</td>
  </tr>
  <tr>
    <td>rpargt</td>
    <td>&amp;#x02994;</td>
    <td>&#x02994;</td>
    <td>C: right paren, gt</td>
  </tr>
  <tr>
    <td>ulcorn</td>
    <td>&amp;#x0231C;</td>
    <td>&#x0231C;</td>
    <td>/ulcorner O: upper left corner</td>
  </tr>
  <tr>
    <td>urcorn</td>
    <td>&amp;#x0231D;</td>
    <td>&#x0231D;</td>
    <td>/urcorner C: upper right corner</td>
  </tr>
  <tr>
    <td>gnap</td>
    <td>&amp;#x02A8A;</td>
    <td>&#x02A8A;</td>
    <td>/gnapprox N: greater, not approximate</td>
  </tr>
  <tr>
    <td>gnE</td>
    <td>&amp;#x02269;</td>
    <td>&#x02269;</td>
    <td>/gneqq N: greater, not dbl equals</td>
  </tr>
  <tr>
    <td>gne</td>
    <td>&amp;#x02A88;</td>
    <td>&#x02A88;</td>
    <td>/gneq N: greater, not equals</td>
  </tr>
  <tr>
    <td>gnsim</td>
    <td>&amp;#x022E7;</td>
    <td>&#x022E7;</td>
    <td>/gnsim N: greater, not similar</td>
  </tr>
  <tr>
    <td>gvnE</td>
    <td>&amp;#x02269;&amp;#x0FE00;</td>
    <td>&#x02269;&#x0FE00;</td>
    <td>/gvertneqq N: gt, vert, not dbl eq</td>
  </tr>
  <tr>
    <td>lnap</td>
    <td>&amp;#x02A89;</td>
    <td>&#x02A89;</td>
    <td>/lnapprox N: less, not approximate</td>
  </tr>
  <tr>
    <td>lnE</td>
    <td>&amp;#x02268;</td>
    <td>&#x02268;</td>
    <td>/lneqq N: less, not double equals</td>
  </tr>
  <tr>
    <td>lne</td>
    <td>&amp;#x02A87;</td>
    <td>&#x02A87;</td>
    <td>/lneq N: less, not equals</td>
  </tr>
  <tr>
    <td>lnsim</td>
    <td>&amp;#x022E6;</td>
    <td>&#x022E6;</td>
    <td>/lnsim N: less, not similar</td>
  </tr>
  <tr>
    <td>lvnE</td>
    <td>&amp;#x02268;&amp;#x0FE00;</td>
    <td>&#x02268;&#x0FE00;</td>
    <td>/lvertneqq N: less, vert, not dbl eq</td>
  </tr>
  <tr>
    <td>nap</td>
    <td>&amp;#x02249;</td>
    <td>&#x02249;</td>
    <td>/napprox N: not approximate</td>
  </tr>
  <tr>
    <td>napE</td>
    <td>&amp;#x02A70;&amp;#x00338;</td>
    <td>&#x02A70;&#x00338;</td>
    <td>not approximately equal or equal to</td>
  </tr>
  <tr>
    <td>napid</td>
    <td>&amp;#x0224B;&amp;#x00338;</td>
    <td>&#x0224B;&#x00338;</td>
    <td>not approximately identical to</td>
  </tr>
  <tr>
    <td>ncong</td>
    <td>&amp;#x02247;</td>
    <td>&#x02247;</td>
    <td>/ncong N: not congruent with</td>
  </tr>
  <tr>
    <td>ncongdot</td>
    <td>&amp;#x02A6D;&amp;#x00338;</td>
    <td>&#x02A6D;&#x00338;</td>
    <td>not congruent, dot</td>
  </tr>
  <tr>
    <td>nequiv</td>
    <td>&amp;#x02262;</td>
    <td>&#x02262;</td>
    <td>/nequiv N: not identical with</td>
  </tr>
  <tr>
    <td>ngE</td>
    <td>&amp;#x02267;&amp;#x00338;</td>
    <td>&#x02267;&#x00338;</td>
    <td>/ngeqq N: not greater, dbl equals</td>
  </tr>
  <tr>
    <td>nge</td>
    <td>&amp;#x02271;</td>
    <td>&#x02271;</td>
    <td>/ngeq N: not greater-than-or-equal</td>
  </tr>
  <tr>
    <td>nges</td>
    <td>&amp;#x02A7E;&amp;#x00338;</td>
    <td>&#x02A7E;&#x00338;</td>
    <td>/ngeqslant N: not gt-or-eq, slanted</td>
  </tr>
  <tr>
    <td>nGg</td>
    <td>&amp;#x022D9;&amp;#x00338;</td>
    <td>&#x022D9;&#x00338;</td>
    <td>not triple greater than</td>
  </tr>
  <tr>
    <td>ngsim</td>
    <td>&amp;#x02275;</td>
    <td>&#x02275;</td>
    <td>not greater, similar</td>
  </tr>
  <tr>
    <td>nGt</td>
    <td>&amp;#x0226B;&amp;#x020D2;</td>
    <td>&#x0226B;&#x020D2;</td>
    <td>not, vert, much greater than</td>
  </tr>
  <tr>
    <td>ngt</td>
    <td>&amp;#x0226F;</td>
    <td>&#x0226F;</td>
    <td>/ngtr N: not greater-than</td>
  </tr>
  <tr>
    <td>nGtv</td>
    <td>&amp;#x0226B;&amp;#x00338;</td>
    <td>&#x0226B;&#x00338;</td>
    <td>not much greater than, variant</td>
  </tr>
  <tr>
    <td>nlE</td>
    <td>&amp;#x02266;&amp;#x00338;</td>
    <td>&#x02266;&#x00338;</td>
    <td>/nleqq N: not less, dbl equals</td>
  </tr>
  <tr>
    <td>nle</td>
    <td>&amp;#x02270;</td>
    <td>&#x02270;</td>
    <td>/nleq N: not less-than-or-equal</td>
  </tr>
  <tr>
    <td>nles</td>
    <td>&amp;#x02A7D;&amp;#x00338;</td>
    <td>&#x02A7D;&#x00338;</td>
    <td>/nleqslant N: not less-or-eq, slant</td>
  </tr>
  <tr>
    <td>nLl</td>
    <td>&amp;#x022D8;&amp;#x00338;</td>
    <td>&#x022D8;&#x00338;</td>
    <td>not triple less than</td>
  </tr>
  <tr>
    <td>nlsim</td>
    <td>&amp;#x02274;</td>
    <td>&#x02274;</td>
    <td>not less, similar</td>
  </tr>
  <tr>
    <td>nLt</td>
    <td>&amp;#x0226A;&amp;#x020D2;</td>
    <td>&#x0226A;&#x020D2;</td>
    <td>not, vert, much less than</td>
  </tr>
  <tr>
    <td>nlt</td>
    <td>&amp;#x0226E;</td>
    <td>&#x0226E;</td>
    <td>/nless N: not less-than</td>
  </tr>
  <tr>
    <td>nltri</td>
    <td>&amp;#x022EA;</td>
    <td>&#x022EA;</td>
    <td>/ntriangleleft N: not left triangle</td>
  </tr>
  <tr>
    <td>nltrie</td>
    <td>&amp;#x022EC;</td>
    <td>&#x022EC;</td>
    <td>/ntrianglelefteq N: not l tri, eq</td>
  </tr>
  <tr>
    <td>nLtv</td>
    <td>&amp;#x0226A;&amp;#x00338;</td>
    <td>&#x0226A;&#x00338;</td>
    <td>not much less than, variant</td>
  </tr>
  <tr>
    <td>nmid</td>
    <td>&amp;#x02224;</td>
    <td>&#x02224;</td>
    <td>/nmid</td>
  </tr>
  <tr>
    <td>npar</td>
    <td>&amp;#x02226;</td>
    <td>&#x02226;</td>
    <td>/nparallel N: not parallel</td>
  </tr>
  <tr>
    <td>npr</td>
    <td>&amp;#x02280;</td>
    <td>&#x02280;</td>
    <td>/nprec N: not precedes</td>
  </tr>
  <tr>
    <td>nprcue</td>
    <td>&amp;#x022E0;</td>
    <td>&#x022E0;</td>
    <td>not curly precedes, eq</td>
  </tr>
  <tr>
    <td>npre</td>
    <td>&amp;#x02AAF;&amp;#x00338;</td>
    <td>&#x02AAF;&#x00338;</td>
    <td>/npreceq N: not precedes, equals</td>
  </tr>
  <tr>
    <td>nrtri</td>
    <td>&amp;#x022EB;</td>
    <td>&#x022EB;</td>
    <td>/ntriangleright N: not rt triangle</td>
  </tr>
  <tr>
    <td>nrtrie</td>
    <td>&amp;#x022ED;</td>
    <td>&#x022ED;</td>
    <td>/ntrianglerighteq N: not r tri, eq</td>
  </tr>
  <tr>
    <td>nsc</td>
    <td>&amp;#x02281;</td>
    <td>&#x02281;</td>
    <td>/nsucc N: not succeeds</td>
  </tr>
  <tr>
    <td>nsccue</td>
    <td>&amp;#x022E1;</td>
    <td>&#x022E1;</td>
    <td>not succeeds, curly eq</td>
  </tr>
  <tr>
    <td>nsce</td>
    <td>&amp;#x02AB0;&amp;#x00338;</td>
    <td>&#x02AB0;&#x00338;</td>
    <td>/nsucceq N: not succeeds, equals</td>
  </tr>
  <tr>
    <td>nsim</td>
    <td>&amp;#x02241;</td>
    <td>&#x02241;</td>
    <td>/nsim N: not similar</td>
  </tr>
  <tr>
    <td>nsime</td>
    <td>&amp;#x02244;</td>
    <td>&#x02244;</td>
    <td>/nsimeq N: not similar, equals</td>
  </tr>
  <tr>
    <td>nsmid</td>
    <td>&amp;#x02224;</td>
    <td>&#x02224;</td>
    <td>/nshortmid</td>
  </tr>
  <tr>
    <td>nspar</td>
    <td>&amp;#x02226;</td>
    <td>&#x02226;</td>
    <td>/nshortparallel N: not short par</td>
  </tr>
  <tr>
    <td>nsqsube</td>
    <td>&amp;#x022E2;</td>
    <td>&#x022E2;</td>
    <td>not, square subset, equals</td>
  </tr>
  <tr>
    <td>nsqsupe</td>
    <td>&amp;#x022E3;</td>
    <td>&#x022E3;</td>
    <td>not, square superset, equals</td>
  </tr>
  <tr>
    <td>nsub</td>
    <td>&amp;#x02284;</td>
    <td>&#x02284;</td>
    <td>not subset</td>
  </tr>
  <tr>
    <td>nsubE</td>
    <td>&amp;#x02AC5;&amp;#x00338;</td>
    <td>&#x02AC5;&#x00338;</td>
    <td>/nsubseteqq N: not subset, dbl eq</td>
  </tr>
  <tr>
    <td>nsube</td>
    <td>&amp;#x02288;</td>
    <td>&#x02288;</td>
    <td>/nsubseteq N: not subset, equals</td>
  </tr>
  <tr>
    <td>nsup</td>
    <td>&amp;#x02285;</td>
    <td>&#x02285;</td>
    <td>not superset</td>
  </tr>
  <tr>
    <td>nsupE</td>
    <td>&amp;#x02AC6;&amp;#x00338;</td>
    <td>&#x02AC6;&#x00338;</td>
    <td>/nsupseteqq N: not superset, dbl eq</td>
  </tr>
  <tr>
    <td>nsupe</td>
    <td>&amp;#x02289;</td>
    <td>&#x02289;</td>
    <td>/nsupseteq N: not superset, equals</td>
  </tr>
  <tr>
    <td>ntgl</td>
    <td>&amp;#x02279;</td>
    <td>&#x02279;</td>
    <td>not greater, less</td>
  </tr>
  <tr>
    <td>ntlg</td>
    <td>&amp;#x02278;</td>
    <td>&#x02278;</td>
    <td>not less, greater</td>
  </tr>
  <tr>
    <td>nvap</td>
    <td>&amp;#x0224D;&amp;#x020D2;</td>
    <td>&#x0224D;&#x020D2;</td>
    <td>not, vert, approximate</td>
  </tr>
  <tr>
    <td>nVDash</td>
    <td>&amp;#x022AF;</td>
    <td>&#x022AF;</td>
    <td>/nVDash N: not dbl vert, dbl dash</td>
  </tr>
  <tr>
    <td>nVdash</td>
    <td>&amp;#x022AE;</td>
    <td>&#x022AE;</td>
    <td>/nVdash N: not dbl vertical, dash</td>
  </tr>
  <tr>
    <td>nvDash</td>
    <td>&amp;#x022AD;</td>
    <td>&#x022AD;</td>
    <td>/nvDash N: not vertical, dbl dash</td>
  </tr>
  <tr>
    <td>nvdash</td>
    <td>&amp;#x022AC;</td>
    <td>&#x022AC;</td>
    <td>/nvdash N: not vertical, dash</td>
  </tr>
  <tr>
    <td>nvge</td>
    <td>&amp;#x02265;&amp;#x020D2;</td>
    <td>&#x02265;&#x020D2;</td>
    <td>not, vert, greater-than-or-equal</td>
  </tr>
  <tr>
    <td>nvgt</td>
    <td>&amp;#x0003E;&amp;#x020D2;</td>
    <td>&#x0003E;&#x020D2;</td>
    <td>not, vert, greater-than</td>
  </tr>
  <tr>
    <td>nvle</td>
    <td>&amp;#x02264;&amp;#x020D2;</td>
    <td>&#x02264;&#x020D2;</td>
    <td>not, vert, less-than-or-equal</td>
  </tr>
  <tr>
    <td>nvlt</td>
    <td>&amp;#x0003C;&amp;#x020D2;</td>
    <td>&#x0003C;&#x020D2;</td>
    <td>not, vert, less-than</td>
  </tr>
  <tr>
    <td>nvltrie</td>
    <td>&amp;#x022B4;&amp;#x020D2;</td>
    <td>&#x022B4;&#x020D2;</td>
    <td>not, vert, left triangle, equals</td>
  </tr>
  <tr>
    <td>nvrtrie</td>
    <td>&amp;#x022B5;&amp;#x020D2;</td>
    <td>&#x022B5;&#x020D2;</td>
    <td>not, vert, right triangle, equals</td>
  </tr>
  <tr>
    <td>nvsim</td>
    <td>&amp;#x0223C;&amp;#x020D2;</td>
    <td>&#x0223C;&#x020D2;</td>
    <td>not, vert, similar</td>
  </tr>
  <tr>
    <td>parsim</td>
    <td>&amp;#x02AF3;</td>
    <td>&#x02AF3;</td>
    <td>parallel, similar</td>
  </tr>
  <tr>
    <td>prnap</td>
    <td>&amp;#x02AB9;</td>
    <td>&#x02AB9;</td>
    <td>/precnapprox N: precedes, not approx</td>
  </tr>
  <tr>
    <td>prnE</td>
    <td>&amp;#x02AB5;</td>
    <td>&#x02AB5;</td>
    <td>/precneqq N: precedes, not dbl eq</td>
  </tr>
  <tr>
    <td>prnsim</td>
    <td>&amp;#x022E8;</td>
    <td>&#x022E8;</td>
    <td>/precnsim N: precedes, not similar</td>
  </tr>
  <tr>
    <td>rnmid</td>
    <td>&amp;#x02AEE;</td>
    <td>&#x02AEE;</td>
    <td>reverse /nmid</td>
  </tr>
  <tr>
    <td>scnap</td>
    <td>&amp;#x02ABA;</td>
    <td>&#x02ABA;</td>
    <td>/succnapprox N: succeeds, not approx</td>
  </tr>
  <tr>
    <td>scnE</td>
    <td>&amp;#x02AB6;</td>
    <td>&#x02AB6;</td>
    <td>/succneqq N: succeeds, not dbl eq</td>
  </tr>
  <tr>
    <td>scnsim</td>
    <td>&amp;#x022E9;</td>
    <td>&#x022E9;</td>
    <td>/succnsim N: succeeds, not similar</td>
  </tr>
  <tr>
    <td>simne</td>
    <td>&amp;#x02246;</td>
    <td>&#x02246;</td>
    <td>similar, not equals</td>
  </tr>
  <tr>
    <td>solbar</td>
    <td>&amp;#x0233F;</td>
    <td>&#x0233F;</td>
    <td>solidus, bar through</td>
  </tr>
  <tr>
    <td>subnE</td>
    <td>&amp;#x02ACB;</td>
    <td>&#x02ACB;</td>
    <td>/subsetneqq N: subset, not dbl eq</td>
  </tr>
  <tr>
    <td>subne</td>
    <td>&amp;#x0228A;</td>
    <td>&#x0228A;</td>
    <td>/subsetneq N: subset, not equals</td>
  </tr>
  <tr>
    <td>supnE</td>
    <td>&amp;#x02ACC;</td>
    <td>&#x02ACC;</td>
    <td>/supsetneqq N: superset, not dbl eq</td>
  </tr>
  <tr>
    <td>supne</td>
    <td>&amp;#x0228B;</td>
    <td>&#x0228B;</td>
    <td>/supsetneq N: superset, not equals</td>
  </tr>
  <tr>
    <td>vnsub</td>
    <td>&amp;#x02282;&amp;#x020D2;</td>
    <td>&#x02282;&#x020D2;</td>
    <td>/nsubset N: not subset, var</td>
  </tr>
  <tr>
    <td>vnsup</td>
    <td>&amp;#x02283;&amp;#x020D2;</td>
    <td>&#x02283;&#x020D2;</td>
    <td>/nsupset N: not superset, var</td>
  </tr>
  <tr>
    <td>vsubnE</td>
    <td>&amp;#x02ACB;&amp;#x0FE00;</td>
    <td>&#x02ACB;&#x0FE00;</td>
    <td>/varsubsetneqq N: subset not dbl eq, var</td>
  </tr>
  <tr>
    <td>vsubne</td>
    <td>&amp;#x0228A;&amp;#x0FE00;</td>
    <td>&#x0228A;&#x0FE00;</td>
    <td>/varsubsetneq N: subset, not eq, var</td>
  </tr>
  <tr>
    <td>vsupnE</td>
    <td>&amp;#x02ACC;&amp;#x0FE00;</td>
    <td>&#x02ACC;&#x0FE00;</td>
    <td>/varsupsetneqq N: super not dbl eq, var</td>
  </tr>
  <tr>
    <td>vsupne</td>
    <td>&amp;#x0228B;&amp;#x0FE00;</td>
    <td>&#x0228B;&#x0FE00;</td>
    <td>/varsupsetneq N: superset, not eq, var</td>
  </tr>
  <tr>
    <td>ang</td>
    <td>&amp;#x02220;</td>
    <td>&#x02220;</td>
    <td>/angle - angle</td>
  </tr>
  <tr>
    <td>ange</td>
    <td>&amp;#x029A4;</td>
    <td>&#x029A4;</td>
    <td>angle, equal</td>
  </tr>
  <tr>
    <td>angmsd</td>
    <td>&amp;#x02221;</td>
    <td>&#x02221;</td>
    <td>/measuredangle - angle-measured</td>
  </tr>
  <tr>
    <td>angmsdaa</td>
    <td>&amp;#x029A8;</td>
    <td>&#x029A8;</td>
    <td>angle-measured, arrow, up, right</td>
  </tr>
  <tr>
    <td>angmsdab</td>
    <td>&amp;#x029A9;</td>
    <td>&#x029A9;</td>
    <td>angle-measured, arrow, up, left</td>
  </tr>
  <tr>
    <td>angmsdac</td>
    <td>&amp;#x029AA;</td>
    <td>&#x029AA;</td>
    <td>angle-measured, arrow, down, right</td>
  </tr>
  <tr>
    <td>angmsdad</td>
    <td>&amp;#x029AB;</td>
    <td>&#x029AB;</td>
    <td>angle-measured, arrow, down, left</td>
  </tr>
  <tr>
    <td>angmsdae</td>
    <td>&amp;#x029AC;</td>
    <td>&#x029AC;</td>
    <td>angle-measured, arrow, right, up</td>
  </tr>
  <tr>
    <td>angmsdaf</td>
    <td>&amp;#x029AD;</td>
    <td>&#x029AD;</td>
    <td>angle-measured, arrow, left, up</td>
  </tr>
  <tr>
    <td>angmsdag</td>
    <td>&amp;#x029AE;</td>
    <td>&#x029AE;</td>
    <td>angle-measured, arrow, right, down</td>
  </tr>
  <tr>
    <td>angmsdah</td>
    <td>&amp;#x029AF;</td>
    <td>&#x029AF;</td>
    <td>angle-measured, arrow, left, down</td>
  </tr>
  <tr>
    <td>angrtvb</td>
    <td>&amp;#x022BE;</td>
    <td>&#x022BE;</td>
    <td>right angle-measured</td>
  </tr>
  <tr>
    <td>angrtvbd</td>
    <td>&amp;#x0299D;</td>
    <td>&#x0299D;</td>
    <td>right angle-measured, dot</td>
  </tr>
  <tr>
    <td>bbrk</td>
    <td>&amp;#x023B5;</td>
    <td>&#x023B5;</td>
    <td>bottom square bracket</td>
  </tr>
  <tr>
    <td>bbrktbrk</td>
    <td>&amp;#x023B6;</td>
    <td>&#x023B6;</td>
    <td>bottom above top square bracket</td>
  </tr>
  <tr>
    <td>bemptyv</td>
    <td>&amp;#x029B0;</td>
    <td>&#x029B0;</td>
    <td>reversed circle, slash</td>
  </tr>
  <tr>
    <td>beth</td>
    <td>&amp;#x02136;</td>
    <td>&#x02136;</td>
    <td>/beth - beth, Hebrew</td>
  </tr>
  <tr>
    <td>boxbox</td>
    <td>&amp;#x029C9;</td>
    <td>&#x029C9;</td>
    <td>two joined squares</td>
  </tr>
  <tr>
    <td>bprime</td>
    <td>&amp;#x02035;</td>
    <td>&#x02035;</td>
    <td>/backprime - reverse prime</td>
  </tr>
  <tr>
    <td>bsemi</td>
    <td>&amp;#x0204F;</td>
    <td>&#x0204F;</td>
    <td>reverse semi-colon</td>
  </tr>
  <tr>
    <td>cemptyv</td>
    <td>&amp;#x029B2;</td>
    <td>&#x029B2;</td>
    <td>circle, slash, small circle above</td>
  </tr>
  <tr>
    <td>cirE</td>
    <td>&amp;#x029C3;</td>
    <td>&#x029C3;</td>
    <td>circle, two horizontal stroked to the right</td>
  </tr>
  <tr>
    <td>cirscir</td>
    <td>&amp;#x029C2;</td>
    <td>&#x029C2;</td>
    <td>circle, small circle to the right</td>
  </tr>
  <tr>
    <td>comp</td>
    <td>&amp;#x02201;</td>
    <td>&#x02201;</td>
    <td>/complement - complement sign</td>
  </tr>
  <tr>
    <td>daleth</td>
    <td>&amp;#x02138;</td>
    <td>&#x02138;</td>
    <td>/daleth - daleth, Hebrew</td>
  </tr>
  <tr>
    <td>demptyv</td>
    <td>&amp;#x029B1;</td>
    <td>&#x029B1;</td>
    <td>circle, slash, bar above</td>
  </tr>
  <tr>
    <td>ell</td>
    <td>&amp;#x02113;</td>
    <td>&#x02113;</td>
    <td>/ell - cursive small l</td>
  </tr>
  <tr>
    <td>empty</td>
    <td>&amp;#x02205;</td>
    <td>&#x02205;</td>
    <td>/emptyset - zero, slash</td>
  </tr>
  <tr>
    <td>emptyv</td>
    <td>&amp;#x02205;</td>
    <td>&#x02205;</td>
    <td>/varnothing - circle, slash</td>
  </tr>
  <tr>
    <td>gimel</td>
    <td>&amp;#x02137;</td>
    <td>&#x02137;</td>
    <td>/gimel - gimel, Hebrew</td>
  </tr>
  <tr>
    <td>iiota</td>
    <td>&amp;#x02129;</td>
    <td>&#x02129;</td>
    <td>inverted iota</td>
  </tr>
  <tr>
    <td>image</td>
    <td>&amp;#x02111;</td>
    <td>&#x02111;</td>
    <td>/Im - imaginary</td>
  </tr>
  <tr>
    <td>imath</td>
    <td>&amp;#x00131;</td>
    <td>&#x00131;</td>
    <td>/imath - small i, no dot</td>
  </tr>
  <tr>
    <td>jmath</td>
    <td>&amp;#x0006A;</td>
    <td>&#x0006A;</td>
    <td>/jmath - small j, no dot</td>
  </tr>
  <tr>
    <td>laemptyv</td>
    <td>&amp;#x029B4;</td>
    <td>&#x029B4;</td>
    <td>circle, slash, left arrow above</td>
  </tr>
  <tr>
    <td>lltri</td>
    <td>&amp;#x025FA;</td>
    <td>&#x025FA;</td>
    <td>lower left triangle</td>
  </tr>
  <tr>
    <td>lrtri</td>
    <td>&amp;#x022BF;</td>
    <td>&#x022BF;</td>
    <td>lower right triangle</td>
  </tr>
  <tr>
    <td>mho</td>
    <td>&amp;#x02127;</td>
    <td>&#x02127;</td>
    <td>/mho - conductance</td>
  </tr>
  <tr>
    <td>nang</td>
    <td>&amp;#x02220;&amp;#x020D2;</td>
    <td>&#x02220;&#x020D2;</td>
    <td>not, vert, angle</td>
  </tr>
  <tr>
    <td>nexist</td>
    <td>&amp;#x02204;</td>
    <td>&#x02204;</td>
    <td>/nexists - negated exists</td>
  </tr>
  <tr>
    <td>oS</td>
    <td>&amp;#x024C8;</td>
    <td>&#x024C8;</td>
    <td>/circledS - capital S in circle</td>
  </tr>
  <tr>
    <td>planck</td>
    <td>&amp;#x0210F;</td>
    <td>&#x0210F;</td>
    <td>/hbar - Planck's over 2pi</td>
  </tr>
  <tr>
    <td>plankv</td>
    <td>&amp;#x0210F;</td>
    <td>&#x0210F;</td>
    <td>/hslash - variant Planck's over 2pi</td>
  </tr>
  <tr>
    <td>raemptyv</td>
    <td>&amp;#x029B3;</td>
    <td>&#x029B3;</td>
    <td>circle, slash, right arrow above</td>
  </tr>
  <tr>
    <td>range</td>
    <td>&amp;#x029A5;</td>
    <td>&#x029A5;</td>
    <td>reverse angle, equal</td>
  </tr>
  <tr>
    <td>real</td>
    <td>&amp;#x0211C;</td>
    <td>&#x0211C;</td>
    <td>/Re - real</td>
  </tr>
  <tr>
    <td>tbrk</td>
    <td>&amp;#x023B4;</td>
    <td>&#x023B4;</td>
    <td>top square bracket</td>
  </tr>
  <tr>
    <td>trpezium</td>
    <td>&amp;#x0FFFD;</td>
    <td>&#x0FFFD;</td>
    <td>trapezium</td>
  </tr>
  <tr>
    <td>ultri</td>
    <td>&amp;#x025F8;</td>
    <td>&#x025F8;</td>
    <td>upper left triangle</td>
  </tr>
  <tr>
    <td>urtri</td>
    <td>&amp;#x025F9;</td>
    <td>&#x025F9;</td>
    <td>upper right triangle</td>
  </tr>
  <tr>
    <td>vzigzag</td>
    <td>&amp;#x0299A;</td>
    <td>&#x0299A;</td>
    <td>vertical zig-zag line</td>
  </tr>
  <tr>
    <td>weierp</td>
    <td>&amp;#x02118;</td>
    <td>&#x02118;</td>
    <td>/wp - Weierstrass p</td>
  </tr>
  <tr>
    <td>apE</td>
    <td>&amp;#x02A70;</td>
    <td>&#x02A70;</td>
    <td>approximately equal or equal to</td>
  </tr>
  <tr>
    <td>ape</td>
    <td>&amp;#x0224A;</td>
    <td>&#x0224A;</td>
    <td>/approxeq R: approximate, equals</td>
  </tr>
  <tr>
    <td>apid</td>
    <td>&amp;#x0224B;</td>
    <td>&#x0224B;</td>
    <td>approximately identical to</td>
  </tr>
  <tr>
    <td>asymp</td>
    <td>&amp;#x02248;</td>
    <td>&#x02248;</td>
    <td>/asymp R: asymptotically equal to</td>
  </tr>
  <tr>
    <td>Barv</td>
    <td>&amp;#x02AE7;</td>
    <td>&#x02AE7;</td>
    <td>vert, dbl bar (over)</td>
  </tr>
  <tr>
    <td>bcong</td>
    <td>&amp;#x0224C;</td>
    <td>&#x0224C;</td>
    <td>/backcong R: reverse congruent</td>
  </tr>
  <tr>
    <td>bepsi</td>
    <td>&amp;#x003F6;</td>
    <td>&#x003F6;</td>
    <td>/backepsilon R: such that</td>
  </tr>
  <tr>
    <td>bowtie</td>
    <td>&amp;#x022C8;</td>
    <td>&#x022C8;</td>
    <td>/bowtie R:</td>
  </tr>
  <tr>
    <td>bsim</td>
    <td>&amp;#x0223D;</td>
    <td>&#x0223D;</td>
    <td>/backsim R: reverse similar</td>
  </tr>
  <tr>
    <td>bsime</td>
    <td>&amp;#x022CD;</td>
    <td>&#x022CD;</td>
    <td>/backsimeq R: reverse similar, eq</td>
  </tr>
  <tr>
    <td>bsolhsub</td>
    <td>&amp;#x0005C;&amp;#x02282;</td>
    <td>&#x0005C;&#x02282;</td>
    <td>reverse solidus, subset</td>
  </tr>
  <tr>
    <td>bump</td>
    <td>&amp;#x0224E;</td>
    <td>&#x0224E;</td>
    <td>/Bumpeq R: bumpy equals</td>
  </tr>
  <tr>
    <td>bumpE</td>
    <td>&amp;#x02AAE;</td>
    <td>&#x02AAE;</td>
    <td>bump, equals</td>
  </tr>
  <tr>
    <td>bumpe</td>
    <td>&amp;#x0224F;</td>
    <td>&#x0224F;</td>
    <td>/bumpeq R: bumpy equals, equals</td>
  </tr>
  <tr>
    <td>cire</td>
    <td>&amp;#x02257;</td>
    <td>&#x02257;</td>
    <td>/circeq R: circle, equals</td>
  </tr>
  <tr>
    <td>Colon</td>
    <td>&amp;#x02237;</td>
    <td>&#x02237;</td>
    <td>/Colon, two colons</td>
  </tr>
  <tr>
    <td>Colone</td>
    <td>&amp;#x02A74;</td>
    <td>&#x02A74;</td>
    <td>double colon, equals</td>
  </tr>
  <tr>
    <td>colone</td>
    <td>&amp;#x02254;</td>
    <td>&#x02254;</td>
    <td>/coloneq R: colon, equals</td>
  </tr>
  <tr>
    <td>congdot</td>
    <td>&amp;#x02A6D;</td>
    <td>&#x02A6D;</td>
    <td>congruent, dot</td>
  </tr>
  <tr>
    <td>csub</td>
    <td>&amp;#x02ACF;</td>
    <td>&#x02ACF;</td>
    <td>subset, closed</td>
  </tr>
  <tr>
    <td>csube</td>
    <td>&amp;#x02AD1;</td>
    <td>&#x02AD1;</td>
    <td>subset, closed, equals</td>
  </tr>
  <tr>
    <td>csup</td>
    <td>&amp;#x02AD0;</td>
    <td>&#x02AD0;</td>
    <td>superset, closed</td>
  </tr>
  <tr>
    <td>csupe</td>
    <td>&amp;#x02AD2;</td>
    <td>&#x02AD2;</td>
    <td>superset, closed, equals</td>
  </tr>
  <tr>
    <td>cuepr</td>
    <td>&amp;#x022DE;</td>
    <td>&#x022DE;</td>
    <td>/curlyeqprec R: curly eq, precedes</td>
  </tr>
  <tr>
    <td>cuesc</td>
    <td>&amp;#x022DF;</td>
    <td>&#x022DF;</td>
    <td>/curlyeqsucc R: curly eq, succeeds</td>
  </tr>
  <tr>
    <td>Dashv</td>
    <td>&amp;#x02AE4;</td>
    <td>&#x02AE4;</td>
    <td>dbl dash, vertical</td>
  </tr>
  <tr>
    <td>dashv</td>
    <td>&amp;#x022A3;</td>
    <td>&#x022A3;</td>
    <td>/dashv R: dash, vertical</td>
  </tr>
  <tr>
    <td>easter</td>
    <td>&amp;#x02A6E;</td>
    <td>&#x02A6E;</td>
    <td>equal, asterisk above</td>
  </tr>
  <tr>
    <td>ecir</td>
    <td>&amp;#x02256;</td>
    <td>&#x02256;</td>
    <td>/eqcirc R: circle on equals sign</td>
  </tr>
  <tr>
    <td>ecolon</td>
    <td>&amp;#x02255;</td>
    <td>&#x02255;</td>
    <td>/eqcolon R: equals, colon</td>
  </tr>
  <tr>
    <td>eDDot</td>
    <td>&amp;#x02A77;</td>
    <td>&#x02A77;</td>
    <td>/ddotseq R: equal with four dots</td>
  </tr>
  <tr>
    <td>eDot</td>
    <td>&amp;#x02251;</td>
    <td>&#x02251;</td>
    <td>/doteqdot /Doteq R: eq, even dots</td>
  </tr>
  <tr>
    <td>efDot</td>
    <td>&amp;#x02252;</td>
    <td>&#x02252;</td>
    <td>/fallingdotseq R: eq, falling dots</td>
  </tr>
  <tr>
    <td>eg</td>
    <td>&amp;#x02A9A;</td>
    <td>&#x02A9A;</td>
    <td>equal-or-greater</td>
  </tr>
  <tr>
    <td>egs</td>
    <td>&amp;#x02A96;</td>
    <td>&#x02A96;</td>
    <td>/eqslantgtr R: equal-or-gtr, slanted</td>
  </tr>
  <tr>
    <td>egsdot</td>
    <td>&amp;#x02A98;</td>
    <td>&#x02A98;</td>
    <td>equal-or-greater, slanted, dot inside</td>
  </tr>
  <tr>
    <td>el</td>
    <td>&amp;#x02A99;</td>
    <td>&#x02A99;</td>
    <td>equal-or-less</td>
  </tr>
  <tr>
    <td>els</td>
    <td>&amp;#x02A95;</td>
    <td>&#x02A95;</td>
    <td>/eqslantless R: eq-or-less, slanted</td>
  </tr>
  <tr>
    <td>elsdot</td>
    <td>&amp;#x02A97;</td>
    <td>&#x02A97;</td>
    <td>equal-or-less, slanted, dot inside</td>
  </tr>
  <tr>
    <td>equest</td>
    <td>&amp;#x0225F;</td>
    <td>&#x0225F;</td>
    <td>/questeq R: equal with questionmark</td>
  </tr>
  <tr>
    <td>equivDD</td>
    <td>&amp;#x02A78;</td>
    <td>&#x02A78;</td>
    <td>equivalent, four dots above</td>
  </tr>
  <tr>
    <td>erDot</td>
    <td>&amp;#x02253;</td>
    <td>&#x02253;</td>
    <td>/risingdotseq R: eq, rising dots</td>
  </tr>
  <tr>
    <td>esdot</td>
    <td>&amp;#x02250;</td>
    <td>&#x02250;</td>
    <td>/doteq R: equals, single dot above</td>
  </tr>
  <tr>
    <td>Esim</td>
    <td>&amp;#x02A73;</td>
    <td>&#x02A73;</td>
    <td>equal, similar</td>
  </tr>
  <tr>
    <td>esim</td>
    <td>&amp;#x02242;</td>
    <td>&#x02242;</td>
    <td>/esim R: equals, similar</td>
  </tr>
  <tr>
    <td>fork</td>
    <td>&amp;#x022D4;</td>
    <td>&#x022D4;</td>
    <td>/pitchfork R: pitchfork</td>
  </tr>
  <tr>
    <td>forkv</td>
    <td>&amp;#x02AD9;</td>
    <td>&#x02AD9;</td>
    <td>fork, variant</td>
  </tr>
  <tr>
    <td>frown</td>
    <td>&amp;#x02322;</td>
    <td>&#x02322;</td>
    <td>/frown R: down curve</td>
  </tr>
  <tr>
    <td>gap</td>
    <td>&amp;#x02A86;</td>
    <td>&#x02A86;</td>
    <td>/gtrapprox R: greater, approximate</td>
  </tr>
  <tr>
    <td>gE</td>
    <td>&amp;#x02267;</td>
    <td>&#x02267;</td>
    <td>/geqq R: greater, double equals</td>
  </tr>
  <tr>
    <td>gEl</td>
    <td>&amp;#x02A8C;</td>
    <td>&#x02A8C;</td>
    <td>/gtreqqless R: gt, dbl equals, less</td>
  </tr>
  <tr>
    <td>gel</td>
    <td>&amp;#x022DB;</td>
    <td>&#x022DB;</td>
    <td>/gtreqless R: greater, equals, less</td>
  </tr>
  <tr>
    <td>ges</td>
    <td>&amp;#x02A7E;</td>
    <td>&#x02A7E;</td>
    <td>/geqslant R: gt-or-equal, slanted</td>
  </tr>
  <tr>
    <td>gescc</td>
    <td>&amp;#x02AA9;</td>
    <td>&#x02AA9;</td>
    <td>greater than, closed by curve, equal, slanted</td>
  </tr>
  <tr>
    <td>gesdot</td>
    <td>&amp;#x02A80;</td>
    <td>&#x02A80;</td>
    <td>greater-than-or-equal, slanted, dot inside</td>
  </tr>
  <tr>
    <td>gesdoto</td>
    <td>&amp;#x02A82;</td>
    <td>&#x02A82;</td>
    <td>greater-than-or-equal, slanted, dot above</td>
  </tr>
  <tr>
    <td>gesdotol</td>
    <td>&amp;#x02A84;</td>
    <td>&#x02A84;</td>
    <td>greater-than-or-equal, slanted, dot above left</td>
  </tr>
  <tr>
    <td>gesl</td>
    <td>&amp;#x022DB;&amp;#x0FE00;</td>
    <td>&#x022DB;&#x0FE00;</td>
    <td>greater, equal, slanted, less</td>
  </tr>
  <tr>
    <td>gesles</td>
    <td>&amp;#x02A94;</td>
    <td>&#x02A94;</td>
    <td>greater, equal, slanted, less, equal, slanted</td>
  </tr>
  <tr>
    <td>Gg</td>
    <td>&amp;#x022D9;</td>
    <td>&#x022D9;</td>
    <td>/ggg /Gg /gggtr R: triple gtr-than</td>
  </tr>
  <tr>
    <td>gl</td>
    <td>&amp;#x02277;</td>
    <td>&#x02277;</td>
    <td>/gtrless R: greater, less</td>
  </tr>
  <tr>
    <td>gla</td>
    <td>&amp;#x02AA5;</td>
    <td>&#x02AA5;</td>
    <td>greater, less, apart</td>
  </tr>
  <tr>
    <td>glE</td>
    <td>&amp;#x02A92;</td>
    <td>&#x02A92;</td>
    <td>greater, less, equal</td>
  </tr>
  <tr>
    <td>glj</td>
    <td>&amp;#x02AA4;</td>
    <td>&#x02AA4;</td>
    <td>greater, less, overlapping</td>
  </tr>
  <tr>
    <td>gsim</td>
    <td>&amp;#x02273;</td>
    <td>&#x02273;</td>
    <td>/gtrsim R: greater, similar</td>
  </tr>
  <tr>
    <td>gsime</td>
    <td>&amp;#x02A8E;</td>
    <td>&#x02A8E;</td>
    <td>greater, similar, equal</td>
  </tr>
  <tr>
    <td>gsiml</td>
    <td>&amp;#x02A90;</td>
    <td>&#x02A90;</td>
    <td>greater, similar, less</td>
  </tr>
  <tr>
    <td>Gt</td>
    <td>&amp;#x0226B;</td>
    <td>&#x0226B;</td>
    <td>/gg R: dbl greater-than sign</td>
  </tr>
  <tr>
    <td>gtcc</td>
    <td>&amp;#x02AA7;</td>
    <td>&#x02AA7;</td>
    <td>greater than, closed by curve</td>
  </tr>
  <tr>
    <td>gtcir</td>
    <td>&amp;#x02A7A;</td>
    <td>&#x02A7A;</td>
    <td>greater than, circle inside</td>
  </tr>
  <tr>
    <td>gtdot</td>
    <td>&amp;#x022D7;</td>
    <td>&#x022D7;</td>
    <td>/gtrdot R: greater than, with dot</td>
  </tr>
  <tr>
    <td>gtquest</td>
    <td>&amp;#x02A7C;</td>
    <td>&#x02A7C;</td>
    <td>greater than, questionmark above</td>
  </tr>
  <tr>
    <td>gtrarr</td>
    <td>&amp;#x02978;</td>
    <td>&#x02978;</td>
    <td>greater than, right arrow</td>
  </tr>
  <tr>
    <td>homtht</td>
    <td>&amp;#x0223B;</td>
    <td>&#x0223B;</td>
    <td>homothetic</td>
  </tr>
  <tr>
    <td>lap</td>
    <td>&amp;#x02A85;</td>
    <td>&#x02A85;</td>
    <td>/lessapprox R: less, approximate</td>
  </tr>
  <tr>
    <td>lat</td>
    <td>&amp;#x02AAB;</td>
    <td>&#x02AAB;</td>
    <td>larger than</td>
  </tr>
  <tr>
    <td>late</td>
    <td>&amp;#x02AAD;</td>
    <td>&#x02AAD;</td>
    <td>larger than or equal</td>
  </tr>
  <tr>
    <td>lates</td>
    <td>&amp;#x02AAD;&amp;#x0FE00;</td>
    <td>&#x02AAD;&#x0FE00;</td>
    <td>larger than or equal, slanted</td>
  </tr>
  <tr>
    <td>lE</td>
    <td>&amp;#x02266;</td>
    <td>&#x02266;</td>
    <td>/leqq R: less, double equals</td>
  </tr>
  <tr>
    <td>lEg</td>
    <td>&amp;#x02A8B;</td>
    <td>&#x02A8B;</td>
    <td>/lesseqqgtr R: less, dbl eq, greater</td>
  </tr>
  <tr>
    <td>leg</td>
    <td>&amp;#x022DA;</td>
    <td>&#x022DA;</td>
    <td>/lesseqgtr R: less, eq, greater</td>
  </tr>
  <tr>
    <td>les</td>
    <td>&amp;#x02A7D;</td>
    <td>&#x02A7D;</td>
    <td>/leqslant R: less-than-or-eq, slant</td>
  </tr>
  <tr>
    <td>lescc</td>
    <td>&amp;#x02AA8;</td>
    <td>&#x02AA8;</td>
    <td>less than, closed by curve, equal, slanted</td>
  </tr>
  <tr>
    <td>lesdot</td>
    <td>&amp;#x02A7F;</td>
    <td>&#x02A7F;</td>
    <td>less-than-or-equal, slanted, dot inside</td>
  </tr>
  <tr>
    <td>lesdoto</td>
    <td>&amp;#x02A81;</td>
    <td>&#x02A81;</td>
    <td>less-than-or-equal, slanted, dot above</td>
  </tr>
  <tr>
    <td>lesdotor</td>
    <td>&amp;#x02A83;</td>
    <td>&#x02A83;</td>
    <td>less-than-or-equal, slanted, dot above right</td>
  </tr>
  <tr>
    <td>lesg</td>
    <td>&amp;#x022DA;&amp;#x0FE00;</td>
    <td>&#x022DA;&#x0FE00;</td>
    <td>less, equal, slanted, greater</td>
  </tr>
  <tr>
    <td>lesges</td>
    <td>&amp;#x02A93;</td>
    <td>&#x02A93;</td>
    <td>less, equal, slanted, greater, equal, slanted</td>
  </tr>
  <tr>
    <td>lg</td>
    <td>&amp;#x02276;</td>
    <td>&#x02276;</td>
    <td>/lessgtr R: less, greater</td>
  </tr>
  <tr>
    <td>lgE</td>
    <td>&amp;#x02A91;</td>
    <td>&#x02A91;</td>
    <td>less, greater, equal</td>
  </tr>
  <tr>
    <td>Ll</td>
    <td>&amp;#x022D8;</td>
    <td>&#x022D8;</td>
    <td>/Ll /lll /llless R: triple less-than</td>
  </tr>
  <tr>
    <td>lsim</td>
    <td>&amp;#x02272;</td>
    <td>&#x02272;</td>
    <td>/lesssim R: less, similar</td>
  </tr>
  <tr>
    <td>lsime</td>
    <td>&amp;#x02A8D;</td>
    <td>&#x02A8D;</td>
    <td>less, similar, equal</td>
  </tr>
  <tr>
    <td>lsimg</td>
    <td>&amp;#x02A8F;</td>
    <td>&#x02A8F;</td>
    <td>less, similar, greater</td>
  </tr>
  <tr>
    <td>Lt</td>
    <td>&amp;#x0226A;</td>
    <td>&#x0226A;</td>
    <td>/ll R: double less-than sign</td>
  </tr>
  <tr>
    <td>ltcc</td>
    <td>&amp;#x02AA6;</td>
    <td>&#x02AA6;</td>
    <td>less than, closed by curve</td>
  </tr>
  <tr>
    <td>ltcir</td>
    <td>&amp;#x02A79;</td>
    <td>&#x02A79;</td>
    <td>less than, circle inside</td>
  </tr>
  <tr>
    <td>ltdot</td>
    <td>&amp;#x022D6;</td>
    <td>&#x022D6;</td>
    <td>/lessdot R: less than, with dot</td>
  </tr>
  <tr>
    <td>ltlarr</td>
    <td>&amp;#x02976;</td>
    <td>&#x02976;</td>
    <td>less than, left arrow</td>
  </tr>
  <tr>
    <td>ltquest</td>
    <td>&amp;#x02A7B;</td>
    <td>&#x02A7B;</td>
    <td>less than, questionmark above</td>
  </tr>
  <tr>
    <td>ltrie</td>
    <td>&amp;#x022B4;</td>
    <td>&#x022B4;</td>
    <td>/trianglelefteq R: left triangle, eq</td>
  </tr>
  <tr>
    <td>mcomma</td>
    <td>&amp;#x02A29;</td>
    <td>&#x02A29;</td>
    <td>minus, comma above</td>
  </tr>
  <tr>
    <td>mDDot</td>
    <td>&amp;#x0223A;</td>
    <td>&#x0223A;</td>
    <td>minus with four dots, geometric properties</td>
  </tr>
  <tr>
    <td>mid</td>
    <td>&amp;#x02223;</td>
    <td>&#x02223;</td>
    <td>/mid R:</td>
  </tr>
  <tr>
    <td>mlcp</td>
    <td>&amp;#x02ADB;</td>
    <td>&#x02ADB;</td>
    <td>/mlcp</td>
  </tr>
  <tr>
    <td>models</td>
    <td>&amp;#x022A7;</td>
    <td>&#x022A7;</td>
    <td>/models R:</td>
  </tr>
  <tr>
    <td>mstpos</td>
    <td>&amp;#x0223E;</td>
    <td>&#x0223E;</td>
    <td>most positive</td>
  </tr>
  <tr>
    <td>Pr</td>
    <td>&amp;#x02ABB;</td>
    <td>&#x02ABB;</td>
    <td>dbl precedes</td>
  </tr>
  <tr>
    <td>pr</td>
    <td>&amp;#x0227A;</td>
    <td>&#x0227A;</td>
    <td>/prec R: precedes</td>
  </tr>
  <tr>
    <td>prap</td>
    <td>&amp;#x02AB7;</td>
    <td>&#x02AB7;</td>
    <td>/precapprox R: precedes, approximate</td>
  </tr>
  <tr>
    <td>prcue</td>
    <td>&amp;#x0227C;</td>
    <td>&#x0227C;</td>
    <td>/preccurlyeq R: precedes, curly eq</td>
  </tr>
  <tr>
    <td>prE</td>
    <td>&amp;#x02AB3;</td>
    <td>&#x02AB3;</td>
    <td>precedes, dbl equals</td>
  </tr>
  <tr>
    <td>pre</td>
    <td>&amp;#x02AAF;</td>
    <td>&#x02AAF;</td>
    <td>/preceq R: precedes, equals</td>
  </tr>
  <tr>
    <td>prsim</td>
    <td>&amp;#x0227E;</td>
    <td>&#x0227E;</td>
    <td>/precsim R: precedes, similar</td>
  </tr>
  <tr>
    <td>prurel</td>
    <td>&amp;#x022B0;</td>
    <td>&#x022B0;</td>
    <td>element precedes under relation</td>
  </tr>
  <tr>
    <td>ratio</td>
    <td>&amp;#x02236;</td>
    <td>&#x02236;</td>
    <td>/ratio</td>
  </tr>
  <tr>
    <td>rtrie</td>
    <td>&amp;#x022B5;</td>
    <td>&#x022B5;</td>
    <td>/trianglerighteq R: right tri, eq</td>
  </tr>
  <tr>
    <td>rtriltri</td>
    <td>&amp;#x029CE;</td>
    <td>&#x029CE;</td>
    <td>right triangle above left triangle</td>
  </tr>
  <tr>
    <td>Sc</td>
    <td>&amp;#x02ABC;</td>
    <td>&#x02ABC;</td>
    <td>dbl succeeds</td>
  </tr>
  <tr>
    <td>sc</td>
    <td>&amp;#x0227B;</td>
    <td>&#x0227B;</td>
    <td>/succ R: succeeds</td>
  </tr>
  <tr>
    <td>scap</td>
    <td>&amp;#x02AB8;</td>
    <td>&#x02AB8;</td>
    <td>/succapprox R: succeeds, approximate</td>
  </tr>
  <tr>
    <td>sccue</td>
    <td>&amp;#x0227D;</td>
    <td>&#x0227D;</td>
    <td>/succcurlyeq R: succeeds, curly eq</td>
  </tr>
  <tr>
    <td>scE</td>
    <td>&amp;#x02AB4;</td>
    <td>&#x02AB4;</td>
    <td>succeeds, dbl equals</td>
  </tr>
  <tr>
    <td>sce</td>
    <td>&amp;#x02AB0;</td>
    <td>&#x02AB0;</td>
    <td>/succeq R: succeeds, equals</td>
  </tr>
  <tr>
    <td>scsim</td>
    <td>&amp;#x0227F;</td>
    <td>&#x0227F;</td>
    <td>/succsim R: succeeds, similar</td>
  </tr>
  <tr>
    <td>sdote</td>
    <td>&amp;#x02A66;</td>
    <td>&#x02A66;</td>
    <td>equal, dot below</td>
  </tr>
  <tr>
    <td>sfrown</td>
    <td>&amp;#x02322;</td>
    <td>&#x02322;</td>
    <td>/smallfrown R: small down curve</td>
  </tr>
  <tr>
    <td>simg</td>
    <td>&amp;#x02A9E;</td>
    <td>&#x02A9E;</td>
    <td>similar, greater</td>
  </tr>
  <tr>
    <td>simgE</td>
    <td>&amp;#x02AA0;</td>
    <td>&#x02AA0;</td>
    <td>similar, greater, equal</td>
  </tr>
  <tr>
    <td>siml</td>
    <td>&amp;#x02A9D;</td>
    <td>&#x02A9D;</td>
    <td>similar, less</td>
  </tr>
  <tr>
    <td>simlE</td>
    <td>&amp;#x02A9F;</td>
    <td>&#x02A9F;</td>
    <td>similar, less, equal</td>
  </tr>
  <tr>
    <td>smid</td>
    <td>&amp;#x02223;</td>
    <td>&#x02223;</td>
    <td>/shortmid R:</td>
  </tr>
  <tr>
    <td>smile</td>
    <td>&amp;#x02323;</td>
    <td>&#x02323;</td>
    <td>/smile R: up curve</td>
  </tr>
  <tr>
    <td>smt</td>
    <td>&amp;#x02AAA;</td>
    <td>&#x02AAA;</td>
    <td>smaller than</td>
  </tr>
  <tr>
    <td>smte</td>
    <td>&amp;#x02AAC;</td>
    <td>&#x02AAC;</td>
    <td>smaller than or equal</td>
  </tr>
  <tr>
    <td>smtes</td>
    <td>&amp;#x02AAC;&amp;#x0FE00;</td>
    <td>&#x02AAC;&#x0FE00;</td>
    <td>smaller than or equal, slanted</td>
  </tr>
  <tr>
    <td>spar</td>
    <td>&amp;#x02225;</td>
    <td>&#x02225;</td>
    <td>/shortparallel R: short parallel</td>
  </tr>
  <tr>
    <td>sqsub</td>
    <td>&amp;#x0228F;</td>
    <td>&#x0228F;</td>
    <td>/sqsubset R: square subset</td>
  </tr>
  <tr>
    <td>sqsube</td>
    <td>&amp;#x02291;</td>
    <td>&#x02291;</td>
    <td>/sqsubseteq R: square subset, equals</td>
  </tr>
  <tr>
    <td>sqsup</td>
    <td>&amp;#x02290;</td>
    <td>&#x02290;</td>
    <td>/sqsupset R: square superset</td>
  </tr>
  <tr>
    <td>sqsupe</td>
    <td>&amp;#x02292;</td>
    <td>&#x02292;</td>
    <td>/sqsupseteq R: square superset, eq</td>
  </tr>
  <tr>
    <td>ssmile</td>
    <td>&amp;#x02323;</td>
    <td>&#x02323;</td>
    <td>/smallsmile R: small up curve</td>
  </tr>
  <tr>
    <td>Sub</td>
    <td>&amp;#x022D0;</td>
    <td>&#x022D0;</td>
    <td>/Subset R: double subset</td>
  </tr>
  <tr>
    <td>subE</td>
    <td>&amp;#x02AC5;</td>
    <td>&#x02AC5;</td>
    <td>/subseteqq R: subset, dbl equals</td>
  </tr>
  <tr>
    <td>subedot</td>
    <td>&amp;#x02AC3;</td>
    <td>&#x02AC3;</td>
    <td>subset, equals, dot</td>
  </tr>
  <tr>
    <td>submult</td>
    <td>&amp;#x02AC1;</td>
    <td>&#x02AC1;</td>
    <td>subset, multiply</td>
  </tr>
  <tr>
    <td>subplus</td>
    <td>&amp;#x02ABF;</td>
    <td>&#x02ABF;</td>
    <td>subset, plus</td>
  </tr>
  <tr>
    <td>subrarr</td>
    <td>&amp;#x02979;</td>
    <td>&#x02979;</td>
    <td>subset, right arrow</td>
  </tr>
  <tr>
    <td>subsim</td>
    <td>&amp;#x02AC7;</td>
    <td>&#x02AC7;</td>
    <td>subset, similar</td>
  </tr>
  <tr>
    <td>subsub</td>
    <td>&amp;#x02AD5;</td>
    <td>&#x02AD5;</td>
    <td>subset above subset</td>
  </tr>
  <tr>
    <td>subsup</td>
    <td>&amp;#x02AD3;</td>
    <td>&#x02AD3;</td>
    <td>subset above superset</td>
  </tr>
  <tr>
    <td>Sup</td>
    <td>&amp;#x022D1;</td>
    <td>&#x022D1;</td>
    <td>/Supset R: dbl superset</td>
  </tr>
  <tr>
    <td>supdsub</td>
    <td>&amp;#x02AD8;</td>
    <td>&#x02AD8;</td>
    <td>superset, subset, dash joining them</td>
  </tr>
  <tr>
    <td>supE</td>
    <td>&amp;#x02AC6;</td>
    <td>&#x02AC6;</td>
    <td>/supseteqq R: superset, dbl equals</td>
  </tr>
  <tr>
    <td>supedot</td>
    <td>&amp;#x02AC4;</td>
    <td>&#x02AC4;</td>
    <td>superset, equals, dot</td>
  </tr>
  <tr>
    <td>suphsol</td>
    <td>&amp;#x02283;&amp;#x0002F;</td>
    <td>&#x02283;&#x0002F;</td>
    <td>superset, solidus</td>
  </tr>
  <tr>
    <td>suphsub</td>
    <td>&amp;#x02AD7;</td>
    <td>&#x02AD7;</td>
    <td>superset, subset</td>
  </tr>
  <tr>
    <td>suplarr</td>
    <td>&amp;#x0297B;</td>
    <td>&#x0297B;</td>
    <td>superset, left arrow</td>
  </tr>
  <tr>
    <td>supmult</td>
    <td>&amp;#x02AC2;</td>
    <td>&#x02AC2;</td>
    <td>superset, multiply</td>
  </tr>
  <tr>
    <td>supplus</td>
    <td>&amp;#x02AC0;</td>
    <td>&#x02AC0;</td>
    <td>superset, plus</td>
  </tr>
  <tr>
    <td>supsim</td>
    <td>&amp;#x02AC8;</td>
    <td>&#x02AC8;</td>
    <td>superset, similar</td>
  </tr>
  <tr>
    <td>supsub</td>
    <td>&amp;#x02AD4;</td>
    <td>&#x02AD4;</td>
    <td>superset above subset</td>
  </tr>
  <tr>
    <td>supsup</td>
    <td>&amp;#x02AD6;</td>
    <td>&#x02AD6;</td>
    <td>superset above superset</td>
  </tr>
  <tr>
    <td>thkap</td>
    <td>&amp;#x02248;</td>
    <td>&#x02248;</td>
    <td>/thickapprox R: thick approximate</td>
  </tr>
  <tr>
    <td>thksim</td>
    <td>&amp;#x0223C;</td>
    <td>&#x0223C;</td>
    <td>/thicksim R: thick similar</td>
  </tr>
  <tr>
    <td>topfork</td>
    <td>&amp;#x02ADA;</td>
    <td>&#x02ADA;</td>
    <td>fork with top</td>
  </tr>
  <tr>
    <td>trie</td>
    <td>&amp;#x0225C;</td>
    <td>&#x0225C;</td>
    <td>/triangleq R: triangle, equals</td>
  </tr>
  <tr>
    <td>twixt</td>
    <td>&amp;#x0226C;</td>
    <td>&#x0226C;</td>
    <td>/between R: between</td>
  </tr>
  <tr>
    <td>Vbar</td>
    <td>&amp;#x02AEB;</td>
    <td>&#x02AEB;</td>
    <td>dbl vert, bar (under)</td>
  </tr>
  <tr>
    <td>vBar</td>
    <td>&amp;#x02AE8;</td>
    <td>&#x02AE8;</td>
    <td>vert, dbl bar (under)</td>
  </tr>
  <tr>
    <td>vBarv</td>
    <td>&amp;#x02AE9;</td>
    <td>&#x02AE9;</td>
    <td>dbl bar, vert over and under</td>
  </tr>
  <tr>
    <td>VDash</td>
    <td>&amp;#x022AB;</td>
    <td>&#x022AB;</td>
    <td>dbl vert, dbl dash</td>
  </tr>
  <tr>
    <td>Vdash</td>
    <td>&amp;#x022A9;</td>
    <td>&#x022A9;</td>
    <td>/Vdash R: dbl vertical, dash</td>
  </tr>
  <tr>
    <td>vDash</td>
    <td>&amp;#x022A8;</td>
    <td>&#x022A8;</td>
    <td>/vDash R: vertical, dbl dash</td>
  </tr>
  <tr>
    <td>vdash</td>
    <td>&amp;#x022A2;</td>
    <td>&#x022A2;</td>
    <td>/vdash R: vertical, dash</td>
  </tr>
  <tr>
    <td>Vdashl</td>
    <td>&amp;#x02AE6;</td>
    <td>&#x02AE6;</td>
    <td>vertical, dash (long)</td>
  </tr>
  <tr>
    <td>vltri</td>
    <td>&amp;#x022B2;</td>
    <td>&#x022B2;</td>
    <td>/vartriangleleft R: l tri, open, var</td>
  </tr>
  <tr>
    <td>vprop</td>
    <td>&amp;#x0221D;</td>
    <td>&#x0221D;</td>
    <td>/varpropto R: proportional, variant</td>
  </tr>
  <tr>
    <td>vrtri</td>
    <td>&amp;#x022B3;</td>
    <td>&#x022B3;</td>
    <td>/vartriangleright R: r tri, open, var</td>
  </tr>
  <tr>
    <td>Vvdash</td>
    <td>&amp;#x022AA;</td>
    <td>&#x022AA;</td>
    <td>/Vvdash R: triple vertical, dash</td>
  </tr>
  <tr>
    <td>boxDL</td>
    <td>&amp;#x02557;</td>
    <td>&#x02557;</td>
    <td>lower left quadrant</td>
  </tr>
  <tr>
    <td>boxDl</td>
    <td>&amp;#x02556;</td>
    <td>&#x02556;</td>
    <td>lower left quadrant</td>
  </tr>
  <tr>
    <td>boxdL</td>
    <td>&amp;#x02555;</td>
    <td>&#x02555;</td>
    <td>lower left quadrant</td>
  </tr>
  <tr>
    <td>boxdl</td>
    <td>&amp;#x02510;</td>
    <td>&#x02510;</td>
    <td>lower left quadrant</td>
  </tr>
  <tr>
    <td>boxDR</td>
    <td>&amp;#x02554;</td>
    <td>&#x02554;</td>
    <td>lower right quadrant</td>
  </tr>
  <tr>
    <td>boxDr</td>
    <td>&amp;#x02553;</td>
    <td>&#x02553;</td>
    <td>lower right quadrant</td>
  </tr>
  <tr>
    <td>boxdR</td>
    <td>&amp;#x02552;</td>
    <td>&#x02552;</td>
    <td>lower right quadrant</td>
  </tr>
  <tr>
    <td>boxdr</td>
    <td>&amp;#x0250C;</td>
    <td>&#x0250C;</td>
    <td>lower right quadrant</td>
  </tr>
  <tr>
    <td>boxH</td>
    <td>&amp;#x02550;</td>
    <td>&#x02550;</td>
    <td>horizontal line</td>
  </tr>
  <tr>
    <td>boxh</td>
    <td>&amp;#x02500;</td>
    <td>&#x02500;</td>
    <td>horizontal line</td>
  </tr>
  <tr>
    <td>boxHD</td>
    <td>&amp;#x02566;</td>
    <td>&#x02566;</td>
    <td>lower left and right quadrants</td>
  </tr>
  <tr>
    <td>boxHd</td>
    <td>&amp;#x02564;</td>
    <td>&#x02564;</td>
    <td>lower left and right quadrants</td>
  </tr>
  <tr>
    <td>boxhD</td>
    <td>&amp;#x02565;</td>
    <td>&#x02565;</td>
    <td>lower left and right quadrants</td>
  </tr>
  <tr>
    <td>boxhd</td>
    <td>&amp;#x0252C;</td>
    <td>&#x0252C;</td>
    <td>lower left and right quadrants</td>
  </tr>
  <tr>
    <td>boxHU</td>
    <td>&amp;#x02569;</td>
    <td>&#x02569;</td>
    <td>upper left and right quadrants</td>
  </tr>
  <tr>
    <td>boxHu</td>
    <td>&amp;#x02567;</td>
    <td>&#x02567;</td>
    <td>upper left and right quadrants</td>
  </tr>
  <tr>
    <td>boxhU</td>
    <td>&amp;#x02568;</td>
    <td>&#x02568;</td>
    <td>upper left and right quadrants</td>
  </tr>
  <tr>
    <td>boxhu</td>
    <td>&amp;#x02534;</td>
    <td>&#x02534;</td>
    <td>upper left and right quadrants</td>
  </tr>
  <tr>
    <td>boxUL</td>
    <td>&amp;#x0255D;</td>
    <td>&#x0255D;</td>
    <td>upper left quadrant</td>
  </tr>
  <tr>
    <td>boxUl</td>
    <td>&amp;#x0255C;</td>
    <td>&#x0255C;</td>
    <td>upper left quadrant</td>
  </tr>
  <tr>
    <td>boxuL</td>
    <td>&amp;#x0255B;</td>
    <td>&#x0255B;</td>
    <td>upper left quadrant</td>
  </tr>
  <tr>
    <td>boxul</td>
    <td>&amp;#x02518;</td>
    <td>&#x02518;</td>
    <td>upper left quadrant</td>
  </tr>
  <tr>
    <td>boxUR</td>
    <td>&amp;#x0255A;</td>
    <td>&#x0255A;</td>
    <td>upper right quadrant</td>
  </tr>
  <tr>
    <td>boxUr</td>
    <td>&amp;#x02559;</td>
    <td>&#x02559;</td>
    <td>upper right quadrant</td>
  </tr>
  <tr>
    <td>boxuR</td>
    <td>&amp;#x02558;</td>
    <td>&#x02558;</td>
    <td>upper right quadrant</td>
  </tr>
  <tr>
    <td>boxur</td>
    <td>&amp;#x02514;</td>
    <td>&#x02514;</td>
    <td>upper right quadrant</td>
  </tr>
  <tr>
    <td>boxV</td>
    <td>&amp;#x02551;</td>
    <td>&#x02551;</td>
    <td>vertical line</td>
  </tr>
  <tr>
    <td>boxv</td>
    <td>&amp;#x02502;</td>
    <td>&#x02502;</td>
    <td>vertical line</td>
  </tr>
  <tr>
    <td>boxVH</td>
    <td>&amp;#x0256C;</td>
    <td>&#x0256C;</td>
    <td>all four quadrants</td>
  </tr>
  <tr>
    <td>boxVh</td>
    <td>&amp;#x0256B;</td>
    <td>&#x0256B;</td>
    <td>all four quadrants</td>
  </tr>
  <tr>
    <td>boxvH</td>
    <td>&amp;#x0256A;</td>
    <td>&#x0256A;</td>
    <td>all four quadrants</td>
  </tr>
  <tr>
    <td>boxvh</td>
    <td>&amp;#x0253C;</td>
    <td>&#x0253C;</td>
    <td>all four quadrants</td>
  </tr>
  <tr>
    <td>boxVL</td>
    <td>&amp;#x02563;</td>
    <td>&#x02563;</td>
    <td>upper and lower left quadrants</td>
  </tr>
  <tr>
    <td>boxVl</td>
    <td>&amp;#x02562;</td>
    <td>&#x02562;</td>
    <td>upper and lower left quadrants</td>
  </tr>
  <tr>
    <td>boxvL</td>
    <td>&amp;#x02561;</td>
    <td>&#x02561;</td>
    <td>upper and lower left quadrants</td>
  </tr>
  <tr>
    <td>boxvl</td>
    <td>&amp;#x02524;</td>
    <td>&#x02524;</td>
    <td>upper and lower left quadrants</td>
  </tr>
  <tr>
    <td>boxVR</td>
    <td>&amp;#x02560;</td>
    <td>&#x02560;</td>
    <td>upper and lower right quadrants</td>
  </tr>
  <tr>
    <td>boxVr</td>
    <td>&amp;#x0255F;</td>
    <td>&#x0255F;</td>
    <td>upper and lower right quadrants</td>
  </tr>
  <tr>
    <td>boxvR</td>
    <td>&amp;#x0255E;</td>
    <td>&#x0255E;</td>
    <td>upper and lower right quadrants</td>
  </tr>
  <tr>
    <td>boxvr</td>
    <td>&amp;#x0251C;</td>
    <td>&#x0251C;</td>
    <td>upper and lower right quadrants</td>
  </tr>
  <tr>
    <td>Acy</td>
    <td>&amp;#x00410;</td>
    <td>&#x00410;</td>
    <td>=capital A, Cyrillic</td>
  </tr>
  <tr>
    <td>acy</td>
    <td>&amp;#x00430;</td>
    <td>&#x00430;</td>
    <td>=small a, Cyrillic</td>
  </tr>
  <tr>
    <td>Bcy</td>
    <td>&amp;#x00411;</td>
    <td>&#x00411;</td>
    <td>=capital BE, Cyrillic</td>
  </tr>
  <tr>
    <td>bcy</td>
    <td>&amp;#x00431;</td>
    <td>&#x00431;</td>
    <td>=small be, Cyrillic</td>
  </tr>
  <tr>
    <td>CHcy</td>
    <td>&amp;#x00427;</td>
    <td>&#x00427;</td>
    <td>=capital CHE, Cyrillic</td>
  </tr>
  <tr>
    <td>chcy</td>
    <td>&amp;#x00447;</td>
    <td>&#x00447;</td>
    <td>=small che, Cyrillic</td>
  </tr>
  <tr>
    <td>Dcy</td>
    <td>&amp;#x00414;</td>
    <td>&#x00414;</td>
    <td>=capital DE, Cyrillic</td>
  </tr>
  <tr>
    <td>dcy</td>
    <td>&amp;#x00434;</td>
    <td>&#x00434;</td>
    <td>=small de, Cyrillic</td>
  </tr>
  <tr>
    <td>Ecy</td>
    <td>&amp;#x0042D;</td>
    <td>&#x0042D;</td>
    <td>=capital E, Cyrillic</td>
  </tr>
  <tr>
    <td>ecy</td>
    <td>&amp;#x0044D;</td>
    <td>&#x0044D;</td>
    <td>=small e, Cyrillic</td>
  </tr>
  <tr>
    <td>Fcy</td>
    <td>&amp;#x00424;</td>
    <td>&#x00424;</td>
    <td>=capital EF, Cyrillic</td>
  </tr>
  <tr>
    <td>fcy</td>
    <td>&amp;#x00444;</td>
    <td>&#x00444;</td>
    <td>=small ef, Cyrillic</td>
  </tr>
  <tr>
    <td>Gcy</td>
    <td>&amp;#x00413;</td>
    <td>&#x00413;</td>
    <td>=capital GHE, Cyrillic</td>
  </tr>
  <tr>
    <td>gcy</td>
    <td>&amp;#x00433;</td>
    <td>&#x00433;</td>
    <td>=small ghe, Cyrillic</td>
  </tr>
  <tr>
    <td>HARDcy</td>
    <td>&amp;#x0042A;</td>
    <td>&#x0042A;</td>
    <td>=capital HARD sign, Cyrillic</td>
  </tr>
  <tr>
    <td>hardcy</td>
    <td>&amp;#x0044A;</td>
    <td>&#x0044A;</td>
    <td>=small hard sign, Cyrillic</td>
  </tr>
  <tr>
    <td>Icy</td>
    <td>&amp;#x00418;</td>
    <td>&#x00418;</td>
    <td>=capital I, Cyrillic</td>
  </tr>
  <tr>
    <td>icy</td>
    <td>&amp;#x00438;</td>
    <td>&#x00438;</td>
    <td>=small i, Cyrillic</td>
  </tr>
  <tr>
    <td>IEcy</td>
    <td>&amp;#x00415;</td>
    <td>&#x00415;</td>
    <td>=capital IE, Cyrillic</td>
  </tr>
  <tr>
    <td>iecy</td>
    <td>&amp;#x00435;</td>
    <td>&#x00435;</td>
    <td>=small ie, Cyrillic</td>
  </tr>
  <tr>
    <td>IOcy</td>
    <td>&amp;#x00401;</td>
    <td>&#x00401;</td>
    <td>=capital IO, Russian</td>
  </tr>
  <tr>
    <td>iocy</td>
    <td>&amp;#x00451;</td>
    <td>&#x00451;</td>
    <td>=small io, Russian</td>
  </tr>
  <tr>
    <td>Jcy</td>
    <td>&amp;#x00419;</td>
    <td>&#x00419;</td>
    <td>=capital short I, Cyrillic</td>
  </tr>
  <tr>
    <td>jcy</td>
    <td>&amp;#x00439;</td>
    <td>&#x00439;</td>
    <td>=small short i, Cyrillic</td>
  </tr>
  <tr>
    <td>Kcy</td>
    <td>&amp;#x0041A;</td>
    <td>&#x0041A;</td>
    <td>=capital KA, Cyrillic</td>
  </tr>
  <tr>
    <td>kcy</td>
    <td>&amp;#x0043A;</td>
    <td>&#x0043A;</td>
    <td>=small ka, Cyrillic</td>
  </tr>
  <tr>
    <td>KHcy</td>
    <td>&amp;#x00425;</td>
    <td>&#x00425;</td>
    <td>=capital HA, Cyrillic</td>
  </tr>
  <tr>
    <td>khcy</td>
    <td>&amp;#x00445;</td>
    <td>&#x00445;</td>
    <td>=small ha, Cyrillic</td>
  </tr>
  <tr>
    <td>Lcy</td>
    <td>&amp;#x0041B;</td>
    <td>&#x0041B;</td>
    <td>=capital EL, Cyrillic</td>
  </tr>
  <tr>
    <td>lcy</td>
    <td>&amp;#x0043B;</td>
    <td>&#x0043B;</td>
    <td>=small el, Cyrillic</td>
  </tr>
  <tr>
    <td>Mcy</td>
    <td>&amp;#x0041C;</td>
    <td>&#x0041C;</td>
    <td>=capital EM, Cyrillic</td>
  </tr>
  <tr>
    <td>mcy</td>
    <td>&amp;#x0043C;</td>
    <td>&#x0043C;</td>
    <td>=small em, Cyrillic</td>
  </tr>
  <tr>
    <td>Ncy</td>
    <td>&amp;#x0041D;</td>
    <td>&#x0041D;</td>
    <td>=capital EN, Cyrillic</td>
  </tr>
  <tr>
    <td>ncy</td>
    <td>&amp;#x0043D;</td>
    <td>&#x0043D;</td>
    <td>=small en, Cyrillic</td>
  </tr>
  <tr>
    <td>numero</td>
    <td>&amp;#x02116;</td>
    <td>&#x02116;</td>
    <td>=numero sign</td>
  </tr>
  <tr>
    <td>Ocy</td>
    <td>&amp;#x0041E;</td>
    <td>&#x0041E;</td>
    <td>=capital O, Cyrillic</td>
  </tr>
  <tr>
    <td>ocy</td>
    <td>&amp;#x0043E;</td>
    <td>&#x0043E;</td>
    <td>=small o, Cyrillic</td>
  </tr>
  <tr>
    <td>Pcy</td>
    <td>&amp;#x0041F;</td>
    <td>&#x0041F;</td>
    <td>=capital PE, Cyrillic</td>
  </tr>
  <tr>
    <td>pcy</td>
    <td>&amp;#x0043F;</td>
    <td>&#x0043F;</td>
    <td>=small pe, Cyrillic</td>
  </tr>
  <tr>
    <td>Rcy</td>
    <td>&amp;#x00420;</td>
    <td>&#x00420;</td>
    <td>=capital ER, Cyrillic</td>
  </tr>
  <tr>
    <td>rcy</td>
    <td>&amp;#x00440;</td>
    <td>&#x00440;</td>
    <td>=small er, Cyrillic</td>
  </tr>
  <tr>
    <td>Scy</td>
    <td>&amp;#x00421;</td>
    <td>&#x00421;</td>
    <td>=capital ES, Cyrillic</td>
  </tr>
  <tr>
    <td>scy</td>
    <td>&amp;#x00441;</td>
    <td>&#x00441;</td>
    <td>=small es, Cyrillic</td>
  </tr>
  <tr>
    <td>SHCHcy</td>
    <td>&amp;#x00429;</td>
    <td>&#x00429;</td>
    <td>=capital SHCHA, Cyrillic</td>
  </tr>
  <tr>
    <td>shchcy</td>
    <td>&amp;#x00449;</td>
    <td>&#x00449;</td>
    <td>=small shcha, Cyrillic</td>
  </tr>
  <tr>
    <td>SHcy</td>
    <td>&amp;#x00428;</td>
    <td>&#x00428;</td>
    <td>=capital SHA, Cyrillic</td>
  </tr>
  <tr>
    <td>shcy</td>
    <td>&amp;#x00448;</td>
    <td>&#x00448;</td>
    <td>=small sha, Cyrillic</td>
  </tr>
  <tr>
    <td>SOFTcy</td>
    <td>&amp;#x0042C;</td>
    <td>&#x0042C;</td>
    <td>=capital SOFT sign, Cyrillic</td>
  </tr>
  <tr>
    <td>softcy</td>
    <td>&amp;#x0044C;</td>
    <td>&#x0044C;</td>
    <td>=small soft sign, Cyrillic</td>
  </tr>
  <tr>
    <td>Tcy</td>
    <td>&amp;#x00422;</td>
    <td>&#x00422;</td>
    <td>=capital TE, Cyrillic</td>
  </tr>
  <tr>
    <td>tcy</td>
    <td>&amp;#x00442;</td>
    <td>&#x00442;</td>
    <td>=small te, Cyrillic</td>
  </tr>
  <tr>
    <td>TScy</td>
    <td>&amp;#x00426;</td>
    <td>&#x00426;</td>
    <td>=capital TSE, Cyrillic</td>
  </tr>
  <tr>
    <td>tscy</td>
    <td>&amp;#x00446;</td>
    <td>&#x00446;</td>
    <td>=small tse, Cyrillic</td>
  </tr>
  <tr>
    <td>Ucy</td>
    <td>&amp;#x00423;</td>
    <td>&#x00423;</td>
    <td>=capital U, Cyrillic</td>
  </tr>
  <tr>
    <td>ucy</td>
    <td>&amp;#x00443;</td>
    <td>&#x00443;</td>
    <td>=small u, Cyrillic</td>
  </tr>
  <tr>
    <td>Vcy</td>
    <td>&amp;#x00412;</td>
    <td>&#x00412;</td>
    <td>=capital VE, Cyrillic</td>
  </tr>
  <tr>
    <td>vcy</td>
    <td>&amp;#x00432;</td>
    <td>&#x00432;</td>
    <td>=small ve, Cyrillic</td>
  </tr>
  <tr>
    <td>YAcy</td>
    <td>&amp;#x0042F;</td>
    <td>&#x0042F;</td>
    <td>=capital YA, Cyrillic</td>
  </tr>
  <tr>
    <td>yacy</td>
    <td>&amp;#x0044F;</td>
    <td>&#x0044F;</td>
    <td>=small ya, Cyrillic</td>
  </tr>
  <tr>
    <td>Ycy</td>
    <td>&amp;#x0042B;</td>
    <td>&#x0042B;</td>
    <td>=capital YERU, Cyrillic</td>
  </tr>
  <tr>
    <td>ycy</td>
    <td>&amp;#x0044B;</td>
    <td>&#x0044B;</td>
    <td>=small yeru, Cyrillic</td>
  </tr>
  <tr>
    <td>YUcy</td>
    <td>&amp;#x0042E;</td>
    <td>&#x0042E;</td>
    <td>=capital YU, Cyrillic</td>
  </tr>
  <tr>
    <td>yucy</td>
    <td>&amp;#x0044E;</td>
    <td>&#x0044E;</td>
    <td>=small yu, Cyrillic</td>
  </tr>
  <tr>
    <td>Zcy</td>
    <td>&amp;#x00417;</td>
    <td>&#x00417;</td>
    <td>=capital ZE, Cyrillic</td>
  </tr>
  <tr>
    <td>zcy</td>
    <td>&amp;#x00437;</td>
    <td>&#x00437;</td>
    <td>=small ze, Cyrillic</td>
  </tr>
  <tr>
    <td>ZHcy</td>
    <td>&amp;#x00416;</td>
    <td>&#x00416;</td>
    <td>=capital ZHE, Cyrillic</td>
  </tr>
  <tr>
    <td>zhcy</td>
    <td>&amp;#x00436;</td>
    <td>&#x00436;</td>
    <td>=small zhe, Cyrillic</td>
  </tr>
  <tr>
    <td>DJcy</td>
    <td>&amp;#x00402;</td>
    <td>&#x00402;</td>
    <td>=capital DJE, Serbian</td>
  </tr>
  <tr>
    <td>djcy</td>
    <td>&amp;#x00452;</td>
    <td>&#x00452;</td>
    <td>=small dje, Serbian</td>
  </tr>
  <tr>
    <td>DScy</td>
    <td>&amp;#x00405;</td>
    <td>&#x00405;</td>
    <td>=capital DSE, Macedonian</td>
  </tr>
  <tr>
    <td>dscy</td>
    <td>&amp;#x00455;</td>
    <td>&#x00455;</td>
    <td>=small dse, Macedonian</td>
  </tr>
  <tr>
    <td>DZcy</td>
    <td>&amp;#x0040F;</td>
    <td>&#x0040F;</td>
    <td>=capital dze, Serbian</td>
  </tr>
  <tr>
    <td>dzcy</td>
    <td>&amp;#x0045F;</td>
    <td>&#x0045F;</td>
    <td>=small dze, Serbian</td>
  </tr>
  <tr>
    <td>GJcy</td>
    <td>&amp;#x00403;</td>
    <td>&#x00403;</td>
    <td>=capital GJE Macedonian</td>
  </tr>
  <tr>
    <td>gjcy</td>
    <td>&amp;#x00453;</td>
    <td>&#x00453;</td>
    <td>=small gje, Macedonian</td>
  </tr>
  <tr>
    <td>Iukcy</td>
    <td>&amp;#x00406;</td>
    <td>&#x00406;</td>
    <td>=capital I, Ukrainian</td>
  </tr>
  <tr>
    <td>iukcy</td>
    <td>&amp;#x00456;</td>
    <td>&#x00456;</td>
    <td>=small i, Ukrainian</td>
  </tr>
  <tr>
    <td>Jsercy</td>
    <td>&amp;#x00408;</td>
    <td>&#x00408;</td>
    <td>=capital JE, Serbian</td>
  </tr>
  <tr>
    <td>jsercy</td>
    <td>&amp;#x00458;</td>
    <td>&#x00458;</td>
    <td>=small je, Serbian</td>
  </tr>
  <tr>
    <td>Jukcy</td>
    <td>&amp;#x00404;</td>
    <td>&#x00404;</td>
    <td>=capital JE, Ukrainian</td>
  </tr>
  <tr>
    <td>jukcy</td>
    <td>&amp;#x00454;</td>
    <td>&#x00454;</td>
    <td>=small je, Ukrainian</td>
  </tr>
  <tr>
    <td>KJcy</td>
    <td>&amp;#x0040C;</td>
    <td>&#x0040C;</td>
    <td>=capital KJE, Macedonian</td>
  </tr>
  <tr>
    <td>kjcy</td>
    <td>&amp;#x0045C;</td>
    <td>&#x0045C;</td>
    <td>=small kje Macedonian</td>
  </tr>
  <tr>
    <td>LJcy</td>
    <td>&amp;#x00409;</td>
    <td>&#x00409;</td>
    <td>=capital LJE, Serbian</td>
  </tr>
  <tr>
    <td>ljcy</td>
    <td>&amp;#x00459;</td>
    <td>&#x00459;</td>
    <td>=small lje, Serbian</td>
  </tr>
  <tr>
    <td>NJcy</td>
    <td>&amp;#x0040A;</td>
    <td>&#x0040A;</td>
    <td>=capital NJE, Serbian</td>
  </tr>
  <tr>
    <td>njcy</td>
    <td>&amp;#x0045A;</td>
    <td>&#x0045A;</td>
    <td>=small nje, Serbian</td>
  </tr>
  <tr>
    <td>TSHcy</td>
    <td>&amp;#x0040B;</td>
    <td>&#x0040B;</td>
    <td>=capital TSHE, Serbian</td>
  </tr>
  <tr>
    <td>tshcy</td>
    <td>&amp;#x0045B;</td>
    <td>&#x0045B;</td>
    <td>=small tshe, Serbian</td>
  </tr>
  <tr>
    <td>Ubrcy</td>
    <td>&amp;#x0040E;</td>
    <td>&#x0040E;</td>
    <td>=capital U, Byelorussian</td>
  </tr>
  <tr>
    <td>ubrcy</td>
    <td>&amp;#x0045E;</td>
    <td>&#x0045E;</td>
    <td>=small u, Byelorussian</td>
  </tr>
  <tr>
    <td>YIcy</td>
    <td>&amp;#x00407;</td>
    <td>&#x00407;</td>
    <td>=capital YI, Ukrainian</td>
  </tr>
  <tr>
    <td>yicy</td>
    <td>&amp;#x00457;</td>
    <td>&#x00457;</td>
    <td>=small yi, Ukrainian</td>
  </tr>
  <tr>
    <td>acute</td>
    <td>&amp;#x000B4;</td>
    <td>&#x000B4;</td>
    <td>=acute accent</td>
  </tr>
  <tr>
    <td>breve</td>
    <td>&amp;#x002D8;</td>
    <td>&#x002D8;</td>
    <td>=breve</td>
  </tr>
  <tr>
    <td>caron</td>
    <td>&amp;#x002C7;</td>
    <td>&#x002C7;</td>
    <td>=caron</td>
  </tr>
  <tr>
    <td>cedil</td>
    <td>&amp;#x000B8;</td>
    <td>&#x000B8;</td>
    <td>=cedilla</td>
  </tr>
  <tr>
    <td>circ</td>
    <td>&amp;#x002C6;</td>
    <td>&#x002C6;</td>
    <td>circumflex accent</td>
  </tr>
  <tr>
    <td>dblac</td>
    <td>&amp;#x002DD;</td>
    <td>&#x002DD;</td>
    <td>=double acute accent</td>
  </tr>
  <tr>
    <td>die</td>
    <td>&amp;#x000A8;</td>
    <td>&#x000A8;</td>
    <td>=dieresis</td>
  </tr>
  <tr>
    <td>dot</td>
    <td>&amp;#x002D9;</td>
    <td>&#x002D9;</td>
    <td>=dot above</td>
  </tr>
  <tr>
    <td>grave</td>
    <td>&amp;#x00060;</td>
    <td>&#x00060;</td>
    <td>=grave accent</td>
  </tr>
  <tr>
    <td>macr</td>
    <td>&amp;#x000AF;</td>
    <td>&#x000AF;</td>
    <td>=macron</td>
  </tr>
  <tr>
    <td>ogon</td>
    <td>&amp;#x002DB;</td>
    <td>&#x002DB;</td>
    <td>=ogonek</td>
  </tr>
  <tr>
    <td>ring</td>
    <td>&amp;#x002DA;</td>
    <td>&#x002DA;</td>
    <td>=ring</td>
  </tr>
  <tr>
    <td>tilde</td>
    <td>&amp;#x002DC;</td>
    <td>&#x002DC;</td>
    <td>=tilde</td>
  </tr>
  <tr>
    <td>uml</td>
    <td>&amp;#x000A8;</td>
    <td>&#x000A8;</td>
    <td>=umlaut mark</td>
  </tr>
  <tr>
    <td>alpha</td>
    <td>&amp;#x003B1;</td>
    <td>&#x003B1;</td>
    <td>/alpha small alpha, Greek</td>
  </tr>
  <tr>
    <td>beta</td>
    <td>&amp;#x003B2;</td>
    <td>&#x003B2;</td>
    <td>/beta small beta, Greek</td>
  </tr>
  <tr>
    <td>chi</td>
    <td>&amp;#x003C7;</td>
    <td>&#x003C7;</td>
    <td>/chi small chi, Greek</td>
  </tr>
  <tr>
    <td>Delta</td>
    <td>&amp;#x00394;</td>
    <td>&#x00394;</td>
    <td>/Delta capital Delta, Greek</td>
  </tr>
  <tr>
    <td>delta</td>
    <td>&amp;#x003B4;</td>
    <td>&#x003B4;</td>
    <td>/delta small delta, Greek</td>
  </tr>
  <tr>
    <td>epsi</td>
    <td>&amp;#x003F5;</td>
    <td>&#x003F5;</td>
    <td>/straightepsilon, small epsilon, Greek</td>
  </tr>
  <tr>
    <td>epsiv</td>
    <td>&amp;#x003B5;</td>
    <td>&#x003B5;</td>
    <td>/varepsilon</td>
  </tr>
  <tr>
    <td>eta</td>
    <td>&amp;#x003B7;</td>
    <td>&#x003B7;</td>
    <td>/eta small eta, Greek</td>
  </tr>
  <tr>
    <td>Gamma</td>
    <td>&amp;#x00393;</td>
    <td>&#x00393;</td>
    <td>/Gamma capital Gamma, Greek</td>
  </tr>
  <tr>
    <td>gamma</td>
    <td>&amp;#x003B3;</td>
    <td>&#x003B3;</td>
    <td>/gamma small gamma, Greek</td>
  </tr>
  <tr>
    <td>Gammad</td>
    <td>&amp;#x003DC;</td>
    <td>&#x003DC;</td>
    <td>capital digamma</td>
  </tr>
  <tr>
    <td>gammad</td>
    <td>&amp;#x003DD;</td>
    <td>&#x003DD;</td>
    <td>/digamma</td>
  </tr>
  <tr>
    <td>iota</td>
    <td>&amp;#x003B9;</td>
    <td>&#x003B9;</td>
    <td>/iota small iota, Greek</td>
  </tr>
  <tr>
    <td>kappa</td>
    <td>&amp;#x003BA;</td>
    <td>&#x003BA;</td>
    <td>/kappa small kappa, Greek</td>
  </tr>
  <tr>
    <td>kappav</td>
    <td>&amp;#x003F0;</td>
    <td>&#x003F0;</td>
    <td>/varkappa</td>
  </tr>
  <tr>
    <td>Lambda</td>
    <td>&amp;#x0039B;</td>
    <td>&#x0039B;</td>
    <td>/Lambda capital Lambda, Greek</td>
  </tr>
  <tr>
    <td>lambda</td>
    <td>&amp;#x003BB;</td>
    <td>&#x003BB;</td>
    <td>/lambda small lambda, Greek</td>
  </tr>
  <tr>
    <td>mu</td>
    <td>&amp;#x003BC;</td>
    <td>&#x003BC;</td>
    <td>/mu small mu, Greek</td>
  </tr>
  <tr>
    <td>nu</td>
    <td>&amp;#x003BD;</td>
    <td>&#x003BD;</td>
    <td>/nu small nu, Greek</td>
  </tr>
  <tr>
    <td>Omega</td>
    <td>&amp;#x003A9;</td>
    <td>&#x003A9;</td>
    <td>/Omega capital Omega, Greek</td>
  </tr>
  <tr>
    <td>omega</td>
    <td>&amp;#x003C9;</td>
    <td>&#x003C9;</td>
    <td>/omega small omega, Greek</td>
  </tr>
  <tr>
    <td>Phi</td>
    <td>&amp;#x003A6;</td>
    <td>&#x003A6;</td>
    <td>/Phi capital Phi, Greek</td>
  </tr>
  <tr>
    <td>phi</td>
    <td>&amp;#x003D5;</td>
    <td>&#x003D5;</td>
    <td>/straightphi - small phi, Greek</td>
  </tr>
  <tr>
    <td>phiv</td>
    <td>&amp;#x003C6;</td>
    <td>&#x003C6;</td>
    <td>/varphi - curly or open phi</td>
  </tr>
  <tr>
    <td>Pi</td>
    <td>&amp;#x003A0;</td>
    <td>&#x003A0;</td>
    <td>/Pi capital Pi, Greek</td>
  </tr>
  <tr>
    <td>pi</td>
    <td>&amp;#x003C0;</td>
    <td>&#x003C0;</td>
    <td>/pi small pi, Greek</td>
  </tr>
  <tr>
    <td>piv</td>
    <td>&amp;#x003D6;</td>
    <td>&#x003D6;</td>
    <td>/varpi</td>
  </tr>
  <tr>
    <td>Psi</td>
    <td>&amp;#x003A8;</td>
    <td>&#x003A8;</td>
    <td>/Psi capital Psi, Greek</td>
  </tr>
  <tr>
    <td>psi</td>
    <td>&amp;#x003C8;</td>
    <td>&#x003C8;</td>
    <td>/psi small psi, Greek</td>
  </tr>
  <tr>
    <td>rho</td>
    <td>&amp;#x003C1;</td>
    <td>&#x003C1;</td>
    <td>/rho small rho, Greek</td>
  </tr>
  <tr>
    <td>rhov</td>
    <td>&amp;#x003F1;</td>
    <td>&#x003F1;</td>
    <td>/varrho</td>
  </tr>
  <tr>
    <td>Sigma</td>
    <td>&amp;#x003A3;</td>
    <td>&#x003A3;</td>
    <td>/Sigma capital Sigma, Greek</td>
  </tr>
  <tr>
    <td>sigma</td>
    <td>&amp;#x003C3;</td>
    <td>&#x003C3;</td>
    <td>/sigma small sigma, Greek</td>
  </tr>
  <tr>
    <td>sigmav</td>
    <td>&amp;#x003C2;</td>
    <td>&#x003C2;</td>
    <td>/varsigma</td>
  </tr>
  <tr>
    <td>tau</td>
    <td>&amp;#x003C4;</td>
    <td>&#x003C4;</td>
    <td>/tau small tau, Greek</td>
  </tr>
  <tr>
    <td>Theta</td>
    <td>&amp;#x00398;</td>
    <td>&#x00398;</td>
    <td>/Theta capital Theta, Greek</td>
  </tr>
  <tr>
    <td>theta</td>
    <td>&amp;#x003B8;</td>
    <td>&#x003B8;</td>
    <td>/theta straight theta, small theta, Greek</td>
  </tr>
  <tr>
    <td>thetav</td>
    <td>&amp;#x003D1;</td>
    <td>&#x003D1;</td>
    <td>/vartheta - curly or open theta</td>
  </tr>
  <tr>
    <td>Upsi</td>
    <td>&amp;#x003D2;</td>
    <td>&#x003D2;</td>
    <td>/Upsilon capital Upsilon, Greek</td>
  </tr>
  <tr>
    <td>upsi</td>
    <td>&amp;#x003C5;</td>
    <td>&#x003C5;</td>
    <td>/upsilon small upsilon, Greek</td>
  </tr>
  <tr>
    <td>Xi</td>
    <td>&amp;#x0039E;</td>
    <td>&#x0039E;</td>
    <td>/Xi capital Xi, Greek</td>
  </tr>
  <tr>
    <td>xi</td>
    <td>&amp;#x003BE;</td>
    <td>&#x003BE;</td>
    <td>/xi small xi, Greek</td>
  </tr>
  <tr>
    <td>zeta</td>
    <td>&amp;#x003B6;</td>
    <td>&#x003B6;</td>
    <td>/zeta small zeta, Greek</td>
  </tr>
  <tr>
    <td>Aacute</td>
    <td>&amp;#x000C1;</td>
    <td>&#x000C1;</td>
    <td>=capital A, acute accent</td>
  </tr>
  <tr>
    <td>aacute</td>
    <td>&amp;#x000E1;</td>
    <td>&#x000E1;</td>
    <td>=small a, acute accent</td>
  </tr>
  <tr>
    <td>Acirc</td>
    <td>&amp;#x000C2;</td>
    <td>&#x000C2;</td>
    <td>=capital A, circumflex accent</td>
  </tr>
  <tr>
    <td>acirc</td>
    <td>&amp;#x000E2;</td>
    <td>&#x000E2;</td>
    <td>=small a, circumflex accent</td>
  </tr>
  <tr>
    <td>AElig</td>
    <td>&amp;#x000C6;</td>
    <td>&#x000C6;</td>
    <td>=capital AE diphthong (ligature)</td>
  </tr>
  <tr>
    <td>aelig</td>
    <td>&amp;#x000E6;</td>
    <td>&#x000E6;</td>
    <td>=small ae diphthong (ligature)</td>
  </tr>
  <tr>
    <td>Agrave</td>
    <td>&amp;#x000C0;</td>
    <td>&#x000C0;</td>
    <td>=capital A, grave accent</td>
  </tr>
  <tr>
    <td>agrave</td>
    <td>&amp;#x000E0;</td>
    <td>&#x000E0;</td>
    <td>=small a, grave accent</td>
  </tr>
  <tr>
    <td>Aring</td>
    <td>&amp;#x000C5;</td>
    <td>&#x000C5;</td>
    <td>=capital A, ring</td>
  </tr>
  <tr>
    <td>aring</td>
    <td>&amp;#x000E5;</td>
    <td>&#x000E5;</td>
    <td>=small a, ring</td>
  </tr>
  <tr>
    <td>Atilde</td>
    <td>&amp;#x000C3;</td>
    <td>&#x000C3;</td>
    <td>=capital A, tilde</td>
  </tr>
  <tr>
    <td>atilde</td>
    <td>&amp;#x000E3;</td>
    <td>&#x000E3;</td>
    <td>=small a, tilde</td>
  </tr>
  <tr>
    <td>Auml</td>
    <td>&amp;#x000C4;</td>
    <td>&#x000C4;</td>
    <td>=capital A, dieresis or umlaut mark</td>
  </tr>
  <tr>
    <td>auml</td>
    <td>&amp;#x000E4;</td>
    <td>&#x000E4;</td>
    <td>=small a, dieresis or umlaut mark</td>
  </tr>
  <tr>
    <td>Ccedil</td>
    <td>&amp;#x000C7;</td>
    <td>&#x000C7;</td>
    <td>=capital C, cedilla</td>
  </tr>
  <tr>
    <td>ccedil</td>
    <td>&amp;#x000E7;</td>
    <td>&#x000E7;</td>
    <td>=small c, cedilla</td>
  </tr>
  <tr>
    <td>Eacute</td>
    <td>&amp;#x000C9;</td>
    <td>&#x000C9;</td>
    <td>=capital E, acute accent</td>
  </tr>
  <tr>
    <td>eacute</td>
    <td>&amp;#x000E9;</td>
    <td>&#x000E9;</td>
    <td>=small e, acute accent</td>
  </tr>
  <tr>
    <td>Ecirc</td>
    <td>&amp;#x000CA;</td>
    <td>&#x000CA;</td>
    <td>=capital E, circumflex accent</td>
  </tr>
  <tr>
    <td>ecirc</td>
    <td>&amp;#x000EA;</td>
    <td>&#x000EA;</td>
    <td>=small e, circumflex accent</td>
  </tr>
  <tr>
    <td>Egrave</td>
    <td>&amp;#x000C8;</td>
    <td>&#x000C8;</td>
    <td>=capital E, grave accent</td>
  </tr>
  <tr>
    <td>egrave</td>
    <td>&amp;#x000E8;</td>
    <td>&#x000E8;</td>
    <td>=small e, grave accent</td>
  </tr>
  <tr>
    <td>ETH</td>
    <td>&amp;#x000D0;</td>
    <td>&#x000D0;</td>
    <td>=capital Eth, Icelandic</td>
  </tr>
  <tr>
    <td>eth</td>
    <td>&amp;#x000F0;</td>
    <td>&#x000F0;</td>
    <td>=small eth, Icelandic</td>
  </tr>
  <tr>
    <td>Euml</td>
    <td>&amp;#x000CB;</td>
    <td>&#x000CB;</td>
    <td>=capital E, dieresis or umlaut mark</td>
  </tr>
  <tr>
    <td>euml</td>
    <td>&amp;#x000EB;</td>
    <td>&#x000EB;</td>
    <td>=small e, dieresis or umlaut mark</td>
  </tr>
  <tr>
    <td>Iacute</td>
    <td>&amp;#x000CD;</td>
    <td>&#x000CD;</td>
    <td>=capital I, acute accent</td>
  </tr>
  <tr>
    <td>iacute</td>
    <td>&amp;#x000ED;</td>
    <td>&#x000ED;</td>
    <td>=small i, acute accent</td>
  </tr>
  <tr>
    <td>Icirc</td>
    <td>&amp;#x000CE;</td>
    <td>&#x000CE;</td>
    <td>=capital I, circumflex accent</td>
  </tr>
  <tr>
    <td>icirc</td>
    <td>&amp;#x000EE;</td>
    <td>&#x000EE;</td>
    <td>=small i, circumflex accent</td>
  </tr>
  <tr>
    <td>Igrave</td>
    <td>&amp;#x000CC;</td>
    <td>&#x000CC;</td>
    <td>=capital I, grave accent</td>
  </tr>
  <tr>
    <td>igrave</td>
    <td>&amp;#x000EC;</td>
    <td>&#x000EC;</td>
    <td>=small i, grave accent</td>
  </tr>
  <tr>
    <td>Iuml</td>
    <td>&amp;#x000CF;</td>
    <td>&#x000CF;</td>
    <td>=capital I, dieresis or umlaut mark</td>
  </tr>
  <tr>
    <td>iuml</td>
    <td>&amp;#x000EF;</td>
    <td>&#x000EF;</td>
    <td>=small i, dieresis or umlaut mark</td>
  </tr>
  <tr>
    <td>Ntilde</td>
    <td>&amp;#x000D1;</td>
    <td>&#x000D1;</td>
    <td>=capital N, tilde</td>
  </tr>
  <tr>
    <td>ntilde</td>
    <td>&amp;#x000F1;</td>
    <td>&#x000F1;</td>
    <td>=small n, tilde</td>
  </tr>
  <tr>
    <td>Oacute</td>
    <td>&amp;#x000D3;</td>
    <td>&#x000D3;</td>
    <td>=capital O, acute accent</td>
  </tr>
  <tr>
    <td>oacute</td>
    <td>&amp;#x000F3;</td>
    <td>&#x000F3;</td>
    <td>=small o, acute accent</td>
  </tr>
  <tr>
    <td>Ocirc</td>
    <td>&amp;#x000D4;</td>
    <td>&#x000D4;</td>
    <td>=capital O, circumflex accent</td>
  </tr>
  <tr>
    <td>ocirc</td>
    <td>&amp;#x000F4;</td>
    <td>&#x000F4;</td>
    <td>=small o, circumflex accent</td>
  </tr>
  <tr>
    <td>Ograve</td>
    <td>&amp;#x000D2;</td>
    <td>&#x000D2;</td>
    <td>=capital O, grave accent</td>
  </tr>
  <tr>
    <td>ograve</td>
    <td>&amp;#x000F2;</td>
    <td>&#x000F2;</td>
    <td>=small o, grave accent</td>
  </tr>
  <tr>
    <td>Oslash</td>
    <td>&amp;#x000D8;</td>
    <td>&#x000D8;</td>
    <td>=capital O, slash</td>
  </tr>
  <tr>
    <td>oslash</td>
    <td>&amp;#x000F8;</td>
    <td>&#x000F8;</td>
    <td>latin small letter o with stroke</td>
  </tr>
  <tr>
    <td>Otilde</td>
    <td>&amp;#x000D5;</td>
    <td>&#x000D5;</td>
    <td>=capital O, tilde</td>
  </tr>
  <tr>
    <td>otilde</td>
    <td>&amp;#x000F5;</td>
    <td>&#x000F5;</td>
    <td>=small o, tilde</td>
  </tr>
  <tr>
    <td>Ouml</td>
    <td>&amp;#x000D6;</td>
    <td>&#x000D6;</td>
    <td>=capital O, dieresis or umlaut mark</td>
  </tr>
  <tr>
    <td>ouml</td>
    <td>&amp;#x000F6;</td>
    <td>&#x000F6;</td>
    <td>=small o, dieresis or umlaut mark</td>
  </tr>
  <tr>
    <td>szlig</td>
    <td>&amp;#x000DF;</td>
    <td>&#x000DF;</td>
    <td>=small sharp s, German (sz ligature)</td>
  </tr>
  <tr>
    <td>THORN</td>
    <td>&amp;#x000DE;</td>
    <td>&#x000DE;</td>
    <td>=capital THORN, Icelandic</td>
  </tr>
  <tr>
    <td>thorn</td>
    <td>&amp;#x000FE;</td>
    <td>&#x000FE;</td>
    <td>=small thorn, Icelandic</td>
  </tr>
  <tr>
    <td>Uacute</td>
    <td>&amp;#x000DA;</td>
    <td>&#x000DA;</td>
    <td>=capital U, acute accent</td>
  </tr>
  <tr>
    <td>uacute</td>
    <td>&amp;#x000FA;</td>
    <td>&#x000FA;</td>
    <td>=small u, acute accent</td>
  </tr>
  <tr>
    <td>Ucirc</td>
    <td>&amp;#x000DB;</td>
    <td>&#x000DB;</td>
    <td>=capital U, circumflex accent</td>
  </tr>
  <tr>
    <td>ucirc</td>
    <td>&amp;#x000FB;</td>
    <td>&#x000FB;</td>
    <td>=small u, circumflex accent</td>
  </tr>
  <tr>
    <td>Ugrave</td>
    <td>&amp;#x000D9;</td>
    <td>&#x000D9;</td>
    <td>=capital U, grave accent</td>
  </tr>
  <tr>
    <td>ugrave</td>
    <td>&amp;#x000F9;</td>
    <td>&#x000F9;</td>
    <td>=small u, grave accent</td>
  </tr>
  <tr>
    <td>Uuml</td>
    <td>&amp;#x000DC;</td>
    <td>&#x000DC;</td>
    <td>=capital U, dieresis or umlaut mark</td>
  </tr>
  <tr>
    <td>uuml</td>
    <td>&amp;#x000FC;</td>
    <td>&#x000FC;</td>
    <td>=small u, dieresis or umlaut mark</td>
  </tr>
  <tr>
    <td>Yacute</td>
    <td>&amp;#x000DD;</td>
    <td>&#x000DD;</td>
    <td>=capital Y, acute accent</td>
  </tr>
  <tr>
    <td>yacute</td>
    <td>&amp;#x000FD;</td>
    <td>&#x000FD;</td>
    <td>=small y, acute accent</td>
  </tr>
  <tr>
    <td>yuml</td>
    <td>&amp;#x000FF;</td>
    <td>&#x000FF;</td>
    <td>=small y, dieresis or umlaut mark</td>
  </tr>
  <tr>
    <td>Abreve</td>
    <td>&amp;#x00102;</td>
    <td>&#x00102;</td>
    <td>=capital A, breve</td>
  </tr>
  <tr>
    <td>abreve</td>
    <td>&amp;#x00103;</td>
    <td>&#x00103;</td>
    <td>=small a, breve</td>
  </tr>
  <tr>
    <td>Amacr</td>
    <td>&amp;#x00100;</td>
    <td>&#x00100;</td>
    <td>=capital A, macron</td>
  </tr>
  <tr>
    <td>amacr</td>
    <td>&amp;#x00101;</td>
    <td>&#x00101;</td>
    <td>=small a, macron</td>
  </tr>
  <tr>
    <td>Aogon</td>
    <td>&amp;#x00104;</td>
    <td>&#x00104;</td>
    <td>=capital A, ogonek</td>
  </tr>
  <tr>
    <td>aogon</td>
    <td>&amp;#x00105;</td>
    <td>&#x00105;</td>
    <td>=small a, ogonek</td>
  </tr>
  <tr>
    <td>Cacute</td>
    <td>&amp;#x00106;</td>
    <td>&#x00106;</td>
    <td>=capital C, acute accent</td>
  </tr>
  <tr>
    <td>cacute</td>
    <td>&amp;#x00107;</td>
    <td>&#x00107;</td>
    <td>=small c, acute accent</td>
  </tr>
  <tr>
    <td>Ccaron</td>
    <td>&amp;#x0010C;</td>
    <td>&#x0010C;</td>
    <td>=capital C, caron</td>
  </tr>
  <tr>
    <td>ccaron</td>
    <td>&amp;#x0010D;</td>
    <td>&#x0010D;</td>
    <td>=small c, caron</td>
  </tr>
  <tr>
    <td>Ccirc</td>
    <td>&amp;#x00108;</td>
    <td>&#x00108;</td>
    <td>=capital C, circumflex accent</td>
  </tr>
  <tr>
    <td>ccirc</td>
    <td>&amp;#x00109;</td>
    <td>&#x00109;</td>
    <td>=small c, circumflex accent</td>
  </tr>
  <tr>
    <td>Cdot</td>
    <td>&amp;#x0010A;</td>
    <td>&#x0010A;</td>
    <td>=capital C, dot above</td>
  </tr>
  <tr>
    <td>cdot</td>
    <td>&amp;#x0010B;</td>
    <td>&#x0010B;</td>
    <td>=small c, dot above</td>
  </tr>
  <tr>
    <td>Dcaron</td>
    <td>&amp;#x0010E;</td>
    <td>&#x0010E;</td>
    <td>=capital D, caron</td>
  </tr>
  <tr>
    <td>dcaron</td>
    <td>&amp;#x0010F;</td>
    <td>&#x0010F;</td>
    <td>=small d, caron</td>
  </tr>
  <tr>
    <td>Dstrok</td>
    <td>&amp;#x00110;</td>
    <td>&#x00110;</td>
    <td>=capital D, stroke</td>
  </tr>
  <tr>
    <td>dstrok</td>
    <td>&amp;#x00111;</td>
    <td>&#x00111;</td>
    <td>=small d, stroke</td>
  </tr>
  <tr>
    <td>Ecaron</td>
    <td>&amp;#x0011A;</td>
    <td>&#x0011A;</td>
    <td>=capital E, caron</td>
  </tr>
  <tr>
    <td>ecaron</td>
    <td>&amp;#x0011B;</td>
    <td>&#x0011B;</td>
    <td>=small e, caron</td>
  </tr>
  <tr>
    <td>Edot</td>
    <td>&amp;#x00116;</td>
    <td>&#x00116;</td>
    <td>=capital E, dot above</td>
  </tr>
  <tr>
    <td>edot</td>
    <td>&amp;#x00117;</td>
    <td>&#x00117;</td>
    <td>=small e, dot above</td>
  </tr>
  <tr>
    <td>Emacr</td>
    <td>&amp;#x00112;</td>
    <td>&#x00112;</td>
    <td>=capital E, macron</td>
  </tr>
  <tr>
    <td>emacr</td>
    <td>&amp;#x00113;</td>
    <td>&#x00113;</td>
    <td>=small e, macron</td>
  </tr>
  <tr>
    <td>ENG</td>
    <td>&amp;#x0014A;</td>
    <td>&#x0014A;</td>
    <td>=capital ENG, Lapp</td>
  </tr>
  <tr>
    <td>eng</td>
    <td>&amp;#x0014B;</td>
    <td>&#x0014B;</td>
    <td>=small eng, Lapp</td>
  </tr>
  <tr>
    <td>Eogon</td>
    <td>&amp;#x00118;</td>
    <td>&#x00118;</td>
    <td>=capital E, ogonek</td>
  </tr>
  <tr>
    <td>eogon</td>
    <td>&amp;#x00119;</td>
    <td>&#x00119;</td>
    <td>=small e, ogonek</td>
  </tr>
  <tr>
    <td>gacute</td>
    <td>&amp;#x001F5;</td>
    <td>&#x001F5;</td>
    <td>=small g, acute accent</td>
  </tr>
  <tr>
    <td>Gbreve</td>
    <td>&amp;#x0011E;</td>
    <td>&#x0011E;</td>
    <td>=capital G, breve</td>
  </tr>
  <tr>
    <td>gbreve</td>
    <td>&amp;#x0011F;</td>
    <td>&#x0011F;</td>
    <td>=small g, breve</td>
  </tr>
  <tr>
    <td>Gcedil</td>
    <td>&amp;#x00122;</td>
    <td>&#x00122;</td>
    <td>=capital G, cedilla</td>
  </tr>
  <tr>
    <td>Gcirc</td>
    <td>&amp;#x0011C;</td>
    <td>&#x0011C;</td>
    <td>=capital G, circumflex accent</td>
  </tr>
  <tr>
    <td>gcirc</td>
    <td>&amp;#x0011D;</td>
    <td>&#x0011D;</td>
    <td>=small g, circumflex accent</td>
  </tr>
  <tr>
    <td>Gdot</td>
    <td>&amp;#x00120;</td>
    <td>&#x00120;</td>
    <td>=capital G, dot above</td>
  </tr>
  <tr>
    <td>gdot</td>
    <td>&amp;#x00121;</td>
    <td>&#x00121;</td>
    <td>=small g, dot above</td>
  </tr>
  <tr>
    <td>Hcirc</td>
    <td>&amp;#x00124;</td>
    <td>&#x00124;</td>
    <td>=capital H, circumflex accent</td>
  </tr>
  <tr>
    <td>hcirc</td>
    <td>&amp;#x00125;</td>
    <td>&#x00125;</td>
    <td>=small h, circumflex accent</td>
  </tr>
  <tr>
    <td>Hstrok</td>
    <td>&amp;#x00126;</td>
    <td>&#x00126;</td>
    <td>=capital H, stroke</td>
  </tr>
  <tr>
    <td>hstrok</td>
    <td>&amp;#x00127;</td>
    <td>&#x00127;</td>
    <td>=small h, stroke</td>
  </tr>
  <tr>
    <td>Idot</td>
    <td>&amp;#x00130;</td>
    <td>&#x00130;</td>
    <td>=capital I, dot above</td>
  </tr>
  <tr>
    <td>IJlig</td>
    <td>&amp;#x00132;</td>
    <td>&#x00132;</td>
    <td>=capital IJ ligature</td>
  </tr>
  <tr>
    <td>ijlig</td>
    <td>&amp;#x00133;</td>
    <td>&#x00133;</td>
    <td>=small ij ligature</td>
  </tr>
  <tr>
    <td>Imacr</td>
    <td>&amp;#x0012A;</td>
    <td>&#x0012A;</td>
    <td>=capital I, macron</td>
  </tr>
  <tr>
    <td>imacr</td>
    <td>&amp;#x0012B;</td>
    <td>&#x0012B;</td>
    <td>=small i, macron</td>
  </tr>
  <tr>
    <td>inodot</td>
    <td>&amp;#x00131;</td>
    <td>&#x00131;</td>
    <td>=small i without dot</td>
  </tr>
  <tr>
    <td>Iogon</td>
    <td>&amp;#x0012E;</td>
    <td>&#x0012E;</td>
    <td>=capital I, ogonek</td>
  </tr>
  <tr>
    <td>iogon</td>
    <td>&amp;#x0012F;</td>
    <td>&#x0012F;</td>
    <td>=small i, ogonek</td>
  </tr>
  <tr>
    <td>Itilde</td>
    <td>&amp;#x00128;</td>
    <td>&#x00128;</td>
    <td>=capital I, tilde</td>
  </tr>
  <tr>
    <td>itilde</td>
    <td>&amp;#x00129;</td>
    <td>&#x00129;</td>
    <td>=small i, tilde</td>
  </tr>
  <tr>
    <td>Jcirc</td>
    <td>&amp;#x00134;</td>
    <td>&#x00134;</td>
    <td>=capital J, circumflex accent</td>
  </tr>
  <tr>
    <td>jcirc</td>
    <td>&amp;#x00135;</td>
    <td>&#x00135;</td>
    <td>=small j, circumflex accent</td>
  </tr>
  <tr>
    <td>Kcedil</td>
    <td>&amp;#x00136;</td>
    <td>&#x00136;</td>
    <td>=capital K, cedilla</td>
  </tr>
  <tr>
    <td>kcedil</td>
    <td>&amp;#x00137;</td>
    <td>&#x00137;</td>
    <td>=small k, cedilla</td>
  </tr>
  <tr>
    <td>kgreen</td>
    <td>&amp;#x00138;</td>
    <td>&#x00138;</td>
    <td>=small k, Greenlandic</td>
  </tr>
  <tr>
    <td>Lacute</td>
    <td>&amp;#x00139;</td>
    <td>&#x00139;</td>
    <td>=capital L, acute accent</td>
  </tr>
  <tr>
    <td>lacute</td>
    <td>&amp;#x0013A;</td>
    <td>&#x0013A;</td>
    <td>=small l, acute accent</td>
  </tr>
  <tr>
    <td>Lcaron</td>
    <td>&amp;#x0013D;</td>
    <td>&#x0013D;</td>
    <td>=capital L, caron</td>
  </tr>
  <tr>
    <td>lcaron</td>
    <td>&amp;#x0013E;</td>
    <td>&#x0013E;</td>
    <td>=small l, caron</td>
  </tr>
  <tr>
    <td>Lcedil</td>
    <td>&amp;#x0013B;</td>
    <td>&#x0013B;</td>
    <td>=capital L, cedilla</td>
  </tr>
  <tr>
    <td>lcedil</td>
    <td>&amp;#x0013C;</td>
    <td>&#x0013C;</td>
    <td>=small l, cedilla</td>
  </tr>
  <tr>
    <td>Lmidot</td>
    <td>&amp;#x0013F;</td>
    <td>&#x0013F;</td>
    <td>=capital L, middle dot</td>
  </tr>
  <tr>
    <td>lmidot</td>
    <td>&amp;#x00140;</td>
    <td>&#x00140;</td>
    <td>=small l, middle dot</td>
  </tr>
  <tr>
    <td>Lstrok</td>
    <td>&amp;#x00141;</td>
    <td>&#x00141;</td>
    <td>=capital L, stroke</td>
  </tr>
  <tr>
    <td>lstrok</td>
    <td>&amp;#x00142;</td>
    <td>&#x00142;</td>
    <td>=small l, stroke</td>
  </tr>
  <tr>
    <td>Nacute</td>
    <td>&amp;#x00143;</td>
    <td>&#x00143;</td>
    <td>=capital N, acute accent</td>
  </tr>
  <tr>
    <td>nacute</td>
    <td>&amp;#x00144;</td>
    <td>&#x00144;</td>
    <td>=small n, acute accent</td>
  </tr>
  <tr>
    <td>napos</td>
    <td>&amp;#x00149;</td>
    <td>&#x00149;</td>
    <td>=small n, apostrophe</td>
  </tr>
  <tr>
    <td>Ncaron</td>
    <td>&amp;#x00147;</td>
    <td>&#x00147;</td>
    <td>=capital N, caron</td>
  </tr>
  <tr>
    <td>ncaron</td>
    <td>&amp;#x00148;</td>
    <td>&#x00148;</td>
    <td>=small n, caron</td>
  </tr>
  <tr>
    <td>Ncedil</td>
    <td>&amp;#x00145;</td>
    <td>&#x00145;</td>
    <td>=capital N, cedilla</td>
  </tr>
  <tr>
    <td>ncedil</td>
    <td>&amp;#x00146;</td>
    <td>&#x00146;</td>
    <td>=small n, cedilla</td>
  </tr>
  <tr>
    <td>Odblac</td>
    <td>&amp;#x00150;</td>
    <td>&#x00150;</td>
    <td>=capital O, double acute accent</td>
  </tr>
  <tr>
    <td>odblac</td>
    <td>&amp;#x00151;</td>
    <td>&#x00151;</td>
    <td>=small o, double acute accent</td>
  </tr>
  <tr>
    <td>OElig</td>
    <td>&amp;#x00152;</td>
    <td>&#x00152;</td>
    <td>=capital OE ligature</td>
  </tr>
  <tr>
    <td>oelig</td>
    <td>&amp;#x00153;</td>
    <td>&#x00153;</td>
    <td>=small oe ligature</td>
  </tr>
  <tr>
    <td>Omacr</td>
    <td>&amp;#x0014C;</td>
    <td>&#x0014C;</td>
    <td>=capital O, macron</td>
  </tr>
  <tr>
    <td>omacr</td>
    <td>&amp;#x0014D;</td>
    <td>&#x0014D;</td>
    <td>=small o, macron</td>
  </tr>
  <tr>
    <td>Racute</td>
    <td>&amp;#x00154;</td>
    <td>&#x00154;</td>
    <td>=capital R, acute accent</td>
  </tr>
  <tr>
    <td>racute</td>
    <td>&amp;#x00155;</td>
    <td>&#x00155;</td>
    <td>=small r, acute accent</td>
  </tr>
  <tr>
    <td>Rcaron</td>
    <td>&amp;#x00158;</td>
    <td>&#x00158;</td>
    <td>=capital R, caron</td>
  </tr>
  <tr>
    <td>rcaron</td>
    <td>&amp;#x00159;</td>
    <td>&#x00159;</td>
    <td>=small r, caron</td>
  </tr>
  <tr>
    <td>Rcedil</td>
    <td>&amp;#x00156;</td>
    <td>&#x00156;</td>
    <td>=capital R, cedilla</td>
  </tr>
  <tr>
    <td>rcedil</td>
    <td>&amp;#x00157;</td>
    <td>&#x00157;</td>
    <td>=small r, cedilla</td>
  </tr>
  <tr>
    <td>Sacute</td>
    <td>&amp;#x0015A;</td>
    <td>&#x0015A;</td>
    <td>=capital S, acute accent</td>
  </tr>
  <tr>
    <td>sacute</td>
    <td>&amp;#x0015B;</td>
    <td>&#x0015B;</td>
    <td>=small s, acute accent</td>
  </tr>
  <tr>
    <td>Scaron</td>
    <td>&amp;#x00160;</td>
    <td>&#x00160;</td>
    <td>=capital S, caron</td>
  </tr>
  <tr>
    <td>scaron</td>
    <td>&amp;#x00161;</td>
    <td>&#x00161;</td>
    <td>=small s, caron</td>
  </tr>
  <tr>
    <td>Scedil</td>
    <td>&amp;#x0015E;</td>
    <td>&#x0015E;</td>
    <td>=capital S, cedilla</td>
  </tr>
  <tr>
    <td>scedil</td>
    <td>&amp;#x0015F;</td>
    <td>&#x0015F;</td>
    <td>=small s, cedilla</td>
  </tr>
  <tr>
    <td>Scirc</td>
    <td>&amp;#x0015C;</td>
    <td>&#x0015C;</td>
    <td>=capital S, circumflex accent</td>
  </tr>
  <tr>
    <td>scirc</td>
    <td>&amp;#x0015D;</td>
    <td>&#x0015D;</td>
    <td>=small s, circumflex accent</td>
  </tr>
  <tr>
    <td>Tcaron</td>
    <td>&amp;#x00164;</td>
    <td>&#x00164;</td>
    <td>=capital T, caron</td>
  </tr>
  <tr>
    <td>tcaron</td>
    <td>&amp;#x00165;</td>
    <td>&#x00165;</td>
    <td>=small t, caron</td>
  </tr>
  <tr>
    <td>Tcedil</td>
    <td>&amp;#x00162;</td>
    <td>&#x00162;</td>
    <td>=capital T, cedilla</td>
  </tr>
  <tr>
    <td>tcedil</td>
    <td>&amp;#x00163;</td>
    <td>&#x00163;</td>
    <td>=small t, cedilla</td>
  </tr>
  <tr>
    <td>Tstrok</td>
    <td>&amp;#x00166;</td>
    <td>&#x00166;</td>
    <td>=capital T, stroke</td>
  </tr>
  <tr>
    <td>tstrok</td>
    <td>&amp;#x00167;</td>
    <td>&#x00167;</td>
    <td>=small t, stroke</td>
  </tr>
  <tr>
    <td>Ubreve</td>
    <td>&amp;#x0016C;</td>
    <td>&#x0016C;</td>
    <td>=capital U, breve</td>
  </tr>
  <tr>
    <td>ubreve</td>
    <td>&amp;#x0016D;</td>
    <td>&#x0016D;</td>
    <td>=small u, breve</td>
  </tr>
  <tr>
    <td>Udblac</td>
    <td>&amp;#x00170;</td>
    <td>&#x00170;</td>
    <td>=capital U, double acute accent</td>
  </tr>
  <tr>
    <td>udblac</td>
    <td>&amp;#x00171;</td>
    <td>&#x00171;</td>
    <td>=small u, double acute accent</td>
  </tr>
  <tr>
    <td>Umacr</td>
    <td>&amp;#x0016A;</td>
    <td>&#x0016A;</td>
    <td>=capital U, macron</td>
  </tr>
  <tr>
    <td>umacr</td>
    <td>&amp;#x0016B;</td>
    <td>&#x0016B;</td>
    <td>=small u, macron</td>
  </tr>
  <tr>
    <td>Uogon</td>
    <td>&amp;#x00172;</td>
    <td>&#x00172;</td>
    <td>=capital U, ogonek</td>
  </tr>
  <tr>
    <td>uogon</td>
    <td>&amp;#x00173;</td>
    <td>&#x00173;</td>
    <td>=small u, ogonek</td>
  </tr>
  <tr>
    <td>Uring</td>
    <td>&amp;#x0016E;</td>
    <td>&#x0016E;</td>
    <td>=capital U, ring</td>
  </tr>
  <tr>
    <td>uring</td>
    <td>&amp;#x0016F;</td>
    <td>&#x0016F;</td>
    <td>=small u, ring</td>
  </tr>
  <tr>
    <td>Utilde</td>
    <td>&amp;#x00168;</td>
    <td>&#x00168;</td>
    <td>=capital U, tilde</td>
  </tr>
  <tr>
    <td>utilde</td>
    <td>&amp;#x00169;</td>
    <td>&#x00169;</td>
    <td>=small u, tilde</td>
  </tr>
  <tr>
    <td>Wcirc</td>
    <td>&amp;#x00174;</td>
    <td>&#x00174;</td>
    <td>=capital W, circumflex accent</td>
  </tr>
  <tr>
    <td>wcirc</td>
    <td>&amp;#x00175;</td>
    <td>&#x00175;</td>
    <td>=small w, circumflex accent</td>
  </tr>
  <tr>
    <td>Ycirc</td>
    <td>&amp;#x00176;</td>
    <td>&#x00176;</td>
    <td>=capital Y, circumflex accent</td>
  </tr>
  <tr>
    <td>ycirc</td>
    <td>&amp;#x00177;</td>
    <td>&#x00177;</td>
    <td>=small y, circumflex accent</td>
  </tr>
  <tr>
    <td>Yuml</td>
    <td>&amp;#x00178;</td>
    <td>&#x00178;</td>
    <td>=capital Y, dieresis or umlaut mark</td>
  </tr>
  <tr>
    <td>Zacute</td>
    <td>&amp;#x00179;</td>
    <td>&#x00179;</td>
    <td>=capital Z, acute accent</td>
  </tr>
  <tr>
    <td>zacute</td>
    <td>&amp;#x0017A;</td>
    <td>&#x0017A;</td>
    <td>=small z, acute accent</td>
  </tr>
  <tr>
    <td>Zcaron</td>
    <td>&amp;#x0017D;</td>
    <td>&#x0017D;</td>
    <td>=capital Z, caron</td>
  </tr>
  <tr>
    <td>zcaron</td>
    <td>&amp;#x0017E;</td>
    <td>&#x0017E;</td>
    <td>=small z, caron</td>
  </tr>
  <tr>
    <td>Zdot</td>
    <td>&amp;#x0017B;</td>
    <td>&#x0017B;</td>
    <td>=capital Z, dot above</td>
  </tr>
  <tr>
    <td>zdot</td>
    <td>&amp;#x0017C;</td>
    <td>&#x0017C;</td>
    <td>=small z, dot above</td>
  </tr>
  <tr>
    <td>Afr</td>
    <td>&amp;#x1D504;</td>
    <td>&#x1D504;</td>
    <td>/frak A, upper case a</td>
  </tr>
  <tr>
    <td>afr</td>
    <td>&amp;#x1D51E;</td>
    <td>&#x1D51E;</td>
    <td>/frak a, lower case a</td>
  </tr>
  <tr>
    <td>Bfr</td>
    <td>&amp;#x1D505;</td>
    <td>&#x1D505;</td>
    <td>/frak B, upper case b</td>
  </tr>
  <tr>
    <td>bfr</td>
    <td>&amp;#x1D51F;</td>
    <td>&#x1D51F;</td>
    <td>/frak b, lower case b</td>
  </tr>
  <tr>
    <td>Cfr</td>
    <td>&amp;#x0212D;</td>
    <td>&#x0212D;</td>
    <td>/frak C, upper case c</td>
  </tr>
  <tr>
    <td>cfr</td>
    <td>&amp;#x1D520;</td>
    <td>&#x1D520;</td>
    <td>/frak c, lower case c</td>
  </tr>
  <tr>
    <td>Dfr</td>
    <td>&amp;#x1D507;</td>
    <td>&#x1D507;</td>
    <td>/frak D, upper case d</td>
  </tr>
  <tr>
    <td>dfr</td>
    <td>&amp;#x1D521;</td>
    <td>&#x1D521;</td>
    <td>/frak d, lower case d</td>
  </tr>
  <tr>
    <td>Efr</td>
    <td>&amp;#x1D508;</td>
    <td>&#x1D508;</td>
    <td>/frak E, upper case e</td>
  </tr>
  <tr>
    <td>efr</td>
    <td>&amp;#x1D522;</td>
    <td>&#x1D522;</td>
    <td>/frak e, lower case e</td>
  </tr>
  <tr>
    <td>Ffr</td>
    <td>&amp;#x1D509;</td>
    <td>&#x1D509;</td>
    <td>/frak F, upper case f</td>
  </tr>
  <tr>
    <td>ffr</td>
    <td>&amp;#x1D523;</td>
    <td>&#x1D523;</td>
    <td>/frak f, lower case f</td>
  </tr>
  <tr>
    <td>Gfr</td>
    <td>&amp;#x1D50A;</td>
    <td>&#x1D50A;</td>
    <td>/frak G, upper case g</td>
  </tr>
  <tr>
    <td>gfr</td>
    <td>&amp;#x1D524;</td>
    <td>&#x1D524;</td>
    <td>/frak g, lower case g</td>
  </tr>
  <tr>
    <td>Hfr</td>
    <td>&amp;#x0210C;</td>
    <td>&#x0210C;</td>
    <td>/frak H, upper case h</td>
  </tr>
  <tr>
    <td>hfr</td>
    <td>&amp;#x1D525;</td>
    <td>&#x1D525;</td>
    <td>/frak h, lower case h</td>
  </tr>
  <tr>
    <td>Ifr</td>
    <td>&amp;#x02111;</td>
    <td>&#x02111;</td>
    <td>/frak I, upper case i</td>
  </tr>
  <tr>
    <td>ifr</td>
    <td>&amp;#x1D526;</td>
    <td>&#x1D526;</td>
    <td>/frak i, lower case i</td>
  </tr>
  <tr>
    <td>Jfr</td>
    <td>&amp;#x1D50D;</td>
    <td>&#x1D50D;</td>
    <td>/frak J, upper case j</td>
  </tr>
  <tr>
    <td>jfr</td>
    <td>&amp;#x1D527;</td>
    <td>&#x1D527;</td>
    <td>/frak j, lower case j</td>
  </tr>
  <tr>
    <td>Kfr</td>
    <td>&amp;#x1D50E;</td>
    <td>&#x1D50E;</td>
    <td>/frak K, upper case k</td>
  </tr>
  <tr>
    <td>kfr</td>
    <td>&amp;#x1D528;</td>
    <td>&#x1D528;</td>
    <td>/frak k, lower case k</td>
  </tr>
  <tr>
    <td>Lfr</td>
    <td>&amp;#x1D50F;</td>
    <td>&#x1D50F;</td>
    <td>/frak L, upper case l</td>
  </tr>
  <tr>
    <td>lfr</td>
    <td>&amp;#x1D529;</td>
    <td>&#x1D529;</td>
    <td>/frak l, lower case l</td>
  </tr>
  <tr>
    <td>Mfr</td>
    <td>&amp;#x1D510;</td>
    <td>&#x1D510;</td>
    <td>/frak M, upper case m</td>
  </tr>
  <tr>
    <td>mfr</td>
    <td>&amp;#x1D52A;</td>
    <td>&#x1D52A;</td>
    <td>/frak m, lower case m</td>
  </tr>
  <tr>
    <td>Nfr</td>
    <td>&amp;#x1D511;</td>
    <td>&#x1D511;</td>
    <td>/frak N, upper case n</td>
  </tr>
  <tr>
    <td>nfr</td>
    <td>&amp;#x1D52B;</td>
    <td>&#x1D52B;</td>
    <td>/frak n, lower case n</td>
  </tr>
  <tr>
    <td>Ofr</td>
    <td>&amp;#x1D512;</td>
    <td>&#x1D512;</td>
    <td>/frak O, upper case o</td>
  </tr>
  <tr>
    <td>ofr</td>
    <td>&amp;#x1D52C;</td>
    <td>&#x1D52C;</td>
    <td>/frak o, lower case o</td>
  </tr>
  <tr>
    <td>Pfr</td>
    <td>&amp;#x1D513;</td>
    <td>&#x1D513;</td>
    <td>/frak P, upper case p</td>
  </tr>
  <tr>
    <td>pfr</td>
    <td>&amp;#x1D52D;</td>
    <td>&#x1D52D;</td>
    <td>/frak p, lower case p</td>
  </tr>
  <tr>
    <td>Qfr</td>
    <td>&amp;#x1D514;</td>
    <td>&#x1D514;</td>
    <td>/frak Q, upper case q</td>
  </tr>
  <tr>
    <td>qfr</td>
    <td>&amp;#x1D52E;</td>
    <td>&#x1D52E;</td>
    <td>/frak q, lower case q</td>
  </tr>
  <tr>
    <td>Rfr</td>
    <td>&amp;#x0211C;</td>
    <td>&#x0211C;</td>
    <td>/frak R, upper case r</td>
  </tr>
  <tr>
    <td>rfr</td>
    <td>&amp;#x1D52F;</td>
    <td>&#x1D52F;</td>
    <td>/frak r, lower case r</td>
  </tr>
  <tr>
    <td>Sfr</td>
    <td>&amp;#x1D516;</td>
    <td>&#x1D516;</td>
    <td>/frak S, upper case s</td>
  </tr>
  <tr>
    <td>sfr</td>
    <td>&amp;#x1D530;</td>
    <td>&#x1D530;</td>
    <td>/frak s, lower case s</td>
  </tr>
  <tr>
    <td>Tfr</td>
    <td>&amp;#x1D517;</td>
    <td>&#x1D517;</td>
    <td>/frak T, upper case t</td>
  </tr>
  <tr>
    <td>tfr</td>
    <td>&amp;#x1D531;</td>
    <td>&#x1D531;</td>
    <td>/frak t, lower case t</td>
  </tr>
  <tr>
    <td>Ufr</td>
    <td>&amp;#x1D518;</td>
    <td>&#x1D518;</td>
    <td>/frak U, upper case u</td>
  </tr>
  <tr>
    <td>ufr</td>
    <td>&amp;#x1D532;</td>
    <td>&#x1D532;</td>
    <td>/frak u, lower case u</td>
  </tr>
  <tr>
    <td>Vfr</td>
    <td>&amp;#x1D519;</td>
    <td>&#x1D519;</td>
    <td>/frak V, upper case v</td>
  </tr>
  <tr>
    <td>vfr</td>
    <td>&amp;#x1D533;</td>
    <td>&#x1D533;</td>
    <td>/frak v, lower case v</td>
  </tr>
  <tr>
    <td>Wfr</td>
    <td>&amp;#x1D51A;</td>
    <td>&#x1D51A;</td>
    <td>/frak W, upper case w</td>
  </tr>
  <tr>
    <td>wfr</td>
    <td>&amp;#x1D534;</td>
    <td>&#x1D534;</td>
    <td>/frak w, lower case w</td>
  </tr>
  <tr>
    <td>Xfr</td>
    <td>&amp;#x1D51B;</td>
    <td>&#x1D51B;</td>
    <td>/frak X, upper case x</td>
  </tr>
  <tr>
    <td>xfr</td>
    <td>&amp;#x1D535;</td>
    <td>&#x1D535;</td>
    <td>/frak x, lower case x</td>
  </tr>
  <tr>
    <td>Yfr</td>
    <td>&amp;#x1D51C;</td>
    <td>&#x1D51C;</td>
    <td>/frak Y, upper case y</td>
  </tr>
  <tr>
    <td>yfr</td>
    <td>&amp;#x1D536;</td>
    <td>&#x1D536;</td>
    <td>/frak y, lower case y</td>
  </tr>
  <tr>
    <td>Zfr</td>
    <td>&amp;#x02128;</td>
    <td>&#x02128;</td>
    <td>/frak Z, upper case z</td>
  </tr>
  <tr>
    <td>zfr</td>
    <td>&amp;#x1D537;</td>
    <td>&#x1D537;</td>
    <td>/frak z, lower case z</td>
  </tr>
  <tr>
    <td>Aopf</td>
    <td>&amp;#x1D538;</td>
    <td>&#x1D538;</td>
    <td>/Bbb A, open face A</td>
  </tr>
  <tr>
    <td>Bopf</td>
    <td>&amp;#x1D539;</td>
    <td>&#x1D539;</td>
    <td>/Bbb B, open face B</td>
  </tr>
  <tr>
    <td>Copf</td>
    <td>&amp;#x02102;</td>
    <td>&#x02102;</td>
    <td>/Bbb C, open face C</td>
  </tr>
  <tr>
    <td>Dopf</td>
    <td>&amp;#x1D53B;</td>
    <td>&#x1D53B;</td>
    <td>/Bbb D, open face D</td>
  </tr>
  <tr>
    <td>Eopf</td>
    <td>&amp;#x1D53C;</td>
    <td>&#x1D53C;</td>
    <td>/Bbb E, open face E</td>
  </tr>
  <tr>
    <td>Fopf</td>
    <td>&amp;#x1D53D;</td>
    <td>&#x1D53D;</td>
    <td>/Bbb F, open face F</td>
  </tr>
  <tr>
    <td>Gopf</td>
    <td>&amp;#x1D53E;</td>
    <td>&#x1D53E;</td>
    <td>/Bbb G, open face G</td>
  </tr>
  <tr>
    <td>Hopf</td>
    <td>&amp;#x0210D;</td>
    <td>&#x0210D;</td>
    <td>/Bbb H, open face H</td>
  </tr>
  <tr>
    <td>Iopf</td>
    <td>&amp;#x1D540;</td>
    <td>&#x1D540;</td>
    <td>/Bbb I, open face I</td>
  </tr>
  <tr>
    <td>Jopf</td>
    <td>&amp;#x1D541;</td>
    <td>&#x1D541;</td>
    <td>/Bbb J, open face J</td>
  </tr>
  <tr>
    <td>Kopf</td>
    <td>&amp;#x1D542;</td>
    <td>&#x1D542;</td>
    <td>/Bbb K, open face K</td>
  </tr>
  <tr>
    <td>Lopf</td>
    <td>&amp;#x1D543;</td>
    <td>&#x1D543;</td>
    <td>/Bbb L, open face L</td>
  </tr>
  <tr>
    <td>Mopf</td>
    <td>&amp;#x1D544;</td>
    <td>&#x1D544;</td>
    <td>/Bbb M, open face M</td>
  </tr>
  <tr>
    <td>Nopf</td>
    <td>&amp;#x02115;</td>
    <td>&#x02115;</td>
    <td>/Bbb N, open face N</td>
  </tr>
  <tr>
    <td>Oopf</td>
    <td>&amp;#x1D546;</td>
    <td>&#x1D546;</td>
    <td>/Bbb O, open face O</td>
  </tr>
  <tr>
    <td>Popf</td>
    <td>&amp;#x02119;</td>
    <td>&#x02119;</td>
    <td>/Bbb P, open face P</td>
  </tr>
  <tr>
    <td>Qopf</td>
    <td>&amp;#x0211A;</td>
    <td>&#x0211A;</td>
    <td>/Bbb Q, open face Q</td>
  </tr>
  <tr>
    <td>Ropf</td>
    <td>&amp;#x0211D;</td>
    <td>&#x0211D;</td>
    <td>/Bbb R, open face R</td>
  </tr>
  <tr>
    <td>Sopf</td>
    <td>&amp;#x1D54A;</td>
    <td>&#x1D54A;</td>
    <td>/Bbb S, open face S</td>
  </tr>
  <tr>
    <td>Topf</td>
    <td>&amp;#x1D54B;</td>
    <td>&#x1D54B;</td>
    <td>/Bbb T, open face T</td>
  </tr>
  <tr>
    <td>Uopf</td>
    <td>&amp;#x1D54C;</td>
    <td>&#x1D54C;</td>
    <td>/Bbb U, open face U</td>
  </tr>
  <tr>
    <td>Vopf</td>
    <td>&amp;#x1D54D;</td>
    <td>&#x1D54D;</td>
    <td>/Bbb V, open face V</td>
  </tr>
  <tr>
    <td>Wopf</td>
    <td>&amp;#x1D54E;</td>
    <td>&#x1D54E;</td>
    <td>/Bbb W, open face W</td>
  </tr>
  <tr>
    <td>Xopf</td>
    <td>&amp;#x1D54F;</td>
    <td>&#x1D54F;</td>
    <td>/Bbb X, open face X</td>
  </tr>
  <tr>
    <td>Yopf</td>
    <td>&amp;#x1D550;</td>
    <td>&#x1D550;</td>
    <td>/Bbb Y, open face Y</td>
  </tr>
  <tr>
    <td>Zopf</td>
    <td>&amp;#x02124;</td>
    <td>&#x02124;</td>
    <td>/Bbb Z, open face Z</td>
  </tr>
  <tr>
    <td>Ascr</td>
    <td>&amp;#x1D49C;</td>
    <td>&#x1D49C;</td>
    <td>/scr A, script letter A</td>
  </tr>
  <tr>
    <td>ascr</td>
    <td>&amp;#x1D4B6;</td>
    <td>&#x1D4B6;</td>
    <td>/scr a, script letter a</td>
  </tr>
  <tr>
    <td>Bscr</td>
    <td>&amp;#x0212C;</td>
    <td>&#x0212C;</td>
    <td>/scr B, script letter B</td>
  </tr>
  <tr>
    <td>bscr</td>
    <td>&amp;#x1D4B7;</td>
    <td>&#x1D4B7;</td>
    <td>/scr b, script letter b</td>
  </tr>
  <tr>
    <td>Cscr</td>
    <td>&amp;#x1D49E;</td>
    <td>&#x1D49E;</td>
    <td>/scr C, script letter C</td>
  </tr>
  <tr>
    <td>cscr</td>
    <td>&amp;#x1D4B8;</td>
    <td>&#x1D4B8;</td>
    <td>/scr c, script letter c</td>
  </tr>
  <tr>
    <td>Dscr</td>
    <td>&amp;#x1D49F;</td>
    <td>&#x1D49F;</td>
    <td>/scr D, script letter D</td>
  </tr>
  <tr>
    <td>dscr</td>
    <td>&amp;#x1D4B9;</td>
    <td>&#x1D4B9;</td>
    <td>/scr d, script letter d</td>
  </tr>
  <tr>
    <td>Escr</td>
    <td>&amp;#x02130;</td>
    <td>&#x02130;</td>
    <td>/scr E, script letter E</td>
  </tr>
  <tr>
    <td>escr</td>
    <td>&amp;#x0212F;</td>
    <td>&#x0212F;</td>
    <td>/scr e, script letter e</td>
  </tr>
  <tr>
    <td>Fscr</td>
    <td>&amp;#x02131;</td>
    <td>&#x02131;</td>
    <td>/scr F, script letter F</td>
  </tr>
  <tr>
    <td>fscr</td>
    <td>&amp;#x1D4BB;</td>
    <td>&#x1D4BB;</td>
    <td>/scr f, script letter f</td>
  </tr>
  <tr>
    <td>Gscr</td>
    <td>&amp;#x1D4A2;</td>
    <td>&#x1D4A2;</td>
    <td>/scr G, script letter G</td>
  </tr>
  <tr>
    <td>gscr</td>
    <td>&amp;#x0210A;</td>
    <td>&#x0210A;</td>
    <td>/scr g, script letter g</td>
  </tr>
  <tr>
    <td>Hscr</td>
    <td>&amp;#x0210B;</td>
    <td>&#x0210B;</td>
    <td>/scr H, script letter H</td>
  </tr>
  <tr>
    <td>hscr</td>
    <td>&amp;#x1D4BD;</td>
    <td>&#x1D4BD;</td>
    <td>/scr h, script letter h</td>
  </tr>
  <tr>
    <td>Iscr</td>
    <td>&amp;#x02110;</td>
    <td>&#x02110;</td>
    <td>/scr I, script letter I</td>
  </tr>
  <tr>
    <td>iscr</td>
    <td>&amp;#x1D4BE;</td>
    <td>&#x1D4BE;</td>
    <td>/scr i, script letter i</td>
  </tr>
  <tr>
    <td>Jscr</td>
    <td>&amp;#x1D4A5;</td>
    <td>&#x1D4A5;</td>
    <td>/scr J, script letter J</td>
  </tr>
  <tr>
    <td>jscr</td>
    <td>&amp;#x1D4BF;</td>
    <td>&#x1D4BF;</td>
    <td>/scr j, script letter j</td>
  </tr>
  <tr>
    <td>Kscr</td>
    <td>&amp;#x1D4A6;</td>
    <td>&#x1D4A6;</td>
    <td>/scr K, script letter K</td>
  </tr>
  <tr>
    <td>kscr</td>
    <td>&amp;#x1D4C0;</td>
    <td>&#x1D4C0;</td>
    <td>/scr k, script letter k</td>
  </tr>
  <tr>
    <td>Lscr</td>
    <td>&amp;#x02112;</td>
    <td>&#x02112;</td>
    <td>/scr L, script letter L</td>
  </tr>
  <tr>
    <td>lscr</td>
    <td>&amp;#x1D4C1;</td>
    <td>&#x1D4C1;</td>
    <td>/scr l, script letter l</td>
  </tr>
  <tr>
    <td>Mscr</td>
    <td>&amp;#x02133;</td>
    <td>&#x02133;</td>
    <td>/scr M, script letter M</td>
  </tr>
  <tr>
    <td>mscr</td>
    <td>&amp;#x1D4C2;</td>
    <td>&#x1D4C2;</td>
    <td>/scr m, script letter m</td>
  </tr>
  <tr>
    <td>Nscr</td>
    <td>&amp;#x1D4A9;</td>
    <td>&#x1D4A9;</td>
    <td>/scr N, script letter N</td>
  </tr>
  <tr>
    <td>nscr</td>
    <td>&amp;#x1D4C3;</td>
    <td>&#x1D4C3;</td>
    <td>/scr n, script letter n</td>
  </tr>
  <tr>
    <td>Oscr</td>
    <td>&amp;#x1D4AA;</td>
    <td>&#x1D4AA;</td>
    <td>/scr O, script letter O</td>
  </tr>
  <tr>
    <td>oscr</td>
    <td>&amp;#x02134;</td>
    <td>&#x02134;</td>
    <td>/scr o, script letter o</td>
  </tr>
  <tr>
    <td>Pscr</td>
    <td>&amp;#x1D4AB;</td>
    <td>&#x1D4AB;</td>
    <td>/scr P, script letter P</td>
  </tr>
  <tr>
    <td>pscr</td>
    <td>&amp;#x1D4C5;</td>
    <td>&#x1D4C5;</td>
    <td>/scr p, script letter p</td>
  </tr>
  <tr>
    <td>Qscr</td>
    <td>&amp;#x1D4AC;</td>
    <td>&#x1D4AC;</td>
    <td>/scr Q, script letter Q</td>
  </tr>
  <tr>
    <td>qscr</td>
    <td>&amp;#x1D4C6;</td>
    <td>&#x1D4C6;</td>
    <td>/scr q, script letter q</td>
  </tr>
  <tr>
    <td>Rscr</td>
    <td>&amp;#x0211B;</td>
    <td>&#x0211B;</td>
    <td>/scr R, script letter R</td>
  </tr>
  <tr>
    <td>rscr</td>
    <td>&amp;#x1D4C7;</td>
    <td>&#x1D4C7;</td>
    <td>/scr r, script letter r</td>
  </tr>
  <tr>
    <td>Sscr</td>
    <td>&amp;#x1D4AE;</td>
    <td>&#x1D4AE;</td>
    <td>/scr S, script letter S</td>
  </tr>
  <tr>
    <td>sscr</td>
    <td>&amp;#x1D4C8;</td>
    <td>&#x1D4C8;</td>
    <td>/scr s, script letter s</td>
  </tr>
  <tr>
    <td>Tscr</td>
    <td>&amp;#x1D4AF;</td>
    <td>&#x1D4AF;</td>
    <td>/scr T, script letter T</td>
  </tr>
  <tr>
    <td>tscr</td>
    <td>&amp;#x1D4C9;</td>
    <td>&#x1D4C9;</td>
    <td>/scr t, script letter t</td>
  </tr>
  <tr>
    <td>Uscr</td>
    <td>&amp;#x1D4B0;</td>
    <td>&#x1D4B0;</td>
    <td>/scr U, script letter U</td>
  </tr>
  <tr>
    <td>uscr</td>
    <td>&amp;#x1D4CA;</td>
    <td>&#x1D4CA;</td>
    <td>/scr u, script letter u</td>
  </tr>
  <tr>
    <td>Vscr</td>
    <td>&amp;#x1D4B1;</td>
    <td>&#x1D4B1;</td>
    <td>/scr V, script letter V</td>
  </tr>
  <tr>
    <td>vscr</td>
    <td>&amp;#x1D4CB;</td>
    <td>&#x1D4CB;</td>
    <td>/scr v, script letter v</td>
  </tr>
  <tr>
    <td>Wscr</td>
    <td>&amp;#x1D4B2;</td>
    <td>&#x1D4B2;</td>
    <td>/scr W, script letter W</td>
  </tr>
  <tr>
    <td>wscr</td>
    <td>&amp;#x1D4CC;</td>
    <td>&#x1D4CC;</td>
    <td>/scr w, script letter w</td>
  </tr>
  <tr>
    <td>Xscr</td>
    <td>&amp;#x1D4B3;</td>
    <td>&#x1D4B3;</td>
    <td>/scr X, script letter X</td>
  </tr>
  <tr>
    <td>xscr</td>
    <td>&amp;#x1D4CD;</td>
    <td>&#x1D4CD;</td>
    <td>/scr x, script letter x</td>
  </tr>
  <tr>
    <td>Yscr</td>
    <td>&amp;#x1D4B4;</td>
    <td>&#x1D4B4;</td>
    <td>/scr Y, script letter Y</td>
  </tr>
  <tr>
    <td>yscr</td>
    <td>&amp;#x1D4CE;</td>
    <td>&#x1D4CE;</td>
    <td>/scr y, script letter y</td>
  </tr>
  <tr>
    <td>Zscr</td>
    <td>&amp;#x1D4B5;</td>
    <td>&#x1D4B5;</td>
    <td>/scr Z, script letter Z</td>
  </tr>
  <tr>
    <td>zscr</td>
    <td>&amp;#x1D4CF;</td>
    <td>&#x1D4CF;</td>
    <td>/scr z, script letter z</td>
  </tr>
  <tr>
    <td>amp</td>
    <td>&amp;#38;</td>
    <td>&#38;</td>
    <td>=ampersand</td>
  </tr>
  <tr>
    <td>apos</td>
    <td>&amp;#x00027;</td>
    <td>&#x00027;</td>
    <td>=apostrophe</td>
  </tr>
  <tr>
    <td>ast</td>
    <td>&amp;#x0002A;</td>
    <td>&#x0002A;</td>
    <td>/ast B: =asterisk</td>
  </tr>
  <tr>
    <td>brvbar</td>
    <td>&amp;#x000A6;</td>
    <td>&#x000A6;</td>
    <td>=broken (vertical) bar</td>
  </tr>
  <tr>
    <td>bsol</td>
    <td>&amp;#x0005C;</td>
    <td>&#x0005C;</td>
    <td>/backslash =reverse solidus</td>
  </tr>
  <tr>
    <td>cent</td>
    <td>&amp;#x000A2;</td>
    <td>&#x000A2;</td>
    <td>=cent sign</td>
  </tr>
  <tr>
    <td>colon</td>
    <td>&amp;#x0003A;</td>
    <td>&#x0003A;</td>
    <td>/colon P:</td>
  </tr>
  <tr>
    <td>comma</td>
    <td>&amp;#x0002C;</td>
    <td>&#x0002C;</td>
    <td>P: =comma</td>
  </tr>
  <tr>
    <td>commat</td>
    <td>&amp;#x00040;</td>
    <td>&#x00040;</td>
    <td>=commercial at</td>
  </tr>
  <tr>
    <td>copy</td>
    <td>&amp;#x000A9;</td>
    <td>&#x000A9;</td>
    <td>=copyright sign</td>
  </tr>
  <tr>
    <td>curren</td>
    <td>&amp;#x000A4;</td>
    <td>&#x000A4;</td>
    <td>=general currency sign</td>
  </tr>
  <tr>
    <td>darr</td>
    <td>&amp;#x02193;</td>
    <td>&#x02193;</td>
    <td>/downarrow A: =downward arrow</td>
  </tr>
  <tr>
    <td>deg</td>
    <td>&amp;#x000B0;</td>
    <td>&#x000B0;</td>
    <td>=degree sign</td>
  </tr>
  <tr>
    <td>divide</td>
    <td>&amp;#x000F7;</td>
    <td>&#x000F7;</td>
    <td>/div B: =divide sign</td>
  </tr>
  <tr>
    <td>dollar</td>
    <td>&amp;#x00024;</td>
    <td>&#x00024;</td>
    <td>=dollar sign</td>
  </tr>
  <tr>
    <td>equals</td>
    <td>&amp;#x0003D;</td>
    <td>&#x0003D;</td>
    <td>=equals sign R:</td>
  </tr>
  <tr>
    <td>excl</td>
    <td>&amp;#x00021;</td>
    <td>&#x00021;</td>
    <td>=exclamation mark</td>
  </tr>
  <tr>
    <td>frac12</td>
    <td>&amp;#x000BD;</td>
    <td>&#x000BD;</td>
    <td>=fraction one-half</td>
  </tr>
  <tr>
    <td>frac14</td>
    <td>&amp;#x000BC;</td>
    <td>&#x000BC;</td>
    <td>=fraction one-quarter</td>
  </tr>
  <tr>
    <td>frac18</td>
    <td>&amp;#x0215B;</td>
    <td>&#x0215B;</td>
    <td>=fraction one-eighth</td>
  </tr>
  <tr>
    <td>frac34</td>
    <td>&amp;#x000BE;</td>
    <td>&#x000BE;</td>
    <td>=fraction three-quarters</td>
  </tr>
  <tr>
    <td>frac38</td>
    <td>&amp;#x0215C;</td>
    <td>&#x0215C;</td>
    <td>=fraction three-eighths</td>
  </tr>
  <tr>
    <td>frac58</td>
    <td>&amp;#x0215D;</td>
    <td>&#x0215D;</td>
    <td>=fraction five-eighths</td>
  </tr>
  <tr>
    <td>frac78</td>
    <td>&amp;#x0215E;</td>
    <td>&#x0215E;</td>
    <td>=fraction seven-eighths</td>
  </tr>
  <tr>
    <td>gt</td>
    <td>&amp;#x0003E;</td>
    <td>&#x0003E;</td>
    <td>=greater-than sign R:</td>
  </tr>
  <tr>
    <td>half</td>
    <td>&amp;#x000BD;</td>
    <td>&#x000BD;</td>
    <td>=fraction one-half</td>
  </tr>
  <tr>
    <td>horbar</td>
    <td>&amp;#x02015;</td>
    <td>&#x02015;</td>
    <td>=horizontal bar</td>
  </tr>
  <tr>
    <td>hyphen</td>
    <td>&amp;#x02010;</td>
    <td>&#x02010;</td>
    <td>=hyphen</td>
  </tr>
  <tr>
    <td>iexcl</td>
    <td>&amp;#x000A1;</td>
    <td>&#x000A1;</td>
    <td>=inverted exclamation mark</td>
  </tr>
  <tr>
    <td>iquest</td>
    <td>&amp;#x000BF;</td>
    <td>&#x000BF;</td>
    <td>=inverted question mark</td>
  </tr>
  <tr>
    <td>laquo</td>
    <td>&amp;#x000AB;</td>
    <td>&#x000AB;</td>
    <td>=angle quotation mark, left</td>
  </tr>
  <tr>
    <td>larr</td>
    <td>&amp;#x02190;</td>
    <td>&#x02190;</td>
    <td>/leftarrow /gets A: =leftward arrow</td>
  </tr>
  <tr>
    <td>lcub</td>
    <td>&amp;#x0007B;</td>
    <td>&#x0007B;</td>
    <td>/lbrace O: =left curly bracket</td>
  </tr>
  <tr>
    <td>ldquo</td>
    <td>&amp;#x0201C;</td>
    <td>&#x0201C;</td>
    <td>=double quotation mark, left</td>
  </tr>
  <tr>
    <td>lowbar</td>
    <td>&amp;#x0005F;</td>
    <td>&#x0005F;</td>
    <td>=low line</td>
  </tr>
  <tr>
    <td>lpar</td>
    <td>&amp;#x00028;</td>
    <td>&#x00028;</td>
    <td>O: =left parenthesis</td>
  </tr>
  <tr>
    <td>lsqb</td>
    <td>&amp;#x0005B;</td>
    <td>&#x0005B;</td>
    <td>/lbrack O: =left square bracket</td>
  </tr>
  <tr>
    <td>lsquo</td>
    <td>&amp;#x02018;</td>
    <td>&#x02018;</td>
    <td>=single quotation mark, left</td>
  </tr>
  <tr>
    <td>lt</td>
    <td>&amp;#60;</td>
    <td>&#60;</td>
    <td>=less-than sign R:</td>
  </tr>
  <tr>
    <td>micro</td>
    <td>&amp;#x000B5;</td>
    <td>&#x000B5;</td>
    <td>=micro sign</td>
  </tr>
  <tr>
    <td>middot</td>
    <td>&amp;#x000B7;</td>
    <td>&#x000B7;</td>
    <td>/centerdot B: =middle dot</td>
  </tr>
  <tr>
    <td>nbsp</td>
    <td>&amp;#x000A0;</td>
    <td>&#x000A0;</td>
    <td>=no break (required) space</td>
  </tr>
  <tr>
    <td>not</td>
    <td>&amp;#x000AC;</td>
    <td>&#x000AC;</td>
    <td>/neg /lnot =not sign</td>
  </tr>
  <tr>
    <td>num</td>
    <td>&amp;#x00023;</td>
    <td>&#x00023;</td>
    <td>=number sign</td>
  </tr>
  <tr>
    <td>ohm</td>
    <td>&amp;#x02126;</td>
    <td>&#x02126;</td>
    <td>=ohm sign</td>
  </tr>
  <tr>
    <td>ordf</td>
    <td>&amp;#x000AA;</td>
    <td>&#x000AA;</td>
    <td>=ordinal indicator, feminine</td>
  </tr>
  <tr>
    <td>ordm</td>
    <td>&amp;#x000BA;</td>
    <td>&#x000BA;</td>
    <td>=ordinal indicator, masculine</td>
  </tr>
  <tr>
    <td>para</td>
    <td>&amp;#x000B6;</td>
    <td>&#x000B6;</td>
    <td>=pilcrow (paragraph sign)</td>
  </tr>
  <tr>
    <td>percnt</td>
    <td>&amp;#x00025;</td>
    <td>&#x00025;</td>
    <td>=percent sign</td>
  </tr>
  <tr>
    <td>period</td>
    <td>&amp;#x0002E;</td>
    <td>&#x0002E;</td>
    <td>=full stop, period</td>
  </tr>
  <tr>
    <td>plus</td>
    <td>&amp;#x0002B;</td>
    <td>&#x0002B;</td>
    <td>=plus sign B:</td>
  </tr>
  <tr>
    <td>plusmn</td>
    <td>&amp;#x000B1;</td>
    <td>&#x000B1;</td>
    <td>/pm B: =plus-or-minus sign</td>
  </tr>
  <tr>
    <td>pound</td>
    <td>&amp;#x000A3;</td>
    <td>&#x000A3;</td>
    <td>=pound sign</td>
  </tr>
  <tr>
    <td>quest</td>
    <td>&amp;#x0003F;</td>
    <td>&#x0003F;</td>
    <td>=question mark</td>
  </tr>
  <tr>
    <td>quot</td>
    <td>&amp;#x00022;</td>
    <td>&#x00022;</td>
    <td>=quotation mark</td>
  </tr>
  <tr>
    <td>raquo</td>
    <td>&amp;#x000BB;</td>
    <td>&#x000BB;</td>
    <td>=angle quotation mark, right</td>
  </tr>
  <tr>
    <td>rarr</td>
    <td>&amp;#x02192;</td>
    <td>&#x02192;</td>
    <td>/rightarrow /to A: =rightward arrow</td>
  </tr>
  <tr>
    <td>rcub</td>
    <td>&amp;#x0007D;</td>
    <td>&#x0007D;</td>
    <td>/rbrace C: =right curly bracket</td>
  </tr>
  <tr>
    <td>rdquo</td>
    <td>&amp;#x0201D;</td>
    <td>&#x0201D;</td>
    <td>=double quotation mark, right</td>
  </tr>
  <tr>
    <td>reg</td>
    <td>&amp;#x000AE;</td>
    <td>&#x000AE;</td>
    <td>/circledR =registered sign</td>
  </tr>
  <tr>
    <td>rpar</td>
    <td>&amp;#x00029;</td>
    <td>&#x00029;</td>
    <td>C: =right parenthesis</td>
  </tr>
  <tr>
    <td>rsqb</td>
    <td>&amp;#x0005D;</td>
    <td>&#x0005D;</td>
    <td>/rbrack C: =right square bracket</td>
  </tr>
  <tr>
    <td>rsquo</td>
    <td>&amp;#x02019;</td>
    <td>&#x02019;</td>
    <td>=single quotation mark, right</td>
  </tr>
  <tr>
    <td>sect</td>
    <td>&amp;#x000A7;</td>
    <td>&#x000A7;</td>
    <td>=section sign</td>
  </tr>
  <tr>
    <td>semi</td>
    <td>&amp;#x0003B;</td>
    <td>&#x0003B;</td>
    <td>=semicolon P:</td>
  </tr>
  <tr>
    <td>shy</td>
    <td>&amp;#x000AD;</td>
    <td>&#x000AD;</td>
    <td>=soft hyphen</td>
  </tr>
  <tr>
    <td>sol</td>
    <td>&amp;#x0002F;</td>
    <td>&#x0002F;</td>
    <td>=solidus</td>
  </tr>
  <tr>
    <td>sung</td>
    <td>&amp;#x0266A;</td>
    <td>&#x0266A;</td>
    <td>=music note (sung text sign)</td>
  </tr>
  <tr>
    <td>sup1</td>
    <td>&amp;#x000B9;</td>
    <td>&#x000B9;</td>
    <td>=superscript one</td>
  </tr>
  <tr>
    <td>sup2</td>
    <td>&amp;#x000B2;</td>
    <td>&#x000B2;</td>
    <td>=superscript two</td>
  </tr>
  <tr>
    <td>sup3</td>
    <td>&amp;#x000B3;</td>
    <td>&#x000B3;</td>
    <td>=superscript three</td>
  </tr>
  <tr>
    <td>times</td>
    <td>&amp;#x000D7;</td>
    <td>&#x000D7;</td>
    <td>/times B: =multiply sign</td>
  </tr>
  <tr>
    <td>trade</td>
    <td>&amp;#x02122;</td>
    <td>&#x02122;</td>
    <td>=trade mark sign</td>
  </tr>
  <tr>
    <td>uarr</td>
    <td>&amp;#x02191;</td>
    <td>&#x02191;</td>
    <td>/uparrow A: =upward arrow</td>
  </tr>
  <tr>
    <td>verbar</td>
    <td>&amp;#x0007C;</td>
    <td>&#x0007C;</td>
    <td>/vert =vertical bar</td>
  </tr>
  <tr>
    <td>yen</td>
    <td>&amp;#x000A5;</td>
    <td>&#x000A5;</td>
    <td>/yen =yen sign</td>
  </tr>
  <tr>
    <td>blank</td>
    <td>&amp;#x02423;</td>
    <td>&#x02423;</td>
    <td>=significant blank symbol</td>
  </tr>
  <tr>
    <td>blk12</td>
    <td>&amp;#x02592;</td>
    <td>&#x02592;</td>
    <td>=50% shaded block</td>
  </tr>
  <tr>
    <td>blk14</td>
    <td>&amp;#x02591;</td>
    <td>&#x02591;</td>
    <td>=25% shaded block</td>
  </tr>
  <tr>
    <td>blk34</td>
    <td>&amp;#x02593;</td>
    <td>&#x02593;</td>
    <td>=75% shaded block</td>
  </tr>
  <tr>
    <td>block</td>
    <td>&amp;#x02588;</td>
    <td>&#x02588;</td>
    <td>=full block</td>
  </tr>
  <tr>
    <td>bull</td>
    <td>&amp;#x02022;</td>
    <td>&#x02022;</td>
    <td>/bullet B: =round bullet, filled</td>
  </tr>
  <tr>
    <td>caret</td>
    <td>&amp;#x02041;</td>
    <td>&#x02041;</td>
    <td>=caret (insertion mark)</td>
  </tr>
  <tr>
    <td>check</td>
    <td>&amp;#x02713;</td>
    <td>&#x02713;</td>
    <td>/checkmark =tick, check mark</td>
  </tr>
  <tr>
    <td>cir</td>
    <td>&amp;#x025CB;</td>
    <td>&#x025CB;</td>
    <td>/circ B: =circle, open</td>
  </tr>
  <tr>
    <td>clubs</td>
    <td>&amp;#x02663;</td>
    <td>&#x02663;</td>
    <td>/clubsuit =club suit symbol</td>
  </tr>
  <tr>
    <td>copysr</td>
    <td>&amp;#x02117;</td>
    <td>&#x02117;</td>
    <td>=sound recording copyright sign</td>
  </tr>
  <tr>
    <td>cross</td>
    <td>&amp;#x02717;</td>
    <td>&#x02717;</td>
    <td>=ballot cross</td>
  </tr>
  <tr>
    <td>Dagger</td>
    <td>&amp;#x02021;</td>
    <td>&#x02021;</td>
    <td>/ddagger B: =double dagger</td>
  </tr>
  <tr>
    <td>dagger</td>
    <td>&amp;#x02020;</td>
    <td>&#x02020;</td>
    <td>/dagger B: =dagger</td>
  </tr>
  <tr>
    <td>dash</td>
    <td>&amp;#x02010;</td>
    <td>&#x02010;</td>
    <td>=hyphen (true graphic)</td>
  </tr>
  <tr>
    <td>diams</td>
    <td>&amp;#x02666;</td>
    <td>&#x02666;</td>
    <td>/diamondsuit =diamond suit symbol</td>
  </tr>
  <tr>
    <td>dlcrop</td>
    <td>&amp;#x0230D;</td>
    <td>&#x0230D;</td>
    <td>downward left crop mark</td>
  </tr>
  <tr>
    <td>drcrop</td>
    <td>&amp;#x0230C;</td>
    <td>&#x0230C;</td>
    <td>downward right crop mark</td>
  </tr>
  <tr>
    <td>dtri</td>
    <td>&amp;#x025BF;</td>
    <td>&#x025BF;</td>
    <td>/triangledown =down triangle, open</td>
  </tr>
  <tr>
    <td>dtrif</td>
    <td>&amp;#x025BE;</td>
    <td>&#x025BE;</td>
    <td>/blacktriangledown =dn tri, filled</td>
  </tr>
  <tr>
    <td>emsp</td>
    <td>&amp;#x02003;</td>
    <td>&#x02003;</td>
    <td>=em space</td>
  </tr>
  <tr>
    <td>emsp13</td>
    <td>&amp;#x02004;</td>
    <td>&#x02004;</td>
    <td>=1/3-em space</td>
  </tr>
  <tr>
    <td>emsp14</td>
    <td>&amp;#x02005;</td>
    <td>&#x02005;</td>
    <td>=1/4-em space</td>
  </tr>
  <tr>
    <td>ensp</td>
    <td>&amp;#x02002;</td>
    <td>&#x02002;</td>
    <td>=en space (1/2-em)</td>
  </tr>
  <tr>
    <td>female</td>
    <td>&amp;#x02640;</td>
    <td>&#x02640;</td>
    <td>=female symbol</td>
  </tr>
  <tr>
    <td>ffilig</td>
    <td>&amp;#x0FB03;</td>
    <td>&#x0FB03;</td>
    <td>small ffi ligature</td>
  </tr>
  <tr>
    <td>fflig</td>
    <td>&amp;#x0FB00;</td>
    <td>&#x0FB00;</td>
    <td>small ff ligature</td>
  </tr>
  <tr>
    <td>ffllig</td>
    <td>&amp;#x0FB04;</td>
    <td>&#x0FB04;</td>
    <td>small ffl ligature</td>
  </tr>
  <tr>
    <td>filig</td>
    <td>&amp;#x0FB01;</td>
    <td>&#x0FB01;</td>
    <td>small fi ligature</td>
  </tr>
  <tr>
    <td>flat</td>
    <td>&amp;#x0266D;</td>
    <td>&#x0266D;</td>
    <td>/flat =musical flat</td>
  </tr>
  <tr>
    <td>fllig</td>
    <td>&amp;#x0FB02;</td>
    <td>&#x0FB02;</td>
    <td>small fl ligature</td>
  </tr>
  <tr>
    <td>frac13</td>
    <td>&amp;#x02153;</td>
    <td>&#x02153;</td>
    <td>=fraction one-third</td>
  </tr>
  <tr>
    <td>frac15</td>
    <td>&amp;#x02155;</td>
    <td>&#x02155;</td>
    <td>=fraction one-fifth</td>
  </tr>
  <tr>
    <td>frac16</td>
    <td>&amp;#x02159;</td>
    <td>&#x02159;</td>
    <td>=fraction one-sixth</td>
  </tr>
  <tr>
    <td>frac23</td>
    <td>&amp;#x02154;</td>
    <td>&#x02154;</td>
    <td>=fraction two-thirds</td>
  </tr>
  <tr>
    <td>frac25</td>
    <td>&amp;#x02156;</td>
    <td>&#x02156;</td>
    <td>=fraction two-fifths</td>
  </tr>
  <tr>
    <td>frac35</td>
    <td>&amp;#x02157;</td>
    <td>&#x02157;</td>
    <td>=fraction three-fifths</td>
  </tr>
  <tr>
    <td>frac45</td>
    <td>&amp;#x02158;</td>
    <td>&#x02158;</td>
    <td>=fraction four-fifths</td>
  </tr>
  <tr>
    <td>frac56</td>
    <td>&amp;#x0215A;</td>
    <td>&#x0215A;</td>
    <td>=fraction five-sixths</td>
  </tr>
  <tr>
    <td>hairsp</td>
    <td>&amp;#x0200A;</td>
    <td>&#x0200A;</td>
    <td>=hair space</td>
  </tr>
  <tr>
    <td>hearts</td>
    <td>&amp;#x02665;</td>
    <td>&#x02665;</td>
    <td>/heartsuit =heart suit symbol</td>
  </tr>
  <tr>
    <td>hellip</td>
    <td>&amp;#x02026;</td>
    <td>&#x02026;</td>
    <td>=ellipsis (horizontal)</td>
  </tr>
  <tr>
    <td>hybull</td>
    <td>&amp;#x02043;</td>
    <td>&#x02043;</td>
    <td>rectangle, filled (hyphen bullet)</td>
  </tr>
  <tr>
    <td>incare</td>
    <td>&amp;#x02105;</td>
    <td>&#x02105;</td>
    <td>=in-care-of symbol</td>
  </tr>
  <tr>
    <td>ldquor</td>
    <td>&amp;#x0201E;</td>
    <td>&#x0201E;</td>
    <td>=rising dbl quote, left (low)</td>
  </tr>
  <tr>
    <td>lhblk</td>
    <td>&amp;#x02584;</td>
    <td>&#x02584;</td>
    <td>=lower half block</td>
  </tr>
  <tr>
    <td>loz</td>
    <td>&amp;#x025CA;</td>
    <td>&#x025CA;</td>
    <td>/lozenge - lozenge or total mark</td>
  </tr>
  <tr>
    <td>lozf</td>
    <td>&amp;#x029EB;</td>
    <td>&#x029EB;</td>
    <td>/blacklozenge - lozenge, filled</td>
  </tr>
  <tr>
    <td>lsquor</td>
    <td>&amp;#x0201A;</td>
    <td>&#x0201A;</td>
    <td>=rising single quote, left (low)</td>
  </tr>
  <tr>
    <td>ltri</td>
    <td>&amp;#x025C3;</td>
    <td>&#x025C3;</td>
    <td>/triangleleft B: l triangle, open</td>
  </tr>
  <tr>
    <td>ltrif</td>
    <td>&amp;#x025C2;</td>
    <td>&#x025C2;</td>
    <td>/blacktriangleleft R: =l tri, filled</td>
  </tr>
  <tr>
    <td>male</td>
    <td>&amp;#x02642;</td>
    <td>&#x02642;</td>
    <td>=male symbol</td>
  </tr>
  <tr>
    <td>malt</td>
    <td>&amp;#x02720;</td>
    <td>&#x02720;</td>
    <td>/maltese =maltese cross</td>
  </tr>
  <tr>
    <td>marker</td>
    <td>&amp;#x025AE;</td>
    <td>&#x025AE;</td>
    <td>=histogram marker</td>
  </tr>
  <tr>
    <td>mdash</td>
    <td>&amp;#x02014;</td>
    <td>&#x02014;</td>
    <td>=em dash</td>
  </tr>
  <tr>
    <td>mldr</td>
    <td>&amp;#x02026;</td>
    <td>&#x02026;</td>
    <td>em leader</td>
  </tr>
  <tr>
    <td>natur</td>
    <td>&amp;#x0266E;</td>
    <td>&#x0266E;</td>
    <td>/natural - music natural</td>
  </tr>
  <tr>
    <td>ndash</td>
    <td>&amp;#x02013;</td>
    <td>&#x02013;</td>
    <td>=en dash</td>
  </tr>
  <tr>
    <td>nldr</td>
    <td>&amp;#x02025;</td>
    <td>&#x02025;</td>
    <td>=double baseline dot (en leader)</td>
  </tr>
  <tr>
    <td>numsp</td>
    <td>&amp;#x02007;</td>
    <td>&#x02007;</td>
    <td>=digit space (width of a number)</td>
  </tr>
  <tr>
    <td>phone</td>
    <td>&amp;#x0260E;</td>
    <td>&#x0260E;</td>
    <td>=telephone symbol</td>
  </tr>
  <tr>
    <td>puncsp</td>
    <td>&amp;#x02008;</td>
    <td>&#x02008;</td>
    <td>=punctuation space (width of comma)</td>
  </tr>
  <tr>
    <td>rdquor</td>
    <td>&amp;#x0201D;</td>
    <td>&#x0201D;</td>
    <td>rising dbl quote, right (high)</td>
  </tr>
  <tr>
    <td>rect</td>
    <td>&amp;#x025AD;</td>
    <td>&#x025AD;</td>
    <td>=rectangle, open</td>
  </tr>
  <tr>
    <td>rsquor</td>
    <td>&amp;#x02019;</td>
    <td>&#x02019;</td>
    <td>rising single quote, right (high)</td>
  </tr>
  <tr>
    <td>rtri</td>
    <td>&amp;#x025B9;</td>
    <td>&#x025B9;</td>
    <td>/triangleright B: r triangle, open</td>
  </tr>
  <tr>
    <td>rtrif</td>
    <td>&amp;#x025B8;</td>
    <td>&#x025B8;</td>
    <td>/blacktriangleright R: =r tri, filled</td>
  </tr>
  <tr>
    <td>rx</td>
    <td>&amp;#x0211E;</td>
    <td>&#x0211E;</td>
    <td>pharmaceutical prescription (Rx)</td>
  </tr>
  <tr>
    <td>sext</td>
    <td>&amp;#x02736;</td>
    <td>&#x02736;</td>
    <td>sextile (6-pointed star)</td>
  </tr>
  <tr>
    <td>sharp</td>
    <td>&amp;#x0266F;</td>
    <td>&#x0266F;</td>
    <td>/sharp =musical sharp</td>
  </tr>
  <tr>
    <td>spades</td>
    <td>&amp;#x02660;</td>
    <td>&#x02660;</td>
    <td>/spadesuit =spades suit symbol</td>
  </tr>
  <tr>
    <td>squ</td>
    <td>&amp;#x025A1;</td>
    <td>&#x025A1;</td>
    <td>=square, open</td>
  </tr>
  <tr>
    <td>squf</td>
    <td>&amp;#x025AA;</td>
    <td>&#x025AA;</td>
    <td>/blacksquare =sq bullet, filled</td>
  </tr>
  <tr>
    <td>star</td>
    <td>&amp;#x02606;</td>
    <td>&#x02606;</td>
    <td>=star, open</td>
  </tr>
  <tr>
    <td>starf</td>
    <td>&amp;#x02605;</td>
    <td>&#x02605;</td>
    <td>/bigstar - star, filled</td>
  </tr>
  <tr>
    <td>target</td>
    <td>&amp;#x02316;</td>
    <td>&#x02316;</td>
    <td>register mark or target</td>
  </tr>
  <tr>
    <td>telrec</td>
    <td>&amp;#x02315;</td>
    <td>&#x02315;</td>
    <td>=telephone recorder symbol</td>
  </tr>
  <tr>
    <td>thinsp</td>
    <td>&amp;#x02009;</td>
    <td>&#x02009;</td>
    <td>=thin space (1/6-em)</td>
  </tr>
  <tr>
    <td>uhblk</td>
    <td>&amp;#x02580;</td>
    <td>&#x02580;</td>
    <td>=upper half block</td>
  </tr>
  <tr>
    <td>ulcrop</td>
    <td>&amp;#x0230F;</td>
    <td>&#x0230F;</td>
    <td>upward left crop mark</td>
  </tr>
  <tr>
    <td>urcrop</td>
    <td>&amp;#x0230E;</td>
    <td>&#x0230E;</td>
    <td>upward right crop mark</td>
  </tr>
  <tr>
    <td>utri</td>
    <td>&amp;#x025B5;</td>
    <td>&#x025B5;</td>
    <td>/triangle =up triangle, open</td>
  </tr>
  <tr>
    <td>utrif</td>
    <td>&amp;#x025B4;</td>
    <td>&#x025B4;</td>
    <td>/blacktriangle =up tri, filled</td>
  </tr>
  <tr>
    <td>vellip</td>
    <td>&amp;#x022EE;</td>
    <td>&#x022EE;</td>
    <td>vertical ellipsis</td>
  </tr>
  <tr>
    <td>acd</td>
    <td>&amp;#x0223F;</td>
    <td>&#x0223F;</td>
    <td>ac current</td>
  </tr>
  <tr>
    <td>aleph</td>
    <td>&amp;#x02135;</td>
    <td>&#x02135;</td>
    <td>/aleph aleph, Hebrew</td>
  </tr>
  <tr>
    <td>And</td>
    <td>&amp;#x02A53;</td>
    <td>&#x02A53;</td>
    <td>dbl logical and</td>
  </tr>
  <tr>
    <td>and</td>
    <td>&amp;#x02227;</td>
    <td>&#x02227;</td>
    <td>/wedge /land B: logical and</td>
  </tr>
  <tr>
    <td>andand</td>
    <td>&amp;#x02A55;</td>
    <td>&#x02A55;</td>
    <td>two logical and</td>
  </tr>
  <tr>
    <td>andd</td>
    <td>&amp;#x02A5C;</td>
    <td>&#x02A5C;</td>
    <td>and, horizontal dash</td>
  </tr>
  <tr>
    <td>andslope</td>
    <td>&amp;#x02A58;</td>
    <td>&#x02A58;</td>
    <td>sloping large and</td>
  </tr>
  <tr>
    <td>andv</td>
    <td>&amp;#x02A5A;</td>
    <td>&#x02A5A;</td>
    <td>and with middle stem</td>
  </tr>
  <tr>
    <td>angrt</td>
    <td>&amp;#x0221F;</td>
    <td>&#x0221F;</td>
    <td>right (90 degree) angle</td>
  </tr>
  <tr>
    <td>angsph</td>
    <td>&amp;#x02222;</td>
    <td>&#x02222;</td>
    <td>/sphericalangle angle-spherical</td>
  </tr>
  <tr>
    <td>angst</td>
    <td>&amp;#x0212B;</td>
    <td>&#x0212B;</td>
    <td>Angstrom capital A, ring</td>
  </tr>
  <tr>
    <td>ap</td>
    <td>&amp;#x02248;</td>
    <td>&#x02248;</td>
    <td>/approx R: approximate</td>
  </tr>
  <tr>
    <td>apacir</td>
    <td>&amp;#x02A6F;</td>
    <td>&#x02A6F;</td>
    <td>approximate, circumflex accent</td>
  </tr>
  <tr>
    <td>awconint</td>
    <td>&amp;#x02233;</td>
    <td>&#x02233;</td>
    <td>contour integral, anti-clockwise</td>
  </tr>
  <tr>
    <td>awint</td>
    <td>&amp;#x02A11;</td>
    <td>&#x02A11;</td>
    <td>anti clock-wise integration</td>
  </tr>
  <tr>
    <td>becaus</td>
    <td>&amp;#x02235;</td>
    <td>&#x02235;</td>
    <td>/because R: because</td>
  </tr>
  <tr>
    <td>bernou</td>
    <td>&amp;#x0212C;</td>
    <td>&#x0212C;</td>
    <td>Bernoulli function (script capital B)</td>
  </tr>
  <tr>
    <td>bne</td>
    <td>&amp;#x0003D;&amp;#x020E5;</td>
    <td>&#x0003D;&#x020E5;</td>
    <td>reverse not equal</td>
  </tr>
  <tr>
    <td>bnequiv</td>
    <td>&amp;#x02261;&amp;#x020E5;</td>
    <td>&#x02261;&#x020E5;</td>
    <td>reverse not equivalent</td>
  </tr>
  <tr>
    <td>bNot</td>
    <td>&amp;#x02AED;</td>
    <td>&#x02AED;</td>
    <td>reverse not with two horizontal strokes</td>
  </tr>
  <tr>
    <td>bnot</td>
    <td>&amp;#x02310;</td>
    <td>&#x02310;</td>
    <td>reverse not</td>
  </tr>
  <tr>
    <td>bottom</td>
    <td>&amp;#x022A5;</td>
    <td>&#x022A5;</td>
    <td>/bot bottom</td>
  </tr>
  <tr>
    <td>cap</td>
    <td>&amp;#x02229;</td>
    <td>&#x02229;</td>
    <td>/cap B: intersection</td>
  </tr>
  <tr>
    <td>Cconint</td>
    <td>&amp;#x02230;</td>
    <td>&#x02230;</td>
    <td>triple contour integral operator</td>
  </tr>
  <tr>
    <td>cirfnint</td>
    <td>&amp;#x02A10;</td>
    <td>&#x02A10;</td>
    <td>circulation function</td>
  </tr>
  <tr>
    <td>compfn</td>
    <td>&amp;#x02218;</td>
    <td>&#x02218;</td>
    <td>/circ B: composite function (small circle)</td>
  </tr>
  <tr>
    <td>cong</td>
    <td>&amp;#x02245;</td>
    <td>&#x02245;</td>
    <td>/cong R: congruent with</td>
  </tr>
  <tr>
    <td>Conint</td>
    <td>&amp;#x0222F;</td>
    <td>&#x0222F;</td>
    <td>double contour integral operator</td>
  </tr>
  <tr>
    <td>conint</td>
    <td>&amp;#x0222E;</td>
    <td>&#x0222E;</td>
    <td>/oint L: contour integral operator</td>
  </tr>
  <tr>
    <td>ctdot</td>
    <td>&amp;#x022EF;</td>
    <td>&#x022EF;</td>
    <td>/cdots, three dots, centered</td>
  </tr>
  <tr>
    <td>cup</td>
    <td>&amp;#x0222A;</td>
    <td>&#x0222A;</td>
    <td>/cup B: union or logical sum</td>
  </tr>
  <tr>
    <td>cwconint</td>
    <td>&amp;#x02232;</td>
    <td>&#x02232;</td>
    <td>contour integral, clockwise</td>
  </tr>
  <tr>
    <td>cwint</td>
    <td>&amp;#x02231;</td>
    <td>&#x02231;</td>
    <td>clockwise integral</td>
  </tr>
  <tr>
    <td>cylcty</td>
    <td>&amp;#x0232D;</td>
    <td>&#x0232D;</td>
    <td>cylindricity</td>
  </tr>
  <tr>
    <td>disin</td>
    <td>&amp;#x022F2;</td>
    <td>&#x022F2;</td>
    <td>set membership, long horizontal stroke</td>
  </tr>
  <tr>
    <td>Dot</td>
    <td>&amp;#x000A8;</td>
    <td>&#x000A8;</td>
    <td>dieresis or umlaut mark</td>
  </tr>
  <tr>
    <td>dsol</td>
    <td>&amp;#x029F6;</td>
    <td>&#x029F6;</td>
    <td>solidus, bar above</td>
  </tr>
  <tr>
    <td>dtdot</td>
    <td>&amp;#x022F1;</td>
    <td>&#x022F1;</td>
    <td>/ddots, three dots, descending</td>
  </tr>
  <tr>
    <td>dwangle</td>
    <td>&amp;#x029A6;</td>
    <td>&#x029A6;</td>
    <td>large downward pointing angle</td>
  </tr>
  <tr>
    <td>elinters</td>
    <td>&amp;#x0FFFD;</td>
    <td>&#x0FFFD;</td>
    <td>electrical intersection</td>
  </tr>
  <tr>
    <td>epar</td>
    <td>&amp;#x022D5;</td>
    <td>&#x022D5;</td>
    <td>parallel, equal; equal or parallel</td>
  </tr>
  <tr>
    <td>eparsl</td>
    <td>&amp;#x029E3;</td>
    <td>&#x029E3;</td>
    <td>parallel, slanted, equal; homothetically congruent to</td>
  </tr>
  <tr>
    <td>equiv</td>
    <td>&amp;#x02261;</td>
    <td>&#x02261;</td>
    <td>/equiv R: identical with</td>
  </tr>
  <tr>
    <td>eqvparsl</td>
    <td>&amp;#x029E5;</td>
    <td>&#x029E5;</td>
    <td>equivalent, equal; congruent and parallel</td>
  </tr>
  <tr>
    <td>exist</td>
    <td>&amp;#x02203;</td>
    <td>&#x02203;</td>
    <td>/exists at least one exists</td>
  </tr>
  <tr>
    <td>fltns</td>
    <td>&amp;#x025B1;</td>
    <td>&#x025B1;</td>
    <td>flatness</td>
  </tr>
  <tr>
    <td>fnof</td>
    <td>&amp;#x00192;</td>
    <td>&#x00192;</td>
    <td>function of (italic small f)</td>
  </tr>
  <tr>
    <td>forall</td>
    <td>&amp;#x02200;</td>
    <td>&#x02200;</td>
    <td>/forall for all</td>
  </tr>
  <tr>
    <td>fpartint</td>
    <td>&amp;#x02A0D;</td>
    <td>&#x02A0D;</td>
    <td>finite part integral</td>
  </tr>
  <tr>
    <td>ge</td>
    <td>&amp;#x02265;</td>
    <td>&#x02265;</td>
    <td>/geq /ge R: greater-than-or-equal</td>
  </tr>
  <tr>
    <td>hamilt</td>
    <td>&amp;#x0210B;</td>
    <td>&#x0210B;</td>
    <td>Hamiltonian (script capital H)</td>
  </tr>
  <tr>
    <td>iff</td>
    <td>&amp;#x021D4;</td>
    <td>&#x021D4;</td>
    <td>/iff if and only if</td>
  </tr>
  <tr>
    <td>iinfin</td>
    <td>&amp;#x029DC;</td>
    <td>&#x029DC;</td>
    <td>infinity sign, incomplete</td>
  </tr>
  <tr>
    <td>imped</td>
    <td>&amp;#x001B5;</td>
    <td>&#x001B5;</td>
    <td>impedance</td>
  </tr>
  <tr>
    <td>infin</td>
    <td>&amp;#x0221E;</td>
    <td>&#x0221E;</td>
    <td>/infty infinity</td>
  </tr>
  <tr>
    <td>infintie</td>
    <td>&amp;#x029DD;</td>
    <td>&#x029DD;</td>
    <td>tie, infinity</td>
  </tr>
  <tr>
    <td>Int</td>
    <td>&amp;#x0222C;</td>
    <td>&#x0222C;</td>
    <td>double integral operator</td>
  </tr>
  <tr>
    <td>int</td>
    <td>&amp;#x0222B;</td>
    <td>&#x0222B;</td>
    <td>/int L: integral operator</td>
  </tr>
  <tr>
    <td>intlarhk</td>
    <td>&amp;#x02A17;</td>
    <td>&#x02A17;</td>
    <td>integral, left arrow with hook</td>
  </tr>
  <tr>
    <td>isin</td>
    <td>&amp;#x02208;</td>
    <td>&#x02208;</td>
    <td>/in R: set membership</td>
  </tr>
  <tr>
    <td>isindot</td>
    <td>&amp;#x022F5;</td>
    <td>&#x022F5;</td>
    <td>set membership, dot above</td>
  </tr>
  <tr>
    <td>isinE</td>
    <td>&amp;#x022F9;</td>
    <td>&#x022F9;</td>
    <td>set membership, two horizontal strokes</td>
  </tr>
  <tr>
    <td>isins</td>
    <td>&amp;#x022F4;</td>
    <td>&#x022F4;</td>
    <td>set membership, vertical bar on horizontal stroke</td>
  </tr>
  <tr>
    <td>isinsv</td>
    <td>&amp;#x022F3;</td>
    <td>&#x022F3;</td>
    <td>large set membership, vertical bar on horizontal stroke</td>
  </tr>
  <tr>
    <td>isinv</td>
    <td>&amp;#x02208;</td>
    <td>&#x02208;</td>
    <td>set membership, variant</td>
  </tr>
  <tr>
    <td>lagran</td>
    <td>&amp;#x02112;</td>
    <td>&#x02112;</td>
    <td>Lagrangian (script capital L)</td>
  </tr>
  <tr>
    <td>Lang</td>
    <td>&amp;#x0300A;</td>
    <td>&#x0300A;</td>
    <td>left angle bracket, double</td>
  </tr>
  <tr>
    <td>lang</td>
    <td>&amp;#x02329;</td>
    <td>&#x02329;</td>
    <td>/langle O: left angle bracket</td>
  </tr>
  <tr>
    <td>lArr</td>
    <td>&amp;#x021D0;</td>
    <td>&#x021D0;</td>
    <td>/Leftarrow A: is implied by</td>
  </tr>
  <tr>
    <td>lbbrk</td>
    <td>&amp;#x03014;</td>
    <td>&#x03014;</td>
    <td>left broken bracket</td>
  </tr>
  <tr>
    <td>le</td>
    <td>&amp;#x02264;</td>
    <td>&#x02264;</td>
    <td>/leq /le R: less-than-or-equal</td>
  </tr>
  <tr>
    <td>loang</td>
    <td>&amp;#x03018;</td>
    <td>&#x03018;</td>
    <td>left open angular bracket</td>
  </tr>
  <tr>
    <td>lobrk</td>
    <td>&amp;#x0301A;</td>
    <td>&#x0301A;</td>
    <td>left open bracket</td>
  </tr>
  <tr>
    <td>lopar</td>
    <td>&amp;#x02985;</td>
    <td>&#x02985;</td>
    <td>left open parenthesis</td>
  </tr>
  <tr>
    <td>lowast</td>
    <td>&amp;#x02217;</td>
    <td>&#x02217;</td>
    <td>low asterisk</td>
  </tr>
  <tr>
    <td>minus</td>
    <td>&amp;#x02212;</td>
    <td>&#x02212;</td>
    <td>B: minus sign</td>
  </tr>
  <tr>
    <td>mnplus</td>
    <td>&amp;#x02213;</td>
    <td>&#x02213;</td>
    <td>/mp B: minus-or-plus sign</td>
  </tr>
  <tr>
    <td>nabla</td>
    <td>&amp;#x02207;</td>
    <td>&#x02207;</td>
    <td>/nabla del, Hamilton operator</td>
  </tr>
  <tr>
    <td>ne</td>
    <td>&amp;#x02260;</td>
    <td>&#x02260;</td>
    <td>/ne /neq R: not equal</td>
  </tr>
  <tr>
    <td>nedot</td>
    <td>&amp;#x02250;&amp;#x00338;</td>
    <td>&#x02250;&#x00338;</td>
    <td>not equal, dot</td>
  </tr>
  <tr>
    <td>nhpar</td>
    <td>&amp;#x02AF2;</td>
    <td>&#x02AF2;</td>
    <td>not, horizontal, parallel</td>
  </tr>
  <tr>
    <td>ni</td>
    <td>&amp;#x0220B;</td>
    <td>&#x0220B;</td>
    <td>/ni /owns R: contains</td>
  </tr>
  <tr>
    <td>nis</td>
    <td>&amp;#x022FC;</td>
    <td>&#x022FC;</td>
    <td>contains, vertical bar on horizontal stroke</td>
  </tr>
  <tr>
    <td>nisd</td>
    <td>&amp;#x022FA;</td>
    <td>&#x022FA;</td>
    <td>contains, long horizontal stroke</td>
  </tr>
  <tr>
    <td>niv</td>
    <td>&amp;#x0220B;</td>
    <td>&#x0220B;</td>
    <td>contains, variant</td>
  </tr>
  <tr>
    <td>Not</td>
    <td>&amp;#x02AEC;</td>
    <td>&#x02AEC;</td>
    <td>not with two horizontal strokes</td>
  </tr>
  <tr>
    <td>notin</td>
    <td>&amp;#x02209;</td>
    <td>&#x02209;</td>
    <td>/notin N: negated set membership</td>
  </tr>
  <tr>
    <td>notindot</td>
    <td>&amp;#x022F5;&amp;#x00338;</td>
    <td>&#x022F5;&#x00338;</td>
    <td>negated set membership, dot above</td>
  </tr>
  <tr>
    <td>notinE</td>
    <td>&amp;#x022F9;&amp;#x00338;</td>
    <td>&#x022F9;&#x00338;</td>
    <td>negated set membership, two horizontal strokes</td>
  </tr>
  <tr>
    <td>notinva</td>
    <td>&amp;#x02209;</td>
    <td>&#x02209;</td>
    <td>negated set membership, variant</td>
  </tr>
  <tr>
    <td>notinvb</td>
    <td>&amp;#x022F7;</td>
    <td>&#x022F7;</td>
    <td>negated set membership, variant</td>
  </tr>
  <tr>
    <td>notinvc</td>
    <td>&amp;#x022F6;</td>
    <td>&#x022F6;</td>
    <td>negated set membership, variant</td>
  </tr>
  <tr>
    <td>notni</td>
    <td>&amp;#x0220C;</td>
    <td>&#x0220C;</td>
    <td>negated contains</td>
  </tr>
  <tr>
    <td>notniva</td>
    <td>&amp;#x0220C;</td>
    <td>&#x0220C;</td>
    <td>negated contains, variant</td>
  </tr>
  <tr>
    <td>notnivb</td>
    <td>&amp;#x022FE;</td>
    <td>&#x022FE;</td>
    <td>contains, variant</td>
  </tr>
  <tr>
    <td>notnivc</td>
    <td>&amp;#x022FD;</td>
    <td>&#x022FD;</td>
    <td>contains, variant</td>
  </tr>
  <tr>
    <td>nparsl</td>
    <td>&amp;#x02AFD;&amp;#x020E5;</td>
    <td>&#x02AFD;&#x020E5;</td>
    <td>not parallel, slanted</td>
  </tr>
  <tr>
    <td>npart</td>
    <td>&amp;#x02202;&amp;#x00338;</td>
    <td>&#x02202;&#x00338;</td>
    <td>not partial differential</td>
  </tr>
  <tr>
    <td>npolint</td>
    <td>&amp;#x02A14;</td>
    <td>&#x02A14;</td>
    <td>line integration, not including the pole</td>
  </tr>
  <tr>
    <td>nvinfin</td>
    <td>&amp;#x029DE;</td>
    <td>&#x029DE;</td>
    <td>not, vert, infinity</td>
  </tr>
  <tr>
    <td>olcross</td>
    <td>&amp;#x029BB;</td>
    <td>&#x029BB;</td>
    <td>circle, cross</td>
  </tr>
  <tr>
    <td>Or</td>
    <td>&amp;#x02A54;</td>
    <td>&#x02A54;</td>
    <td>dbl logical or</td>
  </tr>
  <tr>
    <td>or</td>
    <td>&amp;#x02228;</td>
    <td>&#x02228;</td>
    <td>/vee /lor B: logical or</td>
  </tr>
  <tr>
    <td>ord</td>
    <td>&amp;#x02A5D;</td>
    <td>&#x02A5D;</td>
    <td>or, horizontal dash</td>
  </tr>
  <tr>
    <td>order</td>
    <td>&amp;#x02134;</td>
    <td>&#x02134;</td>
    <td>order of (script small o)</td>
  </tr>
  <tr>
    <td>oror</td>
    <td>&amp;#x02A56;</td>
    <td>&#x02A56;</td>
    <td>two logical or</td>
  </tr>
  <tr>
    <td>orslope</td>
    <td>&amp;#x02A57;</td>
    <td>&#x02A57;</td>
    <td>sloping large or</td>
  </tr>
  <tr>
    <td>orv</td>
    <td>&amp;#x02A5B;</td>
    <td>&#x02A5B;</td>
    <td>or with middle stem</td>
  </tr>
  <tr>
    <td>par</td>
    <td>&amp;#x02225;</td>
    <td>&#x02225;</td>
    <td>/parallel R: parallel</td>
  </tr>
  <tr>
    <td>parsl</td>
    <td>&amp;#x02AFD;</td>
    <td>&#x02AFD;</td>
    <td>parallel, slanted</td>
  </tr>
  <tr>
    <td>part</td>
    <td>&amp;#x02202;</td>
    <td>&#x02202;</td>
    <td>/partial partial differential</td>
  </tr>
  <tr>
    <td>permil</td>
    <td>&amp;#x02030;</td>
    <td>&#x02030;</td>
    <td>per thousand</td>
  </tr>
  <tr>
    <td>perp</td>
    <td>&amp;#x022A5;</td>
    <td>&#x022A5;</td>
    <td>/perp R: perpendicular</td>
  </tr>
  <tr>
    <td>pertenk</td>
    <td>&amp;#x02031;</td>
    <td>&#x02031;</td>
    <td>per 10 thousand</td>
  </tr>
  <tr>
    <td>phmmat</td>
    <td>&amp;#x02133;</td>
    <td>&#x02133;</td>
    <td>physics M-matrix (script capital M)</td>
  </tr>
  <tr>
    <td>pointint</td>
    <td>&amp;#x02A15;</td>
    <td>&#x02A15;</td>
    <td>integral around a point operator</td>
  </tr>
  <tr>
    <td>Prime</td>
    <td>&amp;#x02033;</td>
    <td>&#x02033;</td>
    <td>double prime or second</td>
  </tr>
  <tr>
    <td>prime</td>
    <td>&amp;#x02032;</td>
    <td>&#x02032;</td>
    <td>/prime prime or minute</td>
  </tr>
  <tr>
    <td>profalar</td>
    <td>&amp;#x0232E;</td>
    <td>&#x0232E;</td>
    <td>all-around profile</td>
  </tr>
  <tr>
    <td>profline</td>
    <td>&amp;#x02312;</td>
    <td>&#x02312;</td>
    <td>profile of a line</td>
  </tr>
  <tr>
    <td>profsurf</td>
    <td>&amp;#x02313;</td>
    <td>&#x02313;</td>
    <td>profile of a surface</td>
  </tr>
  <tr>
    <td>prop</td>
    <td>&amp;#x0221D;</td>
    <td>&#x0221D;</td>
    <td>/propto R: is proportional to</td>
  </tr>
  <tr>
    <td>qint</td>
    <td>&amp;#x02A0C;</td>
    <td>&#x02A0C;</td>
    <td>/iiiint quadruple integral operator</td>
  </tr>
  <tr>
    <td>qprime</td>
    <td>&amp;#x02057;</td>
    <td>&#x02057;</td>
    <td>quadruple prime</td>
  </tr>
  <tr>
    <td>quatint</td>
    <td>&amp;#x02A16;</td>
    <td>&#x02A16;</td>
    <td>quaternion integral operator</td>
  </tr>
  <tr>
    <td>radic</td>
    <td>&amp;#x0221A;</td>
    <td>&#x0221A;</td>
    <td>/surd radical</td>
  </tr>
  <tr>
    <td>Rang</td>
    <td>&amp;#x0300B;</td>
    <td>&#x0300B;</td>
    <td>right angle bracket, double</td>
  </tr>
  <tr>
    <td>rang</td>
    <td>&amp;#x0232A;</td>
    <td>&#x0232A;</td>
    <td>/rangle C: right angle bracket</td>
  </tr>
  <tr>
    <td>rArr</td>
    <td>&amp;#x021D2;</td>
    <td>&#x021D2;</td>
    <td>/Rightarrow A: implies</td>
  </tr>
  <tr>
    <td>rbbrk</td>
    <td>&amp;#x03015;</td>
    <td>&#x03015;</td>
    <td>right broken bracket</td>
  </tr>
  <tr>
    <td>roang</td>
    <td>&amp;#x03019;</td>
    <td>&#x03019;</td>
    <td>right open angular bracket</td>
  </tr>
  <tr>
    <td>robrk</td>
    <td>&amp;#x0301B;</td>
    <td>&#x0301B;</td>
    <td>right open bracket</td>
  </tr>
  <tr>
    <td>ropar</td>
    <td>&amp;#x02986;</td>
    <td>&#x02986;</td>
    <td>right open parenthesis</td>
  </tr>
  <tr>
    <td>rppolint</td>
    <td>&amp;#x02A12;</td>
    <td>&#x02A12;</td>
    <td>line integration, rectangular path around pole</td>
  </tr>
  <tr>
    <td>scpolint</td>
    <td>&amp;#x02A13;</td>
    <td>&#x02A13;</td>
    <td>line integration, semi-circular path around pole</td>
  </tr>
  <tr>
    <td>sim</td>
    <td>&amp;#x0223C;</td>
    <td>&#x0223C;</td>
    <td>/sim R: similar</td>
  </tr>
  <tr>
    <td>simdot</td>
    <td>&amp;#x02A6A;</td>
    <td>&#x02A6A;</td>
    <td>similar, dot</td>
  </tr>
  <tr>
    <td>sime</td>
    <td>&amp;#x02243;</td>
    <td>&#x02243;</td>
    <td>/simeq R: similar, equals</td>
  </tr>
  <tr>
    <td>smeparsl</td>
    <td>&amp;#x029E4;</td>
    <td>&#x029E4;</td>
    <td>similar, parallel, slanted, equal</td>
  </tr>
  <tr>
    <td>square</td>
    <td>&amp;#x025A1;</td>
    <td>&#x025A1;</td>
    <td>/square, square</td>
  </tr>
  <tr>
    <td>squarf</td>
    <td>&amp;#x025AA;</td>
    <td>&#x025AA;</td>
    <td>/blacksquare, square, filled</td>
  </tr>
  <tr>
    <td>strns</td>
    <td>&amp;#x000AF;</td>
    <td>&#x000AF;</td>
    <td>straightness</td>
  </tr>
  <tr>
    <td>sub</td>
    <td>&amp;#x02282;</td>
    <td>&#x02282;</td>
    <td>/subset R: subset or is implied by</td>
  </tr>
  <tr>
    <td>sube</td>
    <td>&amp;#x02286;</td>
    <td>&#x02286;</td>
    <td>/subseteq R: subset, equals</td>
  </tr>
  <tr>
    <td>sup</td>
    <td>&amp;#x02283;</td>
    <td>&#x02283;</td>
    <td>/supset R: superset or implies</td>
  </tr>
  <tr>
    <td>supe</td>
    <td>&amp;#x02287;</td>
    <td>&#x02287;</td>
    <td>/supseteq R: superset, equals</td>
  </tr>
  <tr>
    <td>there4</td>
    <td>&amp;#x02234;</td>
    <td>&#x02234;</td>
    <td>/therefore R: therefore</td>
  </tr>
  <tr>
    <td>tint</td>
    <td>&amp;#x0222D;</td>
    <td>&#x0222D;</td>
    <td>/iiint triple integral operator</td>
  </tr>
  <tr>
    <td>top</td>
    <td>&amp;#x022A4;</td>
    <td>&#x022A4;</td>
    <td>/top top</td>
  </tr>
  <tr>
    <td>topbot</td>
    <td>&amp;#x02336;</td>
    <td>&#x02336;</td>
    <td>top and bottom</td>
  </tr>
  <tr>
    <td>topcir</td>
    <td>&amp;#x02AF1;</td>
    <td>&#x02AF1;</td>
    <td>top, circle below</td>
  </tr>
  <tr>
    <td>tprime</td>
    <td>&amp;#x02034;</td>
    <td>&#x02034;</td>
    <td>triple prime</td>
  </tr>
  <tr>
    <td>utdot</td>
    <td>&amp;#x022F0;</td>
    <td>&#x022F0;</td>
    <td>three dots, ascending</td>
  </tr>
  <tr>
    <td>uwangle</td>
    <td>&amp;#x029A7;</td>
    <td>&#x029A7;</td>
    <td>large upward pointing angle</td>
  </tr>
  <tr>
    <td>vangrt</td>
    <td>&amp;#x0299C;</td>
    <td>&#x0299C;</td>
    <td>right angle, variant</td>
  </tr>
  <tr>
    <td>veeeq</td>
    <td>&amp;#x0225A;</td>
    <td>&#x0225A;</td>
    <td>logical or, equals</td>
  </tr>
  <tr>
    <td>Verbar</td>
    <td>&amp;#x02016;</td>
    <td>&#x02016;</td>
    <td>/Vert dbl vertical bar</td>
  </tr>
  <tr>
    <td>wedgeq</td>
    <td>&amp;#x02259;</td>
    <td>&#x02259;</td>
    <td>/wedgeq R: corresponds to (wedge, equals)</td>
  </tr>
  <tr>
    <td>xnis</td>
    <td>&amp;#x022FB;</td>
    <td>&#x022FB;</td>
    <td>large contains, vertical bar on horizontal stroke</td>
  </tr>
  <tr>
    <td>angle</td>
    <td>&amp;#x02220;</td>
    <td>&#x02220;</td>
    <td>alias ISOAMSO ang</td>
  </tr>
  <tr>
    <td>ApplyFunction</td>
    <td>&amp;#x02061;</td>
    <td>&#x02061;</td>
    <td>character showing function application in presentation tagging</td>
  </tr>
  <tr>
    <td>approx</td>
    <td>&amp;#x02248;</td>
    <td>&#x02248;</td>
    <td>alias ISOTECH ap</td>
  </tr>
  <tr>
    <td>approxeq</td>
    <td>&amp;#x0224A;</td>
    <td>&#x0224A;</td>
    <td>alias ISOAMSR ape</td>
  </tr>
  <tr>
    <td>Assign</td>
    <td>&amp;#x02254;</td>
    <td>&#x02254;</td>
    <td>assignment operator, alias ISOAMSR colone</td>
  </tr>
  <tr>
    <td>backcong</td>
    <td>&amp;#x0224C;</td>
    <td>&#x0224C;</td>
    <td>alias ISOAMSR bcong</td>
  </tr>
  <tr>
    <td>backepsilon</td>
    <td>&amp;#x003F6;</td>
    <td>&#x003F6;</td>
    <td>alias ISOAMSR bepsi</td>
  </tr>
  <tr>
    <td>backprime</td>
    <td>&amp;#x02035;</td>
    <td>&#x02035;</td>
    <td>alias ISOAMSO bprime</td>
  </tr>
  <tr>
    <td>backsim</td>
    <td>&amp;#x0223D;</td>
    <td>&#x0223D;</td>
    <td>alias ISOAMSR bsim</td>
  </tr>
  <tr>
    <td>backsimeq</td>
    <td>&amp;#x022CD;</td>
    <td>&#x022CD;</td>
    <td>alias ISOAMSR bsime</td>
  </tr>
  <tr>
    <td>Backslash</td>
    <td>&amp;#x02216;</td>
    <td>&#x02216;</td>
    <td>alias ISOAMSB setmn</td>
  </tr>
  <tr>
    <td>barwedge</td>
    <td>&amp;#x02305;</td>
    <td>&#x02305;</td>
    <td>alias ISOAMSB barwed</td>
  </tr>
  <tr>
    <td>Because</td>
    <td>&amp;#x02235;</td>
    <td>&#x02235;</td>
    <td>alias ISOTECH becaus</td>
  </tr>
  <tr>
    <td>because</td>
    <td>&amp;#x02235;</td>
    <td>&#x02235;</td>
    <td>alias ISOTECH becaus</td>
  </tr>
  <tr>
    <td>Bernoullis</td>
    <td>&amp;#x0212C;</td>
    <td>&#x0212C;</td>
    <td>alias ISOTECH bernou</td>
  </tr>
  <tr>
    <td>between</td>
    <td>&amp;#x0226C;</td>
    <td>&#x0226C;</td>
    <td>alias ISOAMSR twixt</td>
  </tr>
  <tr>
    <td>bigcap</td>
    <td>&amp;#x022C2;</td>
    <td>&#x022C2;</td>
    <td>alias ISOAMSB xcap</td>
  </tr>
  <tr>
    <td>bigcirc</td>
    <td>&amp;#x025EF;</td>
    <td>&#x025EF;</td>
    <td>alias ISOAMSB xcirc</td>
  </tr>
  <tr>
    <td>bigcup</td>
    <td>&amp;#x022C3;</td>
    <td>&#x022C3;</td>
    <td>alias ISOAMSB xcup</td>
  </tr>
  <tr>
    <td>bigodot</td>
    <td>&amp;#x02A00;</td>
    <td>&#x02A00;</td>
    <td>alias ISOAMSB xodot</td>
  </tr>
  <tr>
    <td>bigoplus</td>
    <td>&amp;#x02A01;</td>
    <td>&#x02A01;</td>
    <td>alias ISOAMSB xoplus</td>
  </tr>
  <tr>
    <td>bigotimes</td>
    <td>&amp;#x02A02;</td>
    <td>&#x02A02;</td>
    <td>alias ISOAMSB xotime</td>
  </tr>
  <tr>
    <td>bigsqcup</td>
    <td>&amp;#x02A06;</td>
    <td>&#x02A06;</td>
    <td>alias ISOAMSB xsqcup</td>
  </tr>
  <tr>
    <td>bigstar</td>
    <td>&amp;#x02605;</td>
    <td>&#x02605;</td>
    <td>ISOPUB    starf</td>
  </tr>
  <tr>
    <td>bigtriangledown</td>
    <td>&amp;#x025BD;</td>
    <td>&#x025BD;</td>
    <td>alias ISOAMSB xdtri</td>
  </tr>
  <tr>
    <td>bigtriangleup</td>
    <td>&amp;#x025B3;</td>
    <td>&#x025B3;</td>
    <td>alias ISOAMSB xutri</td>
  </tr>
  <tr>
    <td>biguplus</td>
    <td>&amp;#x02A04;</td>
    <td>&#x02A04;</td>
    <td>alias ISOAMSB xuplus</td>
  </tr>
  <tr>
    <td>bigvee</td>
    <td>&amp;#x022C1;</td>
    <td>&#x022C1;</td>
    <td>alias ISOAMSB xvee</td>
  </tr>
  <tr>
    <td>bigwedge</td>
    <td>&amp;#x022C0;</td>
    <td>&#x022C0;</td>
    <td>alias ISOAMSB xwedge</td>
  </tr>
  <tr>
    <td>bkarow</td>
    <td>&amp;#x0290D;</td>
    <td>&#x0290D;</td>
    <td>alias ISOAMSA rbarr</td>
  </tr>
  <tr>
    <td>blacklozenge</td>
    <td>&amp;#x029EB;</td>
    <td>&#x029EB;</td>
    <td>alias ISOPUB lozf</td>
  </tr>
  <tr>
    <td>blacksquare</td>
    <td>&amp;#x025AA;</td>
    <td>&#x025AA;</td>
    <td>ISOTECH  squarf</td>
  </tr>
  <tr>
    <td>blacktriangle</td>
    <td>&amp;#x025B4;</td>
    <td>&#x025B4;</td>
    <td>alias ISOPUB utrif</td>
  </tr>
  <tr>
    <td>blacktriangledown</td>
    <td>&amp;#x025BE;</td>
    <td>&#x025BE;</td>
    <td>alias ISOPUB dtrif</td>
  </tr>
  <tr>
    <td>blacktriangleleft</td>
    <td>&amp;#x025C2;</td>
    <td>&#x025C2;</td>
    <td>alias ISOPUB ltrif</td>
  </tr>
  <tr>
    <td>blacktriangleright</td>
    <td>&amp;#x025B8;</td>
    <td>&#x025B8;</td>
    <td>alias ISOPUB rtrif</td>
  </tr>
  <tr>
    <td>bot</td>
    <td>&amp;#x022A5;</td>
    <td>&#x022A5;</td>
    <td>alias ISOTECH bottom</td>
  </tr>
  <tr>
    <td>boxminus</td>
    <td>&amp;#x0229F;</td>
    <td>&#x0229F;</td>
    <td>alias ISOAMSB minusb</td>
  </tr>
  <tr>
    <td>boxplus</td>
    <td>&amp;#x0229E;</td>
    <td>&#x0229E;</td>
    <td>alias ISOAMSB plusb</td>
  </tr>
  <tr>
    <td>boxtimes</td>
    <td>&amp;#x022A0;</td>
    <td>&#x022A0;</td>
    <td>alias ISOAMSB timesb</td>
  </tr>
  <tr>
    <td>Breve</td>
    <td>&amp;#x002D8;</td>
    <td>&#x002D8;</td>
    <td>alias ISODIA breve</td>
  </tr>
  <tr>
    <td>bullet</td>
    <td>&amp;#x02022;</td>
    <td>&#x02022;</td>
    <td>alias ISOPUB bull</td>
  </tr>
  <tr>
    <td>Bumpeq</td>
    <td>&amp;#x0224E;</td>
    <td>&#x0224E;</td>
    <td>alias ISOAMSR bump</td>
  </tr>
  <tr>
    <td>bumpeq</td>
    <td>&amp;#x0224F;</td>
    <td>&#x0224F;</td>
    <td>alias ISOAMSR bumpe</td>
  </tr>
  <tr>
    <td>CapitalDifferentialD</td>
    <td>&amp;#x02145;</td>
    <td>&#x02145;</td>
    <td>D for use in differentials, e.g., within integrals</td>
  </tr>
  <tr>
    <td>Cayleys</td>
    <td>&amp;#x0212D;</td>
    <td>&#x0212D;</td>
    <td>the non-associative ring of octonions or Cayley numbers</td>
  </tr>
  <tr>
    <td>Cedilla</td>
    <td>&amp;#x000B8;</td>
    <td>&#x000B8;</td>
    <td>alias ISODIA cedil</td>
  </tr>
  <tr>
    <td>CenterDot</td>
    <td>&amp;#x000B7;</td>
    <td>&#x000B7;</td>
    <td>alias ISONUM middot</td>
  </tr>
  <tr>
    <td>centerdot</td>
    <td>&amp;#x000B7;</td>
    <td>&#x000B7;</td>
    <td>alias ISONUM middot</td>
  </tr>
  <tr>
    <td>checkmark</td>
    <td>&amp;#x02713;</td>
    <td>&#x02713;</td>
    <td>alias ISOPUB check</td>
  </tr>
  <tr>
    <td>circeq</td>
    <td>&amp;#x02257;</td>
    <td>&#x02257;</td>
    <td>alias ISOAMSR cire</td>
  </tr>
  <tr>
    <td>circlearrowleft</td>
    <td>&amp;#x021BA;</td>
    <td>&#x021BA;</td>
    <td>alias ISOAMSA olarr</td>
  </tr>
  <tr>
    <td>circlearrowright</td>
    <td>&amp;#x021BB;</td>
    <td>&#x021BB;</td>
    <td>alias ISOAMSA orarr</td>
  </tr>
  <tr>
    <td>circledast</td>
    <td>&amp;#x0229B;</td>
    <td>&#x0229B;</td>
    <td>alias ISOAMSB oast</td>
  </tr>
  <tr>
    <td>circledcirc</td>
    <td>&amp;#x0229A;</td>
    <td>&#x0229A;</td>
    <td>alias ISOAMSB ocir</td>
  </tr>
  <tr>
    <td>circleddash</td>
    <td>&amp;#x0229D;</td>
    <td>&#x0229D;</td>
    <td>alias ISOAMSB odash</td>
  </tr>
  <tr>
    <td>CircleDot</td>
    <td>&amp;#x02299;</td>
    <td>&#x02299;</td>
    <td>alias ISOAMSB odot</td>
  </tr>
  <tr>
    <td>circledR</td>
    <td>&amp;#x000AE;</td>
    <td>&#x000AE;</td>
    <td>alias ISONUM reg</td>
  </tr>
  <tr>
    <td>circledS</td>
    <td>&amp;#x024C8;</td>
    <td>&#x024C8;</td>
    <td>alias ISOAMSO oS</td>
  </tr>
  <tr>
    <td>CircleMinus</td>
    <td>&amp;#x02296;</td>
    <td>&#x02296;</td>
    <td>alias ISOAMSB ominus</td>
  </tr>
  <tr>
    <td>CirclePlus</td>
    <td>&amp;#x02295;</td>
    <td>&#x02295;</td>
    <td>alias ISOAMSB oplus</td>
  </tr>
  <tr>
    <td>CircleTimes</td>
    <td>&amp;#x02297;</td>
    <td>&#x02297;</td>
    <td>alias ISOAMSB otimes</td>
  </tr>
  <tr>
    <td>ClockwiseContourIntegral</td>
    <td>&amp;#x02232;</td>
    <td>&#x02232;</td>
    <td>alias ISOTECH cwconint</td>
  </tr>
  <tr>
    <td>CloseCurlyDoubleQuote</td>
    <td>&amp;#x0201D;</td>
    <td>&#x0201D;</td>
    <td>alias ISONUM rdquo</td>
  </tr>
  <tr>
    <td>CloseCurlyQuote</td>
    <td>&amp;#x02019;</td>
    <td>&#x02019;</td>
    <td>alias ISONUM rsquo</td>
  </tr>
  <tr>
    <td>clubsuit</td>
    <td>&amp;#x02663;</td>
    <td>&#x02663;</td>
    <td>ISOPUB    clubs</td>
  </tr>
  <tr>
    <td>coloneq</td>
    <td>&amp;#x02254;</td>
    <td>&#x02254;</td>
    <td>alias ISOAMSR colone</td>
  </tr>
  <tr>
    <td>complement</td>
    <td>&amp;#x02201;</td>
    <td>&#x02201;</td>
    <td>alias ISOAMSO comp</td>
  </tr>
  <tr>
    <td>complexes</td>
    <td>&amp;#x02102;</td>
    <td>&#x02102;</td>
    <td>the field of complex numbers</td>
  </tr>
  <tr>
    <td>Congruent</td>
    <td>&amp;#x02261;</td>
    <td>&#x02261;</td>
    <td>alias ISOTECH equiv</td>
  </tr>
  <tr>
    <td>ContourIntegral</td>
    <td>&amp;#x0222E;</td>
    <td>&#x0222E;</td>
    <td>alias ISOTECH conint</td>
  </tr>
  <tr>
    <td>Coproduct</td>
    <td>&amp;#x02210;</td>
    <td>&#x02210;</td>
    <td>alias ISOAMSB coprod</td>
  </tr>
  <tr>
    <td>CounterClockwiseContourIntegral</td>
    <td>&amp;#x02233;</td>
    <td>&#x02233;</td>
    <td>alias ISOTECH awconint</td>
  </tr>
  <tr>
    <td>CupCap</td>
    <td>&amp;#x0224D;</td>
    <td>&#x0224D;</td>
    <td>alias asympeq</td>
  </tr>
  <tr>
    <td>curlyeqprec</td>
    <td>&amp;#x022DE;</td>
    <td>&#x022DE;</td>
    <td>alias ISOAMSR cuepr</td>
  </tr>
  <tr>
    <td>curlyeqsucc</td>
    <td>&amp;#x022DF;</td>
    <td>&#x022DF;</td>
    <td>alias ISOAMSR cuesc</td>
  </tr>
  <tr>
    <td>curlyvee</td>
    <td>&amp;#x022CE;</td>
    <td>&#x022CE;</td>
    <td>alias ISOAMSB cuvee</td>
  </tr>
  <tr>
    <td>curlywedge</td>
    <td>&amp;#x022CF;</td>
    <td>&#x022CF;</td>
    <td>alias ISOAMSB cuwed</td>
  </tr>
  <tr>
    <td>curvearrowleft</td>
    <td>&amp;#x021B6;</td>
    <td>&#x021B6;</td>
    <td>alias ISOAMSA cularr</td>
  </tr>
  <tr>
    <td>curvearrowright</td>
    <td>&amp;#x021B7;</td>
    <td>&#x021B7;</td>
    <td>alias ISOAMSA curarr</td>
  </tr>
  <tr>
    <td>dbkarow</td>
    <td>&amp;#x0290F;</td>
    <td>&#x0290F;</td>
    <td>alias ISOAMSA rBarr</td>
  </tr>
  <tr>
    <td>ddagger</td>
    <td>&amp;#x02021;</td>
    <td>&#x02021;</td>
    <td>alias ISOPUB Dagger</td>
  </tr>
  <tr>
    <td>ddotseq</td>
    <td>&amp;#x02A77;</td>
    <td>&#x02A77;</td>
    <td>alias ISOAMSR eDDot</td>
  </tr>
  <tr>
    <td>Del</td>
    <td>&amp;#x02207;</td>
    <td>&#x02207;</td>
    <td>alias ISOTECH nabla</td>
  </tr>
  <tr>
    <td>DiacriticalAcute</td>
    <td>&amp;#x000B4;</td>
    <td>&#x000B4;</td>
    <td>alias ISODIA acute</td>
  </tr>
  <tr>
    <td>DiacriticalDot</td>
    <td>&amp;#x002D9;</td>
    <td>&#x002D9;</td>
    <td>alias ISODIA dot</td>
  </tr>
  <tr>
    <td>DiacriticalDoubleAcute</td>
    <td>&amp;#x002DD;</td>
    <td>&#x002DD;</td>
    <td>alias ISODIA dblac</td>
  </tr>
  <tr>
    <td>DiacriticalGrave</td>
    <td>&amp;#x00060;</td>
    <td>&#x00060;</td>
    <td>alias ISODIA grave</td>
  </tr>
  <tr>
    <td>DiacriticalTilde</td>
    <td>&amp;#x002DC;</td>
    <td>&#x002DC;</td>
    <td>alias ISODIA tilde</td>
  </tr>
  <tr>
    <td>Diamond</td>
    <td>&amp;#x022C4;</td>
    <td>&#x022C4;</td>
    <td>alias ISOAMSB diam</td>
  </tr>
  <tr>
    <td>diamond</td>
    <td>&amp;#x022C4;</td>
    <td>&#x022C4;</td>
    <td>alias ISOAMSB diam</td>
  </tr>
  <tr>
    <td>diamondsuit</td>
    <td>&amp;#x02666;</td>
    <td>&#x02666;</td>
    <td>ISOPUB    diams</td>
  </tr>
  <tr>
    <td>DifferentialD</td>
    <td>&amp;#x02146;</td>
    <td>&#x02146;</td>
    <td>d for use in differentials, e.g., within integrals</td>
  </tr>
  <tr>
    <td>digamma</td>
    <td>&amp;#x003DD;</td>
    <td>&#x003DD;</td>
    <td>alias ISOGRK3 gammad</td>
  </tr>
  <tr>
    <td>div</td>
    <td>&amp;#x000F7;</td>
    <td>&#x000F7;</td>
    <td>alias ISONUM divide</td>
  </tr>
  <tr>
    <td>divideontimes</td>
    <td>&amp;#x022C7;</td>
    <td>&#x022C7;</td>
    <td>alias ISOAMSB divonx</td>
  </tr>
  <tr>
    <td>doteq</td>
    <td>&amp;#x02250;</td>
    <td>&#x02250;</td>
    <td>alias ISOAMSR esdot</td>
  </tr>
  <tr>
    <td>doteqdot</td>
    <td>&amp;#x02251;</td>
    <td>&#x02251;</td>
    <td>alias ISOAMSR eDot</td>
  </tr>
  <tr>
    <td>DotEqual</td>
    <td>&amp;#x02250;</td>
    <td>&#x02250;</td>
    <td>alias ISOAMSR esdot</td>
  </tr>
  <tr>
    <td>dotminus</td>
    <td>&amp;#x02238;</td>
    <td>&#x02238;</td>
    <td>alias ISOAMSB minusd</td>
  </tr>
  <tr>
    <td>dotplus</td>
    <td>&amp;#x02214;</td>
    <td>&#x02214;</td>
    <td>alias ISOAMSB plusdo</td>
  </tr>
  <tr>
    <td>dotsquare</td>
    <td>&amp;#x022A1;</td>
    <td>&#x022A1;</td>
    <td>alias ISOAMSB sdotb</td>
  </tr>
  <tr>
    <td>doublebarwedge</td>
    <td>&amp;#x02306;</td>
    <td>&#x02306;</td>
    <td>alias ISOAMSB Barwed</td>
  </tr>
  <tr>
    <td>DoubleContourIntegral</td>
    <td>&amp;#x0222F;</td>
    <td>&#x0222F;</td>
    <td>alias ISOTECH Conint</td>
  </tr>
  <tr>
    <td>DoubleDot</td>
    <td>&amp;#x000A8;</td>
    <td>&#x000A8;</td>
    <td>alias ISODIA die</td>
  </tr>
  <tr>
    <td>DoubleDownArrow</td>
    <td>&amp;#x021D3;</td>
    <td>&#x021D3;</td>
    <td>alias ISOAMSA dArr</td>
  </tr>
  <tr>
    <td>DoubleLeftArrow</td>
    <td>&amp;#x021D0;</td>
    <td>&#x021D0;</td>
    <td>alias ISOTECH lArr</td>
  </tr>
  <tr>
    <td>DoubleLeftRightArrow</td>
    <td>&amp;#x021D4;</td>
    <td>&#x021D4;</td>
    <td>alias ISOAMSA hArr</td>
  </tr>
  <tr>
    <td>DoubleLeftTee</td>
    <td>&amp;#x02AE4;</td>
    <td>&#x02AE4;</td>
    <td>alias for  &amp;Dashv;</td>
  </tr>
  <tr>
    <td>DoubleLongLeftArrow</td>
    <td>&amp;#x027F8;</td>
    <td>&#x027F8;</td>
    <td>alias ISOAMSA xlArr</td>
  </tr>
  <tr>
    <td>DoubleLongLeftRightArrow</td>
    <td>&amp;#x027FA;</td>
    <td>&#x027FA;</td>
    <td>alias ISOAMSA xhArr</td>
  </tr>
  <tr>
    <td>DoubleLongRightArrow</td>
    <td>&amp;#x027F9;</td>
    <td>&#x027F9;</td>
    <td>alias ISOAMSA xrArr</td>
  </tr>
  <tr>
    <td>DoubleRightArrow</td>
    <td>&amp;#x021D2;</td>
    <td>&#x021D2;</td>
    <td>alias ISOTECH rArr</td>
  </tr>
  <tr>
    <td>DoubleRightTee</td>
    <td>&amp;#x022A8;</td>
    <td>&#x022A8;</td>
    <td>alias ISOAMSR vDash</td>
  </tr>
  <tr>
    <td>DoubleUpArrow</td>
    <td>&amp;#x021D1;</td>
    <td>&#x021D1;</td>
    <td>alias ISOAMSA uArr</td>
  </tr>
  <tr>
    <td>DoubleUpDownArrow</td>
    <td>&amp;#x021D5;</td>
    <td>&#x021D5;</td>
    <td>alias ISOAMSA vArr</td>
  </tr>
  <tr>
    <td>DoubleVerticalBar</td>
    <td>&amp;#x02225;</td>
    <td>&#x02225;</td>
    <td>alias ISOTECH par</td>
  </tr>
  <tr>
    <td>DownArrow</td>
    <td>&amp;#x02193;</td>
    <td>&#x02193;</td>
    <td>alias ISONUM darr</td>
  </tr>
  <tr>
    <td>Downarrow</td>
    <td>&amp;#x021D3;</td>
    <td>&#x021D3;</td>
    <td>alias ISOAMSA dArr</td>
  </tr>
  <tr>
    <td>downarrow</td>
    <td>&amp;#x02193;</td>
    <td>&#x02193;</td>
    <td>alias ISONUM darr</td>
  </tr>
  <tr>
    <td>DownArrowUpArrow</td>
    <td>&amp;#x021F5;</td>
    <td>&#x021F5;</td>
    <td>alias ISOAMSA duarr</td>
  </tr>
  <tr>
    <td>downdownarrows</td>
    <td>&amp;#x021CA;</td>
    <td>&#x021CA;</td>
    <td>alias ISOAMSA ddarr</td>
  </tr>
  <tr>
    <td>downharpoonleft</td>
    <td>&amp;#x021C3;</td>
    <td>&#x021C3;</td>
    <td>alias ISOAMSA dharl</td>
  </tr>
  <tr>
    <td>downharpoonright</td>
    <td>&amp;#x021C2;</td>
    <td>&#x021C2;</td>
    <td>alias ISOAMSA dharr</td>
  </tr>
  <tr>
    <td>DownLeftVector</td>
    <td>&amp;#x021BD;</td>
    <td>&#x021BD;</td>
    <td>alias ISOAMSA lhard</td>
  </tr>
  <tr>
    <td>DownRightVector</td>
    <td>&amp;#x021C1;</td>
    <td>&#x021C1;</td>
    <td>alias ISOAMSA rhard</td>
  </tr>
  <tr>
    <td>DownTee</td>
    <td>&amp;#x022A4;</td>
    <td>&#x022A4;</td>
    <td>alias ISOTECH top</td>
  </tr>
  <tr>
    <td>DownTeeArrow</td>
    <td>&amp;#x021A7;</td>
    <td>&#x021A7;</td>
    <td>alias for mapstodown</td>
  </tr>
  <tr>
    <td>drbkarow</td>
    <td>&amp;#x02910;</td>
    <td>&#x02910;</td>
    <td>alias ISOAMSA RBarr</td>
  </tr>
  <tr>
    <td>Element</td>
    <td>&amp;#x02208;</td>
    <td>&#x02208;</td>
    <td>alias ISOTECH isinv</td>
  </tr>
  <tr>
    <td>emptyset</td>
    <td>&amp;#x02205;</td>
    <td>&#x02205;</td>
    <td>alias ISOAMSO empty</td>
  </tr>
  <tr>
    <td>eqcirc</td>
    <td>&amp;#x02256;</td>
    <td>&#x02256;</td>
    <td>alias ISOAMSR ecir</td>
  </tr>
  <tr>
    <td>eqcolon</td>
    <td>&amp;#x02255;</td>
    <td>&#x02255;</td>
    <td>alias ISOAMSR ecolon</td>
  </tr>
  <tr>
    <td>eqsim</td>
    <td>&amp;#x02242;</td>
    <td>&#x02242;</td>
    <td>alias ISOAMSR esim</td>
  </tr>
  <tr>
    <td>eqslantgtr</td>
    <td>&amp;#x02A96;</td>
    <td>&#x02A96;</td>
    <td>alias ISOAMSR egs</td>
  </tr>
  <tr>
    <td>eqslantless</td>
    <td>&amp;#x02A95;</td>
    <td>&#x02A95;</td>
    <td>alias ISOAMSR els</td>
  </tr>
  <tr>
    <td>EqualTilde</td>
    <td>&amp;#x02242;</td>
    <td>&#x02242;</td>
    <td>alias ISOAMSR esim</td>
  </tr>
  <tr>
    <td>Equilibrium</td>
    <td>&amp;#x021CC;</td>
    <td>&#x021CC;</td>
    <td>alias ISOAMSA rlhar</td>
  </tr>
  <tr>
    <td>Exists</td>
    <td>&amp;#x02203;</td>
    <td>&#x02203;</td>
    <td>alias ISOTECH exist</td>
  </tr>
  <tr>
    <td>expectation</td>
    <td>&amp;#x02130;</td>
    <td>&#x02130;</td>
    <td>expectation (operator)</td>
  </tr>
  <tr>
    <td>ExponentialE</td>
    <td>&amp;#x02147;</td>
    <td>&#x02147;</td>
    <td>e use for the exponential base of the natural logarithms</td>
  </tr>
  <tr>
    <td>exponentiale</td>
    <td>&amp;#x02147;</td>
    <td>&#x02147;</td>
    <td>base of the Napierian logarithms</td>
  </tr>
  <tr>
    <td>fallingdotseq</td>
    <td>&amp;#x02252;</td>
    <td>&#x02252;</td>
    <td>alias ISOAMSR efDot</td>
  </tr>
  <tr>
    <td>ForAll</td>
    <td>&amp;#x02200;</td>
    <td>&#x02200;</td>
    <td>alias ISOTECH forall</td>
  </tr>
  <tr>
    <td>Fouriertrf</td>
    <td>&amp;#x02131;</td>
    <td>&#x02131;</td>
    <td>Fourier transform</td>
  </tr>
  <tr>
    <td>geq</td>
    <td>&amp;#x02265;</td>
    <td>&#x02265;</td>
    <td>alias ISOTECH ge</td>
  </tr>
  <tr>
    <td>geqq</td>
    <td>&amp;#x02267;</td>
    <td>&#x02267;</td>
    <td>alias ISOAMSR gE</td>
  </tr>
  <tr>
    <td>geqslant</td>
    <td>&amp;#x02A7E;</td>
    <td>&#x02A7E;</td>
    <td>alias ISOAMSR ges</td>
  </tr>
  <tr>
    <td>gg</td>
    <td>&amp;#x0226B;</td>
    <td>&#x0226B;</td>
    <td>alias ISOAMSR Gt</td>
  </tr>
  <tr>
    <td>ggg</td>
    <td>&amp;#x022D9;</td>
    <td>&#x022D9;</td>
    <td>alias ISOAMSR Gg</td>
  </tr>
  <tr>
    <td>gnapprox</td>
    <td>&amp;#x02A8A;</td>
    <td>&#x02A8A;</td>
    <td>alias ISOAMSN gnap</td>
  </tr>
  <tr>
    <td>gneq</td>
    <td>&amp;#x02A88;</td>
    <td>&#x02A88;</td>
    <td>alias ISOAMSN gne</td>
  </tr>
  <tr>
    <td>gneqq</td>
    <td>&amp;#x02269;</td>
    <td>&#x02269;</td>
    <td>alias ISOAMSN gnE</td>
  </tr>
  <tr>
    <td>GreaterEqual</td>
    <td>&amp;#x02265;</td>
    <td>&#x02265;</td>
    <td>alias ISOTECH ge</td>
  </tr>
  <tr>
    <td>GreaterEqualLess</td>
    <td>&amp;#x022DB;</td>
    <td>&#x022DB;</td>
    <td>alias ISOAMSR gel</td>
  </tr>
  <tr>
    <td>GreaterFullEqual</td>
    <td>&amp;#x02267;</td>
    <td>&#x02267;</td>
    <td>alias ISOAMSR gE</td>
  </tr>
  <tr>
    <td>GreaterLess</td>
    <td>&amp;#x02277;</td>
    <td>&#x02277;</td>
    <td>alias ISOAMSR gl</td>
  </tr>
  <tr>
    <td>GreaterSlantEqual</td>
    <td>&amp;#x02A7E;</td>
    <td>&#x02A7E;</td>
    <td>alias ISOAMSR ges</td>
  </tr>
  <tr>
    <td>GreaterTilde</td>
    <td>&amp;#x02273;</td>
    <td>&#x02273;</td>
    <td>alias ISOAMSR gsim</td>
  </tr>
  <tr>
    <td>gtrapprox</td>
    <td>&amp;#x02A86;</td>
    <td>&#x02A86;</td>
    <td>alias ISOAMSR gap</td>
  </tr>
  <tr>
    <td>gtrdot</td>
    <td>&amp;#x022D7;</td>
    <td>&#x022D7;</td>
    <td>alias ISOAMSR gtdot</td>
  </tr>
  <tr>
    <td>gtreqless</td>
    <td>&amp;#x022DB;</td>
    <td>&#x022DB;</td>
    <td>alias ISOAMSR gel</td>
  </tr>
  <tr>
    <td>gtreqqless</td>
    <td>&amp;#x02A8C;</td>
    <td>&#x02A8C;</td>
    <td>alias ISOAMSR gEl</td>
  </tr>
  <tr>
    <td>gtrless</td>
    <td>&amp;#x02277;</td>
    <td>&#x02277;</td>
    <td>alias ISOAMSR gl</td>
  </tr>
  <tr>
    <td>gtrsim</td>
    <td>&amp;#x02273;</td>
    <td>&#x02273;</td>
    <td>alias ISOAMSR gsim</td>
  </tr>
  <tr>
    <td>gvertneqq</td>
    <td>&amp;#x02269;&amp;#x0FE00;</td>
    <td>&#x02269;&#x0FE00;</td>
    <td>alias ISOAMSN gvnE</td>
  </tr>
  <tr>
    <td>Hacek</td>
    <td>&amp;#x002C7;</td>
    <td>&#x002C7;</td>
    <td>alias ISODIA caron</td>
  </tr>
  <tr>
    <td>hbar</td>
    <td>&amp;#x0210F;</td>
    <td>&#x0210F;</td>
    <td>alias ISOAMSO plank</td>
  </tr>
  <tr>
    <td>heartsuit</td>
    <td>&amp;#x02665;</td>
    <td>&#x02665;</td>
    <td>ISOPUB hearts</td>
  </tr>
  <tr>
    <td>HilbertSpace</td>
    <td>&amp;#x0210B;</td>
    <td>&#x0210B;</td>
    <td>Hilbert space</td>
  </tr>
  <tr>
    <td>hksearow</td>
    <td>&amp;#x02925;</td>
    <td>&#x02925;</td>
    <td>alias ISOAMSA searhk</td>
  </tr>
  <tr>
    <td>hkswarow</td>
    <td>&amp;#x02926;</td>
    <td>&#x02926;</td>
    <td>alias ISOAMSA swarhk</td>
  </tr>
  <tr>
    <td>hookleftarrow</td>
    <td>&amp;#x021A9;</td>
    <td>&#x021A9;</td>
    <td>alias ISOAMSA larrhk</td>
  </tr>
  <tr>
    <td>hookrightarrow</td>
    <td>&amp;#x021AA;</td>
    <td>&#x021AA;</td>
    <td>alias ISOAMSA rarrhk</td>
  </tr>
  <tr>
    <td>hslash</td>
    <td>&amp;#x0210F;</td>
    <td>&#x0210F;</td>
    <td>alias ISOAMSO plankv</td>
  </tr>
  <tr>
    <td>HumpDownHump</td>
    <td>&amp;#x0224E;</td>
    <td>&#x0224E;</td>
    <td>alias ISOAMSR bump</td>
  </tr>
  <tr>
    <td>HumpEqual</td>
    <td>&amp;#x0224F;</td>
    <td>&#x0224F;</td>
    <td>alias ISOAMSR bumpe</td>
  </tr>
  <tr>
    <td>iiiint</td>
    <td>&amp;#x02A0C;</td>
    <td>&#x02A0C;</td>
    <td>alias ISOTECH qint</td>
  </tr>
  <tr>
    <td>iiint</td>
    <td>&amp;#x0222D;</td>
    <td>&#x0222D;</td>
    <td>alias ISOTECH tint</td>
  </tr>
  <tr>
    <td>Im</td>
    <td>&amp;#x02111;</td>
    <td>&#x02111;</td>
    <td>alias ISOAMSO image</td>
  </tr>
  <tr>
    <td>ImaginaryI</td>
    <td>&amp;#x02148;</td>
    <td>&#x02148;</td>
    <td>i for use as a square root of -1</td>
  </tr>
  <tr>
    <td>imagline</td>
    <td>&amp;#x02110;</td>
    <td>&#x02110;</td>
    <td>the geometric imaginary line</td>
  </tr>
  <tr>
    <td>imagpart</td>
    <td>&amp;#x02111;</td>
    <td>&#x02111;</td>
    <td>alias ISOAMSO image</td>
  </tr>
  <tr>
    <td>Implies</td>
    <td>&amp;#x021D2;</td>
    <td>&#x021D2;</td>
    <td>alias ISOTECH rArr</td>
  </tr>
  <tr>
    <td>in</td>
    <td>&amp;#x02208;</td>
    <td>&#x02208;</td>
    <td>ISOTECH   isin</td>
  </tr>
  <tr>
    <td>integers</td>
    <td>&amp;#x02124;</td>
    <td>&#x02124;</td>
    <td>the ring of integers</td>
  </tr>
  <tr>
    <td>Integral</td>
    <td>&amp;#x0222B;</td>
    <td>&#x0222B;</td>
    <td>alias ISOTECH int</td>
  </tr>
  <tr>
    <td>intercal</td>
    <td>&amp;#x022BA;</td>
    <td>&#x022BA;</td>
    <td>alias ISOAMSB intcal</td>
  </tr>
  <tr>
    <td>Intersection</td>
    <td>&amp;#x022C2;</td>
    <td>&#x022C2;</td>
    <td>alias ISOAMSB xcap</td>
  </tr>
  <tr>
    <td>intprod</td>
    <td>&amp;#x02A3C;</td>
    <td>&#x02A3C;</td>
    <td>alias ISOAMSB iprod</td>
  </tr>
  <tr>
    <td>InvisibleComma</td>
    <td>&amp;#x02063;</td>
    <td>&#x02063;</td>
    <td>used as a separator, e.g., in indices</td>
  </tr>
  <tr>
    <td>InvisibleTimes</td>
    <td>&amp;#x02062;</td>
    <td>&#x02062;</td>
    <td>marks multiplication when it is understood without a mark</td>
  </tr>
  <tr>
    <td>langle</td>
    <td>&amp;#x02329;</td>
    <td>&#x02329;</td>
    <td>alias ISOTECH lang</td>
  </tr>
  <tr>
    <td>Laplacetrf</td>
    <td>&amp;#x02112;</td>
    <td>&#x02112;</td>
    <td>Laplace transform</td>
  </tr>
  <tr>
    <td>lbrace</td>
    <td>&amp;#x0007B;</td>
    <td>&#x0007B;</td>
    <td>alias ISONUM lcub</td>
  </tr>
  <tr>
    <td>lbrack</td>
    <td>&amp;#x0005B;</td>
    <td>&#x0005B;</td>
    <td>alias ISONUM lsqb</td>
  </tr>
  <tr>
    <td>LeftAngleBracket</td>
    <td>&amp;#x02329;</td>
    <td>&#x02329;</td>
    <td>alias ISOTECH lang</td>
  </tr>
  <tr>
    <td>LeftArrow</td>
    <td>&amp;#x02190;</td>
    <td>&#x02190;</td>
    <td>alias ISONUM larr</td>
  </tr>
  <tr>
    <td>Leftarrow</td>
    <td>&amp;#x021D0;</td>
    <td>&#x021D0;</td>
    <td>alias ISOTECH lArr</td>
  </tr>
  <tr>
    <td>leftarrow</td>
    <td>&amp;#x02190;</td>
    <td>&#x02190;</td>
    <td>alias ISONUM larr</td>
  </tr>
  <tr>
    <td>LeftArrowBar</td>
    <td>&amp;#x021E4;</td>
    <td>&#x021E4;</td>
    <td>alias for larrb</td>
  </tr>
  <tr>
    <td>LeftArrowRightArrow</td>
    <td>&amp;#x021C6;</td>
    <td>&#x021C6;</td>
    <td>alias ISOAMSA lrarr</td>
  </tr>
  <tr>
    <td>leftarrowtail</td>
    <td>&amp;#x021A2;</td>
    <td>&#x021A2;</td>
    <td>alias ISOAMSA larrtl</td>
  </tr>
  <tr>
    <td>LeftCeiling</td>
    <td>&amp;#x02308;</td>
    <td>&#x02308;</td>
    <td>alias ISOAMSC lceil</td>
  </tr>
  <tr>
    <td>LeftDoubleBracket</td>
    <td>&amp;#x0301A;</td>
    <td>&#x0301A;</td>
    <td>left double bracket delimiter</td>
  </tr>
  <tr>
    <td>LeftDownVector</td>
    <td>&amp;#x021C3;</td>
    <td>&#x021C3;</td>
    <td>alias ISOAMSA dharl</td>
  </tr>
  <tr>
    <td>LeftFloor</td>
    <td>&amp;#x0230A;</td>
    <td>&#x0230A;</td>
    <td>alias ISOAMSC lfloor</td>
  </tr>
  <tr>
    <td>leftharpoondown</td>
    <td>&amp;#x021BD;</td>
    <td>&#x021BD;</td>
    <td>alias ISOAMSA lhard</td>
  </tr>
  <tr>
    <td>leftharpoonup</td>
    <td>&amp;#x021BC;</td>
    <td>&#x021BC;</td>
    <td>alias ISOAMSA lharu</td>
  </tr>
  <tr>
    <td>leftleftarrows</td>
    <td>&amp;#x021C7;</td>
    <td>&#x021C7;</td>
    <td>alias ISOAMSA llarr</td>
  </tr>
  <tr>
    <td>LeftRightArrow</td>
    <td>&amp;#x02194;</td>
    <td>&#x02194;</td>
    <td>alias ISOAMSA harr</td>
  </tr>
  <tr>
    <td>Leftrightarrow</td>
    <td>&amp;#x021D4;</td>
    <td>&#x021D4;</td>
    <td>alias ISOAMSA hArr</td>
  </tr>
  <tr>
    <td>leftrightarrow</td>
    <td>&amp;#x02194;</td>
    <td>&#x02194;</td>
    <td>alias ISOAMSA harr</td>
  </tr>
  <tr>
    <td>leftrightarrows</td>
    <td>&amp;#x021C6;</td>
    <td>&#x021C6;</td>
    <td>alias ISOAMSA lrarr</td>
  </tr>
  <tr>
    <td>leftrightharpoons</td>
    <td>&amp;#x021CB;</td>
    <td>&#x021CB;</td>
    <td>alias ISOAMSA lrhar</td>
  </tr>
  <tr>
    <td>leftrightsquigarrow</td>
    <td>&amp;#x021AD;</td>
    <td>&#x021AD;</td>
    <td>alias ISOAMSA harrw</td>
  </tr>
  <tr>
    <td>LeftTee</td>
    <td>&amp;#x022A3;</td>
    <td>&#x022A3;</td>
    <td>alias ISOAMSR dashv</td>
  </tr>
  <tr>
    <td>LeftTeeArrow</td>
    <td>&amp;#x021A4;</td>
    <td>&#x021A4;</td>
    <td>alias for mapstoleft</td>
  </tr>
  <tr>
    <td>leftthreetimes</td>
    <td>&amp;#x022CB;</td>
    <td>&#x022CB;</td>
    <td>alias ISOAMSB lthree</td>
  </tr>
  <tr>
    <td>LeftTriangle</td>
    <td>&amp;#x022B2;</td>
    <td>&#x022B2;</td>
    <td>alias ISOAMSR vltri</td>
  </tr>
  <tr>
    <td>LeftTriangleEqual</td>
    <td>&amp;#x022B4;</td>
    <td>&#x022B4;</td>
    <td>alias ISOAMSR ltrie</td>
  </tr>
  <tr>
    <td>LeftUpVector</td>
    <td>&amp;#x021BF;</td>
    <td>&#x021BF;</td>
    <td>alias ISOAMSA uharl</td>
  </tr>
  <tr>
    <td>LeftVector</td>
    <td>&amp;#x021BC;</td>
    <td>&#x021BC;</td>
    <td>alias ISOAMSA lharu</td>
  </tr>
  <tr>
    <td>leq</td>
    <td>&amp;#x02264;</td>
    <td>&#x02264;</td>
    <td>alias ISOTECH le</td>
  </tr>
  <tr>
    <td>leqq</td>
    <td>&amp;#x02266;</td>
    <td>&#x02266;</td>
    <td>alias ISOAMSR lE</td>
  </tr>
  <tr>
    <td>leqslant</td>
    <td>&amp;#x02A7D;</td>
    <td>&#x02A7D;</td>
    <td>alias ISOAMSR les</td>
  </tr>
  <tr>
    <td>lessapprox</td>
    <td>&amp;#x02A85;</td>
    <td>&#x02A85;</td>
    <td>alias ISOAMSR lap</td>
  </tr>
  <tr>
    <td>lessdot</td>
    <td>&amp;#x022D6;</td>
    <td>&#x022D6;</td>
    <td>alias ISOAMSR ltdot</td>
  </tr>
  <tr>
    <td>lesseqgtr</td>
    <td>&amp;#x022DA;</td>
    <td>&#x022DA;</td>
    <td>alias ISOAMSR leg</td>
  </tr>
  <tr>
    <td>lesseqqgtr</td>
    <td>&amp;#x02A8B;</td>
    <td>&#x02A8B;</td>
    <td>alias ISOAMSR lEg</td>
  </tr>
  <tr>
    <td>LessEqualGreater</td>
    <td>&amp;#x022DA;</td>
    <td>&#x022DA;</td>
    <td>alias ISOAMSR leg</td>
  </tr>
  <tr>
    <td>LessFullEqual</td>
    <td>&amp;#x02266;</td>
    <td>&#x02266;</td>
    <td>alias ISOAMSR lE</td>
  </tr>
  <tr>
    <td>LessGreater</td>
    <td>&amp;#x02276;</td>
    <td>&#x02276;</td>
    <td>alias ISOAMSR lg</td>
  </tr>
  <tr>
    <td>lessgtr</td>
    <td>&amp;#x02276;</td>
    <td>&#x02276;</td>
    <td>alias ISOAMSR lg</td>
  </tr>
  <tr>
    <td>lesssim</td>
    <td>&amp;#x02272;</td>
    <td>&#x02272;</td>
    <td>alias ISOAMSR lsim</td>
  </tr>
  <tr>
    <td>LessSlantEqual</td>
    <td>&amp;#x02A7D;</td>
    <td>&#x02A7D;</td>
    <td>alias ISOAMSR les</td>
  </tr>
  <tr>
    <td>LessTilde</td>
    <td>&amp;#x02272;</td>
    <td>&#x02272;</td>
    <td>alias ISOAMSR lsim</td>
  </tr>
  <tr>
    <td>ll</td>
    <td>&amp;#x0226A;</td>
    <td>&#x0226A;</td>
    <td>alias ISOAMSR Lt</td>
  </tr>
  <tr>
    <td>llcorner</td>
    <td>&amp;#x0231E;</td>
    <td>&#x0231E;</td>
    <td>alias ISOAMSC dlcorn</td>
  </tr>
  <tr>
    <td>Lleftarrow</td>
    <td>&amp;#x021DA;</td>
    <td>&#x021DA;</td>
    <td>alias ISOAMSA lAarr</td>
  </tr>
  <tr>
    <td>lmoustache</td>
    <td>&amp;#x023B0;</td>
    <td>&#x023B0;</td>
    <td>alias ISOAMSC lmoust</td>
  </tr>
  <tr>
    <td>lnapprox</td>
    <td>&amp;#x02A89;</td>
    <td>&#x02A89;</td>
    <td>alias ISOAMSN lnap</td>
  </tr>
  <tr>
    <td>lneq</td>
    <td>&amp;#x02A87;</td>
    <td>&#x02A87;</td>
    <td>alias ISOAMSN lne</td>
  </tr>
  <tr>
    <td>lneqq</td>
    <td>&amp;#x02268;</td>
    <td>&#x02268;</td>
    <td>alias ISOAMSN lnE</td>
  </tr>
  <tr>
    <td>LongLeftArrow</td>
    <td>&amp;#x027F5;</td>
    <td>&#x027F5;</td>
    <td>alias ISOAMSA xlarr</td>
  </tr>
  <tr>
    <td>Longleftarrow</td>
    <td>&amp;#x027F8;</td>
    <td>&#x027F8;</td>
    <td>alias ISOAMSA xlArr</td>
  </tr>
  <tr>
    <td>longleftarrow</td>
    <td>&amp;#x027F5;</td>
    <td>&#x027F5;</td>
    <td>alias ISOAMSA xlarr</td>
  </tr>
  <tr>
    <td>LongLeftRightArrow</td>
    <td>&amp;#x027F7;</td>
    <td>&#x027F7;</td>
    <td>alias ISOAMSA xharr</td>
  </tr>
  <tr>
    <td>Longleftrightarrow</td>
    <td>&amp;#x027FA;</td>
    <td>&#x027FA;</td>
    <td>alias ISOAMSA xhArr</td>
  </tr>
  <tr>
    <td>longleftrightarrow</td>
    <td>&amp;#x027F7;</td>
    <td>&#x027F7;</td>
    <td>alias ISOAMSA xharr</td>
  </tr>
  <tr>
    <td>longmapsto</td>
    <td>&amp;#x027FC;</td>
    <td>&#x027FC;</td>
    <td>alias ISOAMSA xmap</td>
  </tr>
  <tr>
    <td>LongRightArrow</td>
    <td>&amp;#x027F6;</td>
    <td>&#x027F6;</td>
    <td>alias ISOAMSA xrarr</td>
  </tr>
  <tr>
    <td>Longrightarrow</td>
    <td>&amp;#x027F9;</td>
    <td>&#x027F9;</td>
    <td>alias ISOAMSA xrArr</td>
  </tr>
  <tr>
    <td>longrightarrow</td>
    <td>&amp;#x027F6;</td>
    <td>&#x027F6;</td>
    <td>alias ISOAMSA xrarr</td>
  </tr>
  <tr>
    <td>looparrowleft</td>
    <td>&amp;#x021AB;</td>
    <td>&#x021AB;</td>
    <td>alias ISOAMSA larrlp</td>
  </tr>
  <tr>
    <td>looparrowright</td>
    <td>&amp;#x021AC;</td>
    <td>&#x021AC;</td>
    <td>alias ISOAMSA rarrlp</td>
  </tr>
  <tr>
    <td>LowerLeftArrow</td>
    <td>&amp;#x02199;</td>
    <td>&#x02199;</td>
    <td>alias ISOAMSA swarr</td>
  </tr>
  <tr>
    <td>LowerRightArrow</td>
    <td>&amp;#x02198;</td>
    <td>&#x02198;</td>
    <td>alias ISOAMSA searr</td>
  </tr>
  <tr>
    <td>lozenge</td>
    <td>&amp;#x025CA;</td>
    <td>&#x025CA;</td>
    <td>alias ISOPUB loz</td>
  </tr>
  <tr>
    <td>lrcorner</td>
    <td>&amp;#x0231F;</td>
    <td>&#x0231F;</td>
    <td>alias ISOAMSC drcorn</td>
  </tr>
  <tr>
    <td>Lsh</td>
    <td>&amp;#x021B0;</td>
    <td>&#x021B0;</td>
    <td>alias ISOAMSA lsh</td>
  </tr>
  <tr>
    <td>lvertneqq</td>
    <td>&amp;#x02268;&amp;#x0FE00;</td>
    <td>&#x02268;&#x0FE00;</td>
    <td>alias ISOAMSN lvnE</td>
  </tr>
  <tr>
    <td>maltese</td>
    <td>&amp;#x02720;</td>
    <td>&#x02720;</td>
    <td>alias ISOPUB malt</td>
  </tr>
  <tr>
    <td>mapsto</td>
    <td>&amp;#x021A6;</td>
    <td>&#x021A6;</td>
    <td>alias ISOAMSA map</td>
  </tr>
  <tr>
    <td>measuredangle</td>
    <td>&amp;#x02221;</td>
    <td>&#x02221;</td>
    <td>alias ISOAMSO angmsd</td>
  </tr>
  <tr>
    <td>Mellintrf</td>
    <td>&amp;#x02133;</td>
    <td>&#x02133;</td>
    <td>Mellin transform</td>
  </tr>
  <tr>
    <td>MinusPlus</td>
    <td>&amp;#x02213;</td>
    <td>&#x02213;</td>
    <td>alias ISOTECH mnplus</td>
  </tr>
  <tr>
    <td>mp</td>
    <td>&amp;#x02213;</td>
    <td>&#x02213;</td>
    <td>alias ISOTECH mnplus</td>
  </tr>
  <tr>
    <td>multimap</td>
    <td>&amp;#x022B8;</td>
    <td>&#x022B8;</td>
    <td>alias ISOAMSA mumap</td>
  </tr>
  <tr>
    <td>napprox</td>
    <td>&amp;#x02249;</td>
    <td>&#x02249;</td>
    <td>alias ISOAMSN nap</td>
  </tr>
  <tr>
    <td>natural</td>
    <td>&amp;#x0266E;</td>
    <td>&#x0266E;</td>
    <td>alias ISOPUB natur</td>
  </tr>
  <tr>
    <td>naturals</td>
    <td>&amp;#x02115;</td>
    <td>&#x02115;</td>
    <td>the semi-ring of natural numbers</td>
  </tr>
  <tr>
    <td>nearrow</td>
    <td>&amp;#x02197;</td>
    <td>&#x02197;</td>
    <td>alias ISOAMSA nearr</td>
  </tr>
  <tr>
    <td>NegativeMediumSpace</td>
    <td>&amp;#x0200B;</td>
    <td>&#x0200B;</td>
    <td>space of width -4/18 em</td>
  </tr>
  <tr>
    <td>NegativeThickSpace</td>
    <td>&amp;#x0200B;</td>
    <td>&#x0200B;</td>
    <td>space of width -5/18 em</td>
  </tr>
  <tr>
    <td>NegativeThinSpace</td>
    <td>&amp;#x0200B;</td>
    <td>&#x0200B;</td>
    <td>space of width -3/18 em</td>
  </tr>
  <tr>
    <td>NegativeVeryThinSpace</td>
    <td>&amp;#x0200B;</td>
    <td>&#x0200B;</td>
    <td>space of width -1/18 em</td>
  </tr>
  <tr>
    <td>NestedGreaterGreater</td>
    <td>&amp;#x0226B;</td>
    <td>&#x0226B;</td>
    <td>alias ISOAMSR Gt</td>
  </tr>
  <tr>
    <td>NestedLessLess</td>
    <td>&amp;#x0226A;</td>
    <td>&#x0226A;</td>
    <td>alias ISOAMSR Lt</td>
  </tr>
  <tr>
    <td>nexists</td>
    <td>&amp;#x02204;</td>
    <td>&#x02204;</td>
    <td>alias ISOAMSO nexist</td>
  </tr>
  <tr>
    <td>ngeq</td>
    <td>&amp;#x02271;</td>
    <td>&#x02271;</td>
    <td>alias ISOAMSN nge</td>
  </tr>
  <tr>
    <td>ngeqq</td>
    <td>&amp;#x02267;&amp;#x00338;</td>
    <td>&#x02267;&#x00338;</td>
    <td>alias ISOAMSN ngE</td>
  </tr>
  <tr>
    <td>ngeqslant</td>
    <td>&amp;#x02A7E;&amp;#x00338;</td>
    <td>&#x02A7E;&#x00338;</td>
    <td>alias ISOAMSN nges</td>
  </tr>
  <tr>
    <td>ngtr</td>
    <td>&amp;#x0226F;</td>
    <td>&#x0226F;</td>
    <td>alias ISOAMSN ngt</td>
  </tr>
  <tr>
    <td>nLeftarrow</td>
    <td>&amp;#x021CD;</td>
    <td>&#x021CD;</td>
    <td>alias ISOAMSA nlArr</td>
  </tr>
  <tr>
    <td>nleftarrow</td>
    <td>&amp;#x0219A;</td>
    <td>&#x0219A;</td>
    <td>alias ISOAMSA nlarr</td>
  </tr>
  <tr>
    <td>nLeftrightarrow</td>
    <td>&amp;#x021CE;</td>
    <td>&#x021CE;</td>
    <td>alias ISOAMSA nhArr</td>
  </tr>
  <tr>
    <td>nleftrightarrow</td>
    <td>&amp;#x021AE;</td>
    <td>&#x021AE;</td>
    <td>alias ISOAMSA nharr</td>
  </tr>
  <tr>
    <td>nleq</td>
    <td>&amp;#x02270;</td>
    <td>&#x02270;</td>
    <td>alias ISOAMSN nle</td>
  </tr>
  <tr>
    <td>nleqq</td>
    <td>&amp;#x02266;&amp;#x00338;</td>
    <td>&#x02266;&#x00338;</td>
    <td>alias ISOAMSN nlE</td>
  </tr>
  <tr>
    <td>nleqslant</td>
    <td>&amp;#x02A7D;&amp;#x00338;</td>
    <td>&#x02A7D;&#x00338;</td>
    <td>alias ISOAMSN nles</td>
  </tr>
  <tr>
    <td>nless</td>
    <td>&amp;#x0226E;</td>
    <td>&#x0226E;</td>
    <td>alias ISOAMSN nlt</td>
  </tr>
  <tr>
    <td>NonBreakingSpace</td>
    <td>&amp;#x000A0;</td>
    <td>&#x000A0;</td>
    <td>alias ISONUM nbsp</td>
  </tr>
  <tr>
    <td>NotCongruent</td>
    <td>&amp;#x02262;</td>
    <td>&#x02262;</td>
    <td>alias ISOAMSN nequiv</td>
  </tr>
  <tr>
    <td>NotDoubleVerticalBar</td>
    <td>&amp;#x02226;</td>
    <td>&#x02226;</td>
    <td>alias ISOAMSN npar</td>
  </tr>
  <tr>
    <td>NotElement</td>
    <td>&amp;#x02209;</td>
    <td>&#x02209;</td>
    <td>alias ISOTECH notin</td>
  </tr>
  <tr>
    <td>NotEqual</td>
    <td>&amp;#x02260;</td>
    <td>&#x02260;</td>
    <td>alias ISOTECH ne</td>
  </tr>
  <tr>
    <td>NotEqualTilde</td>
    <td>&amp;#x02242;&amp;#x00338;</td>
    <td>&#x02242;&#x00338;</td>
    <td>alias for  &amp;nesim;</td>
  </tr>
  <tr>
    <td>NotExists</td>
    <td>&amp;#x02204;</td>
    <td>&#x02204;</td>
    <td>alias ISOAMSO nexist</td>
  </tr>
  <tr>
    <td>NotGreater</td>
    <td>&amp;#x0226F;</td>
    <td>&#x0226F;</td>
    <td>alias ISOAMSN ngt</td>
  </tr>
  <tr>
    <td>NotGreaterEqual</td>
    <td>&amp;#x02271;</td>
    <td>&#x02271;</td>
    <td>alias ISOAMSN nge</td>
  </tr>
  <tr>
    <td>NotGreaterFullEqual</td>
    <td>&amp;#x02266;&amp;#x00338;</td>
    <td>&#x02266;&#x00338;</td>
    <td>alias ISOAMSN nlE</td>
  </tr>
  <tr>
    <td>NotGreaterGreater</td>
    <td>&amp;#x0226B;&amp;#x00338;</td>
    <td>&#x0226B;&#x00338;</td>
    <td>alias ISOAMSN nGtv</td>
  </tr>
  <tr>
    <td>NotGreaterLess</td>
    <td>&amp;#x02279;</td>
    <td>&#x02279;</td>
    <td>alias ISOAMSN ntvgl</td>
  </tr>
  <tr>
    <td>NotGreaterSlantEqual</td>
    <td>&amp;#x02A7E;&amp;#x00338;</td>
    <td>&#x02A7E;&#x00338;</td>
    <td>alias ISOAMSN nges</td>
  </tr>
  <tr>
    <td>NotGreaterTilde</td>
    <td>&amp;#x02275;</td>
    <td>&#x02275;</td>
    <td>alias ISOAMSN ngsim</td>
  </tr>
  <tr>
    <td>NotHumpDownHump</td>
    <td>&amp;#x0224E;&amp;#x00338;</td>
    <td>&#x0224E;&#x00338;</td>
    <td>alias for &amp;nbump;</td>
  </tr>
  <tr>
    <td>NotLeftTriangle</td>
    <td>&amp;#x022EA;</td>
    <td>&#x022EA;</td>
    <td>alias ISOAMSN nltri</td>
  </tr>
  <tr>
    <td>NotLeftTriangleEqual</td>
    <td>&amp;#x022EC;</td>
    <td>&#x022EC;</td>
    <td>alias ISOAMSN nltrie</td>
  </tr>
  <tr>
    <td>NotLess</td>
    <td>&amp;#x0226E;</td>
    <td>&#x0226E;</td>
    <td>alias ISOAMSN nlt</td>
  </tr>
  <tr>
    <td>NotLessEqual</td>
    <td>&amp;#x02270;</td>
    <td>&#x02270;</td>
    <td>alias ISOAMSN nle</td>
  </tr>
  <tr>
    <td>NotLessGreater</td>
    <td>&amp;#x02278;</td>
    <td>&#x02278;</td>
    <td>alias ISOAMSN ntvlg</td>
  </tr>
  <tr>
    <td>NotLessLess</td>
    <td>&amp;#x0226A;&amp;#x00338;</td>
    <td>&#x0226A;&#x00338;</td>
    <td>alias ISOAMSN nLtv</td>
  </tr>
  <tr>
    <td>NotLessSlantEqual</td>
    <td>&amp;#x02A7D;&amp;#x00338;</td>
    <td>&#x02A7D;&#x00338;</td>
    <td>alias ISOAMSN nles</td>
  </tr>
  <tr>
    <td>NotLessTilde</td>
    <td>&amp;#x02274;</td>
    <td>&#x02274;</td>
    <td>alias ISOAMSN nlsim</td>
  </tr>
  <tr>
    <td>NotPrecedes</td>
    <td>&amp;#x02280;</td>
    <td>&#x02280;</td>
    <td>alias ISOAMSN npr</td>
  </tr>
  <tr>
    <td>NotPrecedesEqual</td>
    <td>&amp;#x02AAF;&amp;#x00338;</td>
    <td>&#x02AAF;&#x00338;</td>
    <td>alias ISOAMSN npre</td>
  </tr>
  <tr>
    <td>NotPrecedesSlantEqual</td>
    <td>&amp;#x022E0;</td>
    <td>&#x022E0;</td>
    <td>alias ISOAMSN nprcue</td>
  </tr>
  <tr>
    <td>NotReverseElement</td>
    <td>&amp;#x0220C;</td>
    <td>&#x0220C;</td>
    <td>alias ISOTECH notniva</td>
  </tr>
  <tr>
    <td>NotRightTriangle</td>
    <td>&amp;#x022EB;</td>
    <td>&#x022EB;</td>
    <td>alias ISOAMSN nrtri</td>
  </tr>
  <tr>
    <td>NotRightTriangleEqual</td>
    <td>&amp;#x022ED;</td>
    <td>&#x022ED;</td>
    <td>alias ISOAMSN nrtrie</td>
  </tr>
  <tr>
    <td>NotSquareSubsetEqual</td>
    <td>&amp;#x022E2;</td>
    <td>&#x022E2;</td>
    <td>alias ISOAMSN nsqsube</td>
  </tr>
  <tr>
    <td>NotSquareSupersetEqual</td>
    <td>&amp;#x022E3;</td>
    <td>&#x022E3;</td>
    <td>alias ISOAMSN nsqsupe</td>
  </tr>
  <tr>
    <td>NotSubset</td>
    <td>&amp;#x02282;&amp;#x020D2;</td>
    <td>&#x02282;&#x020D2;</td>
    <td>alias ISOAMSN vnsub</td>
  </tr>
  <tr>
    <td>NotSubsetEqual</td>
    <td>&amp;#x02288;</td>
    <td>&#x02288;</td>
    <td>alias ISOAMSN nsube</td>
  </tr>
  <tr>
    <td>NotSucceeds</td>
    <td>&amp;#x02281;</td>
    <td>&#x02281;</td>
    <td>alias ISOAMSN nsc</td>
  </tr>
  <tr>
    <td>NotSucceedsEqual</td>
    <td>&amp;#x02AB0;&amp;#x00338;</td>
    <td>&#x02AB0;&#x00338;</td>
    <td>alias ISOAMSN nsce</td>
  </tr>
  <tr>
    <td>NotSucceedsSlantEqual</td>
    <td>&amp;#x022E1;</td>
    <td>&#x022E1;</td>
    <td>alias ISOAMSN nsccue</td>
  </tr>
  <tr>
    <td>NotSuperset</td>
    <td>&amp;#x02283;&amp;#x020D2;</td>
    <td>&#x02283;&#x020D2;</td>
    <td>alias ISOAMSN vnsup</td>
  </tr>
  <tr>
    <td>NotSupersetEqual</td>
    <td>&amp;#x02289;</td>
    <td>&#x02289;</td>
    <td>alias ISOAMSN nsupe</td>
  </tr>
  <tr>
    <td>NotTilde</td>
    <td>&amp;#x02241;</td>
    <td>&#x02241;</td>
    <td>alias ISOAMSN nsim</td>
  </tr>
  <tr>
    <td>NotTildeEqual</td>
    <td>&amp;#x02244;</td>
    <td>&#x02244;</td>
    <td>alias ISOAMSN nsime</td>
  </tr>
  <tr>
    <td>NotTildeFullEqual</td>
    <td>&amp;#x02247;</td>
    <td>&#x02247;</td>
    <td>alias ISOAMSN ncong</td>
  </tr>
  <tr>
    <td>NotTildeTilde</td>
    <td>&amp;#x02249;</td>
    <td>&#x02249;</td>
    <td>alias ISOAMSN nap</td>
  </tr>
  <tr>
    <td>NotVerticalBar</td>
    <td>&amp;#x02224;</td>
    <td>&#x02224;</td>
    <td>alias ISOAMSN nmid</td>
  </tr>
  <tr>
    <td>nparallel</td>
    <td>&amp;#x02226;</td>
    <td>&#x02226;</td>
    <td>alias ISOAMSN npar</td>
  </tr>
  <tr>
    <td>nprec</td>
    <td>&amp;#x02280;</td>
    <td>&#x02280;</td>
    <td>alias ISOAMSN npr</td>
  </tr>
  <tr>
    <td>npreceq</td>
    <td>&amp;#x02AAF;&amp;#x00338;</td>
    <td>&#x02AAF;&#x00338;</td>
    <td>alias ISOAMSN npre</td>
  </tr>
  <tr>
    <td>nRightarrow</td>
    <td>&amp;#x021CF;</td>
    <td>&#x021CF;</td>
    <td>alias ISOAMSA nrArr</td>
  </tr>
  <tr>
    <td>nrightarrow</td>
    <td>&amp;#x0219B;</td>
    <td>&#x0219B;</td>
    <td>alias ISOAMSA nrarr</td>
  </tr>
  <tr>
    <td>nshortmid</td>
    <td>&amp;#x02224;</td>
    <td>&#x02224;</td>
    <td>alias ISOAMSN nsmid</td>
  </tr>
  <tr>
    <td>nshortparallel</td>
    <td>&amp;#x02226;</td>
    <td>&#x02226;</td>
    <td>alias ISOAMSN nspar</td>
  </tr>
  <tr>
    <td>nsimeq</td>
    <td>&amp;#x02244;</td>
    <td>&#x02244;</td>
    <td>alias ISOAMSN nsime</td>
  </tr>
  <tr>
    <td>nsubset</td>
    <td>&amp;#x02282;&amp;#x020D2;</td>
    <td>&#x02282;&#x020D2;</td>
    <td>alias ISOAMSN vnsub</td>
  </tr>
  <tr>
    <td>nsubseteq</td>
    <td>&amp;#x02288;</td>
    <td>&#x02288;</td>
    <td>alias ISOAMSN nsube</td>
  </tr>
  <tr>
    <td>nsubseteqq</td>
    <td>&amp;#x02AC5;&amp;#x00338;</td>
    <td>&#x02AC5;&#x00338;</td>
    <td>alias ISOAMSN nsubE</td>
  </tr>
  <tr>
    <td>nsucc</td>
    <td>&amp;#x02281;</td>
    <td>&#x02281;</td>
    <td>alias ISOAMSN nsc</td>
  </tr>
  <tr>
    <td>nsucceq</td>
    <td>&amp;#x02AB0;&amp;#x00338;</td>
    <td>&#x02AB0;&#x00338;</td>
    <td>alias ISOAMSN nsce</td>
  </tr>
  <tr>
    <td>nsupset</td>
    <td>&amp;#x02283;&amp;#x020D2;</td>
    <td>&#x02283;&#x020D2;</td>
    <td>alias ISOAMSN vnsup</td>
  </tr>
  <tr>
    <td>nsupseteq</td>
    <td>&amp;#x02289;</td>
    <td>&#x02289;</td>
    <td>alias ISOAMSN nsupe</td>
  </tr>
  <tr>
    <td>nsupseteqq</td>
    <td>&amp;#x02AC6;&amp;#x00338;</td>
    <td>&#x02AC6;&#x00338;</td>
    <td>alias ISOAMSN nsupE</td>
  </tr>
  <tr>
    <td>ntriangleleft</td>
    <td>&amp;#x022EA;</td>
    <td>&#x022EA;</td>
    <td>alias ISOAMSN nltri</td>
  </tr>
  <tr>
    <td>ntrianglelefteq</td>
    <td>&amp;#x022EC;</td>
    <td>&#x022EC;</td>
    <td>alias ISOAMSN nltrie</td>
  </tr>
  <tr>
    <td>ntriangleright</td>
    <td>&amp;#x022EB;</td>
    <td>&#x022EB;</td>
    <td>alias ISOAMSN nrtri</td>
  </tr>
  <tr>
    <td>ntrianglerighteq</td>
    <td>&amp;#x022ED;</td>
    <td>&#x022ED;</td>
    <td>alias ISOAMSN nrtrie</td>
  </tr>
  <tr>
    <td>nwarrow</td>
    <td>&amp;#x02196;</td>
    <td>&#x02196;</td>
    <td>alias ISOAMSA nwarr</td>
  </tr>
  <tr>
    <td>oint</td>
    <td>&amp;#x0222E;</td>
    <td>&#x0222E;</td>
    <td>alias ISOTECH conint</td>
  </tr>
  <tr>
    <td>OpenCurlyDoubleQuote</td>
    <td>&amp;#x0201C;</td>
    <td>&#x0201C;</td>
    <td>alias ISONUM ldquo</td>
  </tr>
  <tr>
    <td>OpenCurlyQuote</td>
    <td>&amp;#x02018;</td>
    <td>&#x02018;</td>
    <td>alias ISONUM lsquo</td>
  </tr>
  <tr>
    <td>orderof</td>
    <td>&amp;#x02134;</td>
    <td>&#x02134;</td>
    <td>alias ISOTECH order</td>
  </tr>
  <tr>
    <td>parallel</td>
    <td>&amp;#x02225;</td>
    <td>&#x02225;</td>
    <td>alias ISOTECH par</td>
  </tr>
  <tr>
    <td>PartialD</td>
    <td>&amp;#x02202;</td>
    <td>&#x02202;</td>
    <td>alias ISOTECH part</td>
  </tr>
  <tr>
    <td>pitchfork</td>
    <td>&amp;#x022D4;</td>
    <td>&#x022D4;</td>
    <td>alias ISOAMSR fork</td>
  </tr>
  <tr>
    <td>PlusMinus</td>
    <td>&amp;#x000B1;</td>
    <td>&#x000B1;</td>
    <td>alias ISONUM plusmn</td>
  </tr>
  <tr>
    <td>pm</td>
    <td>&amp;#x000B1;</td>
    <td>&#x000B1;</td>
    <td>alias ISONUM plusmn</td>
  </tr>
  <tr>
    <td>Poincareplane</td>
    <td>&amp;#x0210C;</td>
    <td>&#x0210C;</td>
    <td>the Poincare upper half-plane</td>
  </tr>
  <tr>
    <td>prec</td>
    <td>&amp;#x0227A;</td>
    <td>&#x0227A;</td>
    <td>alias ISOAMSR pr</td>
  </tr>
  <tr>
    <td>precapprox</td>
    <td>&amp;#x02AB7;</td>
    <td>&#x02AB7;</td>
    <td>alias ISOAMSR prap</td>
  </tr>
  <tr>
    <td>preccurlyeq</td>
    <td>&amp;#x0227C;</td>
    <td>&#x0227C;</td>
    <td>alias ISOAMSR prcue</td>
  </tr>
  <tr>
    <td>Precedes</td>
    <td>&amp;#x0227A;</td>
    <td>&#x0227A;</td>
    <td>alias ISOAMSR pr</td>
  </tr>
  <tr>
    <td>PrecedesEqual</td>
    <td>&amp;#x02AAF;</td>
    <td>&#x02AAF;</td>
    <td>alias ISOAMSR pre</td>
  </tr>
  <tr>
    <td>PrecedesSlantEqual</td>
    <td>&amp;#x0227C;</td>
    <td>&#x0227C;</td>
    <td>alias ISOAMSR prcue</td>
  </tr>
  <tr>
    <td>PrecedesTilde</td>
    <td>&amp;#x0227E;</td>
    <td>&#x0227E;</td>
    <td>alias ISOAMSR prsim</td>
  </tr>
  <tr>
    <td>preceq</td>
    <td>&amp;#x02AAF;</td>
    <td>&#x02AAF;</td>
    <td>alias ISOAMSR pre</td>
  </tr>
  <tr>
    <td>precnapprox</td>
    <td>&amp;#x02AB9;</td>
    <td>&#x02AB9;</td>
    <td>alias ISOAMSN prnap</td>
  </tr>
  <tr>
    <td>precneqq</td>
    <td>&amp;#x02AB5;</td>
    <td>&#x02AB5;</td>
    <td>alias ISOAMSN prnE</td>
  </tr>
  <tr>
    <td>precnsim</td>
    <td>&amp;#x022E8;</td>
    <td>&#x022E8;</td>
    <td>alias ISOAMSN prnsim</td>
  </tr>
  <tr>
    <td>precsim</td>
    <td>&amp;#x0227E;</td>
    <td>&#x0227E;</td>
    <td>alias ISOAMSR prsim</td>
  </tr>
  <tr>
    <td>primes</td>
    <td>&amp;#x02119;</td>
    <td>&#x02119;</td>
    <td>the prime natural numbers</td>
  </tr>
  <tr>
    <td>Proportion</td>
    <td>&amp;#x02237;</td>
    <td>&#x02237;</td>
    <td>alias ISOAMSR Colon</td>
  </tr>
  <tr>
    <td>Proportional</td>
    <td>&amp;#x0221D;</td>
    <td>&#x0221D;</td>
    <td>alias ISOTECH prop</td>
  </tr>
  <tr>
    <td>propto</td>
    <td>&amp;#x0221D;</td>
    <td>&#x0221D;</td>
    <td>alias ISOTECH prop</td>
  </tr>
  <tr>
    <td>quaternions</td>
    <td>&amp;#x0210D;</td>
    <td>&#x0210D;</td>
    <td>the ring (skew field) of quaternions</td>
  </tr>
  <tr>
    <td>questeq</td>
    <td>&amp;#x0225F;</td>
    <td>&#x0225F;</td>
    <td>alias ISOAMSR equest</td>
  </tr>
  <tr>
    <td>rangle</td>
    <td>&amp;#x0232A;</td>
    <td>&#x0232A;</td>
    <td>alias ISOTECH rang</td>
  </tr>
  <tr>
    <td>rationals</td>
    <td>&amp;#x0211A;</td>
    <td>&#x0211A;</td>
    <td>the field of rational numbers</td>
  </tr>
  <tr>
    <td>rbrace</td>
    <td>&amp;#x0007D;</td>
    <td>&#x0007D;</td>
    <td>alias ISONUM rcub</td>
  </tr>
  <tr>
    <td>rbrack</td>
    <td>&amp;#x0005D;</td>
    <td>&#x0005D;</td>
    <td>alias ISONUM rsqb</td>
  </tr>
  <tr>
    <td>Re</td>
    <td>&amp;#x0211C;</td>
    <td>&#x0211C;</td>
    <td>alias ISOAMSO real</td>
  </tr>
  <tr>
    <td>realine</td>
    <td>&amp;#x0211B;</td>
    <td>&#x0211B;</td>
    <td>the geometric real line</td>
  </tr>
  <tr>
    <td>realpart</td>
    <td>&amp;#x0211C;</td>
    <td>&#x0211C;</td>
    <td>alias ISOAMSO real</td>
  </tr>
  <tr>
    <td>reals</td>
    <td>&amp;#x0211D;</td>
    <td>&#x0211D;</td>
    <td>the field of real numbers</td>
  </tr>
  <tr>
    <td>ReverseElement</td>
    <td>&amp;#x0220B;</td>
    <td>&#x0220B;</td>
    <td>alias ISOTECH niv</td>
  </tr>
  <tr>
    <td>ReverseEquilibrium</td>
    <td>&amp;#x021CB;</td>
    <td>&#x021CB;</td>
    <td>alias ISOAMSA lrhar</td>
  </tr>
  <tr>
    <td>ReverseUpEquilibrium</td>
    <td>&amp;#x0296F;</td>
    <td>&#x0296F;</td>
    <td>alias ISOAMSA duhar</td>
  </tr>
  <tr>
    <td>RightAngleBracket</td>
    <td>&amp;#x0232A;</td>
    <td>&#x0232A;</td>
    <td>alias ISOTECH rang</td>
  </tr>
  <tr>
    <td>RightArrow</td>
    <td>&amp;#x02192;</td>
    <td>&#x02192;</td>
    <td>alias ISONUM rarr</td>
  </tr>
  <tr>
    <td>Rightarrow</td>
    <td>&amp;#x021D2;</td>
    <td>&#x021D2;</td>
    <td>alias ISOTECH rArr</td>
  </tr>
  <tr>
    <td>rightarrow</td>
    <td>&amp;#x02192;</td>
    <td>&#x02192;</td>
    <td>alias ISONUM rarr</td>
  </tr>
  <tr>
    <td>RightArrowBar</td>
    <td>&amp;#x021E5;</td>
    <td>&#x021E5;</td>
    <td>alias for rarrb</td>
  </tr>
  <tr>
    <td>RightArrowLeftArrow</td>
    <td>&amp;#x021C4;</td>
    <td>&#x021C4;</td>
    <td>alias ISOAMSA rlarr</td>
  </tr>
  <tr>
    <td>rightarrowtail</td>
    <td>&amp;#x021A3;</td>
    <td>&#x021A3;</td>
    <td>alias ISOAMSA rarrtl</td>
  </tr>
  <tr>
    <td>RightCeiling</td>
    <td>&amp;#x02309;</td>
    <td>&#x02309;</td>
    <td>alias ISOAMSC rceil</td>
  </tr>
  <tr>
    <td>RightDoubleBracket</td>
    <td>&amp;#x0301B;</td>
    <td>&#x0301B;</td>
    <td>right double bracket delimiter</td>
  </tr>
  <tr>
    <td>RightDownVector</td>
    <td>&amp;#x021C2;</td>
    <td>&#x021C2;</td>
    <td>alias ISOAMSA dharr</td>
  </tr>
  <tr>
    <td>RightFloor</td>
    <td>&amp;#x0230B;</td>
    <td>&#x0230B;</td>
    <td>alias ISOAMSC rfloor</td>
  </tr>
  <tr>
    <td>rightharpoondown</td>
    <td>&amp;#x021C1;</td>
    <td>&#x021C1;</td>
    <td>alias ISOAMSA rhard</td>
  </tr>
  <tr>
    <td>rightharpoonup</td>
    <td>&amp;#x021C0;</td>
    <td>&#x021C0;</td>
    <td>alias ISOAMSA rharu</td>
  </tr>
  <tr>
    <td>rightleftarrows</td>
    <td>&amp;#x021C4;</td>
    <td>&#x021C4;</td>
    <td>alias ISOAMSA rlarr</td>
  </tr>
  <tr>
    <td>rightleftharpoons</td>
    <td>&amp;#x021CC;</td>
    <td>&#x021CC;</td>
    <td>alias ISOAMSA rlhar</td>
  </tr>
  <tr>
    <td>rightrightarrows</td>
    <td>&amp;#x021C9;</td>
    <td>&#x021C9;</td>
    <td>alias ISOAMSA rrarr</td>
  </tr>
  <tr>
    <td>rightsquigarrow</td>
    <td>&amp;#x0219D;</td>
    <td>&#x0219D;</td>
    <td>alias ISOAMSA rarrw</td>
  </tr>
  <tr>
    <td>RightTee</td>
    <td>&amp;#x022A2;</td>
    <td>&#x022A2;</td>
    <td>alias ISOAMSR vdash</td>
  </tr>
  <tr>
    <td>RightTeeArrow</td>
    <td>&amp;#x021A6;</td>
    <td>&#x021A6;</td>
    <td>alias ISOAMSA map</td>
  </tr>
  <tr>
    <td>rightthreetimes</td>
    <td>&amp;#x022CC;</td>
    <td>&#x022CC;</td>
    <td>alias ISOAMSB rthree</td>
  </tr>
  <tr>
    <td>RightTriangle</td>
    <td>&amp;#x022B3;</td>
    <td>&#x022B3;</td>
    <td>alias ISOAMSR vrtri</td>
  </tr>
  <tr>
    <td>RightTriangleEqual</td>
    <td>&amp;#x022B5;</td>
    <td>&#x022B5;</td>
    <td>alias ISOAMSR rtrie</td>
  </tr>
  <tr>
    <td>RightUpVector</td>
    <td>&amp;#x021BE;</td>
    <td>&#x021BE;</td>
    <td>alias ISOAMSA uharr</td>
  </tr>
  <tr>
    <td>RightVector</td>
    <td>&amp;#x021C0;</td>
    <td>&#x021C0;</td>
    <td>alias ISOAMSA rharu</td>
  </tr>
  <tr>
    <td>risingdotseq</td>
    <td>&amp;#x02253;</td>
    <td>&#x02253;</td>
    <td>alias ISOAMSR erDot</td>
  </tr>
  <tr>
    <td>rmoustache</td>
    <td>&amp;#x023B1;</td>
    <td>&#x023B1;</td>
    <td>alias ISOAMSC rmoust</td>
  </tr>
  <tr>
    <td>Rrightarrow</td>
    <td>&amp;#x021DB;</td>
    <td>&#x021DB;</td>
    <td>alias ISOAMSA rAarr</td>
  </tr>
  <tr>
    <td>Rsh</td>
    <td>&amp;#x021B1;</td>
    <td>&#x021B1;</td>
    <td>alias ISOAMSA rsh</td>
  </tr>
  <tr>
    <td>searrow</td>
    <td>&amp;#x02198;</td>
    <td>&#x02198;</td>
    <td>alias ISOAMSA searr</td>
  </tr>
  <tr>
    <td>setminus</td>
    <td>&amp;#x02216;</td>
    <td>&#x02216;</td>
    <td>alias ISOAMSB setmn</td>
  </tr>
  <tr>
    <td>ShortDownArrow</td>
    <td>&amp;#x02193;</td>
    <td>&#x02193;</td>
    <td>short down arrow</td>
  </tr>
  <tr>
    <td>ShortLeftArrow</td>
    <td>&amp;#x02190;</td>
    <td>&#x02190;</td>
    <td>alias ISOAMSA slarr</td>
  </tr>
  <tr>
    <td>shortmid</td>
    <td>&amp;#x02223;</td>
    <td>&#x02223;</td>
    <td>alias ISOAMSR smid</td>
  </tr>
  <tr>
    <td>shortparallel</td>
    <td>&amp;#x02225;</td>
    <td>&#x02225;</td>
    <td>alias ISOAMSR spar</td>
  </tr>
  <tr>
    <td>ShortRightArrow</td>
    <td>&amp;#x02192;</td>
    <td>&#x02192;</td>
    <td>alias ISOAMSA srarr</td>
  </tr>
  <tr>
    <td>ShortUpArrow</td>
    <td>&amp;#x02191;</td>
    <td>&#x02191;</td>
    <td>short up arrow</td>
  </tr>
  <tr>
    <td>simeq</td>
    <td>&amp;#x02243;</td>
    <td>&#x02243;</td>
    <td>alias ISOTECH sime</td>
  </tr>
  <tr>
    <td>SmallCircle</td>
    <td>&amp;#x02218;</td>
    <td>&#x02218;</td>
    <td>alias ISOTECH compfn</td>
  </tr>
  <tr>
    <td>smallsetminus</td>
    <td>&amp;#x02216;</td>
    <td>&#x02216;</td>
    <td>alias ISOAMSB ssetmn</td>
  </tr>
  <tr>
    <td>spadesuit</td>
    <td>&amp;#x02660;</td>
    <td>&#x02660;</td>
    <td>ISOPUB    spades</td>
  </tr>
  <tr>
    <td>Sqrt</td>
    <td>&amp;#x0221A;</td>
    <td>&#x0221A;</td>
    <td>alias ISOTECH radic</td>
  </tr>
  <tr>
    <td>sqsubset</td>
    <td>&amp;#x0228F;</td>
    <td>&#x0228F;</td>
    <td>alias ISOAMSR sqsub</td>
  </tr>
  <tr>
    <td>sqsubseteq</td>
    <td>&amp;#x02291;</td>
    <td>&#x02291;</td>
    <td>alias ISOAMSR sqsube</td>
  </tr>
  <tr>
    <td>sqsupset</td>
    <td>&amp;#x02290;</td>
    <td>&#x02290;</td>
    <td>alias ISOAMSR sqsup</td>
  </tr>
  <tr>
    <td>sqsupseteq</td>
    <td>&amp;#x02292;</td>
    <td>&#x02292;</td>
    <td>alias ISOAMSR sqsupe</td>
  </tr>
  <tr>
    <td>Square</td>
    <td>&amp;#x025A1;</td>
    <td>&#x025A1;</td>
    <td>alias for square</td>
  </tr>
  <tr>
    <td>SquareIntersection</td>
    <td>&amp;#x02293;</td>
    <td>&#x02293;</td>
    <td>alias ISOAMSB sqcap</td>
  </tr>
  <tr>
    <td>SquareSubset</td>
    <td>&amp;#x0228F;</td>
    <td>&#x0228F;</td>
    <td>alias ISOAMSR sqsub</td>
  </tr>
  <tr>
    <td>SquareSubsetEqual</td>
    <td>&amp;#x02291;</td>
    <td>&#x02291;</td>
    <td>alias ISOAMSR sqsube</td>
  </tr>
  <tr>
    <td>SquareSuperset</td>
    <td>&amp;#x02290;</td>
    <td>&#x02290;</td>
    <td>alias ISOAMSR sqsup</td>
  </tr>
  <tr>
    <td>SquareSupersetEqual</td>
    <td>&amp;#x02292;</td>
    <td>&#x02292;</td>
    <td>alias ISOAMSR sqsupe</td>
  </tr>
  <tr>
    <td>SquareUnion</td>
    <td>&amp;#x02294;</td>
    <td>&#x02294;</td>
    <td>alias ISOAMSB sqcup</td>
  </tr>
  <tr>
    <td>Star</td>
    <td>&amp;#x022C6;</td>
    <td>&#x022C6;</td>
    <td>alias ISOAMSB sstarf</td>
  </tr>
  <tr>
    <td>straightepsilon</td>
    <td>&amp;#x003F5;</td>
    <td>&#x003F5;</td>
    <td>alias ISOGRK3 epsi</td>
  </tr>
  <tr>
    <td>straightphi</td>
    <td>&amp;#x003D5;</td>
    <td>&#x003D5;</td>
    <td>alias ISOGRK3 phi</td>
  </tr>
  <tr>
    <td>Subset</td>
    <td>&amp;#x022D0;</td>
    <td>&#x022D0;</td>
    <td>alias ISOAMSR Sub</td>
  </tr>
  <tr>
    <td>subset</td>
    <td>&amp;#x02282;</td>
    <td>&#x02282;</td>
    <td>alias ISOTECH sub</td>
  </tr>
  <tr>
    <td>subseteq</td>
    <td>&amp;#x02286;</td>
    <td>&#x02286;</td>
    <td>alias ISOTECH sube</td>
  </tr>
  <tr>
    <td>subseteqq</td>
    <td>&amp;#x02AC5;</td>
    <td>&#x02AC5;</td>
    <td>alias ISOAMSR subE</td>
  </tr>
  <tr>
    <td>SubsetEqual</td>
    <td>&amp;#x02286;</td>
    <td>&#x02286;</td>
    <td>alias ISOTECH sube</td>
  </tr>
  <tr>
    <td>subsetneq</td>
    <td>&amp;#x0228A;</td>
    <td>&#x0228A;</td>
    <td>alias ISOAMSN subne</td>
  </tr>
  <tr>
    <td>subsetneqq</td>
    <td>&amp;#x02ACB;</td>
    <td>&#x02ACB;</td>
    <td>alias ISOAMSN subnE</td>
  </tr>
  <tr>
    <td>succ</td>
    <td>&amp;#x0227B;</td>
    <td>&#x0227B;</td>
    <td>alias ISOAMSR sc</td>
  </tr>
  <tr>
    <td>succapprox</td>
    <td>&amp;#x02AB8;</td>
    <td>&#x02AB8;</td>
    <td>alias ISOAMSR scap</td>
  </tr>
  <tr>
    <td>succcurlyeq</td>
    <td>&amp;#x0227D;</td>
    <td>&#x0227D;</td>
    <td>alias ISOAMSR sccue</td>
  </tr>
  <tr>
    <td>Succeeds</td>
    <td>&amp;#x0227B;</td>
    <td>&#x0227B;</td>
    <td>alias ISOAMSR sc</td>
  </tr>
  <tr>
    <td>SucceedsEqual</td>
    <td>&amp;#x02AB0;</td>
    <td>&#x02AB0;</td>
    <td>alias ISOAMSR sce</td>
  </tr>
  <tr>
    <td>SucceedsSlantEqual</td>
    <td>&amp;#x0227D;</td>
    <td>&#x0227D;</td>
    <td>alias ISOAMSR sccue</td>
  </tr>
  <tr>
    <td>SucceedsTilde</td>
    <td>&amp;#x0227F;</td>
    <td>&#x0227F;</td>
    <td>alias ISOAMSR scsim</td>
  </tr>
  <tr>
    <td>succeq</td>
    <td>&amp;#x02AB0;</td>
    <td>&#x02AB0;</td>
    <td>alias ISOAMSR sce</td>
  </tr>
  <tr>
    <td>succnapprox</td>
    <td>&amp;#x02ABA;</td>
    <td>&#x02ABA;</td>
    <td>alias ISOAMSN scnap</td>
  </tr>
  <tr>
    <td>succneqq</td>
    <td>&amp;#x02AB6;</td>
    <td>&#x02AB6;</td>
    <td>alias ISOAMSN scnE</td>
  </tr>
  <tr>
    <td>succnsim</td>
    <td>&amp;#x022E9;</td>
    <td>&#x022E9;</td>
    <td>alias ISOAMSN scnsim</td>
  </tr>
  <tr>
    <td>succsim</td>
    <td>&amp;#x0227F;</td>
    <td>&#x0227F;</td>
    <td>alias ISOAMSR scsim</td>
  </tr>
  <tr>
    <td>SuchThat</td>
    <td>&amp;#x0220B;</td>
    <td>&#x0220B;</td>
    <td>ISOTECH  ni</td>
  </tr>
  <tr>
    <td>Sum</td>
    <td>&amp;#x02211;</td>
    <td>&#x02211;</td>
    <td>alias ISOAMSB sum</td>
  </tr>
  <tr>
    <td>Superset</td>
    <td>&amp;#x02283;</td>
    <td>&#x02283;</td>
    <td>alias ISOTECH sup</td>
  </tr>
  <tr>
    <td>SupersetEqual</td>
    <td>&amp;#x02287;</td>
    <td>&#x02287;</td>
    <td>alias ISOTECH supe</td>
  </tr>
  <tr>
    <td>Supset</td>
    <td>&amp;#x022D1;</td>
    <td>&#x022D1;</td>
    <td>alias ISOAMSR Sup</td>
  </tr>
  <tr>
    <td>supset</td>
    <td>&amp;#x02283;</td>
    <td>&#x02283;</td>
    <td>alias ISOTECH sup</td>
  </tr>
  <tr>
    <td>supseteq</td>
    <td>&amp;#x02287;</td>
    <td>&#x02287;</td>
    <td>alias ISOTECH supe</td>
  </tr>
  <tr>
    <td>supseteqq</td>
    <td>&amp;#x02AC6;</td>
    <td>&#x02AC6;</td>
    <td>alias ISOAMSR supE</td>
  </tr>
  <tr>
    <td>supsetneq</td>
    <td>&amp;#x0228B;</td>
    <td>&#x0228B;</td>
    <td>alias ISOAMSN supne</td>
  </tr>
  <tr>
    <td>supsetneqq</td>
    <td>&amp;#x02ACC;</td>
    <td>&#x02ACC;</td>
    <td>alias ISOAMSN supnE</td>
  </tr>
  <tr>
    <td>swarrow</td>
    <td>&amp;#x02199;</td>
    <td>&#x02199;</td>
    <td>alias ISOAMSA swarr</td>
  </tr>
  <tr>
    <td>Therefore</td>
    <td>&amp;#x02234;</td>
    <td>&#x02234;</td>
    <td>alias ISOTECH there4</td>
  </tr>
  <tr>
    <td>therefore</td>
    <td>&amp;#x02234;</td>
    <td>&#x02234;</td>
    <td>alias ISOTECH there4</td>
  </tr>
  <tr>
    <td>thickapprox</td>
    <td>&amp;#x02248;</td>
    <td>&#x02248;</td>
    <td>ISOAMSR   thkap</td>
  </tr>
  <tr>
    <td>thicksim</td>
    <td>&amp;#x0223C;</td>
    <td>&#x0223C;</td>
    <td>ISOAMSR   thksim</td>
  </tr>
  <tr>
    <td>ThinSpace</td>
    <td>&amp;#x02009;</td>
    <td>&#x02009;</td>
    <td>space of width 3/18 em alias ISOPUB thinsp</td>
  </tr>
  <tr>
    <td>Tilde</td>
    <td>&amp;#x0223C;</td>
    <td>&#x0223C;</td>
    <td>alias ISOTECH sim</td>
  </tr>
  <tr>
    <td>TildeEqual</td>
    <td>&amp;#x02243;</td>
    <td>&#x02243;</td>
    <td>alias ISOTECH sime</td>
  </tr>
  <tr>
    <td>TildeFullEqual</td>
    <td>&amp;#x02245;</td>
    <td>&#x02245;</td>
    <td>alias ISOTECH cong</td>
  </tr>
  <tr>
    <td>TildeTilde</td>
    <td>&amp;#x02248;</td>
    <td>&#x02248;</td>
    <td>alias ISOTECH ap</td>
  </tr>
  <tr>
    <td>toea</td>
    <td>&amp;#x02928;</td>
    <td>&#x02928;</td>
    <td>alias ISOAMSA nesear</td>
  </tr>
  <tr>
    <td>tosa</td>
    <td>&amp;#x02929;</td>
    <td>&#x02929;</td>
    <td>alias ISOAMSA seswar</td>
  </tr>
  <tr>
    <td>triangle</td>
    <td>&amp;#x025B5;</td>
    <td>&#x025B5;</td>
    <td>alias ISOPUB utri</td>
  </tr>
  <tr>
    <td>triangledown</td>
    <td>&amp;#x025BF;</td>
    <td>&#x025BF;</td>
    <td>alias ISOPUB dtri</td>
  </tr>
  <tr>
    <td>triangleleft</td>
    <td>&amp;#x025C3;</td>
    <td>&#x025C3;</td>
    <td>alias ISOPUB ltri</td>
  </tr>
  <tr>
    <td>trianglelefteq</td>
    <td>&amp;#x022B4;</td>
    <td>&#x022B4;</td>
    <td>alias ISOAMSR ltrie</td>
  </tr>
  <tr>
    <td>triangleq</td>
    <td>&amp;#x0225C;</td>
    <td>&#x0225C;</td>
    <td>alias ISOAMSR trie</td>
  </tr>
  <tr>
    <td>triangleright</td>
    <td>&amp;#x025B9;</td>
    <td>&#x025B9;</td>
    <td>alias ISOPUB rtri</td>
  </tr>
  <tr>
    <td>trianglerighteq</td>
    <td>&amp;#x022B5;</td>
    <td>&#x022B5;</td>
    <td>alias ISOAMSR rtrie</td>
  </tr>
  <tr>
    <td>twoheadleftarrow</td>
    <td>&amp;#x0219E;</td>
    <td>&#x0219E;</td>
    <td>alias ISOAMSA Larr</td>
  </tr>
  <tr>
    <td>twoheadrightarrow</td>
    <td>&amp;#x021A0;</td>
    <td>&#x021A0;</td>
    <td>alias ISOAMSA Rarr</td>
  </tr>
  <tr>
    <td>ulcorner</td>
    <td>&amp;#x0231C;</td>
    <td>&#x0231C;</td>
    <td>alias ISOAMSC ulcorn</td>
  </tr>
  <tr>
    <td>Union</td>
    <td>&amp;#x022C3;</td>
    <td>&#x022C3;</td>
    <td>alias ISOAMSB xcup</td>
  </tr>
  <tr>
    <td>UnionPlus</td>
    <td>&amp;#x0228E;</td>
    <td>&#x0228E;</td>
    <td>alias ISOAMSB uplus</td>
  </tr>
  <tr>
    <td>UpArrow</td>
    <td>&amp;#x02191;</td>
    <td>&#x02191;</td>
    <td>alias ISONUM uarr</td>
  </tr>
  <tr>
    <td>Uparrow</td>
    <td>&amp;#x021D1;</td>
    <td>&#x021D1;</td>
    <td>alias ISOAMSA uArr</td>
  </tr>
  <tr>
    <td>uparrow</td>
    <td>&amp;#x02191;</td>
    <td>&#x02191;</td>
    <td>alias ISONUM uarr</td>
  </tr>
  <tr>
    <td>UpArrowDownArrow</td>
    <td>&amp;#x021C5;</td>
    <td>&#x021C5;</td>
    <td>alias ISOAMSA udarr</td>
  </tr>
  <tr>
    <td>UpDownArrow</td>
    <td>&amp;#x02195;</td>
    <td>&#x02195;</td>
    <td>alias ISOAMSA varr</td>
  </tr>
  <tr>
    <td>Updownarrow</td>
    <td>&amp;#x021D5;</td>
    <td>&#x021D5;</td>
    <td>alias ISOAMSA vArr</td>
  </tr>
  <tr>
    <td>updownarrow</td>
    <td>&amp;#x02195;</td>
    <td>&#x02195;</td>
    <td>alias ISOAMSA varr</td>
  </tr>
  <tr>
    <td>UpEquilibrium</td>
    <td>&amp;#x0296E;</td>
    <td>&#x0296E;</td>
    <td>alias ISOAMSA udhar</td>
  </tr>
  <tr>
    <td>upharpoonleft</td>
    <td>&amp;#x021BF;</td>
    <td>&#x021BF;</td>
    <td>alias ISOAMSA uharl</td>
  </tr>
  <tr>
    <td>upharpoonright</td>
    <td>&amp;#x021BE;</td>
    <td>&#x021BE;</td>
    <td>alias ISOAMSA uharr</td>
  </tr>
  <tr>
    <td>UpperLeftArrow</td>
    <td>&amp;#x02196;</td>
    <td>&#x02196;</td>
    <td>alias ISOAMSA nwarr</td>
  </tr>
  <tr>
    <td>UpperRightArrow</td>
    <td>&amp;#x02197;</td>
    <td>&#x02197;</td>
    <td>alias ISOAMSA nearr</td>
  </tr>
  <tr>
    <td>upsilon</td>
    <td>&amp;#x003C5;</td>
    <td>&#x003C5;</td>
    <td>alias ISOGRK3 upsi</td>
  </tr>
  <tr>
    <td>UpTee</td>
    <td>&amp;#x022A5;</td>
    <td>&#x022A5;</td>
    <td>alias ISOTECH perp</td>
  </tr>
  <tr>
    <td>UpTeeArrow</td>
    <td>&amp;#x021A5;</td>
    <td>&#x021A5;</td>
    <td>Alias mapstoup</td>
  </tr>
  <tr>
    <td>upuparrows</td>
    <td>&amp;#x021C8;</td>
    <td>&#x021C8;</td>
    <td>alias ISOAMSA uuarr</td>
  </tr>
  <tr>
    <td>urcorner</td>
    <td>&amp;#x0231D;</td>
    <td>&#x0231D;</td>
    <td>alias ISOAMSC urcorn</td>
  </tr>
  <tr>
    <td>varepsilon</td>
    <td>&amp;#x003B5;</td>
    <td>&#x003B5;</td>
    <td>alias ISOGRK3 epsiv</td>
  </tr>
  <tr>
    <td>varkappa</td>
    <td>&amp;#x003F0;</td>
    <td>&#x003F0;</td>
    <td>alias ISOGRK3 kappav</td>
  </tr>
  <tr>
    <td>varnothing</td>
    <td>&amp;#x02205;</td>
    <td>&#x02205;</td>
    <td>alias ISOAMSO emptyv</td>
  </tr>
  <tr>
    <td>varphi</td>
    <td>&amp;#x003C6;</td>
    <td>&#x003C6;</td>
    <td>alias ISOGRK3 phiv</td>
  </tr>
  <tr>
    <td>varpi</td>
    <td>&amp;#x003D6;</td>
    <td>&#x003D6;</td>
    <td>alias ISOGRK3 piv</td>
  </tr>
  <tr>
    <td>varpropto</td>
    <td>&amp;#x0221D;</td>
    <td>&#x0221D;</td>
    <td>alias ISOAMSR vprop</td>
  </tr>
  <tr>
    <td>varrho</td>
    <td>&amp;#x003F1;</td>
    <td>&#x003F1;</td>
    <td>alias ISOGRK3 rhov</td>
  </tr>
  <tr>
    <td>varsigma</td>
    <td>&amp;#x003C2;</td>
    <td>&#x003C2;</td>
    <td>alias ISOGRK3 sigmav</td>
  </tr>
  <tr>
    <td>varsubsetneq</td>
    <td>&amp;#x0228A;&amp;#x0FE00;</td>
    <td>&#x0228A;&#x0FE00;</td>
    <td>alias ISOAMSN vsubne</td>
  </tr>
  <tr>
    <td>varsubsetneqq</td>
    <td>&amp;#x02ACB;&amp;#x0FE00;</td>
    <td>&#x02ACB;&#x0FE00;</td>
    <td>alias ISOAMSN vsubnE</td>
  </tr>
  <tr>
    <td>varsupsetneq</td>
    <td>&amp;#x0228B;&amp;#x0FE00;</td>
    <td>&#x0228B;&#x0FE00;</td>
    <td>alias ISOAMSN vsupne</td>
  </tr>
  <tr>
    <td>varsupsetneqq</td>
    <td>&amp;#x02ACC;&amp;#x0FE00;</td>
    <td>&#x02ACC;&#x0FE00;</td>
    <td>alias ISOAMSN vsupnE</td>
  </tr>
  <tr>
    <td>vartheta</td>
    <td>&amp;#x003D1;</td>
    <td>&#x003D1;</td>
    <td>alias ISOGRK3 thetav</td>
  </tr>
  <tr>
    <td>vartriangleleft</td>
    <td>&amp;#x022B2;</td>
    <td>&#x022B2;</td>
    <td>alias ISOAMSR vltri</td>
  </tr>
  <tr>
    <td>vartriangleright</td>
    <td>&amp;#x022B3;</td>
    <td>&#x022B3;</td>
    <td>alias ISOAMSR vrtri</td>
  </tr>
  <tr>
    <td>Vee</td>
    <td>&amp;#x022C1;</td>
    <td>&#x022C1;</td>
    <td>alias ISOAMSB xvee</td>
  </tr>
  <tr>
    <td>vee</td>
    <td>&amp;#x02228;</td>
    <td>&#x02228;</td>
    <td>alias ISOTECH or</td>
  </tr>
  <tr>
    <td>Vert</td>
    <td>&amp;#x02016;</td>
    <td>&#x02016;</td>
    <td>alias ISOTECH Verbar</td>
  </tr>
  <tr>
    <td>vert</td>
    <td>&amp;#x0007C;</td>
    <td>&#x0007C;</td>
    <td>alias ISONUM verbar</td>
  </tr>
  <tr>
    <td>VerticalBar</td>
    <td>&amp;#x02223;</td>
    <td>&#x02223;</td>
    <td>alias ISOAMSR mid</td>
  </tr>
  <tr>
    <td>VerticalTilde</td>
    <td>&amp;#x02240;</td>
    <td>&#x02240;</td>
    <td>alias ISOAMSB wreath</td>
  </tr>
  <tr>
    <td>VeryThinSpace</td>
    <td>&amp;#x0200A;</td>
    <td>&#x0200A;</td>
    <td>space of width 1/18 em alias ISOPUB hairsp</td>
  </tr>
  <tr>
    <td>Wedge</td>
    <td>&amp;#x022C0;</td>
    <td>&#x022C0;</td>
    <td>alias ISOAMSB xwedge</td>
  </tr>
  <tr>
    <td>wedge</td>
    <td>&amp;#x02227;</td>
    <td>&#x02227;</td>
    <td>alias ISOTECH and</td>
  </tr>
  <tr>
    <td>wp</td>
    <td>&amp;#x02118;</td>
    <td>&#x02118;</td>
    <td>alias ISOAMSO weierp</td>
  </tr>
  <tr>
    <td>wr</td>
    <td>&amp;#x02240;</td>
    <td>&#x02240;</td>
    <td>alias ISOAMSB wreath</td>
  </tr>
  <tr>
    <td>zeetrf</td>
    <td>&amp;#x02128;</td>
    <td>&#x02128;</td>
    <td>zee transform</td>
  </tr>
  <tr>
    <td>af</td>
    <td>&amp;#x02061;</td>
    <td>&#x02061;</td>
    <td>character showing function application in presentation tagging</td>
  </tr>
  <tr>
    <td>aopf</td>
    <td>&amp;#x1D552;</td>
    <td>&#x1D552;</td>
    <td></td>
  </tr>
  <tr>
    <td>asympeq</td>
    <td>&amp;#x0224D;</td>
    <td>&#x0224D;</td>
    <td>Old ISOAMSR asymp (for HTML compatibility)</td>
  </tr>
  <tr>
    <td>bopf</td>
    <td>&amp;#x1D553;</td>
    <td>&#x1D553;</td>
    <td></td>
  </tr>
  <tr>
    <td>copf</td>
    <td>&amp;#x1D554;</td>
    <td>&#x1D554;</td>
    <td></td>
  </tr>
  <tr>
    <td>Cross</td>
    <td>&amp;#x02A2F;</td>
    <td>&#x02A2F;</td>
    <td>cross or vector product</td>
  </tr>
  <tr>
    <td>DD</td>
    <td>&amp;#x02145;</td>
    <td>&#x02145;</td>
    <td>D for use in differentials, e.g., within integrals</td>
  </tr>
  <tr>
    <td>dd</td>
    <td>&amp;#x02146;</td>
    <td>&#x02146;</td>
    <td>d for use in differentials, e.g., within integrals</td>
  </tr>
  <tr>
    <td>dopf</td>
    <td>&amp;#x1D555;</td>
    <td>&#x1D555;</td>
    <td></td>
  </tr>
  <tr>
    <td>DownArrowBar</td>
    <td>&amp;#x02913;</td>
    <td>&#x02913;</td>
    <td>down arrow to bar</td>
  </tr>
  <tr>
    <td>DownLeftRightVector</td>
    <td>&amp;#x02950;</td>
    <td>&#x02950;</td>
    <td>left-down-right-down harpoon</td>
  </tr>
  <tr>
    <td>DownLeftTeeVector</td>
    <td>&amp;#x0295E;</td>
    <td>&#x0295E;</td>
    <td>left-down harpoon from bar</td>
  </tr>
  <tr>
    <td>DownLeftVectorBar</td>
    <td>&amp;#x02956;</td>
    <td>&#x02956;</td>
    <td>left-down harpoon to bar</td>
  </tr>
  <tr>
    <td>DownRightTeeVector</td>
    <td>&amp;#x0295F;</td>
    <td>&#x0295F;</td>
    <td>right-down harpoon from bar</td>
  </tr>
  <tr>
    <td>DownRightVectorBar</td>
    <td>&amp;#x02957;</td>
    <td>&#x02957;</td>
    <td>right-down harpoon to bar</td>
  </tr>
  <tr>
    <td>ee</td>
    <td>&amp;#x02147;</td>
    <td>&#x02147;</td>
    <td>e use for the exponential base of the natural logarithms</td>
  </tr>
  <tr>
    <td>EmptySmallSquare</td>
    <td>&amp;#x025FB;</td>
    <td>&#x025FB;</td>
    <td>empty small square</td>
  </tr>
  <tr>
    <td>EmptyVerySmallSquare</td>
    <td>&amp;#x025AB;</td>
    <td>&#x025AB;</td>
    <td>empty small square</td>
  </tr>
  <tr>
    <td>eopf</td>
    <td>&amp;#x1D556;</td>
    <td>&#x1D556;</td>
    <td></td>
  </tr>
  <tr>
    <td>Equal</td>
    <td>&amp;#x02A75;</td>
    <td>&#x02A75;</td>
    <td>two consecutive equal signs</td>
  </tr>
  <tr>
    <td>FilledSmallSquare</td>
    <td>&amp;#x025FC;</td>
    <td>&#x025FC;</td>
    <td>filled small square</td>
  </tr>
  <tr>
    <td>FilledVerySmallSquare</td>
    <td>&amp;#x025AA;</td>
    <td>&#x025AA;</td>
    <td>filled very small square</td>
  </tr>
  <tr>
    <td>fopf</td>
    <td>&amp;#x1D557;</td>
    <td>&#x1D557;</td>
    <td></td>
  </tr>
  <tr>
    <td>gopf</td>
    <td>&amp;#x1D558;</td>
    <td>&#x1D558;</td>
    <td></td>
  </tr>
  <tr>
    <td>GreaterGreater</td>
    <td>&amp;#x02AA2;</td>
    <td>&#x02AA2;</td>
    <td>alias for GT</td>
  </tr>
  <tr>
    <td>Hat</td>
    <td>&amp;#x0005E;</td>
    <td>&#x0005E;</td>
    <td>circumflex accent</td>
  </tr>
  <tr>
    <td>hopf</td>
    <td>&amp;#x1D559;</td>
    <td>&#x1D559;</td>
    <td></td>
  </tr>
  <tr>
    <td>HorizontalLine</td>
    <td>&amp;#x02500;</td>
    <td>&#x02500;</td>
    <td>short horizontal line</td>
  </tr>
  <tr>
    <td>ic</td>
    <td>&amp;#x02063;</td>
    <td>&#x02063;</td>
    <td>short form of  &amp;InvisibleComma;</td>
  </tr>
  <tr>
    <td>ii</td>
    <td>&amp;#x02148;</td>
    <td>&#x02148;</td>
    <td>i for use as a square root of -1</td>
  </tr>
  <tr>
    <td>iopf</td>
    <td>&amp;#x1D55A;</td>
    <td>&#x1D55A;</td>
    <td></td>
  </tr>
  <tr>
    <td>it</td>
    <td>&amp;#x02062;</td>
    <td>&#x02062;</td>
    <td>marks multiplication when it is understood without a mark</td>
  </tr>
  <tr>
    <td>jopf</td>
    <td>&amp;#x1D55B;</td>
    <td>&#x1D55B;</td>
    <td></td>
  </tr>
  <tr>
    <td>kopf</td>
    <td>&amp;#x1D55C;</td>
    <td>&#x1D55C;</td>
    <td></td>
  </tr>
  <tr>
    <td>larrb</td>
    <td>&amp;#x021E4;</td>
    <td>&#x021E4;</td>
    <td>leftwards arrow to bar</td>
  </tr>
  <tr>
    <td>LeftDownTeeVector</td>
    <td>&amp;#x02961;</td>
    <td>&#x02961;</td>
    <td>down-left harpoon from bar</td>
  </tr>
  <tr>
    <td>LeftDownVectorBar</td>
    <td>&amp;#x02959;</td>
    <td>&#x02959;</td>
    <td>down-left harpoon to bar</td>
  </tr>
  <tr>
    <td>LeftRightVector</td>
    <td>&amp;#x0294E;</td>
    <td>&#x0294E;</td>
    <td>left-up-right-up harpoon</td>
  </tr>
  <tr>
    <td>LeftTeeVector</td>
    <td>&amp;#x0295A;</td>
    <td>&#x0295A;</td>
    <td>left-up harpoon from bar</td>
  </tr>
  <tr>
    <td>LeftTriangleBar</td>
    <td>&amp;#x029CF;</td>
    <td>&#x029CF;</td>
    <td>left triangle, vertical bar</td>
  </tr>
  <tr>
    <td>LeftUpDownVector</td>
    <td>&amp;#x02951;</td>
    <td>&#x02951;</td>
    <td>up-left-down-left harpoon</td>
  </tr>
  <tr>
    <td>LeftUpTeeVector</td>
    <td>&amp;#x02960;</td>
    <td>&#x02960;</td>
    <td>up-left harpoon from bar</td>
  </tr>
  <tr>
    <td>LeftUpVectorBar</td>
    <td>&amp;#x02958;</td>
    <td>&#x02958;</td>
    <td>up-left harpoon to bar</td>
  </tr>
  <tr>
    <td>LeftVectorBar</td>
    <td>&amp;#x02952;</td>
    <td>&#x02952;</td>
    <td>left-up harpoon to bar</td>
  </tr>
  <tr>
    <td>LessLess</td>
    <td>&amp;#x02AA1;</td>
    <td>&#x02AA1;</td>
    <td>alias for Lt</td>
  </tr>
  <tr>
    <td>lopf</td>
    <td>&amp;#x1D55D;</td>
    <td>&#x1D55D;</td>
    <td></td>
  </tr>
  <tr>
    <td>mapstodown</td>
    <td>&amp;#x021A7;</td>
    <td>&#x021A7;</td>
    <td>downwards arrow from bar</td>
  </tr>
  <tr>
    <td>mapstoleft</td>
    <td>&amp;#x021A4;</td>
    <td>&#x021A4;</td>
    <td>leftwards arrow from bar</td>
  </tr>
  <tr>
    <td>mapstoup</td>
    <td>&amp;#x021A5;</td>
    <td>&#x021A5;</td>
    <td>upwards arrow from bar</td>
  </tr>
  <tr>
    <td>MediumSpace</td>
    <td>&amp;#x0205F;</td>
    <td>&#x0205F;</td>
    <td>space of width 4/18 em</td>
  </tr>
  <tr>
    <td>mopf</td>
    <td>&amp;#x1D55E;</td>
    <td>&#x1D55E;</td>
    <td></td>
  </tr>
  <tr>
    <td>nbump</td>
    <td>&amp;#x0224E;&amp;#x00338;</td>
    <td>&#x0224E;&#x00338;</td>
    <td>not bumpy equals</td>
  </tr>
  <tr>
    <td>nbumpe</td>
    <td>&amp;#x0224F;&amp;#x00338;</td>
    <td>&#x0224F;&#x00338;</td>
    <td>not bumpy single equals</td>
  </tr>
  <tr>
    <td>nesim</td>
    <td>&amp;#x02242;&amp;#x00338;</td>
    <td>&#x02242;&#x00338;</td>
    <td>not equal or similar</td>
  </tr>
  <tr>
    <td>NewLine</td>
    <td>&amp;#x0000A;</td>
    <td>&#x0000A;</td>
    <td>force a line break; line feed</td>
  </tr>
  <tr>
    <td>NoBreak</td>
    <td>&amp;#x02060;</td>
    <td>&#x02060;</td>
    <td>never break line here</td>
  </tr>
  <tr>
    <td>nopf</td>
    <td>&amp;#x1D55F;</td>
    <td>&#x1D55F;</td>
    <td></td>
  </tr>
  <tr>
    <td>NotCupCap</td>
    <td>&amp;#x0226D;</td>
    <td>&#x0226D;</td>
    <td>alias for &amp;nasymp;</td>
  </tr>
  <tr>
    <td>NotHumpEqual</td>
    <td>&amp;#x0224F;&amp;#x00338;</td>
    <td>&#x0224F;&#x00338;</td>
    <td>alias for &amp;nbumpe;</td>
  </tr>
  <tr>
    <td>NotLeftTriangleBar</td>
    <td>&amp;#x029CF;&amp;#x00338;</td>
    <td>&#x029CF;&#x00338;</td>
    <td>not left triangle, vertical bar</td>
  </tr>
  <tr>
    <td>NotNestedGreaterGreater</td>
    <td>&amp;#x02AA2;&amp;#x00338;</td>
    <td>&#x02AA2;&#x00338;</td>
    <td>not double greater-than sign</td>
  </tr>
  <tr>
    <td>NotNestedLessLess</td>
    <td>&amp;#x02AA1;&amp;#x00338;</td>
    <td>&#x02AA1;&#x00338;</td>
    <td>not double less-than sign</td>
  </tr>
  <tr>
    <td>NotRightTriangleBar</td>
    <td>&amp;#x029D0;&amp;#x00338;</td>
    <td>&#x029D0;&#x00338;</td>
    <td>not vertical bar, right triangle</td>
  </tr>
  <tr>
    <td>NotSquareSubset</td>
    <td>&amp;#x0228F;&amp;#x00338;</td>
    <td>&#x0228F;&#x00338;</td>
    <td>square not subset</td>
  </tr>
  <tr>
    <td>NotSquareSuperset</td>
    <td>&amp;#x02290;&amp;#x00338;</td>
    <td>&#x02290;&#x00338;</td>
    <td>negated set-like partial order operator</td>
  </tr>
  <tr>
    <td>NotSucceedsTilde</td>
    <td>&amp;#x0227F;&amp;#x00338;</td>
    <td>&#x0227F;&#x00338;</td>
    <td>not succeeds or similar</td>
  </tr>
  <tr>
    <td>oopf</td>
    <td>&amp;#x1D560;</td>
    <td>&#x1D560;</td>
    <td></td>
  </tr>
  <tr>
    <td>OverBar</td>
    <td>&amp;#x000AF;</td>
    <td>&#x000AF;</td>
    <td>over bar</td>
  </tr>
  <tr>
    <td>OverBrace</td>
    <td>&amp;#x0FE37;</td>
    <td>&#x0FE37;</td>
    <td>over brace</td>
  </tr>
  <tr>
    <td>OverBracket</td>
    <td>&amp;#x023B4;</td>
    <td>&#x023B4;</td>
    <td>over bracket</td>
  </tr>
  <tr>
    <td>OverParenthesis</td>
    <td>&amp;#x0FE35;</td>
    <td>&#x0FE35;</td>
    <td>over parenthesis</td>
  </tr>
  <tr>
    <td>planckh</td>
    <td>&amp;#x0210E;</td>
    <td>&#x0210E;</td>
    <td>the ring (skew field) of quaternions</td>
  </tr>
  <tr>
    <td>popf</td>
    <td>&amp;#x1D561;</td>
    <td>&#x1D561;</td>
    <td></td>
  </tr>
  <tr>
    <td>Product</td>
    <td>&amp;#x0220F;</td>
    <td>&#x0220F;</td>
    <td>alias for &amp;prod;</td>
  </tr>
  <tr>
    <td>qopf</td>
    <td>&amp;#x1D562;</td>
    <td>&#x1D562;</td>
    <td></td>
  </tr>
  <tr>
    <td>rarrb</td>
    <td>&amp;#x021E5;</td>
    <td>&#x021E5;</td>
    <td>leftwards arrow to bar</td>
  </tr>
  <tr>
    <td>RightDownTeeVector</td>
    <td>&amp;#x0295D;</td>
    <td>&#x0295D;</td>
    <td>down-right harpoon from bar</td>
  </tr>
  <tr>
    <td>RightDownVectorBar</td>
    <td>&amp;#x02955;</td>
    <td>&#x02955;</td>
    <td>down-right harpoon to bar</td>
  </tr>
  <tr>
    <td>RightTeeVector</td>
    <td>&amp;#x0295B;</td>
    <td>&#x0295B;</td>
    <td>right-up harpoon from bar</td>
  </tr>
  <tr>
    <td>RightTriangleBar</td>
    <td>&amp;#x029D0;</td>
    <td>&#x029D0;</td>
    <td>vertical bar, right triangle</td>
  </tr>
  <tr>
    <td>RightUpDownVector</td>
    <td>&amp;#x0294F;</td>
    <td>&#x0294F;</td>
    <td>up-right-down-right harpoon</td>
  </tr>
  <tr>
    <td>RightUpTeeVector</td>
    <td>&amp;#x0295C;</td>
    <td>&#x0295C;</td>
    <td>up-right harpoon from bar</td>
  </tr>
  <tr>
    <td>RightUpVectorBar</td>
    <td>&amp;#x02954;</td>
    <td>&#x02954;</td>
    <td>up-right harpoon to bar</td>
  </tr>
  <tr>
    <td>RightVectorBar</td>
    <td>&amp;#x02953;</td>
    <td>&#x02953;</td>
    <td>up-right harpoon to bar</td>
  </tr>
  <tr>
    <td>ropf</td>
    <td>&amp;#x1D563;</td>
    <td>&#x1D563;</td>
    <td></td>
  </tr>
  <tr>
    <td>RoundImplies</td>
    <td>&amp;#x02970;</td>
    <td>&#x02970;</td>
    <td>round implies</td>
  </tr>
  <tr>
    <td>RuleDelayed</td>
    <td>&amp;#x029F4;</td>
    <td>&#x029F4;</td>
    <td>rule-delayed (colon right arrow)</td>
  </tr>
  <tr>
    <td>sopf</td>
    <td>&amp;#x1D564;</td>
    <td>&#x1D564;</td>
    <td></td>
  </tr>
  <tr>
    <td>Tab</td>
    <td>&amp;#x00009;</td>
    <td>&#x00009;</td>
    <td>tabulator stop; horizontal tabulation</td>
  </tr>
  <tr>
    <td>ThickSpace</td>
    <td>&amp;#x02009;&amp;#x0200A;&amp;#x0200A;</td>
    <td>&#x02009;&#x0200A;&#x0200A;</td>
    <td>space of width 5/18 em</td>
  </tr>
  <tr>
    <td>topf</td>
    <td>&amp;#x1D565;</td>
    <td>&#x1D565;</td>
    <td></td>
  </tr>
  <tr>
    <td>UnderBrace</td>
    <td>&amp;#x0FE38;</td>
    <td>&#x0FE38;</td>
    <td>under brace</td>
  </tr>
  <tr>
    <td>UnderBracket</td>
    <td>&amp;#x023B5;</td>
    <td>&#x023B5;</td>
    <td>under bracket</td>
  </tr>
  <tr>
    <td>UnderParenthesis</td>
    <td>&amp;#x0FE36;</td>
    <td>&#x0FE36;</td>
    <td>under parenthesis</td>
  </tr>
  <tr>
    <td>uopf</td>
    <td>&amp;#x1D566;</td>
    <td>&#x1D566;</td>
    <td></td>
  </tr>
  <tr>
    <td>UpArrowBar</td>
    <td>&amp;#x02912;</td>
    <td>&#x02912;</td>
    <td>up arrow to bar</td>
  </tr>
  <tr>
    <td>Upsilon</td>
    <td>&amp;#x003A5;</td>
    <td>&#x003A5;</td>
    <td>ISOGRK1 Ugr, HTML4 Upsilon</td>
  </tr>
  <tr>
    <td>VerticalLine</td>
    <td>&amp;#x0007C;</td>
    <td>&#x0007C;</td>
    <td>alias ISONUM verbar</td>
  </tr>
  <tr>
    <td>VerticalSeparator</td>
    <td>&amp;#x02758;</td>
    <td>&#x02758;</td>
    <td>vertical separating operator</td>
  </tr>
  <tr>
    <td>vopf</td>
    <td>&amp;#x1D567;</td>
    <td>&#x1D567;</td>
    <td></td>
  </tr>
  <tr>
    <td>wopf</td>
    <td>&amp;#x1D568;</td>
    <td>&#x1D568;</td>
    <td></td>
  </tr>
  <tr>
    <td>xopf</td>
    <td>&amp;#x1D569;</td>
    <td>&#x1D569;</td>
    <td></td>
  </tr>
  <tr>
    <td>yopf</td>
    <td>&amp;#x1D56A;</td>
    <td>&#x1D56A;</td>
    <td></td>
  </tr>
  <tr>
    <td>ZeroWidthSpace</td>
    <td>&amp;#x0200B;</td>
    <td>&#x0200B;</td>
    <td>zero width space</td>
  </tr>
  <tr>
    <td>zopf</td>
    <td>&amp;#x1D56B;</td>
    <td>&#x1D56B;</td>
    <td></td>
  </tr>
</table>
ENTITY_LIST
      
      ABOUT = <<ABOUT
<p>entity reference (example: (('&amp;ENTITY_NAME;')))</p>
<p>
#{LIST}
</p>
ABOUT
    end
  end
end
