INTRODUCTION
============

This is a little project to convert [VqWiki](http://www.vqwiki.org) source content
to [MediaWiki](http://www.mediawiki.org) content.

The first question to answer, is why would anyone need to do this?

In my case, I took a job where I needed to convert over 700 pages of vqwiki
content to MediaWiki format.

Another use might be for vqwiki developers to create test pages if they decide
to fully support MediaWiki as an alternative content syntax at some point in time.
There are a plethora of wiki syntaxes out there, and some effort has been made to
standardize them, but currently, content authors are punished to some extent by having their
content trapped within a particular arcane wiki syntax.

Another use of this project might be to extend the translator to handle other output
formats, or indeed a different input syntax.  The latter problem is more difficult, but
the former problem is relatively trivial, as you can see from the two short scripts which
convert what I call "wiki intermediate form" (wif) to some other syntax:

- wif2mwiki.cg - convert from wif to MediaWiki syntax
- wif2vq.cg    - convert from wif to vqwiki syntax (especially trivial!)

This is the idea behind many wiki translators, and indeed there is a standard
that has been developed called [Creole](http://www.wikicreole.org) as an attempt
to standardize wiki syntaxes, or at the very least, provide a method that wiki
implementers can use to translate to a standardized intermediate form.

IMPLEMENTATION
==============

This conversion is implemented in a language called "Cado", which I invented in 2003,
and have used and extended over the last several years to solve many interesting
translation and code-generation problems.

Cado allowed me to write the translator as a series of regular expressions.
Some of them are a little complex, but once you get the hang of them, they are
very easy to modify.  So if you have some content that I don't handle, for example,
it should be relatively easy to add.

Cado is currently hosted here:  <http://sourceforge.net/projects/cado>

You will need Cado version 1.81 or later for the translation to succeed.

Cado is an interpreter that is wrapped around Perl.  It is a very simple language
that allows one to write and document translations in a simple declarative form.
Cado can be easily extended by adding Perl operators or external shell commands.
One can also call Perl functions, including Cado operators, from the replacement
section of a substitution operation.  I used this in several places to implement
the pattern (for those familiar with the ex/vi/ed/vim class editors):

    g/somepattern/s/pattern/replacement/

Implementing such a construct in Perl usually involves reading in a file,
and using the grep() function with a substitution pattern.

Here is one way you can do it in Cado:

```perl
#eliminate line-breaks within blocks, and put back quote tokens:
CG_SUBSTITUTE_SPEC2 = s/$UNIVTOK//gs
CG_SUBSTITUTE_SPEC = s/$UNIVTOK2([^$UNIVTOK2]*)$UNIVTOK2/sprintf("{=VQ_JAVA_LQ=}%s{=VQ_JAVA_RQ=}", &s2_op(${DS}1))/egs

#apply the substitution to the input:
%void $INPUT:substitute:assign
```

The trick here is to call the secondary substitution operator (:s2 op, called directly
as a Perl function: &s2_op()) directly from the replacement expression held in
$CG_SUBSTITUTE_SPEC.  This is very similar to the "g//s///" editor pattern mentioned above,
where we first pick out the range of lines we want to operate on with a g// pattern,
and then process a substitution on those lines.  With Cado specifications, we can have
even finer grained control, since we are not limited to line-based operations.

Another thing to be aware of, when reading the substitution expressions, is the
order in which things occur.  In the above expressions, for example, $UNIVTOK and ${DS} are
interpolated by Cado before the resulting substitution expression is passed to Perl.
(This is because I used the "=" operator instead of the ":=" operator, the latter of
which suppresses interpolation.)

HOW TO START:
=============

First, you must get your vqwiki into file-based content.  This may involve writing a bit
of sql.  In my case, I have always used file-based persistence.  You might try a vqwiki
testbed starting with file-based persistence, to avoid the initial problem of extracting
your content from your database.  I.e., fire up a file-base vqwiki and then just
cut/paste a few pages from your original, database-persisted vqwiki instance.

Of course you can also paste content directly into files and save them to disk,
under the topic names you want to translate.

Once you have your content in some files, examine the script "convert.sh",
which converts a list of topics that you provide.  Note the many test topics
I have commented out - you can modify the script to just try a couple of your
topics in a similar fashion, to get a handle on the translation process.

Second, you will need an instance of a wiki that purports to understand MediaWiki syntax,
to observe the rendering of your translated pages.  In my case, I used a lovely little
wiki called [JAMWiki](http://jamwiki.org).  JAMWiki is implemented using java servlet
technology, and so its war bundle can be dropped, for example, into a Tomcat instance,
and be up and running very quickly.  You may be able to use the same container
as your vqwiki instance.

AUTOMATIC POSTING VIA CURL TO JAMWIKI
=====================================

I have enclosed a script "editwiki.cg" which will post your new MediaWiki content directly
to a JAMWiki instance.  I have used [Curl](http://curl.haxx.se/) to do the heavy lifting.

If you do not want to try this right away, then just comment out the line that calls
editwiki.cg in the convert.sh driver.

If you do want to try out automated posting, you will need to provide the url of your
local JAMWiki instance in the variable $TOPIC_BASE_URL in convert.sh.
If you have a troublesome page that is not getting loaded, then try that topic
alone and examine the files in bld/edit/*, to see if you can gets some hints of
what went wrong.  One thing that will go wrong, is the spam filter provided by
JAMWiki will likely interfere with content containing html.  Go to the JAMWiki
configuration page and disable the spam filter (you may want to enable it again
later if your JAMWiki is external facing).

Note that when I run convert.sh on my 700+ pages of content, it takes about 5 minutes
to translate and post all content to JAMWiki, or about 2.3 pages per second
(2.4GHz MacBook Pro).

LINKING.PROPERTIES
==================

If you use the linking.properties feature of vqwiki, note that I will translate
these to MediaWiki format if you supply your linking.properties file to the translator.
The translation will expand the shorthand links to one-line HREFS, which are recognized
later by wif2mwiki.cg, and magically become regular MediaWiki external topic links.

NOT HANDLED
===========

At this time, I am not handling upload artifacts, or image-linked urls.
If you have a large amount of embedded `[<java>]` or `[<html>]` tags,
the content will be preserved but will not be rendered as vqwiki does.
This is an area where vqwiki is ahead of the curve.  Another area is that
vqwiki will render images inline, and so any pictures you are expecting
in your content will have to be uploaded and converted to local references
to achieve the same effect.

Linking property prefixes containing dash ("-") or other non-alphanumeric characters,
are not currently handled properly.

COMMENTS, SUGGESTIONS, PROBLEMS?
================================

If you find a use for this little project, or need help in some way to get it
working, please do not hesitate to contact me via email:  russt (at) releasetools.org.

Russ Tremain
July 2010
