#!/bin/sh

if [[ -z "${REPODIR}" ]]; then
    echo "Please set the REPODIR environment variable to the path to and including Hornslien"
    exit 1
else
    export REPODIR="${REPODIR}"
    echo REPODIR ${REPODIR}
fi

DATASET="Undefined"
if [ "$1" -eq "1" ]; then
    DATASET="Col_x_Ler"
fi
if [ "$1" -eq "2" ]; then
    DATASET="Ler_x_Col"
fi
if [ "$1" -eq "3" ]; then
    DATASET="Col_x_Tsu"
fi
if [ "$1" -eq "4" ]; then
    DATASET="Tsu_x_Col"
fi

# Restricted data set to these genes.
export MYGENES="AT2G35670|AT4G25530|AT1G02580|AT1G65330|AT3G19350|AT5G26650|AT2G17690|AT4G13460|AT1G55560|AT2G32990|AT4G10640|AT5G60440|AT1G65300|AT5G26630"

# Restrict output to the read counts. Chop off the statistics.
cat ${REPODIR}/project1/results1/Statistics/${DATASET}.three_reps_per_gene.filtered.final.csv \
    | egrep "${MYGENES}" | cut -d ',' -f 1-7 \
    > IR.${DATASET}.three_reps_per_gene

wc *.three_reps_per_gene