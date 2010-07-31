#!/bin/sh
#wikiconvert00003 - test mediawiki conversion.

TESTNAME=wikiconvert00003
echo TESTNAME is $TESTNAME
. ./regress_defs.ksh

cado -u -cgroot $REGRESS_CG_ROOT -DTESTNAME=$TESTNAME $TESTNAME.cg
