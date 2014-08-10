#!/bin/bash

#
#    Author: Sarven Capadisli <info@csarven.ca>
#    Author URI: http://csarven.ca/#i
#

. ./abs.config.sh

rm "$provRetrieval"

echo '<?xml version="1.0" encoding="UTF-8"?>
<rdf:RDF
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:sdmx="http://purl.org/linked-data/sdmx#">' > "$provRetrieval" ;

sed -i 's/\&ndash;/\&#8211;/g' ${agency}.html;
sed -i 's/\&mdash;/\&#8212;/g' ${agency}.html;
xmllint --xpath "//a[@class = \"ds\"]" ${agency}.html | sed 's/\/a>/\/a>\n/gi' > ${agency}.temp


Get=(DataStructure Data);

#D.txt contains a list of datasets which need to be retrieved per dimension code. 
D=($(<../scripts/D.txt));

counter=1;
while read line ; do
    DataSetCode=$(echo "$line" | perl -pe 's/<a(.*)(?=dscode)dscode=\"([^\"]*)\"(.*)/$2/');

    for GD in "${Get[@]}" ; do
        if [ "$GD" == "Data" ]
        then
            DataType="http:\/\/purl.org\/linked-data\/sdmx#DataSet"
            DataTypeLabel="Data"
            DataTypePath=""

            downloadURL="${sourceNamespace}Get${GD}/${DataSetCode}";
        else
            DataType="http:\/\/purl.org\/linked-data\/sdmx#DataStructureDefinition"
            DataTypeLabel="Structure"
            DataTypePath=".Structure"

            downloadURL="${sourceNamespace}Get${GD}/${DataSetCode}/ABS";
        fi

        if [[ ${GD} == "Data" && ${D[*]} =~ "$DataSetCode" ]] ;
            then
            xmllint --format --xpath "/*[local-name() ='Structure']/*[local-name() ='CodeLists']/*[local-name() = 'CodeList'][@id = /*[local-name() ='Structure']/*[local-name() ='KeyFamilies']/*[local-name() ='KeyFamily']/*[local-name() ='Components']/*[local-name() ='Dimension'][1]/@codelist]/*[local-name() = 'Code']/@value" "$data""${DataSetCode}".Structure.xml | perl -pe 's/\s+value\=\"([^\"]*)\"/$1\n/gi' | while read i; do

                downloadURL="${sourceNamespace}Get${GD}/${DataSetCode}/${i}/ABS";

                echo "[D] $counter $downloadURL" ;
                sleep 1
                dtstart=$(date +"%Y-%m-%dT%H:%M:%SZ") ;
                dtstartd=$(echo "$dtstart" | sed 's/[^0-9]*//g') ;
                #curl -L "${downloadURL}" -o "$data""${DataSetCode}.${i}.xml" ;
                sleep 1
                dtend=$(date +"%Y-%m-%dT%H:%M:%SZ") ;
                dtendd=$(echo "$dtend" | sed 's/[^0-9]*//g') ;

                echo "$line" | perl -pe 's/<a(.*)(?=dscode)dscode=\"([^\"]*)\"(.*)(?=href)href=\"([^\"]*)\">([^<]*)<\/a>/
                <rdf:Description rdf:about="http:\/\/'$agency'.270a.info\/provenance\/activity\/'$dtstartd'">
                    <rdf:type rdf:resource="http:\/\/www.w3.org\/ns\/prov#Activity"\/>
                    <prov:startedAtTime rdf:datatype="http:\/\/www.w3.org\/2001\/XMLSchema#dateTime">'$dtstart'<\/prov:startedAtTime>
                    <prov:endedAtTime rdf:datatype="http:\/\/www.w3.org\/2001\/XMLSchema#dateTime">'$dtend'<\/prov:endedAtTime>
                    <prov:wasAssociatedWith rdf:resource="http:\/\/csarven.ca\/#i"\/>
                    <prov:used rdf:resource="https:\/\/launchpad.net\/ubuntu\/+source\/curl"\/>
                    <prov:used>
                        <rdf:Description rdf:about="http:\/\/stat.abs.gov.au\/restsdmx\/sdmx.ashx\/Get'$GD'\/$2\/'$i'\/ABS">
                            <foaf:page rdf:resource="http:\/\/stat.abs.gov.au\/$4"\/>
                            <dcterms:identifier>'$DataSetCode'<\/dcterms:identifier>
                            <dcterms:title xml:lang="en">$5<\/dcterms:title>
                        <\/rdf:Description>
                    <\/prov:used>
                    <prov:generated>
                        <rdf:Description rdf:about="http:\/\/'$agency'.270a.info\/data\/'$DataSetCode''$DataTypePath'.'$i'.xml">
                            <dcterms:identifier>'$DataSetCode'<\/dcterms:identifier>
                            <dcterms:title xml:lang="en">$5<\/dcterms:title>
                        <\/rdf:Description>
                    <\/prov:generated>
                    <rdfs:label xml:lang="en">Retrieved '$DataSetCode' '$DataTypeLabel'<\/rdfs:label>
                    <rdfs:comment xml:lang="en">'$DataTypeLabel' of dataset '$DataSetCode' retrieved from source and saved to local filesystem.<\/rdfs:comment>
                <\/rdf:Description>/' >> "$provRetrieval" ;

    #            if [ "$GD" == "Data" ]
    #            then
    #            echo "$i" | perl -pe 's/<a(.*)(?=dscode)dscode=\"([^\"]*)\"(.*)(?=href)href=\"([^\"]*)\">([^<]*)</a>/
    #            <rdf:Description rdf:about="http://abs.270a.info/dataset/'$DataSetCode'">
    #                <dcterms:title>$5</dcterms:title>
    #            </rdf:Description>/' >> "$provRetrieval" ;
    #            fi

    #            (( counter++ ));
            done
        else
            echo "[.] $counter $downloadURL" ;
            sleep 1
            dtstart=$(date +"%Y-%m-%dT%H:%M:%SZ") ;
            dtstartd=$(echo "$dtstart" | sed 's/[^0-9]*//g') ;
            #curl -L "${downloadURL}" > "$data""$DataSetCode""$DataTypePath".xml
            sleep 1
            dtend=$(date +"%Y-%m-%dT%H:%M:%SZ") ;
            dtendd=$(echo "$dtend" | sed 's/[^0-9]*//g') ;

            echo "$line" | perl -pe 's/<a(.*)(?=dscode)dscode=\"([^\"]*)\"(.*)(?=href)href=\"([^\"]*)\">([^<]*)<\/a>/
            <rdf:Description rdf:about="http:\/\/abs.270a.info\/provenance\/activity\/'$dtstartd'">
                <rdf:type rdf:resource="http:\/\/www.w3.org\/ns\/prov#Activity"\/>
                <prov:startedAtTime rdf:datatype="http:\/\/www.w3.org\/2001\/XMLSchema#dateTime">'$dtstart'<\/prov:startedAtTime>
                <prov:endedAtTime rdf:datatype="http:\/\/www.w3.org\/2001\/XMLSchema#dateTime">'$dtend'<\/prov:endedAtTime>
                <prov:wasAssociatedWith rdf:resource="http:\/\/csarven.ca\/#i"\/>
                <prov:used rdf:resource="https:\/\/launchpad.net\/ubuntu\/+source\/curl"\/>
                <prov:used>
                    <rdf:Description rdf:about="http:\/\/stat.abs.gov.au\/restsdmx\/sdmx.ashx\/Get'$GD'\/$2\/ABS">
                        <foaf:page rdf:resource="http:\/\/stat.abs.gov.au\/$4"\/>
                        <dcterms:identifier>'$DataSetCode'<\/dcterms:identifier>
                        <dcterms:title>$5<\/dcterms:title>
                    <\/rdf:Description>
                <\/prov:used>
                <prov:generated>
                    <rdf:Description rdf:about="http:\/\/'$agency'.270a.info\/data\/'$DataSetCode''$DataTypePath'.xml">
                        <dcterms:identifier>'$DataSetCode'<\/dcterms:identifier>
                        <dcterms:title>$5<\/dcterms:title>
                    <\/rdf:Description>
                <\/prov:generated>
                <rdfs:label xml:lang="en">Retrieved '$DataSetCode' '$DataTypeLabel'<\/rdfs:label>
                <rdfs:comment xml:lang="en">'$DataTypeLabel' of dataset '$DataSetCode' retrieved from source and saved to local filesystem.<\/rdfs:comment>
            <\/rdf:Description>/' >> "$provRetrieval" ;

