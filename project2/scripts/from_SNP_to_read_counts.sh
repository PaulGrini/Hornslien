#!/bin/sh

echo "Convert files with 24 read counts per SNP"
echo " to files with 6 read counts per gene."

DATASET="Undefined"
PARAM="0"
MATERNAL="Undefined"
if [ "$1" -eq "1" ]; then
    DATASET="Col_x_Ler"
    PARAM="1"
    MATERNAL="Col"
fi
if [ "$1" -eq "2" ]; then
    DATASET="Ler_x_Col"
    PARAM="2"
    MATERNAL="Ler"
fi
if [ "$1" -eq "3" ]; then
    DATASET="Col_x_Tsu"
    PARAM="3"
    MATERNAL="Col"
fi
if [ "$1" -eq "4" ]; then
    DATASET="Tsu_x_Col"
    PARAM="4"
    MATERNAL="Tsu"
fi

BINDIR=$(dirname "$0")
SCRIPT=${BINDIR}/from_SNP_to_read_counts.pl 

echo "PARAM $PARAM DATASET $DATASET MATERNAL $MATERNAL"
${SCRIPT} $MATERNAL SNP.${DATASET}.csv > SNP.${DATASET}.three_reps_per_gene 

date
