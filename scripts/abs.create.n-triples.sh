#!/bin/bash

#
#    Author: Sarven Capadisli <info@csarven.ca>
#    Author URI: http://csarven.ca/#i
#

. ./abs.config.sh

mkdir -p "$data"import ;
rm "$data"import/*.nt ;

for i in "$data"*Structure.rdf ; do file=$(basename "$i"); DataSetCode=${file%.Structure.*}; rapper -g "$i" > "$data"import/"$DataSetCode".Structure.nt ; done;

find "$data"*Structure.rdf | while read f; do file=$(basename "$f"); DataSetCode=${file%.Structure.*};
    for i in "$data""$DataSetCode"*rdf ; do
        if [[ "$i" != *".Structure.rdf" && "$i" != "abs."* ]]
        then
            rapper -g "$i" >> "$data"import/"$DataSetCode".nt ;
        fi
    done
done
#real    503m27.369s
#user    426m6.887s
#sys     19m57.428s
