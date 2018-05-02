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
The numbers indicate Col_Ler, Ler_Col, Col_Tsu, Tsu_Col respectively.

$ ../scripts/make_scripts.sh 1   
$ ../scripts/make_scripts.sh 2   
$ ../scripts/make_scripts.sh 3   
$ ../scripts/make_scripts.sh 4   

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

On Abel, sequences were extracted from the raw reads files.
The *.seq files consisted of just nucleotides, untrimmed, 150bp per line.
The script count_SNP.Col_x_Tsu.sh (and count_SNP.Tsu_x_Col.sh) were run on Abel.
The files count_SNP.Col_x_Tsu.log (and count_SNP.Tsu_x_Col.log) were downloaded.


