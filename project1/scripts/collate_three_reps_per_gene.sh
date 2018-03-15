#!/bin/sh

# IGNORE HOMOZYGOUS CROSSES

# Col0_x_Col0_BR1_CAGATC_L007_PAIR_001.Columns_Col_Ler
# ColxColBR2_S5_L008_PAIR_001.Columns_Col_Ler
# Col0_x_Col0_BR3_CTTGTA_L007_PAIR_001.Columns_Col_Ler

# Ler_x_Ler_BR1_ACAGTG_L007_PAIR_001.Columns_Col_Ler
# LerxLerBR2_S6_L008_PAIR_001.Columns_Col_Ler
# Ler_x_Ler_BR3_GCCAAT_L007_PAIR_001.Columns_Col_Ler

# Col0_x_Col0_BR1_CAGATC_L007_PAIR_001.Columns_Col_Tsu
# ColxColBR2_S5_L008_PAIR_001.Columns_Col_Tsu
# Col0_x_Col0_BR3_CTTGTA_L007_PAIR_001.Columns_Col_Tsu

# Tsu_x_Tsu_BR1_CCGTCC_L007_PAIR_001.Columns_Col_Tsu
# Tsu_x_Tsu_BR2_GTCCGC_L007_PAIR_001.Columns_Col_Tsu
# Tsu_x_Tsu_BR3_GTGAAA_L007_PAIR_001.Columns_Col_Tsu

function collate () {
    replicate1=$1
    replicate2=$2
    replicate3=$3
    cross=$4
    reversal=$5   # 1 => Leave columns as is. 2 => Reverse the columns.
    
    if [ ! -f "${replicate1}" ]; then echo "ERROR: File not found ${replicate1}"; return; fi
    if [ ! -f "${replicate2}" ]; then echo "ERROR: File not found ${replicate2}"; return; fi
    if [ ! -f "${replicate3}" ]; then echo "ERROR: File not found ${replicate3}"; return; fi

    # Assume each input file has same genes in same order. Otherwise print nothing.
    # Output field order: gene Col Col Col other other other
    if [ $reversal == 1 ]; then
	paste $replicate1 $replicate2 $replicate3 \
	    | awk '{if ($1==$4 && $4==$7) print $1, $2,$5,$8, $3,$6,$9;}' \
		  > ${cross}.three_reps_per_gene
    elif [ $reversal == 2 ]; then
	paste $replicate1 $replicate2 $replicate3 \
	    | awk '{if ($1==$4 && $4==$7) print $1, $3,$6,$9, $2,$5,$8;}' \
		  > ${cross}.three_reps_per_gene
    else
	echo "ERROR: $reversal not a valid reversal"; exit 1
    fi
    	
    echo "Created new file: ${cross}.three_reps_per_gene"
}

collate Col0_x_Ler_BR2_TGACCA_L007_PAIR_001.Columns_Col_Ler.half \
        ColxLerBR3_S3_L008_PAIR_001.Columns_Col_Ler.half \
        ColxLerBR4_S4_L008_PAIR_001.Columns_Col_Ler.half \
        Col_x_Ler 1

collate Ler_x_Col_BR1_CGATGT_L007_PAIR_001.Columns_Col_Ler.half \
	LerxColBR2_S1_L008_PAIR_001.Columns_Col_Ler.half \
	LerxColBR3_S2_L008_PAIR_001.Columns_Col_Ler.half \
	Ler_x_Col 2

collate Ler_x_drm1_BR1_AGTTCC_L007_PAIR_001.Columns_Col_Ler.half \
	Ler_x_drm1_BR2_CTTGTA_L006_PAIR_001.Columns_Col_Ler.half \
	Ler_x_drm1_BR3_ATGTCA_L007_PAIR_001.Columns_Col_Ler.half \
	Ler_x_drm1 2

collate drm1_x_Ler_BR1_GCCAAT_L006_PAIR_001.Columns_Col_Ler.half \
	drm1_x_Ler_BR2_CAGATC_L006_PAIR_001.Columns_Col_Ler.half \
	drm1_x_Ler_BR4_AGTCAA_L007_PAIR_001.Columns_Col_Ler.half \
	drm1_x_Ler 1 

