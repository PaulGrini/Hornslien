#!/bin/sh

## INPUT FILES LIKE THIS: (1 replicate of 1 cross on each line)
# 
# ERCC-00002 10
# 
# AT1G01530.1 110
#
## OUTPUT FILES LIKE THIS: (3 replicates of cross 1, 3 replicates of cross 2, on each line)
#
# ERCC-00002 10 10 10 20 20 20
# ERCC-00003 0 0 0 5 5 5
# (92 lines)
#            
# AT1G01530.1 110 105 115 210 205 215
# AT1G01540.1 0 0 0  110 105 115
# (1011 lines)

function processing () {

    ERCC[1]="../ERCC/${1}.rpk";
    ERCC[2]="../ERCC/${2}.rpk";
    ERCC[3]="../ERCC/${3}.rpk";
    ERCC[4]="../ERCC/${4}.rpk";
    ERCC[5]="../ERCC/${5}.rpk";
    ERCC[6]="../ERCC/${6}.rpk";

    DATA[1]="${7}.rpk";
    DATA[2]="${8}.rpk";
    DATA[3]="${9}.rpk";
    DATA[4]="${10}.rpk";
    DATA[5]="${11}.rpk";
    DATA[6]="${12}.rpk";

    COMPARE=${13};
    echo "COMPARE ${COMPARE}..."

    echo "Test for file exists..."
    for II in {1..6};    do
	XX=${ERCC[${II}]}
	if [ ! -f ${XX} ]; then
	    echo "File not found! ${XX}"; exit 1
	fi
	XX=${DATA[${II}]}
	if [ ! -f ${XX} ]; then
	    echo "File not found! ${XX}"; exit 1
	fi
    done

    echo "Creating combo files..."
    cat ${ERCC[1]} | awk '{print $1;}' > six_ercc.txt
    cat ${DATA[1]} | awk '{print $1;}' > six_data.txt
    for II in {1..6};
    do
	cp six_ercc.txt tmp
	join -1 1 -2 1 tmp ${ERCC[${II}]} > six_ercc.txt
	cp six_data.txt tmp
	join -1 1 -2 1 tmp ${DATA[${II}]} > six_data.txt
    done
    
## THESE LINES ADDED MAT + PAT, WHICH IS GOOD FOR INFORMATIVE READS.
## DO NOT DO THIS FOR ERRC, WHICH USES ALL READS.
#cp six_data.txt tmp
#cat tmp | awk '{print $1, ($2+$3), ($4+$5), ($6+$7), ($8+$9), ($10+$11), ($12+$13);}' > six_data.txt
    
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
# Reads <parameter>.csv
# Writes <parameter>.sig
    Rscript limma.foldchange.ercc.R ${COMPARE}.ERCC-normalized
    
    echo "Clean up..."
# limma replaced gene names with quoted numbers and sorted by P-value.
# We will restore the sort order and combine with gene list.
# In order to sort numerically, replace strings like "1" with uniform width numbers like 0001.
    tail -n 1011 ${COMPARE}.ERCC-normalized.sig > tmp
    cat tmp | awk 'BEGIN { FS = ","; OFS=",";}  {gsub(/"/, "", $1); $1 = sprintf("%04d", 0+$1); print $0;}' \
	| sort --field-separator=',' -k1,1n > ${COMPARE}.ERCC-normalized.sig
    paste -d ',' ${COMPARE}.ERCC-normalized.csv ${COMPARE}.ERCC-normalized.sig > ${COMPARE}.gene_normalized_significance.csv
    rm tmp
}
#3
processing \
"Ler_x_Ler_BR1_ACAGTG_L007.count_with_zeros" \
"LerxLerBR2_S6_L008.count_with_zeros" \
"Ler_x_Ler_BR3_GCCAAT_L007.count_with_zeros" \
"Col0_x_Col0_BR1_CAGATC_L007.count_with_zeros" \
"ColxColBR2_S5_L008.count_with_zeros" \
"Col0_x_Col0_BR3_CTTGTA_L007.count_with_zeros" \
"../Homozygous/trim.pair.Ler_x_Ler_BR1_ACAGTG_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Homozygous/trim.pair.LerxLerBR2_S6_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Homozygous/trim.pair.Ler_x_Ler_BR3_GCCAAT_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Homozygous/trim.pair.Col0_x_Col0_BR1_CAGATC_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Homozygous/trim.pair.ColxColBR2_S5_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Homozygous/trim.pair.Col0_x_Col0_BR3_CTTGTA_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"Ler_x_Ler.Col_x_Col"
#4
processing \
"Tsu_x_Tsu_BR1_CCGTCC_L007.count_with_zeros" \
"Tsu_x_Tsu_BR2_GTCCGC_L007.count_with_zeros" \
"Tsu_x_Tsu_BR3_GTGAAA_L007.count_with_zeros" \
"Col0_x_Col0_BR1_CAGATC_L007.count_with_zeros" \
"ColxColBR2_S5_L008.count_with_zeros" \
"Col0_x_Col0_BR3_CTTGTA_L007.count_with_zeros" \
"../Homozygous/trim.pair.Tsu_x_Tsu_BR1_CCGTCC_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Homozygous/trim.pair.Tsu_x_Tsu_BR2_GTCCGC_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Homozygous/trim.pair.Tsu_x_Tsu_BR3_GTGAAA_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Homozygous/trim.pair.Col0_x_Col0_BR1_CAGATC_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Homozygous/trim.pair.ColxColBR2_S5_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Homozygous/trim.pair.Col0_x_Col0_BR3_CTTGTA_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"Tsu_x_Tsu.Col_x_Col" 
#5
processing \
"Ler_x_Ler_BR1_ACAGTG_L007.count_with_zeros" \
"LerxLerBR2_S6_L008.count_with_zeros" \
"Ler_x_Ler_BR3_GCCAAT_L007.count_with_zeros" \
"Tsu_x_Tsu_BR1_CCGTCC_L007.count_with_zeros" \
"Tsu_x_Tsu_BR2_GTCCGC_L007.count_with_zeros" \
"Tsu_x_Tsu_BR3_GTGAAA_L007.count_with_zeros" \
"../Homozygous/trim.pair.Ler_x_Ler_BR1_ACAGTG_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Homozygous/trim.pair.LerxLerBR2_S6_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Homozygous/trim.pair.Ler_x_Ler_BR3_GCCAAT_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Homozygous/trim.pair.Tsu_x_Tsu_BR1_CCGTCC_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Homozygous/trim.pair.Tsu_x_Tsu_BR2_GTCCGC_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Homozygous/trim.pair.Tsu_x_Tsu_BR3_GTGAAA_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"Ler_x_Ler.Tsu_x_Tsu" 
#7
processing \
"Ler_x_met1-3_BR1_ATGTCA_L001.count_with_zeros" \
"Ler_x_met1-3_BR3_GTCCGC_L008.count_with_zeros" \
"Ler_x_met1-3_BR4_GTGAAA_L008.count_with_zeros" \
"Ler_x_Col_BR1_CGATGT_L007.count_with_zeros" \
"LerxColBR2_S1_L008.count_with_zeros" \
"LerxColBR3_S2_L008.count_with_zeros" \
"../Ler/trim.pair.Ler_x_met1-3_BR1_ATGTCA_L001_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Ler_x_met1-3_BR3_GTCCGC_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Ler_x_met1-3_BR4_GTGAAA_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Ler_x_Col_BR1_CGATGT_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.LerxColBR2_S1_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.LerxColBR3_S2_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"Ler_x_met1-3.Ler_x_Col"
#8
processing \
"Ler_x_met179_BR1_GCCAAT_L008.count_with_zeros" \
"Ler_x_met179_BR2_CAGATC_L008.count_with_zeros" \
"Ler_x_met179_BR3_CTTGTA_L008.count_with_zeros" \
"Ler_x_Col_BR1_CGATGT_L007.count_with_zeros" \
"LerxColBR2_S1_L008.count_with_zeros" \
"LerxColBR3_S2_L008.count_with_zeros" \
"../Ler/trim.pair.Ler_x_met179_BR1_GCCAAT_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Ler_x_met179_BR2_CAGATC_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Ler_x_met179_BR3_CTTGTA_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Ler_x_Col_BR1_CGATGT_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.LerxColBR2_S1_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.LerxColBR3_S2_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"Ler_x_met179.Ler_x_Col."
#9
processing \
"Ler_x_rdr6_BR1_CTTGTA_L003.count_with_zeros" \
"Ler_x_rdr6_BR2_TGACCA_L006.count_with_zeros" \
"Ler_x_rdr6_BR4_ACAGTG_L006.count_with_zeros" \
"Ler_x_Col_BR1_CGATGT_L007.count_with_zeros" \
"LerxColBR2_S1_L008.count_with_zeros" \
"LerxColBR3_S2_L008.count_with_zeros" \
"../Ler/trim.pair.Ler_x_rdr6_BR1_CTTGTA_L003_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Ler_x_rdr6_BR2_TGACCA_L006_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Ler_x_rdr6_BR4_ACAGTG_L006_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Ler_x_Col_BR1_CGATGT_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.LerxColBR2_S1_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.LerxColBR3_S2_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"Ler_x_rdr6.Ler_x_Col"
#10
processing \
"Ler_x_nrpE1_BR1_AGTCAA_L002.count_with_zeros" \
"Ler_x_nrpE1_BR2_AGTTCC_L002.count_with_zeros" \
"Ler_x_nrpE1_BR4_CGATGT_L003.count_with_zeros" \
"Ler_x_Col_BR1_CGATGT_L007.count_with_zeros" \
"LerxColBR2_S1_L008.count_with_zeros" \
"LerxColBR3_S2_L008.count_with_zeros" \
"../Ler/trim.pair.Ler_x_nrpE1_BR1_AGTCAA_L002_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Ler_x_nrpE1_BR2_AGTTCC_L002_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Ler_x_nrpE1_BR4_CGATGT_L003_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Ler_x_Col_BR1_CGATGT_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.LerxColBR2_S1_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.LerxColBR3_S2_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"Ler_x_nrpE1.Ler_x_Col"
#11
processing \
"Ler_x_drm1_BR1_AGTTCC_L007.count_with_zeros" \
"Ler_x_drm1_BR2_CTTGTA_L006.count_with_zeros" \
"Ler_x_drm1_BR3_ATGTCA_L007.count_with_zeros" \
"Ler_x_Col_BR1_CGATGT_L007.count_with_zeros" \
"LerxColBR2_S1_L008.count_with_zeros" \
"LerxColBR3_S2_L008.count_with_zeros" \
"../Ler/trim.pair.Ler_x_drm1_BR1_AGTTCC_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Ler_x_drm1_BR2_CTTGTA_L006_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Ler_x_drm1_BR3_ATGTCA_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Ler_x_Col_BR1_CGATGT_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.LerxColBR2_S1_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.LerxColBR3_S2_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"Ler_x_drm12.Ler_x_Col"
#12
processing \
"Ler_x_mea9_BR1_GTCCGC_L002.count_with_zeros" \
"Ler_x_mea9_BR2_GTGAAA_L002.count_with_zeros" \
"Ler_x_mea9_BR3_ACAGTG_L003.count_with_zeros" \
"Ler_x_Col_BR1_CGATGT_L007.count_with_zeros" \
"LerxColBR2_S1_L008.count_with_zeros" \
"LerxColBR3_S2_L008.count_with_zeros" \
"../Ler/trim.pair.Ler_x_mea9_BR1_GTCCGC_L002_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Ler_x_mea9_BR2_GTGAAA_L002_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Ler_x_mea9_BR3_ACAGTG_L003_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Ler_x_Col_BR1_CGATGT_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.LerxColBR2_S1_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.LerxColBR3_S2_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"Ler_x_mea9.Ler_x_Col"
#13
processing \
"Col0_x_Ler_BR2_TGACCA_L007.count_with_zeros" \
"ColxLerBR3_S3_L008.count_with_zeros" \
"ColxLerBR4_S4_L008.count_with_zeros" \
"Ler_x_Col_BR1_CGATGT_L007.count_with_zeros" \
"LerxColBR2_S1_L008.count_with_zeros" \
"LerxColBR3_S2_L008.count_with_zeros" \
"../Ler/trim.pair.Col0_x_Ler_BR2_TGACCA_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.ColxLerBR3_S3_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.ColxLerBR4_S4_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Ler_x_Col_BR1_CGATGT_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.LerxColBR2_S1_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.LerxColBR3_S2_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"Col_x_Ler.Ler_x_Col"
#15
processing \
"rdr6_x_Ler_BR1_GCCAAT_L003.count_with_zeros" \
"rdr6_x_Ler_BR2_CAGATC_L003.count_with_zeros" \
"rdr6_x_Ler_BR3_CGATGT_L006.count_with_zeros" \
"Col0_x_Ler_BR2_TGACCA_L007.count_with_zeros" \
"ColxLerBR3_S3_L008.count_with_zeros" \
"ColxLerBR4_S4_L008.count_with_zeros" \
"../Ler/trim.pair.rdr6_x_Ler_BR1_GCCAAT_L003_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.rdr6_x_Ler_BR2_CAGATC_L003_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.rdr6_x_Ler_BR3_CGATGT_L006_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Col0_x_Ler_BR2_TGACCA_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.ColxLerBR3_S3_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.ColxLerBR4_S4_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"rdr6_x_Ler.Col_x_Ler"
#16
processing \
"nrpE1_x_Ler_BR1_CCGTCC_L001.count_with_zeros" \
"nrpE1_x_Ler_BR2_GTCCGC_L001.count_with_zeros" \
"nrpE1_x_Ler_BR4_GTGAAA_L001.count_with_zeros" \
"Col0_x_Ler_BR2_TGACCA_L007.count_with_zeros" \
"ColxLerBR3_S3_L008.count_with_zeros" \
"ColxLerBR4_S4_L008.count_with_zeros" \
"../Ler/trim.pair.nrpE1_x_Ler_BR1_CCGTCC_L001_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.nrpE1_x_Ler_BR2_GTCCGC_L001_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.nrpE1_x_Ler_BR4_GTGAAA_L001_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Col0_x_Ler_BR2_TGACCA_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.ColxLerBR3_S3_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.ColxLerBR4_S4_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"nrpE1_x_Ler.Col_x_Ler"
#17
processing \
"drm1_x_Ler_BR1_GCCAAT_L006.count_with_zeros" \
"drm1_x_Ler_BR2_CAGATC_L006.count_with_zeros" \
"drm1_x_Ler_BR4_AGTCAA_L007.count_with_zeros" \
"Col0_x_Ler_BR2_TGACCA_L007.count_with_zeros" \
"ColxLerBR3_S3_L008.count_with_zeros" \
"ColxLerBR4_S4_L008.count_with_zeros" \
"../Ler/trim.pair.drm1_x_Ler_BR1_GCCAAT_L006_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.drm1_x_Ler_BR2_CAGATC_L006_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.drm1_x_Ler_BR4_AGTCAA_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Col0_x_Ler_BR2_TGACCA_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.ColxLerBR3_S3_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.ColxLerBR4_S4_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"drm12_x_Ler.Col_x_Ler"
#18
processing \
"mea9_x_Ler_BR1_ATGTCA_L002.count_with_zeros" \
"mea9_x_Ler_BR2_CCGTCC_L002.count_with_zeros" \
"mea9_x_Ler_BR3_TGACCA_L003.count_with_zeros" \
"Col0_x_Ler_BR2_TGACCA_L007.count_with_zeros" \
"ColxLerBR3_S3_L008.count_with_zeros" \
"ColxLerBR4_S4_L008.count_with_zeros" \
"../Ler/trim.pair.mea9_x_Ler_BR1_ATGTCA_L002_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.mea9_x_Ler_BR2_CCGTCC_L002_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.mea9_x_Ler_BR3_TGACCA_L003_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.Col0_x_Ler_BR2_TGACCA_L007_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.ColxLerBR3_S3_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Ler/trim.pair.ColxLerBR4_S4_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"mea9_x_Ler.Col_x_Ler"
#21
processing \
"Tsu_x_met179_BR1_CGATGT_L008.count_with_zeros" \
"Tsu_x_met179_BR2_TGACCA_L008.count_with_zeros" \
"Tsu_x_met179_BR3_ACAGTG_L008.count_with_zeros" \
"Tsu_x_Col0_BR1_AGTCAA_L008.count_with_zeros" \
"Tsu_x_Col0_BR3_AGTTCC_L008.count_with_zeros" \
"Tsu_x_Col0_BR4_AGTCAA_L001.count_with_zeros" \
"../Tsu/trim.pair.Tsu_x_met179_BR1_CGATGT_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Tsu/trim.pair.Tsu_x_met179_BR2_TGACCA_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Tsu/trim.pair.Tsu_x_met179_BR3_ACAGTG_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Tsu/trim.pair.Tsu_x_Col0_BR1_AGTCAA_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Tsu/trim.pair.Tsu_x_Col0_BR3_AGTTCC_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Tsu/trim.pair.Tsu_x_Col0_BR4_AGTCAA_L001_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"Tsu_x_met179.Tsu_x_Col"
#22
processing \
"Col0_x_Tsu_BR1_ATGTCA_L008.count_with_zeros" \
"Col0_x_Tsu_BR2_AGTTCC_L001.count_with_zeros" \
"Col0_x_Tsu_BR3_CCGTCC_L008.count_with_zeros" \
"Tsu_x_Col0_BR1_AGTCAA_L008.count_with_zeros" \
"Tsu_x_Col0_BR3_AGTTCC_L008.count_with_zeros" \
"Tsu_x_Col0_BR4_AGTCAA_L001.count_with_zeros" \
"../Tsu/trim.pair.Col0_x_Tsu_BR1_ATGTCA_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Tsu/trim.pair.Col0_x_Tsu_BR2_AGTTCC_L001_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Tsu/trim.pair.Col0_x_Tsu_BR3_CCGTCC_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Tsu/trim.pair.Tsu_x_Col0_BR1_AGTCAA_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Tsu/trim.pair.Tsu_x_Col0_BR3_AGTTCC_L008_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"../Tsu/trim.pair.Tsu_x_Col0_BR4_AGTCAA_L001_PAIR_001.bam.gene_counts.sorted.with_zeros" \
"Col_x_Tsu.Tsu_x_Col"

echo "Done"

