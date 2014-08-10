#!/bin/bash

#
#    Author: Sarven Capadisli <info@csarven.ca>
#    Author URI: http://csarven.ca/#i
#

. ./abs.config.sh

./"$agency".drop.graph.void.sh

echo Importing LODStats into "$namespace"graph/void ;
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/void "$data"import/*stats.ttl;

./"$agency".construct.void.sh

./"$agency".drop.graph.void.sh

echo Inserting "$void" back into "$namespace"graph/void ;
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/void "$void"

