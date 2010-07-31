#!/bin/sh
#wikiconvert00004 - comment

TESTNAME=wikiconvert00004
echo TESTNAME is $TESTNAME
. ./regress_defs.ksh

cado -u -cgroot $REGRESS_CG_ROOT -DTESTNAME=$TESTNAME $TESTNAME.cg
