= install

((<RWiki>))をインストールしよう．

== 必要なもの．

たくさんあります．

* 環境

  * あるマシンに，デーモン（起きぱなしプロセス）を一人作ります．
    このデーモンにポート番号を1つ割り当てる必要があります．
    このデーモン，結構メモリ食いますのでご注意（現時点ではページ数に比例）．
    root権限は要りませんが，一般プロバイダだと許してもらえないかも．

  * CGIインタフェイスを利用する場合，CGIプログラムが使える環境が必要です．
    さらに，CGIプログラム（が動くマシン）から
    そのデーモンに接続できないといけません．
    別マシンからでもOKだけどファイアウォールとかあると厳しい．

  * メイルインタフェイスを利用する場合，メイル処理プログラム（postfixなど）が
    使える環境が必要です．さらに，メイル処理プログラム（が動くマシン）から
    そのデーモンに接続できないといけません．以下同文．

* Ruby本体

  ruby/1.6系が必要です．

* RWiki本体

  * ((<RAA:RWiki>))

* ライブラリ

  * ((<RAA:druby - distributed ruby>)) (2.0.0)
  * ((<RAA:ERB>)) (2.0.2)
  * ((<RAA:Devel::Logger>)) (1.2.0)
  * ((<RAA:RDtool>)) (0.6.10)
    * ((<RAA:OptionParser>))
    * ((<RAA:Racc>))
    * ((<RAA:strscan>))


=== root権限のひと

その権限を活用してなんでもつっこんでください
（各パッケージのインストーラを利用してください）．


=== そうでないひと

頑張りましょう．

(1) 各種ライブラリを取ってきて展開します．

(2) ~/lib/rubyと~/binディレクトリを（なければ）作ります．

     # 以下，/home/nahiは適宜読み替えてください．
     #   cd ~ && pwd
     # して出てくるディレクトリです．


(3) druby

     $ cp -pr lib/* /home/nahi/lib/ruby

(4) ERB

     $ cp -p lib/* /home/nahi/lib/ruby

(5) Devel::Logger

     $ cp -p lib/* /home/nahi/lib/ruby

(6) Racc

     $ ruby setup.rb config --bin-dir=/home/nahi/bin --rb-dir=/home/nahi/lib/ruby --so-dir=/home/nahi/lib/ruby
     $ ruby setup.rb setup
     $ ruby setup.rb install
     $ ruby setup.rb clean
     $ rm -rf config.save ext/cparse/Makefile

(7) strscan

     $ ruby setup.rb config --bin-dir=/home/nahi/bin --rb-dir=/home/nahi/lib/ruby --so-dir=/home/nahi/lib/ruby
     $ ruby setup.rb setup
     $ ruby setup.rb install
     $ ruby setup.rb clean
     $ rm -f config.save ext/strscanso/Makefile

(8) optparse

     $ cp -p optparse.rb /home/nahi/lib/ruby

(9) rdtool

     $ ruby rdtoolconf.rb

     $ vi Makefile        # Makefileを3個所，以下のように書き換えます．
     BIN_DIR = /home/nahi/bin
     SITE_RUBY = /home/nahi/lib/ruby
     RD_DIR = /home/nahi/lib/ruby/rd

     $ make install install-rmi2html
     $ make clean

こんなにめんどくさいアプリ俺は他に知らん．:)

== RWikiのインストール手順

(1) パッケージを取ってきて展開します．

(2) RWikiのライブラリをインストールします．

    root権限のひと

     $ sudo ruby install.rb

    そうでないひと

     $ cp -pr lib/* /home/nahi/lib/ruby

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
