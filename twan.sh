#! /bin/sh
#
# twan.sh
# Copyright (C) 2016 djp <djp@cutter>
#
# Distributed under terms of the MIT license.
#


ID=$*
if [[ "$ID" != [0-9] ]]; then 
    echo "twan command must be followed by a single task ID"
    exit 1
fi
vi ~/tmp/tw-annot-$ID.tmp
task $ID annotate "`cat ~/tmp/tw-annot-$ID.tmp`"
rm ~/tmp/tw-annot-$ID.tmp
exit 0

