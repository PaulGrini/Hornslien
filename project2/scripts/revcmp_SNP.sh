#!/bin/sh

while read line; do
    set -- $line
    FWD=$6
    REV=` echo ${FWD} | rev `
    LOW=`echo ${REV} | tr 'A' 'a' | tr 'C' 'c' | tr 'G' 'g' | tr 'T' 't' `
    CMP=`echo ${LOW} | tr 'a' 'T' | tr 'c' 'G' | tr 'g' 'C' | tr 't' 'A' `
    echo $1 $2 $3 $4 $5 ${FWD} ${CMP}
done