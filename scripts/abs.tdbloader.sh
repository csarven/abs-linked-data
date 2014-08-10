#!/bin/bash

#
#    Author: Sarven Capadisli <info@csarven.ca>
#    Author URI: http://csarven.ca/#i
#

. ./abs.config.sh
#exit;
#echo "Removing $db";
#rm -rf "$db";

##RDF/XML ##ls -1S "$data"*.rdf | grep -vE "(Structure|prov).rdf" | while read i ; do file=$(basename "$i"); dataSetCode=${file%.*}; java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/"$dataSetCode" "$i"; done ;

#ls -1S "$data"import/*.nt | grep -vE "(Structure|abs).nt" | while read i ; do file=$(basename "$i"); dataSetCode=${file%.*}; java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/"$dataSetCode" "$i"; done ;

#"$data"import/*.Structure.nt \
#"$data""$agency".prov.retrieval.rdf \

java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta \
"$data""$agency".exactMatch.bfs.nt \
"$data""$agency".exactMatch.bis.nt \
"$data""$agency".exactMatch.dbpedia.nt \
"$data""$agency".exactMatch.ecb.nt \
"$data""$agency".exactMatch.eurostat.nt \
"$data""$agency".exactMatch.fao.nt \
"$data""$agency".exactMatch.geonames.nt \
"$data""$agency".exactMatch.imf.nt \
"$data""$agency".exactMatch.transparency.nt \
"$data""$agency".exactMatch.uis.nt \
"$data""$agency".exactMatch.worldbank.nt

#"$data""$agency".prov.archive.nt \
#"$data"abs.property.meta.nt \
#"$data"abs.dataset.names.nt \


./abs.tdbstats.sh
#real    4773m42.281s
#user    1420m41.521s
#sys     154m25.293s

