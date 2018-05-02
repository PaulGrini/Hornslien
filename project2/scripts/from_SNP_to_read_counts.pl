#! /usr/bin/perl -w
use strict;

# Input the read counts covering each Col or Ler SNP.
# Examples:  Col_x_Ler.csv  or  Ler_x_Col.csv
# Output count files similar to those for Informative Reads.

# Although this script mentions Col_x_Ler explicitly,
# Col and Ler are really just place markers.
# The script should work for Col_x_Tsu any cross at all.

# Mimic Informative Reads files where...
# ColLerBR1.Columns_Col_Ler files contain one line per gene with gene name, Col count, Ler count.
#   These files always list Col before Ler.
# ColLerBR1.Columns_Col_Ler.half from cut_materinal_in_half.sh
#   These files also list Col before Ler.
#   For Col_x_Ler the script cut column 2 (Col) in half.
#   For Ler_x_Col the script cut column 3 (Ler) in half.
# ColLer.three_reps_per_gene files generated by collate_three_reps_per_gene.sh 
#   These files list maternal before paternal, for 3 biological replicates.
#   For Col_x_Ler the script used reversal=1 i.e retain columns to output: gene Col Col Col Ler Ler Ler
#   For Ler_x_Col the script used reversal=2 i.e.  swap columns to output: gene Ler Ler Ler Col Col Col

# PARAMETERS
die ("Usage: $0 <Col|Ler> <filename> ") unless (scalar(@ARGV)==2);
die ("Usage: $0 <Col|Ler> <filename> ") unless ($ARGV[0] eq "Col" || $ARGV[0] eq "Ler");
my ($MATERNAL) = $ARGV[0];
my ($DATA_FILE) = $ARGV[1];
print STDERR "Maternal = $MATERNAL\n";
print STDERR "Input File = $DATA_FILE\n";

# CONSTANTS
my ($INFINITY)=1000000;

# GLOBALS
my (%ALL_DATA); # hash ( gene, array_of_lines )

# MAIN
print STDERR "Reading...\n";
&read_infile();
&all_genes();
print STDERR "Done.\n";

# For one gene,
# Review several lines of data (one line per SNP), 
# Choose one line of data as representative.
# Then use the counts on that line,
# And output count files similar to Informative Reads.
sub all_genes () {
    my ($gene);
    my ($line);
    my (@FIELDS);
    my (@MatBR) = (0,0,0,0);
    my (@PatBR) = (0,0,0,0);
    my ($i,$m1,$m2,$p1,$p2);
    foreach $gene (sort (keys (%ALL_DATA))) {
	$line = one_gene ($gene);
	#print STDERR "$line\n";
	@FIELDS = split (',', $line);	
	# Fields 1 - 3 are Col fwd Read 1 (reps 1,2,3) 
	# Fields 4 - 6 are Col rev Read 1 (reps 1,2,3) 
	# Fields 7 - 9 are Col fwd Read 2 (reps 1,2,3)
	# Fields 10-12 are Col rev Read 2 (reps 1,2,3)
	# Fields 13-15 are Ler fwd Read 1 (reps 1,2,3)
	# Fields 16-18 are Ler rev Read 1 (reps 1,2,3)
	# Fields 19-21 are Ler fwd Read 2 (reps 1,2,3)	    
	# Fields 22-24 are Ler rev Read 2 (reps 1,2,3)	    
	if ($MATERNAL eq "Col") {
	    $m1=4;  # first of 3 reps for Col R1 rev
	    $m2=7;  # first of 3 reps for Col R2 fwd
	    $p1=16;   # first of 3 reps for Ler R1 rev 
	    $p2=19;   # first of 3 reps for Ler R2 fwd
	} else {
	    $m1=16;   # first of 3 reps for Ler R1 rev 
	    $m2=19;   # first of 3 reps for Ler R2 fwd
	    $p1=4;  # first of 3 reps for Col R1 rev
	    $p2=7;  # first of 3 reps for Col R2 fwd
	}
	print STDERR " Gene $gene was represented by this SNP count line: $line\n";
	print STDERR " Compute Mat BR1 from ($FIELDS[$m1] + $FIELDS[$m2]) / 2 \n";
	print STDERR " Compute Pat BR1 from ($FIELDS[$p1] + $FIELDS[$p2]) \n";
	for ($i=1; $i<=3; $i++) {
	    $MatBR[$i] = $FIELDS[$m1++] + $FIELDS[$m2++];
	    $MatBR[$i] = int (0.5+$MatBR[$i]/2.0); # cut maternal in half, then round to integer
	    $PatBR[$i] = $FIELDS[$p1++] + $FIELDS[$p2++];      
	}
	print STDERR "Output $gene $MatBR[1] $MatBR[2] $MatBR[3] $PatBR[1] $PatBR[2] $PatBR[3]\n";
	print STDOUT "$gene $MatBR[1] $MatBR[2] $MatBR[3] $PatBR[1] $PatBR[2] $PatBR[3]\n";
    }
}

