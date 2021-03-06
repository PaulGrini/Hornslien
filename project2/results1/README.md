Process 
=============

Experiment:

Twelve genes were selected to include MEG, PEG, and BEG examples.
For each gene, SNPs were discovered by comparing the pilon P4 consensus sequences.
SNPs were discovered using nucmer and show-snps from the MUMmer package.
For each SNP, the 21bp region was extracted in forward and reverse complement.
These results are in the parsed_SNPs.txt file

The make_script.sh script parsed the SNPs and generated the count_SNPs.sh script.
The following counts were generated with the count_SNPs.sh script on Abel.
Using each 21bp sequence, reads were searched with grep to count exact match.
The search was performed with Abel on UiO sequence files representing Cross.Replicate.Read.
Nearly all matches involved our 21bp reverse sequence to R2 or our 21bp forward sequence to R1.
These coverage counts are in the Col_x_Ler.csv (and Ler_x_Col) files.
In these files, Col comes before Ler.

The from_SNP_to_read_counts.sh script invokes the from_SNP_to_read_counts.pl script.
This script converted the csv files to the three_reps_per_gene format used for Informative Reads.
The results are in the Col_x_Ler.three_reps_per_gene (and Ler_x_Col) files.
In these files, maternal comes before paternal.
These outputs are designed for comparison to outputs of collate_three_reps_per_gene.sh for IR.

For Informative Reads, it was necessary to run the apply_filter_to_counts.sh script.
That generated the three_reps_per_gene.filtered files with fewer than 1011 genes per cross.
For this experiment, it is not necessary to filter the genes. We have 12 genes, period.

The next step was to run the run_differential_expression.sh script.
This is a wrapper to send each cross through the limma statistics.
We will run the limma R script directly: limma.foldchange.r in core.
This script says it expects "gene Col Col Col other other other"
but actually it was always run with "gene Mat Mat Mat Pat Pat Pat".
The output is in *.de sorted by most to least significant.

Rscript limma.foldchange.r Col_x_Ler.three_reps_per_gene
Rscript limma.foldchange.r Ler_x_Col.three_reps_per_gene

Then, do what run_differential_expression.sh does...

foreach X (*.de)
foreach? cat $X | tr -d '"' | sort -t"," -k1,1n | awk '{if (C++ >= 1) print $0;}' > $X.sorted
foreach? end

Then, do what finalize_csv.csh does...

foreach X (*.three_reps_per_gene)
foreach? echo $X
foreach? cat $X | tr ' ' ',' > $X.csv
foreach? paste $X.csv $X.de.sorted | tr '\t' ',' > $X.final.csv
foreach? end

For a fair comparison, extract Informative Read counts for the same 12 genes.

cat Col_x_Ler.three_reps_per_gene.filtered.final.csv | grep -E 'AT1G55560|AT1G65300|AT2G17690|AT2G32990|AT2G35670|AT3G19350|AT4G10640|AT4G13460|AT4G25530|AT5G26630|AT5G2665|AT5G60440' > twelve_genes.Col_x_Ler.three_reps_per_gene.filtered.final.csv

cat Ler_x_Col.three_reps_per_gene.filtered.final.csv | grep -E 'AT1G55560|AT1G65300|AT2G17690|AT2G32990|AT2G35670|AT3G19350|AT4G10640|AT4G13460|AT4G25530|AT5G26630|AT5G2665|AT5G60440' > twelve_genes.Ler_x_Col.three_reps_per_gene.filtered.final.csv

cat twelve_genes.Col_x_Ler.three_reps_per_gene.filtered.final.csv | tr ',' ' ' | awk '{print $1,$2,$3,$4,$5,$6,$7;}' > Col_x_Ler.three_reps_per_gene

cat twelve_genes.Ler_x_Col.three_reps_per_gene.filtered.final.csv | tr ',' ' ' | awk '{print $1,$2,$3,$4,$5,$6,$7;}' > Ler_x_Col.three_reps_per_gene



Files
=============

parsed_SNPs.txt 
--------------------

Columns:

Gene Genotype Gene.SNP_ID position SNP 21bpFwd 21bpRev

Sample data:

AT1G02790 COL AT1G02790.SNP1 82 . CAAAAAAAAAATAAAGATAT ATATCTTTATTTTTTTTTTG
AT1G02790 LER AT1G02790.SNP1 83 A CAAAAAAAAAAATAAAGATAT ATATCTTTATTTTTTTTTTTG
AT1G02790 COL AT1G02790.SNP2 1011 G CATGGGGTGGGTCAGACCCAA TTGGGTCTGACCCACCCCATG
AT1G02790 LER AT1G02790.SNP2 1012 T CATGGGGTGGTTCAGACCCAA TTGGGTCTGAACCACCCCATG

count_SNP.Col_x_Ler.log, count_SNP.Ler_x_Col.log
------------------------------------------------

Read coverage per SNP obtained by grep using count_SNP.sh

Col_x_Ler.csv, Ler_x_Col.csv
----------------------------

Read coverage per SNP, one line per SNP, obtained using log_to_csv.sh

Columns:

SNP_ID,
COL-Fwd-R1-BR1,COL-Fwd-R1-BR2,COL-Fwd-R1-BR3,
COL-Fwd-R2-BR1,COL-Fwd-R2-BR2,COL-Fwd-R2-BR3,
COL-Rev-R1-BR1,COL-Rev-R1-BR2,COL-Rev-R1-BR3,
COL-Rev-R1-BR2,COL-Rev-R2-BR2,COL-Rev-R2-BR3,
LER-Fwd-R1-BR1,LER-Fwd-R1-BR2,LER-Fwd-R1-BR3,
LER-Fwd-R2-BR1,LER-Fwd-R2-BR2,LER-Fwd-R2-BR3,
LER-Rev-R1-BR1,LER-Rev-R1-BR2,LER-Rev-R1-BR3,
LER-Rev-R1-BR2,LER-Rev-R2-BR2,LER-Rev-R2-BR3,

Sample data:

AT1G55560.SNP1393,9,0,0,24,11,2,7,2,1,11,5,15,0,0,0,24,28,36,1,1,0,0,1,2
AT1G55560.SNP1394,19,13,7,316,128,360,409,137,238,11,3,7,48,10,18,513,526,894,639,376,667,44,4,16
AT1G55560.SNP1395,20,10,14,354,154,204,368,129,256,10,10,14,33,17,60,403,340,545,417,495,485,47,19,58


Col_x_Ler.three_reps_per_gene, Ler_x_Col.three_reps_per_gene
------------------------------------------------------------

Six values of read coverage per gene, taken from one representative SNP per gene. 

Generated from Col_x_Ler.csv, Ler_x_Col.csv

Generated by running from_SNP_to_read_counts.sh which runs from_SNP_to_read_counts.pl

Sample data:

AT1G55560 361 142 230 436 357 605
AT1G65300 3001 2637 2736 1301 1214 1289

Comparison
==========

For 12 genes, run max-min-SNP-count through limma as well is IR counts for same genes.

Generate i.e. Col_x_Ler.three_reps_per_gene.filtered.final.csv for 12 genes using max min SNP count.

Generate IR csv files i.e. twelve_genes.Col_x_Ler.three_reps_per_gene.filtered.final.csv

Compare in Excel. CORREL(FC) is 0.77 (but the stats do not correlate).

In Excel, the one outlier by FC is AT2G35670. 
Interestingly, this gene has 3 alignments to self.
Also, the SNP count at one SNP gives counts almost as high as the IR count.



