Apply the Count SNPs method to Col Tsu crosses.
===============================================

The method was previously applied to 12 genes in Col Ler crosses.
We modified the scripts to use either (1) Col Ler or (2) Col Tsu depending on a parameter.

Step 1. Extract 10bp before & after each SNP. 
This requires a delta file from MUMmer nucmer.
This runs MUMmmer show-snps. 
This uses the FASTA files referenced within the delta file.
This assigns a SNP ID to each SNP and lists the Col and Tsu variants.

$ show-snps -H -C -T -x 10 Col_Ler.delta | ../scripts/parse_SNPs.sh 1 > parsed_SNPs.Col_Ler.txt
$ show-snps -H -C -T -x 10 Col_Tsu.delta | ../scripts/parse_SNPs.sh 3 > parsed_SNPs.Col_Tsu.txt

Step 2. Make the script to grep for SNPs.
This runs script_SNP.sh and writes count_SNP.Col_Tsu.sh.

$ ../scripts/make_scripts.sh 1   # Col_Ler
$ ../scripts/make_scripts.sh 2   # Ler_Col
$ ../scripts/make_scripts.sh 3   # Col_Tsu
$ ../scripts/make_scripts.sh 4   # Tsu_Col

Step 3. Use grep to count SNPs.
On Abel, run the count_SNP.Col_x_Tsu.sh in a directory with these files.
Col_x_Tsu_BR1_R1.seq
Col_x_Tsu_BR1_R2.seq
Col_x_Tsu_BR2_R1.seq
Col_x_Tsu_BR2_R2.seq
Col_x_Tsu_BR3_R1.seq
Col_x_Tsu_BR3_R2.seq
On Abel, run the count_SNP.Tsu_x_Col.sh in a directory with these files.
Tsu_x_Col_BR1_R1.seq
Tsu_x_Col_BR1_R2.seq
Tsu_x_Col_BR3_R1.seq
Tsu_x_Col_BR3_R2.seq
Tsu_x_Col_BR4_R1.seq
Tsu_x_Col_BR4_R2.seq

