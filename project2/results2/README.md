# Apply the Count SNPs method to Col Tsu crosses.

The method was previously applied to 12 genes in Col Ler crosses.
We modified the scripts to use either (1) Col Ler or (2) Col Tsu depending on a parameter.

## Step 1. Extract 10bp before & after each SNP. 
This requires a delta file from MUMmer nucmer.
This runs MUMmmer show-snps. 
This uses the FASTA files referenced within the delta file.
This assigns a SNP ID to each SNP and lists the Col and Tsu variants.
```
$ show-snps -H -C -T -x 10 Col_Ler.delta | ../scripts/parse_SNPs.sh 1 > parsed_SNPs.Col_Ler.txt
$ show-snps -H -C -T -x 10 Col_Tsu.delta | ../scripts/parse_SNPs.sh 3 > parsed_SNPs.Col_Tsu.txt
```
## Step 2. Make the script to grep for SNPs.
This runs script_SNP.sh and writes count_SNP.Col_Tsu.sh.
The numbers indicate Col_Ler, Ler_Col, Col_Tsu, Tsu_Col respectively.
```
$ ../scripts/make_scripts.sh 1   
$ ../scripts/make_scripts.sh 2   
$ ../scripts/make_scripts.sh 3   
$ ../scripts/make_scripts.sh 4   
```
## Step 3. Use grep to count SNPs.
On Abel, run the count_SNP.Col_x_Tsu.sh in a directory with these files.

* Col_x_Tsu_BR1_R1.seq
* Col_x_Tsu_BR1_R2.seq
* Col_x_Tsu_BR2_R1.seq
* Col_x_Tsu_BR2_R2.seq
* Col_x_Tsu_BR3_R1.seq
* Col_x_Tsu_BR3_R2.seq

On Abel, run the count_SNP.Tsu_x_Col.sh in a directory with these files.

* Tsu_x_Col_BR1_R1.seq
* Tsu_x_Col_BR1_R2.seq
* Tsu_x_Col_BR3_R1.seq
* Tsu_x_Col_BR3_R2.seq
* Tsu_x_Col_BR4_R1.seq
* Tsu_x_Col_BR4_R2.seq

On Abel, sequences were extracted from the raw reads files.
The *.seq files consisted of just nucleotides, untrimmed, 150bp per line.
The script count_SNP.Col_x_Tsu.sh (and count_SNP.Tsu_x_Col.sh) were run on Abel.
The files count_SNP.Col_x_Tsu.log (and count_SNP.Tsu_x_Col.log) were downloaded.

## Step 4. Convert the SNP count logs to csv files.
The inputs are log files with lines like this.
```
AT1G02580,COL,AT1G02580.SNP3,334,T,ATTATGCTCTTGAAGAAGATG,fwd,R2
Col_x_Tsu_BR1_R2.seq:94
Col_x_Tsu_BR2_R2.seq:187
Col_x_Tsu_BR3_R2.seq:172
```
The script was run like this.
The script parameters 3 and 4 indicate Col_Tsu and Tsu_Col respectively.
```
$ ../scripts/log_to_csv.sh 3
$ ../scripts/log_to_csv.sh 4
```
In the output csv files, Col comes before Ler and Col comes before Tsu.
The outputs are csv files with lines like this.
```
AT1G02580.SNP3,0,0,0,94,187,172,115,208,160,0,0,0,0,0,0,86,82,82,75,67,107,0,0,0
```

## Step 5. Transform SNP counts to read counts.
The script was run like this using 3 => Col_x_Tsu and 4 => Tsu_x_Col.
```
$ from_SNP_to_read_counts.sh 3
$ from_SNP_to_read_counts.sh 4
```
The from_SNP_to_read_counts.sh script invokes the from_SNP_to_read_counts.pl script. 
This script converted the csv files to the three_reps_per_gene format used for Informative Reads. 
The results are in the SNP.Col_x_Tsu.three_reps_per_gene (and SNP.Tsu_x_Col) files. 
In these files, maternal values have been cut in half. 
In these files, maternal comes before paternal. 
These outputs are designed for comparison to outputs of collate_three_reps_per_gene.sh for IR. 
The from_SNP_to_read_counts.log file has the log for how each gene was computed.

The output is in SNP.Col_x_Tsu.three_reps_per_gene (and SNP.Tsu_x_Col.three_reps_per_gene).
The outputs look like this.
```
AT1G02580 271 274 261 205 380 229
```

## Step 6. Recreate equivalent files from Informative Reads pipeline.
Now we have the "three_reps_per_gene" files for SNP counts.
For comparison, we need the "three_reps_per_gene" files for IR counts.
Unfortunately, those were considered intermediate files and were not saved in the repo.
We will recreate them from stats files by removing all the stats.
This script inputs *.three_reps_per_gene.filtered.final.csv from the repo.
This script outputs IR *.three_reps_per_gene csv files.
```
../scripts/get_IR_three_reps_per_gene.sh 3
../scripts/get_IR_three_reps_per_gene.sh 4
```

## STEP 7. Generate statistics.
Run the comparative_12gene_counts.sh script on SNP and IR data.

The script runs on these input files:

* IR.Col_x_Tsu.three_reps_per_gene
* IR.Tsu_x_Col.three_reps_per_gene
* SNP.Col_x_Tsu.three_reps_per_gene
* SNP.Tsu_x_Col.three_reps_per_gene

The script generates these intermediate files:

* IR.Col_x_Tsu.three_reps_per_gene.de.sorted
* IR.Tsu_x_Col.three_reps_per_gene.de.sorted
* SNP.Col_x_Tsu.three_reps_per_gene.de.sorted
* SNP.Tsu_x_Col.three_reps_per_gene.de.sorted

The script generates these output files:

* IR.Col_x_Tsu.three_reps_per_gene.final.csv
* IR.Tsu_x_Col.three_reps_per_gene.final.csv
* SNP.Col_x_Tsu.three_reps_per_gene.final.csv
* SNP.Tsu_x_Col.three_reps_per_gene.final.csv

