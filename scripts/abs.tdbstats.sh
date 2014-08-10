#!/bin/bash

#
#    Author: Sarven Capadisli <info@csarven.ca>
#    Author URI: http://csarven.ca/#i
#

. ./abs.config.sh

echo "Updating tdbstats";
java "$JVM_ARGS" tdb.tdbstats --loc="$db" --graph=urn:x-arq:UnionGraph > "$db"stats2.opt ;
mv "$db"stats.opt "$db"stats.bak ;
mv "$db"stats2.opt "$db"stats.opt ;

#real    17m48.242s
#user    11m32.840s
#sys     2m5.220s
