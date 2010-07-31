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

#common set-up for codegen regression suite.

#set path-separator:
unset PS; PS=':' ; _doscnt=`echo $PATH | grep -c ';'` ; [ $_doscnt -ne 0 ] && PS=';' ; unset _doscnt

set -a
REGRESS_CG_ROOT=../bld/cgtstroot
WIKI_CONVERSION_TEMPLATES=$REGRESS_CG_ROOT/wif

#test src templates:
CG_TEMPLATE_PATH="..;$CG_TEMPLATE_PATH"
set +a
