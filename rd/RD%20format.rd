= RWiki writing format

RWiki's syntax rule is based on
((<Ruby>))'s ((<RD|URL:http://www2.pos.to/~tosh/ruby/rdtool/en/>))
(POD-like documentation format).

For more detail about RD,
see ((<URL:http://www.pragmaticprogrammer.com/ruby/articles/rdtool.html>))
and ((<URL:http://www2.pos.to/~tosh/ruby/rdtool/en/doc/rd-draft.html>)).

== Paragragh

Lines are converted
to
a paragraph
.

Paragraphs are separeted by empty line.

((*Source*)):
  > Lines are converted
  > to
  > a paragraph
  > .
  > 
  > Paragraphs are separeted by empty line.

== Verbatim

Indented lines are converted to verbatim for citation.
  Verbatim
  Verbatim

((*Source*)):
  > Indented lines are converted to verbatim for citation.
  >   Verbatim
  >   Verbatim

== Bullet list

* Lines whose initial character is asterisk are converted to bullet lists.
* An item may be the paragraph
  which has same indented multiple
  lines.
  * List may be
    nested.
    * And nested.
      * And nested.
    * Like this.
  * Like this.
* Like this.

((*Source*)):
  > * Lines whose initial character is asterisk are converted to bullet lists.
  > * An item may be the paragraph
  >   which has same indented multiple
  >   lines.
  >   * List may be
  >     nested.
  >     * And nested.
  >       * And nested.
  >     * Like this.
  >   * Like this.
  > * Like this.

== Ordered list

(1) Lines which starts with (#digit) are
    converted to ordered lists.
(9) Actual digit is ignored.
  * You may use Bullet list in Ordered list.
  * (#digit) style is well known listing style in Japan.

((*Source*)):
  > (1) Lines which starts with (#digit) are
  >     converted to ordered lists.
  > (9) Actual digit is ignored.
  >   * You may use Bullet list in Ordered list.
  >   * (#digit) style is well known listing style in Japan.

== Labeled list

: Lines
   whose initial character is colon are converted to labeled lists.
   Indented paragraph is for description text.
: R
   is for Ruby.
: P
   is for Perl.
: S
   is for Smalltalk.

((*Source*)):
  > : Lines
  >    whose initial character is colon are converted to labeled lists.
  >    Indented paragraph is for description text.
  > : R
  >    is for Ruby.
  > : P
  >    is for Perl.
  > : S
  >    is for Smalltalk.

== Headline

= My headline 1
== My headline 1.1
=== My headline 1.1.1
+ My headline 1.1.1.1
++ My headline 1.1.1.1.1

((*Source*)):
  = My headline 1
  == My headline 1.1
  === My headline 1.1.1
  + My headline 1.1.1.1
  ++ My headline 1.1.1.1.1

== Reference

* Another RWiki page: ((<help>))
* URL: ((<URL:http://www.ruby-lang.org>))
* When you want to use other label than reference for display,
  write such like: ((<This page !|RD format>))

((*Source*)):
  > * Another RWiki page: ((<help>))
  > * URL: ((<URL:http://www.ruby-lang.org>))
  > * When you want to use other label than reference for display,
  >   write such like: ((<This page !|RD format>))

== Inline formatting

You can use several inline format sequence.

:(('((*emphasis*))'))
  blah blah ((*emphasis*)) blah blah 
:(('(('verbatim' ))'))
  blah blah (('verbatim')) blah blah
:(('(({program code}))'))
  blah blah (({program code})) blah blah
:(('((%keyboard input%))'))
  blah blah ((%keyboard input%)) blah blah
:(('((-Footnote-))'))
  blah blah((-Footnote is at the bottom of the page-)) blah blah