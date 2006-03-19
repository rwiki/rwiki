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

=== RWikiサーバの起動

siteディレクトリにRWikiサーバのひな形が置いてあります。
標準的なRWikiサーバはsite/rwiki.rbです。
まず、これを起動して実験してみましょう。
 [ターミナル1]
 $ cd site
 $ ruby -Ke -dv rwiki.rb

=== WEBrickインターフェイスの起動

RWikiはCGIやWEBrick、Mailなどさまざまなインターフェイスから利用できます。
動作の確認をするために、準備が比較的簡単なWEBrickを用いたHTTPサーバを
起動します。

 [ターミナル2]
 $ cd interface
 $ ruby -Ke rw-webrick.rb

Webブラウザからhttp://localhost:1818にアクセスするとデフォルトのページが
表示されると思います。

=== CGIインターフェイスの準備

CGIインターフェイスはinterface/rw-cgi.rbです。
一行目のインタプリタ名と「#SETUP」とある行を適切に設定してください。
あなたのHTTPサーバの設定に従ってCGIを設置して下さい。
rw-cgi.rbを試してみてください。

なお、従来のrw-cgi.rbは新しいRWikiサーバと互換性がありません。
これまでのRWikiからのバージョンアップされる場合にはCGIインターフェイスを
新しく設定し直してください。

=== RWikiサーバの設定

RWikiサーバの設定を変更してみましょう。
いくつかの設定はsite/rw-config.rbを編集して行います。
rw-config.rbで設定できる主な項目を以下に示します。
* フッタの連絡先／連絡先名 - MAILTO / ADDRESS
* CSSのURL - CSS
* データファイルの置き場所 - DB_DIR
* トップページの名称 - TOP_NAME
* サーバが使用するポート - DRB_URI

site/rwiki.rbを変更することでさまざまなカスタマイズが可能です。

=== RWikiサーバの本運用

rubyに-dオプション($DEBUG)をつけずに起動すると、デーモンとして
サーバを起動します。

 $ ruby -Ke rwiki.rb

一通りの動作を確認したあとは、-dオプションを外して起動すると良いでしょう。

