#!/bin/sh

PATH_TO_SCRIPT=`dirname $0`
export PREPARE="${PATH_TO_SCRIPT}/prepare_anova.pl"

# ${PREPARE} \
#   Cross1 n (where n is 1 for mat=Col0 or 2 for pat=Col0
#   File1 File2 File3
#   Cross2 n (where n is 1 for mat=Col0 or 2 for pat=Col0
#   File1 File2 File3

${PREPARE} \
    Ler_x_Col  2 \
    Ler_x_Col_BR1_CGATGT_L007_PAIR_001.Columns_Col_Ler \
    LerxColBR2_S1_L008_PAIR_001.Columns_Col_Ler \
    LerxColBR3_S2_L008_PAIR_001.Columns_Col_Ler \
    Ler_x_Met1-3  2 \
    Ler_x_met1-3_BR1_ATGTCA_L001_PAIR_001.Columns_Col_Ler \
    Ler_x_met1-3_BR3_GTCCGC_L008_PAIR_001.Columns_Col_Ler \
    Ler_x_met1-3_BR4_GTGAAA_L008_PAIR_001.Columns_Col_Ler \

${PREPARE} \
    Ler_x_Col 2 \
    Ler_x_Col_BR1_CGATGT_L007_PAIR_001.Columns_Col_Ler \
    LerxColBR2_S1_L008_PAIR_001.Columns_Col_Ler \
    LerxColBR3_S2_L008_PAIR_001.Columns_Col_Ler \
    Ler_x_met179 2 \
    Ler_x_met179_BR1_GCCAAT_L008_PAIR_001.Columns_Col_Ler \
    Ler_x_met179_BR2_CAGATC_L008_PAIR_001.Columns_Col_Ler \
    Ler_x_met179_BR3_CTTGTA_L008_PAIR_001.Columns_Col_Ler \

${PREPARE} \
    Ler_x_Col 2 \
    Ler_x_Col_BR1_CGATGT_L007_PAIR_001.Columns_Col_Ler \
    LerxColBR2_S1_L008_PAIR_001.Columns_Col_Ler \
    LerxColBR3_S2_L008_PAIR_001.Columns_Col_Ler \
    Ler_x_rdr6 2 \
    Ler_x_rdr6_BR1_CTTGTA_L003_PAIR_001.Columns_Col_Ler \
    Ler_x_rdr6_BR2_TGACCA_L006_PAIR_001.Columns_Col_Ler \
    Ler_x_rdr6_BR4_ACAGTG_L006_PAIR_001.Columns_Col_Ler \

${PREPARE} \
    Ler_x_Col 2 \
    Ler_x_Col_BR1_CGATGT_L007_PAIR_001.Columns_Col_Ler \
    LerxColBR2_S1_L008_PAIR_001.Columns_Col_Ler \
    LerxColBR3_S2_L008_PAIR_001.Columns_Col_Ler \
    Ler_x_nrpE1 2 \
    Ler_x_nrpE1_BR1_AGTCAA_L002_PAIR_001.Columns_Col_Ler \
    Ler_x_nrpE1_BR2_AGTTCC_L002_PAIR_001.Columns_Col_Ler \
    Ler_x_nrpE1_BR4_CGATGT_L003_PAIR_001.Columns_Col_Ler \

${PREPARE} \
    Ler_x_Col 2 \
    Ler_x_Col_BR1_CGATGT_L007_PAIR_001.Columns_Col_Ler \
    LerxColBR2_S1_L008_PAIR_001.Columns_Col_Ler \
    LerxColBR3_S2_L008_PAIR_001.Columns_Col_Ler \
    Ler_x_drm1 2 \
    Ler_x_drm1_BR1_AGTTCC_L007_PAIR_001.Columns_Col_Ler \
    Ler_x_drm1_BR2_CTTGTA_L006_PAIR_001.Columns_Col_Ler \
    Ler_x_drm1_BR3_ATGTCA_L007_PAIR_001.Columns_Col_Ler \

${PREPARE} \
    Ler_x_Col 2 \
    Ler_x_Col_BR1_CGATGT_L007_PAIR_001.Columns_Col_Ler \
    LerxColBR2_S1_L008_PAIR_001.Columns_Col_Ler \
    LerxColBR3_S2_L008_PAIR_001.Columns_Col_Ler \
    Ler_x_mea9 2 \
    Ler_x_mea9_BR1_GTCCGC_L002_PAIR_001.Columns_Col_Ler \
    Ler_x_mea9_BR2_GTGAAA_L002_PAIR_001.Columns_Col_Ler \
    Ler_x_mea9_BR3_ACAGTG_L003_PAIR_001.Columns_Col_Ler \

${PREPARE} \
    Ler_x_Col 2 \
    Ler_x_Col_BR1_CGATGT_L007_PAIR_001.Columns_Col_Ler \
    LerxColBR2_S1_L008_PAIR_001.Columns_Col_Ler \
    LerxColBR3_S2_L008_PAIR_001.Columns_Col_Ler \
    Col_x_Ler 1 \
    Col0_x_Ler_BR2_TGACCA_L007_PAIR_001.Columns_Col_Ler \
    ColxLerBR3_S3_L008_PAIR_001.Columns_Col_Ler \
    ColxLerBR4_S4_L008_PAIR_001.Columns_Col_Ler \

${PREPARE} \
    Col_x_Ler 1 \
    Col0_x_Ler_BR2_TGACCA_L007_PAIR_001.Columns_Col_Ler \
    ColxLerBR3_S3_L008_PAIR_001.Columns_Col_Ler \
    ColxLerBR4_S4_L008_PAIR_001.Columns_Col_Ler \
    rdr6_x_Ler 1 \
    rdr6_x_Ler_BR3_CGATGT_L006_PAIR_001.Columns_Col_Ler \
    rdr6_x_Ler_BR2_CAGATC_L003_PAIR_001.Columns_Col_Ler \
    rdr6_x_Ler_BR1_GCCAAT_L003_PAIR_001.Columns_Col_Ler \