collate Ler_x_mea9_BR1_GTCCGC_L002_PAIR_001.Columns_Col_Ler.half \
	Ler_x_mea9_BR2_GTGAAA_L002_PAIR_001.Columns_Col_Ler.half \
	Ler_x_mea9_BR3_ACAGTG_L003_PAIR_001.Columns_Col_Ler.half \
	Ler_x_mea9 2

collate mea9_x_Ler_BR1_ATGTCA_L002_PAIR_001.Columns_Col_Ler.half \
	mea9_x_Ler_BR2_CCGTCC_L002_PAIR_001.Columns_Col_Ler.half \
	mea9_x_Ler_BR3_TGACCA_L003_PAIR_001.Columns_Col_Ler.half \
	mea9_x_Ler 1 

collate Ler_x_met1-3_BR1_ATGTCA_L001_PAIR_001.Columns_Col_Ler.half \
	Ler_x_met1-3_BR3_GTCCGC_L008_PAIR_001.Columns_Col_Ler.half \
	Ler_x_met1-3_BR4_GTGAAA_L008_PAIR_001.Columns_Col_Ler.half \
	Ler_x_met1-3 2
	
collate Ler_x_met179_BR1_GCCAAT_L008_PAIR_001.Columns_Col_Ler.half \
	Ler_x_met179_BR2_CAGATC_L008_PAIR_001.Columns_Col_Ler.half \
	Ler_x_met179_BR3_CTTGTA_L008_PAIR_001.Columns_Col_Ler.half \
	Ler_x_met179 2

collate Ler_x_nrpE1_BR1_AGTCAA_L002_PAIR_001.Columns_Col_Ler.half \
	Ler_x_nrpE1_BR2_AGTTCC_L002_PAIR_001.Columns_Col_Ler.half \
	Ler_x_nrpE1_BR4_CGATGT_L003_PAIR_001.Columns_Col_Ler.half \
	Ler_x_nrpE1 2

collate nrpE1_x_Ler_BR1_CCGTCC_L001_PAIR_001.Columns_Col_Ler.half \
	nrpE1_x_Ler_BR2_GTCCGC_L001_PAIR_001.Columns_Col_Ler.half \
	nrpE1_x_Ler_BR4_GTGAAA_L001_PAIR_001.Columns_Col_Ler.half \
	nrpE1_x_Ler 1

collate Ler_x_rdr6_BR1_CTTGTA_L003_PAIR_001.Columns_Col_Ler.half \
	Ler_x_rdr6_BR2_TGACCA_L006_PAIR_001.Columns_Col_Ler.half \
	Ler_x_rdr6_BR4_ACAGTG_L006_PAIR_001.Columns_Col_Ler.half \
	Ler_x_rdr6 2
	
collate rdr6_x_Ler_BR1_GCCAAT_L003_PAIR_001.Columns_Col_Ler.half \
	rdr6_x_Ler_BR2_CAGATC_L003_PAIR_001.Columns_Col_Ler.half \
	rdr6_x_Ler_BR3_CGATGT_L006_PAIR_001.Columns_Col_Ler.half \
	rdr6_x_Ler 1
	
collate Col0_x_Tsu_BR1_ATGTCA_L008_PAIR_001.Columns_Col_Tsu.half \
	Col0_x_Tsu_BR2_AGTTCC_L001_PAIR_001.Columns_Col_Tsu.half \
	Col0_x_Tsu_BR3_CCGTCC_L008_PAIR_001.Columns_Col_Tsu.half \
	Col_x_Tsu 1

collate Tsu_x_Col0_BR1_AGTCAA_L008_PAIR_001.Columns_Col_Tsu.half \
	Tsu_x_Col0_BR3_AGTTCC_L008_PAIR_001.Columns_Col_Tsu.half \
	Tsu_x_Col0_BR4_AGTCAA_L001_PAIR_001.Columns_Col_Tsu.half \
	Tsu_x_Col 2

collate Tsu_x_met179_BR1_CGATGT_L008_PAIR_001.Columns_Col_Tsu.half \
	Tsu_x_met179_BR2_TGACCA_L008_PAIR_001.Columns_Col_Tsu.half \
	Tsu_x_met179_BR3_ACAGTG_L008_PAIR_001.Columns_Col_Tsu.half \
	Tsu_x_met179 2

echo Done
