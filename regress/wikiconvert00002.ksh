#!/bin/sh
#wikiconvert00002 - test that the intermediate form is being generated correctly

TESTNAME=wikiconvert00002
echo TESTNAME is $TESTNAME
. ./regress_defs.ksh

cado -u -cgroot $REGRESS_CG_ROOT -DTESTNAME=$TESTNAME $TESTNAME.cg
