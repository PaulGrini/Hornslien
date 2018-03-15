#!/bin/sh 

# This is a project-specific wrapper for the core script: filter_genes.pl

if [ -z "$SCRIPTDIR" ]; then echo "ERROR SCRIPTDIR NOT SET"; exit 1; fi
echo SCRIPT DIRECTORY $SCRIPTDIR
CWD=`pwd`

PROG=${SCRIPTDIR}/filter_genes.pl
echo PROG $PROG
ls -l $PROG

MIN_READS_PER_REP=50
MIN_READS_PER_GENE=200
MIN_FOLD_PER_REP=5
echo MIN_READS_PER_REP $MIN_READS_PER_REP
echo MIN_READS_PER_GENE $MIN_READS_PER_GENE
echo MIN_FOLD_PER_REP $MIN_FOLD_PER_REP

FIRST_COL=1
SECOND_COL=2
TEMPFILE=filter_genes.tmp

echo "RUN Col_x_Col reads map to Col and Ler consensus"
cat Col0_x_Col0_BR1_CAGATC_L007_PAIR_001.Columns_Col_Ler \
    ColxColBR2_S5_L008_PAIR_001.Columns_Col_Ler \
    Col0_x_Col0_BR3_CTTGTA_L007_PAIR_001.Columns_Col_Ler \
    > $TEMPFILE
${PROG} ${TEMPFILE} ${FIRST_COL} ${MIN_READS_PER_REP} ${MIN_READS_PER_GENE} ${MIN_FOLD_PER_REP} \
	| sort -k1,1 > Genes_Pass_Filter.Col.Col_Ler.txt
rm $TEMPFILE

echo "RUN Ler_x_Ler reads map to Col and Ler consensus"
cat Ler_x_Ler_BR1_ACAGTG_L007_PAIR_001.Columns_Col_Ler \
    LerxLerBR2_S6_L008_PAIR_001.Columns_Col_Ler \
    Ler_x_Ler_BR3_GCCAAT_L007_PAIR_001.Columns_Col_Ler \
    > $TEMPFILE
${PROG} ${TEMPFILE} ${SECOND_COL} ${MIN_READS_PER_REP} ${MIN_READS_PER_GENE} ${MIN_FOLD_PER_REP} \
	| sort -k1,1 > Genes_Pass_Filter.Ler.Col_Ler.txt
rm $TEMPFILE

echo "Intersection of Col and Ler pass genes"
comm -1 -2 Genes_Pass_Filter.Col.Col_Ler.txt Genes_Pass_Filter.Ler.Col_Ler.txt \
     > Genes_Pass_Filter.Both.Col_Ler.txt

echo "RUN Col_x_Col reads map to Col and Tsu consensus"
cat Col0_x_Col0_BR1_CAGATC_L007_PAIR_001.Columns_Col_Tsu \
    ColxColBR2_S5_L008_PAIR_001.Columns_Col_Tsu \
    Col0_x_Col0_BR3_CTTGTA_L007_PAIR_001.Columns_Col_Tsu \
    > $TEMPFILE
${PROG} ${TEMPFILE} ${FIRST_COL} ${MIN_READS_PER_REP} ${MIN_READS_PER_GENE} ${MIN_FOLD_PER_REP} \
	| sort -k1,1 > Genes_Pass_Filter.Col.Col_Tsu.txt
rm $TEMPFILE

echo "RUN Tsu_x_Tsu reads map to Col and Tsu consensus"
cat Tsu_x_Tsu_BR1_CCGTCC_L007_PAIR_001.Columns_Col_Tsu \
    Tsu_x_Tsu_BR2_GTCCGC_L007_PAIR_001.Columns_Col_Tsu \
    Tsu_x_Tsu_BR3_GTGAAA_L007_PAIR_001.Columns_Col_Tsu \
    > $TEMPFILE
${PROG} ${TEMPFILE} ${SECOND_COL} ${MIN_READS_PER_REP} ${MIN_READS_PER_GENE} ${MIN_FOLD_PER_REP} \
	| sort -k1,1 > Genes_Pass_Filter.Tsu.Col_Tsu.txt
rm $TEMPFILE

echo "Intersection of Col and Tsu pass genes"
comm -1 -2 Genes_Pass_Filter.Col.Col_Tsu.txt Genes_Pass_Filter.Tsu.Col_Tsu.txt \
     > Genes_Pass_Filter.Both.Col_Tsu.txt

date
echo DONE
