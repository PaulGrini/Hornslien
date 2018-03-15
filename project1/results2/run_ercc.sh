#!/bin/sh

COMPARE="Ler_x_Col.Ler_x_met1-3"

ERCC[1]="ArabidopsisImprinting/project1/results2/Ler_x_Col_BR1_CGATGT_L007.count"
ERCC[2]="ArabidopsisImprinting/project1/results2/LerxColBR2_S1_L008.count"
ERCC[3]="ArabidopsisImprinting/project1/results2/LerxColBR3_S2_L008.count"
ERCC[4]="ArabidopsisImprinting/project1/results2/Ler_x_met1-3_BR1_ATGTCA_L001.count"
ERCC[5]="ArabidopsisImprinting/project1/results2/Ler_x_met1-3_BR3_GTCCGC_L008.count"
ERCC[6]="ArabidopsisImprinting/project1/results2/Ler_x_met1-3_BR4_GTGAAA_L008.count"

DATA[1]="ArabidopsisImprinting/project1/results1/Ler_x_Col_BR1_CGATGT_L007_PAIR_001.Columns_Col_Ler"
DATA[2]="ArabidopsisImprinting/project1/results1/LerxColBR2_S1_L008_PAIR_001.Columns_Col_Ler"
DATA[3]="ArabidopsisImprinting/project1/results1/LerxColBR3_S2_L008_PAIR_001.Columns_Col_Ler"
DATA[4]="ArabidopsisImprinting/project1/results1/Ler_x_met1-3_BR1_ATGTCA_L001_PAIR_001.Columns_Col_Ler"
DATA[5]="ArabidopsisImprinting/project1/results1/Ler_x_met1-3_BR3_GTCCGC_L008_PAIR_001.Columns_Col_Ler"
DATA[6]="ArabidopsisImprinting/project1/results1/Ler_x_met1-3_BR4_GTGAAA_L008_PAIR_001.Columns_Col_Ler"

echo "Creating combo files..."
cat ${ERCC[1]} | awk '{print $2;}' > six_ercc.txt
cat ${DATA[1]} | awk '{print $1;}' > six_data.txt
for II in {1..6};
do
    cp six_ercc.txt tmp
    join -1 1 -2 2 tmp ${ERCC[${II}]} > six_ercc.txt
    cp six_data.txt tmp
    join -1 1 -2 1 tmp ${DATA[${II}]} > six_data.txt
done
cp six_data.txt tmp
cat tmp | awk '{print $1, ($2+$3), ($4+$5), ($6+$7), ($8+$9), ($10+$11), ($12+$13);}' > six_data.txt

echo "Start normalization..."
echo "Consider using rlog normalization to avoid pseudocount."
Rscript erccNormalization.oneLane.R six_ercc.txt six_data.txt

echo "Clean up..."
mv ERCC-normalized.six_data.txt ${COMPARE}.ERCC-normalized.csv
rm tmp
rm six_ercc.txt
rm six_data.txt

echo "Start significance..."
echo "Note this uses pseudocount."
Rscript limma.foldchange.ercc.R ${COMPARE}.ERCC-normalized

echo "Clean up..."
cat ${COMPARE}.ERCC-normalized.sig | sed 's/"//g' > ${COMPARE}.ERCC-normalized.sig.csv

echo "Done"

