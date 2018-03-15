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

function reduce () {
    column="$1"
    filename="$2"
    if [ -f "${filename}" ]
       then
	   echo "Column $column is maternal $filename"
	   if [ "${column}" == "1" ]
	   then	
	       cat ${filename} | awk '{print $1, int(0.5+($2/2)), $3;}' > ${filename}.half
	   else
	       cat ${filename} | awk '{print $1, $2, int(0.5+($3/2));}' > ${filename}.half
	   fi
	   echo "Created new file: ${filename}.half"
    else
	echo "File $filename not found"
    fi
}

reduce 1 Col0_x_Ler_BR2_TGACCA_L007_PAIR_001.Columns_Col_Ler
reduce 1 ColxLerBR3_S3_L008_PAIR_001.Columns_Col_Ler
reduce 1 ColxLerBR4_S4_L008_PAIR_001.Columns_Col_Ler

reduce 2 Ler_x_Col_BR1_CGATGT_L007_PAIR_001.Columns_Col_Ler
reduce 2 LerxColBR2_S1_L008_PAIR_001.Columns_Col_Ler
reduce 2 LerxColBR3_S2_L008_PAIR_001.Columns_Col_Ler

reduce 2 Ler_x_drm1_BR1_AGTTCC_L007_PAIR_001.Columns_Col_Ler
reduce 2 Ler_x_drm1_BR2_CTTGTA_L006_PAIR_001.Columns_Col_Ler
reduce 2 Ler_x_drm1_BR3_ATGTCA_L007_PAIR_001.Columns_Col_Ler

reduce 1 drm1_x_Ler_BR1_GCCAAT_L006_PAIR_001.Columns_Col_Ler
reduce 1 drm1_x_Ler_BR2_CAGATC_L006_PAIR_001.Columns_Col_Ler
reduce 1 drm1_x_Ler_BR4_AGTCAA_L007_PAIR_001.Columns_Col_Ler

reduce 2 Ler_x_mea9_BR1_GTCCGC_L002_PAIR_001.Columns_Col_Ler
reduce 2 Ler_x_mea9_BR2_GTGAAA_L002_PAIR_001.Columns_Col_Ler
reduce 2 Ler_x_mea9_BR3_ACAGTG_L003_PAIR_001.Columns_Col_Ler

reduce 1 mea9_x_Ler_BR1_ATGTCA_L002_PAIR_001.Columns_Col_Ler
reduce 1 mea9_x_Ler_BR2_CCGTCC_L002_PAIR_001.Columns_Col_Ler
reduce 1 mea9_x_Ler_BR3_TGACCA_L003_PAIR_001.Columns_Col_Ler

reduce 2 Ler_x_met1-3_BR1_ATGTCA_L001_PAIR_001.Columns_Col_Ler
reduce 2 Ler_x_met1-3_BR3_GTCCGC_L008_PAIR_001.Columns_Col_Ler
reduce 2 Ler_x_met1-3_BR4_GTGAAA_L008_PAIR_001.Columns_Col_Ler

reduce 2 Ler_x_met179_BR1_GCCAAT_L008_PAIR_001.Columns_Col_Ler
reduce 2 Ler_x_met179_BR2_CAGATC_L008_PAIR_001.Columns_Col_Ler
reduce 2 Ler_x_met179_BR3_CTTGTA_L008_PAIR_001.Columns_Col_Ler

reduce 2 Ler_x_nrpE1_BR1_AGTCAA_L002_PAIR_001.Columns_Col_Ler
reduce 2 Ler_x_nrpE1_BR2_AGTTCC_L002_PAIR_001.Columns_Col_Ler
reduce 2 Ler_x_nrpE1_BR4_CGATGT_L003_PAIR_001.Columns_Col_Ler

reduce 1 nrpE1_x_Ler_BR1_CCGTCC_L001_PAIR_001.Columns_Col_Ler
reduce 1 nrpE1_x_Ler_BR2_GTCCGC_L001_PAIR_001.Columns_Col_Ler
reduce 1 nrpE1_x_Ler_BR4_GTGAAA_L001_PAIR_001.Columns_Col_Ler

reduce 2 Ler_x_rdr6_BR1_CTTGTA_L003_PAIR_001.Columns_Col_Ler
reduce 2 Ler_x_rdr6_BR2_TGACCA_L006_PAIR_001.Columns_Col_Ler
reduce 2 Ler_x_rdr6_BR4_ACAGTG_L006_PAIR_001.Columns_Col_Ler

reduce 1 rdr6_x_Ler_BR1_GCCAAT_L003_PAIR_001.Columns_Col_Ler
reduce 1 rdr6_x_Ler_BR2_CAGATC_L003_PAIR_001.Columns_Col_Ler
reduce 1 rdr6_x_Ler_BR3_CGATGT_L006_PAIR_001.Columns_Col_Ler

reduce 1 Col0_x_Tsu_BR1_ATGTCA_L008_PAIR_001.Columns_Col_Tsu
reduce 1 Col0_x_Tsu_BR2_AGTTCC_L001_PAIR_001.Columns_Col_Tsu
reduce 1 Col0_x_Tsu_BR3_CCGTCC_L008_PAIR_001.Columns_Col_Tsu

reduce 2 Tsu_x_Col0_BR1_AGTCAA_L008_PAIR_001.Columns_Col_Tsu
reduce 2 Tsu_x_Col0_BR3_AGTTCC_L008_PAIR_001.Columns_Col_Tsu
reduce 2 Tsu_x_Col0_BR4_AGTCAA_L001_PAIR_001.Columns_Col_Tsu

reduce 2 Tsu_x_met179_BR1_CGATGT_L008_PAIR_001.Columns_Col_Tsu
reduce 2 Tsu_x_met179_BR2_TGACCA_L008_PAIR_001.Columns_Col_Tsu
reduce 2 Tsu_x_met179_BR3_ACAGTG_L008_PAIR_001.Columns_Col_Tsu

echo Done