#                if [ "$GD" == "Data" ]
#                then
#                echo "$i" | perl -pe 's/<a(.*)(?=dscode)dscode=\"([^\"]*)\"(.*)(?=href)href=\"([^\"]*)\">([^<]*)<\/a>/
#                <rdf:Description rdf:about="http:\/\/abs.270a.info\/dataset\/'$DataSetCode'">
#                    <dcterms:title>$5<\/dcterms:title>
#                <\/rdf:Description>/' >> "$provRetrieval" ;
#                fi
        fi
    done;
done < abs.temp;

echo -e "\n</rdf:RDF>" >> "$provRetrieval" ;

mv abs.temp /tmp/


#real    1161m27.449s
#user    0m35.462s
#sys     1m25.961s

#wget "${sourceNamespace}GetData/$DataSetCode/ABS"
#wget "${sourceNamespace}GetDataStructure/$DataSetCode/ABS"

#parallel -j 4 curl -L "${sourceNamespace}GetData/${DataSetCode}/{}/ABS" -o "$data""${DataSetCode}.{}.xml"

##Retries to get all datasets by slicing them on the first dimension
#data="../data/"; sourceNamespace="http://stat.abs.gov.au/restsdmx/sdmx.ashx/";  while read DataSetCode; do xmllint --format --xpath "/*[local-name() ='Structure']/*[local-name() ='CodeLists']/*[local-name() = 'CodeList'][@id = /*[local-name() ='Structure']/*[local-name() ='KeyFamilies']/*[local-name() ='KeyFamily']/*[local-name() ='Components']/*[local-name() ='Dimension'][1]/@codelist]/*[local-name() = 'Code']/@value" "$data""${DataSetCode}".Structure.xml | perl -pe 's/\s+value\=\"([^\"]*)\"/$1\n/gi' | while read i; do curl -L "${sourceNamespace}GetData/${DataSetCode}/${i}/ABS" -o "$data""${DataSetCode}.${i}.xml" ; done ; done < D.txt

##Retries to get all datasets that wasn't retrieved for properly.
#data="../data/"; sourceNamespace="http://stat.abs.gov.au/restsdmx/sdmx.ashx/"; find *.xml -type f -size 11883c | grep -E ".*\..*\.xml" | grep -v Structure | perl -pe "s/([^\.]*)(.*)/\$1/g" | sort -u | while read DataSetCode; do echo "---${DataSetCode}"; find "${DataSetCode}".*.xml -type f -size 11883c | sort -u | grep -E ".*\..*\.xml" | grep -v Structure | perl -pe "s/(${DataSetCode}\.|\.xml)//g" | parallel -j 4 curl -L "${sourceNamespace}GetData/${DataSetCode}/{}/ABS" -o "$data""${DataSetCode}.{}.xml" ; done

