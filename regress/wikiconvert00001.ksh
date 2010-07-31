#!/bin/sh
#wikiconvert00001 - test conversion to wif and back again.

TESTNAME=wikiconvert00001
echo TESTNAME is $TESTNAME
. ./regress_defs.ksh

#clean up from previous run:
rm -rf "$REGRESS_CG_ROOT"

cado -u -cgroot $REGRESS_CG_ROOT -DTESTNAME=$TESTNAME $TESTNAME.cg
