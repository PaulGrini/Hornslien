#!/bin/sh

# Input:
#
# Generated by from_SNP_to_read_counts.sh using 12 genes... 
# SNP.Col_x_Ler.three_reps_per_gene
# SNP.Ler_x_Col.three_reps_per_gene
#
# Genated during the IR pipeline, but filtered for the 12 genes...
# IR.Col_x_Ler.three_reps_per_gene
# IR.Ler_x_Col.three_reps_per_gene
#
# Example data (gene mat/2 mat/2 mat/2 pat pat pat):
# AT1G55560.1 838 417 1056 2846 2669 3556
#
# Output:
# 
# Limma stats: 
#    gene mat/2 mat/2 mat/2 pat pat pat \
#    gene_num log_FC avg_log_expr t_statistic P_value adjusted_P LogOddsDiffExpr FoldChange

date
pwd

if [[ -z "${SCRIPTDIR}" ]]; then
    echo "Please set the SCRIPTDIR environment variable to the home of limma.foldchange.r"
    exit 1
else
    export SCRIPTDIR="${SCRIPTDIR}"
    echo SCRIPTDIR ${SCRIPTDIR}
    ls -l ${SCRIPTDIR}/limma.foldchange.r
fi

Rscript ${SCRIPTDIR}/limma.foldchange.r SNP.Col_x_Ler.three_reps_per_gene
Rscript ${SCRIPTDIR}/limma.foldchange.r SNP.Ler_x_Col.three_reps_per_gene

Rscript ${SCRIPTDIR}/limma.foldchange.r IR.Col_x_Ler.three_reps_per_gene
Rscript ${SCRIPTDIR}/limma.foldchange.r IR.Ler_x_Col.three_reps_per_gene

for X in $(ls *.three_reps_per_gene)
do
    cat ${X} | tr ' ' ',' > tmp.${X}.csv
    cat ${X}.de | tr -d '"' | sort -t"," -k1,1n | awk '{if (C++ >= 1) print $0;}' > ${X}.de.sorted
    paste tmp.${X}.csv ${X}.de.sorted | tr '\t' ',' > ${X}.final.csv
    rm tmp.${X}.csv
    rm ${X}.de
done

ls -l
echo DONE