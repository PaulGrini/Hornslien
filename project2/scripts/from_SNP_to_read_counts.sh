#!/bin/sh

echo "Convert files with 24 read counts per SNP"
echo " to files with 6 read counts per gene."

BINDIR=.
SCRIPT=${BINDIR}/from_SNP_to_read_counts.pl 

echo "Col_x_Ler"
${SCRIPT} Col Col_x_Ler.csv > Col_x_Ler.three_reps_per_gene 
#2> Col_x_Ler.three_reps_per_gene.log

echo "Ler_x_Col"
${SCRIPT} Ler Ler_x_Col.csv > Ler_x_Col.three_reps_per_gene 
#2> Ler_x_Col.three_reps_per_gene.log

date
