= TEST

Press 'src' and view source to see how to write pages.
The writing format is ((<RD format>)).

== Itemize

* item
* item block
  item block
  item block
  * subitem
  * subitem block A
    head part
    * subsubitem block
      subsubitem block
      (1) listing
      (2) listing
    * subsubitem
    subitem block A
    tail part
  * subitem
* item

== Listing

(1) Hello,
(2) World.

1. Super
2. Super++

((%1.%)) must be ((%(1)%)) and ((%2.%)) must be ((%(2)%)).
This is well known listing style in Japan(only?).

== Emphasis

Text text ((*emphasis*)) blah blah.

==  Verbatim

Text text text text.
Text text.
  Indented ((*Verbatim*)) <- Not emphasized because it's in Verbatim block.
And another (('((*Verbatim*))')).

== Other markups

(({program code})) and ((%keyboard input%)).
Text text((-footnote is at the bottom of the page-)).  Text text.

== Headline

= My headline 1
== My headline 1.1
=== My headline 1.1.1
+ My headline 1.1.1.1
++ My headline 1.1.1.1.1

== Reference

* Another RWiki page: ((<help>))
* URL: ((<URL:http://www.ruby-lang.org>))

When you want to use other label than reference for display, write such like:

((<This page !|TEST>))
