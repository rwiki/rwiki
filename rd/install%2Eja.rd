= install

((<RWiki>))をインストールしよう．



== 必要なもの．

* Ruby本体

  ruby-1.8.4が必要です．

* RWiki本体

  * ((<RAA:RWiki>))

* ライブラリ

  * ((<RAA:RDtool>)) (0.6.20)

== あるとより楽しめるもの

* ライブラリ

  * なに?

== RWikiのインストール手順

RWikiは通常、常駐するRWikiサーバとCGIなどの各種インターフェイスの
二つ以上のプロセスで構成されます。
はじめに、RWikiサーバ、各種インターフェイスが利用するRWikiのライブラリを
インストールし、続いてRWikiサーバ、インターフェイスの設定を説明します。

=== RWikiライブラリのインストール

 $ tar xzvf rwiki-2.x.tar.gz
 $ cd rwiki-2.x
 $ sudo ruby install.rb

=== RWikiサーバの設定

 FIXME

(3) rw-config.rbを書き直して設定してください．

     $ cd site
     $ vi rw-config.rb 

(4) rw-cgi.rb を CGI として起動できるようにします．~/public_htmlに置いたり，chmodしたり．

     $ cp interface/rw-cgi.rb ~/public
     $ chmod 755 ~/public/rw-cgi.rb

(5) rw-cgi.rb の SETUP とコメントのある辺りを書き直してください．

(6) ライブラリをインストールしたディレクトリ（例えば/home/nahi/lib/ruby）がrubyのライブラリ検索パスにあることを確認します．

     $ ruby -e 'p $:'

(7) なければ環境変数RUBYLIBに追加しましょう．例えば以下のどれか．

     $ setenv RUBYLIB /home/nahi/lib/ruby
     $ setenv RUBYLIB $RUBYLIB:"/home/nahi/lib/ruby"
     $ export RUBYLIB="/home/nahi/lib/ruby"

(8) rwikiサーバを起動します．

    とりあえずデバッグモードでは次のように

     $ ruby -dv -Ke rwiki.rb

    動きそうな気がする時は

     $ ruby -Ke rwiki.rb

(9) rw-cgi.rbをブラウザで開いてみてください．
