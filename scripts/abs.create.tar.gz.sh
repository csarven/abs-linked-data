#!/bin/bash

. ./abs.config.sh

cd "$data"
tar -cvzf meta.tar.gz *.Structure.rdf abs.*

tar -cvzf data.tar.gz *.rdf --exclude='*.Structure.rdf' --exclude='abs.*'

