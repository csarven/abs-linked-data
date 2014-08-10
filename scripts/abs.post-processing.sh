#!/bin/bash

#
#    Author: Sarven Capadisli <info@csarven.ca>
#    Author URI: http://csarven.ca/#i
#

. ./abs.config.sh


dtstart=$(date +"%Y-%m-%dT%H:%M:%SZ") ;
dtstartd=$(echo "$dtstart" | sed 's/[^0-9]*//g') ;

echo Exporting "$data"abs.metadata.archive."$dtstartd".nt ;
java "$JVM_ARGS" tdb.tdbquery --time --desc="$tdbAssembler" --results=n-triples 'CONSTRUCT { ?s ?p ?o } WHERE { GRAPH <'"$namespace"'graph/void> { ?s ?p ?o } }' > "$data""$agency".metadata.archive."$dtstartd".nt

echo Exporting "$data"abs.prov.archive.nt ;
java "$JVM_ARGS" tdb.tdbquery --time --desc="$tdbAssembler" --results=n-triples 'CONSTRUCT { ?s ?p ?o } WHERE { ?s a <http://www.w3.org/ns/prov#Activity> . ?s ?p ?o . }' > "$data""$agency".prov.archive.nt

