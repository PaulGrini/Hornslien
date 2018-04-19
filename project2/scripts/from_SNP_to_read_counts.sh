#!/bin/sh

echo "Convert files with 24 read counts per SNP"
echo " to files with 6 read counts per gene."

BINDIR=$(dirname "$0")
SCRIPT=${BINDIR}/from_SNP_to_read_counts.pl 

echo "Col_x_Ler"
${SCRIPT} Col SNP.Col_x_Ler.csv > SNP.Col_x_Ler.three_reps_per_gene 

echo "Ler_x_Col"
${SCRIPT} Ler SNP.Ler_x_Col.csv > SNP.Ler_x_Col.three_reps_per_gene 

date
