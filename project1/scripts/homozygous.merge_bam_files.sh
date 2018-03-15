#!/bin/sh

samtools merge Col_x_Col.bam trim.pair.Col0_x_Col0_BR1_CAGATC_L007_PAIR_001.bam trim.pair.ColxColBR2_S5_L008_PAIR_001.bam trim.pair.Col0_x_Col0_BR3_CTTGTA_L007_PAIR_001.bam

samtools merge Ler_x_Ler.bam trim.pair.Ler_x_Ler_BR1_ACAGTG_L007_PAIR_001.bam trim.pair.LerxLerBR2_S6_L008_PAIR_001.bam trim.pair.Ler_x_Ler_BR3_GCCAAT_L007_PAIR_001.bam

samtools merge Tsu_x_Tsu.bam trim.pair.Tsu_x_Tsu_BR1_CCGTCC_L007_PAIR_001.bam trim.pair.Tsu_x_Tsu_BR2_GTCCGC_L007_PAIR_001.bam trim.pair.Tsu_x_Tsu_BR3_GTGAAA_L007_PAIR_001.bam