${PREPARE} \
    Col_x_Ler 1 \
    Col0_x_Ler_BR2_TGACCA_L007_PAIR_001.Columns_Col_Ler \
    ColxLerBR3_S3_L008_PAIR_001.Columns_Col_Ler \
    ColxLerBR4_S4_L008_PAIR_001.Columns_Col_Ler \
    nrpE1_x_Ler 1 \
    nrpE1_x_Ler_BR1_CCGTCC_L001_PAIR_001.Columns_Col_Ler \
    nrpE1_x_Ler_BR2_GTCCGC_L001_PAIR_001.Columns_Col_Ler \
    nrpE1_x_Ler_BR4_GTGAAA_L001_PAIR_001.Columns_Col_Ler \

${PREPARE} \
    Col_x_Ler 1 \
    Col0_x_Ler_BR2_TGACCA_L007_PAIR_001.Columns_Col_Ler \
    ColxLerBR3_S3_L008_PAIR_001.Columns_Col_Ler \
    ColxLerBR4_S4_L008_PAIR_001.Columns_Col_Ler \
    drm1_x_Ler 1 \
    drm1_x_Ler_BR1_GCCAAT_L006_PAIR_001.Columns_Col_Ler \
    drm1_x_Ler_BR2_CAGATC_L006_PAIR_001.Columns_Col_Ler \
    drm1_x_Ler_BR4_AGTCAA_L007_PAIR_001.Columns_Col_Ler \

${PREPARE} \
    Col_x_Ler 1 \
    Col0_x_Ler_BR2_TGACCA_L007_PAIR_001.Columns_Col_Ler \
    ColxLerBR3_S3_L008_PAIR_001.Columns_Col_Ler \
    ColxLerBR4_S4_L008_PAIR_001.Columns_Col_Ler \
    mea9_x_Ler 1 \
    mea9_x_Ler_BR1_ATGTCA_L002_PAIR_001.Columns_Col_Ler \
    mea9_x_Ler_BR2_CCGTCC_L002_PAIR_001.Columns_Col_Ler \
    mea9_x_Ler_BR3_TGACCA_L003_PAIR_001.Columns_Col_Ler \

${PREPARE} \
    Tsu_x_Col 2 \
    Tsu_x_Col0_BR1_AGTCAA_L008_PAIR_001.Columns_Col_Tsu \
    Tsu_x_Col0_BR3_AGTTCC_L008_PAIR_001.Columns_Col_Tsu \
    Tsu_x_Col0_BR4_AGTCAA_L001_PAIR_001.Columns_Col_Tsu \
    Tsu_x_met179 2 \
    Tsu_x_met179_BR1_CGATGT_L008_PAIR_001.Columns_Col_Tsu \
    Tsu_x_met179_BR2_TGACCA_L008_PAIR_001.Columns_Col_Tsu \
    Tsu_x_met179_BR3_ACAGTG_L008_PAIR_001.Columns_Col_Tsu \

${PREPARE} \
    Tsu_x_Col 2 \
    Tsu_x_Col0_BR1_AGTCAA_L008_PAIR_001.Columns_Col_Tsu \
    Tsu_x_Col0_BR3_AGTTCC_L008_PAIR_001.Columns_Col_Tsu \
    Tsu_x_Col0_BR4_AGTCAA_L001_PAIR_001.Columns_Col_Tsu \
    Col_x_Tsu 1 \
    Col0_x_Tsu_BR1_ATGTCA_L008_PAIR_001.Columns_Col_Tsu \
    Col0_x_Tsu_BR2_AGTTCC_L001_PAIR_001.Columns_Col_Tsu \
    Col0_x_Tsu_BR3_CCGTCC_L008_PAIR_001.Columns_Col_Tsu \

# Homozygotes are compared just for completeness.
# Use Col as maternal for Col x Col.
# Use Col as paternal for Ler x Ler and Tsu x Tsu.
# This is arbitrary but we're aiming for maternal count > paternal count.

${PREPARE} \
    Col_x_Col 2 \
    Col0_x_Col0_BR1_CAGATC_L007_PAIR_001.Columns_Col_Ler \
    ColxColBR2_S5_L008_PAIR_001.Columns_Col_Ler \
    Col0_x_Col0_BR3_CTTGTA_L007_PAIR_001.Columns_Col_Ler \
    Ler_x_Ler 1 \
    Ler_x_Ler_BR1_ACAGTG_L007_PAIR_001.Columns_Col_Ler \
    LerxLerBR2_S6_L008_PAIR_001.Columns_Col_Ler \
    Ler_x_Ler_BR3_GCCAAT_L007_PAIR_001.Columns_Col_Ler \

${PREPARE} \
    Col_x_Col 2 \
    Col0_x_Col0_BR1_CAGATC_L007_PAIR_001.Columns_Col_Tsu \
    ColxColBR2_S5_L008_PAIR_001.Columns_Col_Tsu \
    Col0_x_Col0_BR3_CTTGTA_L007_PAIR_001.Columns_Col_Tsu \
    Tsu_x_Tsu 1 \
    Tsu_x_Tsu_BR1_CCGTCC_L007_PAIR_001.Columns_Col_Tsu \
    Tsu_x_Tsu_BR3_GTGAAA_L007_PAIR_001.Columns_Col_Tsu \
    Tsu_x_Tsu_BR2_GTCCGC_L007_PAIR_001.Columns_Col_Tsu \

date
