#!/bin/bash

#
#    Author: Sarven Capadisli <info@csarven.ca>
#    Author URI: http://csarven.ca/#i
#

. ./abs.config.sh

echo Dropping graph "$namespace"graph/void ;
java "$JVM_ARGS" tdb.tdbupdate --desc="$tdbAssembler" 'DROP GRAPH <'"$namespace"'graph/void>'

