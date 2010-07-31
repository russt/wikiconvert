#!/bin/sh
#
# Copyright (C) 2010 Russ Tremain.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the Artistic License 2.0 or later.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# Artistic License 2.0 for more details.
#
# You should have received a copy of the Artistic License the file
# LICENSE.  If not, see:
#     <http://www.perlfoundation.org/artistic_license_2_0>
#

#
# convert.sh - sample wrapper program to convert vqwiki content to mediawiki format,
# and post it to a jamwiki instance.
#
#INPUT:  read-only access to vqwiki content pages in the directory "vqwiki_pages".
#        If you are using vqwiki with file-based persistence, vqwiki_pages can be
#        a symlink to your content directory.
#
#OUTPUT: various files under "bld" directory:
#        bld/alltopics    a list of all top-level from vqwiki_pages directory.
#        bld/topic_list   alltopics, minus files listed in local/topics.exclude.
#        bld/wif/*        content converted to "wiki intermediate form"
#        bld/mediawiki/*  content converted to mediawiki syntax
#        bld/edit/*       files related to curl interactions with jamwiki.
#        
CG_ROOT_BASE=./bld
rm -rf "$CG_ROOT_BASE"
mkdir -p "$CG_ROOT_BASE"

#generate the topic list from the current wiki, and then subtract off the excluded topics:
\ls -1 vqwiki_pages/*.txt > $CG_ROOT_BASE/alltopics
comm -23 $CG_ROOT_BASE/alltopics local/topics.exclude > $CG_ROOT_BASE/topic_list
TOPIC_LIST=`cat $CG_ROOT_BASE/topic_list`
#TOPIC_LIST=vqwiki_pages/RussScratchPage.txt
#TOPIC_LIST=vqwiki_pages/LeftMenu.txt
#TOPIC_LIST="vqwiki_pages/C+C%2B%2B.txt"
#TOPIC_LIST=vqwiki_pages/MyLeftMenu.txt
#TOPIC_LIST=vqwiki_pages/MojaveRequestTracker.txt
#TOPIC_LIST=vqwiki_pages/OrderStatus.txt
#TOPIC_LIST=vqwiki_pages/AnnotatedProjectXml.txt
#TOPIC_LIST=vqwiki_pages/VideoExplained.txt
TOPIC_LIST=vqwiki_pages/CygwinHowTo.txt

WIFDIR=$CG_ROOT_BASE/wif
MWDIR=$CG_ROOT_BASE/mediawiki
EDITDIR=$CG_ROOT_BASE/edit

#define as appropriate
TOPIC_BASE_URL="http://localhost:4407/jamwiki/en"

for topicfn in $TOPIC_LIST
do
    topic=`basename "$topicfn"`

    echo Converting $topic to intermediate form ...
    cado -u -cgroot $WIFDIR -DTOPIC_INFILE="$topicfn" vq2tok.cg

    echo Converting $topic to mediawiki form ...
    cado -u -cgroot $MWDIR -DTOPIC_INFILE="$WIFDIR/$topic" wif2mwiki.cg

    echo Posting $topic to the JAM wiki ...
    cado -u -cgroot $EDITDIR -DTOPIC_INFILE="$MWDIR/$topic" -DTOPIC_BASE_URL="$TOPIC_BASE_URL" editwiki.cg
done
