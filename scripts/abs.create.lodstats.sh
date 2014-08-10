#!/bin/bash

#
#    Author: Sarven Capadisli <info@csarven.ca>
#    Author URI: http://csarven.ca/#i
#

. $HOME/lodstats-env/bin/activate

. ./abs.config.sh

mkdir -p "$data"import
rm "$data"import/*stats*

echo "Creating LODStats for Datasets"
find "$data"import/*.nt -not -name "*Structure*" -not -name "*abs\.*" -not -name "meta.nt" | while read i ; do lodstats -val "$i" > "$i".stats.ttl ; echo "Created $i.stats.ttl" ; done;

echo Exporting "$namespace"graph/meta ;
java "$JVM_ARGS" tdb.tdbquery --time --desc="$tdbAssembler" --results=n-triples 'CONSTRUCT { ?s ?p ?o } WHERE { GRAPH <'"$namespace"'graph/meta> { ?s ?p ?o } }' > "$data"import/meta.nt ;

echo Creating LODStats "$data"import/meta.nt.stats.ttl ;
lodstats -val "$data"import/meta.nt > "$data"import/meta.nt.stats.ttl ;

echo "Fixing URI for meta stats" ;
find "$data"import/*stats.ttl -name "*[!Structure|abs.]" | while read i ; do sed -ri 's/<file:\/\/\/data\/'"$agency"'-linked-data\/data'"$state"'\/import\/([^\.]*)\.nt/<http:\/\/'"$agency"'.270a.info\/dataset\/\1/g' "$i" ; done ;



#find "$data" -name "*[!Structure|prov].rdf" | while read i ; do file=$(basename "$i"); dataSetCode=${file%.*};
#    lodstats -val "$data"import/graph.data.nt > "$data"import/graph.data.nt.stats.ttl
#    done;

#real    30m10.775s
#user    29m19.740s
#sys     0m49.048s