# For one gene, parse every line, and retain the one line with largest numbers.
# Define largest line as line whose max value is the max value over all genes.
# Example returned strings:
# AT1G55560.SNP1395,20,10,14,354,154,204,368,129,256,10,10,14,33,17,60,403,340,545,417,495,485,47,19,58
# AT1G65300.SNP2053,7,0,16,3021,2569,2776,2980,2704,2696,7,0,16,2,1,0,1299,1213,1289,1297,1193,1454,2,0,0
sub one_gene () {
    my ($gene) = shift;
    my ($elements) = scalar ( @{ $ALL_DATA{$gene} } );
    my ($line);
    my (@array);
    my (@FIELDS);
    my ($max_this_line);
    my ($max_this_gene);
    my ($line_with_max);
    my ($ii,$jj);
    $max_this_gene= -1;
    for ($ii=0; $ii<$elements; $ii++) {
	$line = @{$ALL_DATA{$gene}}[$ii];
	@FIELDS = split (',', $line);
	$max_this_line = -1;
	for ($jj=1; $jj<=24; $jj++) {
	    if ($jj>=4 && $jj<=9 || $jj>=16 && $jj<=21) {
		if ($FIELDS[$jj]>$max_this_line) {
		    $max_this_line=$FIELDS[$jj];
		}
	    }
	}
	if ($max_this_line>$max_this_gene) {
	    $max_this_gene=$max_this_line;
	    $line_with_max=$line;
	}
    }
    return $line_with_max;
}

# Input files like this:
# $ head Ler_x_Col.csv 
#AT1G55560.SNP1393,1,0,0,50,10,16,8,8,3,4,2,2,0,0,0,22,0,0,1,3,1,1,4,1
#AT1G55560.SNP1394,3,5,4,763,669,1007,661,462,1048,7,5,15,83,24,13,248,9,26,250,5,45,63,15,14
#AT1G55560.SNP1395,1,0,28,627,403,583,701,425,627,0,0,68,35,46,12,246,24,36,234,25,54,28,53,26
#
# Field 0 is gene
# Fields 1 - 3 are Col fwd Read 1 (reps 1,2,3) * noise
# Fields 4 - 6 are Col rev Read 1 (reps 1,2,3) * signal
# Fields 7 - 9 are Col fwd Read 2 (reps 1,2,3) * signal
# Fields 10-12 are Col rev Read 2 (reps 1,2,3) * noise
# Fields 13-15 are Ler fwd Read 1 (reps 1,2,3) * noise
# Fields 16-18 are Ler rev Read 1 (reps 1,2,3) * signal
# Fields 19-21 are Ler fwd Read 2 (reps 1,2,3) * signal
# Fields 22-24 are Ler rev Read 2 (reps 1,2,3) * noise
#
# Load the ALL_DATA hash of key=gene to value=array of input lines.

sub read_infile () {
    my ($line);
    my ($elements);
    my ($line_count)=0;
    my (@array);
    my ($gene_count)=0;
    my ($prev_gene)="";
    my ($ii);
    open (INFILE, "<$DATA_FILE") or die ("Cannot open $DATA_FILE");
    while (<INFILE>) {
	chomp;
	$line = $_;
	# Get gene name from first 9 characters of each line.
	my ($gene) = substr($line,0,9);
	if ($gene ne $prev_gene) {
	    if ($prev_gene ne "") {
		@{$ALL_DATA{$prev_gene}} = @array;
		$gene_count++;
	    }
	    @array = [];
	    $ii=0;
	    $prev_gene = $gene;
	}
	$array[$ii++]=$line;
	$line_count++;
    }
    close (INFILE);
    @{$ALL_DATA{$prev_gene}} = @array;   # add the last gene
    $gene_count++;
    print STDERR "Input lines: $line_count\n";
    print STDERR "Input genes: $gene_count\n";
}
