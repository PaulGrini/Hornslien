#!/bin/sh

DIRNAME=`dirname $0`
SCRIPT=${DIRNAME}/one_gene_for_anova.pl

CFILE[0]=Col_x_Col_vs_Ler_x_Ler.cross.matrix.csv
CFILE[1]=Col_x_Col_vs_Tsu_x_Tsu.cross.matrix.csv
CFILE[2]=Col_x_Ler_vs_drm1_x_Ler.cross.matrix.csv
CFILE[3]=Col_x_Ler_vs_mea9_x_Ler.cross.matrix.csv
CFILE[4]=Col_x_Ler_vs_nrpE1_x_Ler.cross.matrix.csv
CFILE[5]=Col_x_Ler_vs_rdr6_x_Ler.cross.matrix.csv
CFILE[6]=Ler_x_Col_vs_Col_x_Ler.cross.matrix.csv
CFILE[7]=Ler_x_Col_vs_Ler_x_Met1-3.cross.matrix.csv
CFILE[8]=Ler_x_Col_vs_Ler_x_drm1.cross.matrix.csv
CFILE[9]=Ler_x_Col_vs_Ler_x_mea9.cross.matrix.csv
CFILE[10]=Ler_x_Col_vs_Ler_x_met179.cross.matrix.csv
CFILE[11]=Ler_x_Col_vs_Ler_x_nrpE1.cross.matrix.csv
CFILE[12]=Ler_x_Col_vs_Ler_x_rdr6.cross.matrix.csv
CFILE[13]=Tsu_x_Col_vs_Col_x_Tsu.cross.matrix.csv
CFILE[14]=Tsu_x_Col_vs_Tsu_x_met179.cross.matrix.csv

C1[0]=Col_x_Col
C1[1]=Col_x_Col
C1[2]=Col_x_Ler
C1[3]=Col_x_Ler
C1[4]=Col_x_Ler
C1[5]=Col_x_Ler
C1[6]=Ler_x_Col
C1[7]=Ler_x_Col
C1[8]=Ler_x_Col
C1[9]=Ler_x_Col
C1[10]=Ler_x_Col
C1[11]=Ler_x_Col
C1[12]=Ler_x_Col
C1[13]=Tsu_x_Col
C1[14]=Tsu_x_Col

C2[0]=Ler_x_Ler
C2[1]=Tsu_x_Tsu
C2[2]=drm1_x_Ler
C2[3]=mea9_x_Ler
C2[4]=nrpE1_x_Ler
C2[5]=rdr6_x_Ler
C2[6]=Col_x_Ler
C2[7]=Ler_x_Met1-3
C2[8]=Ler_x_drm1
C2[9]=Ler_x_mea9
C2[10]=Ler_x_met179
C2[11]=Ler_x_nrpE1
C2[12]=Ler_x_rdr6
C2[13]=Col_x_Tsu
C2[14]=Tsu_x_met179

HEADER='"cross1","cross2","gene","unused","Df1","Df2","Df3","residualDF","Sum Sq1","Sum Sq2","Sum Sq3","residualSS","Mean Sq1","Mean Sq2","Mean Sq3","residualMS","F value1","F value2","F value3","residualF","Pr(>F)1","Pr(>F)2","Pr(>F)3","residualPr"'

LINES=`cat ${DIRNAME}/anova.gene_list.txt`

for ii in {0..14}; do

    FILE1="${CFILE[${ii}]}"
    CROSS1="${C1[${ii}]}"
    CROSS2="${C2[${ii}]}"

    echo "Outer loop" $FILE1 $CROSS1 $CROSS2

    echo $HEADER  > anova.matrix.${CROSS1}.${CROSS2}.csv

    for GENE1 in $LINES; do
	
	echo $ii $CROSS1 $CROSS2 $GENE1
	
	cat ${FILE1} | ${SCRIPT} ${CROSS1} ${CROSS2} ${GENE1} > anova.input.csv
	
	Rscript ${DIRNAME}/master_anova.R
	
	cat anova.output.csv | awk -F',' -v CROSS1="$CROSS1" -v CROSS2="$CROSS2" -v GENE1="$GENE1" \
	    'BEGIN {OFS=",";} {if (++C==2) print CROSS1, CROSS2, GENE1, $0}' \
	    >> anova.matrix.${CROSS1}.${CROSS2}.csv
	
    done

done




