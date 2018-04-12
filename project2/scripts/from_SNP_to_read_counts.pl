#! /usr/bin/perl -w
use strict;

# Input the read counts covering each Col or Ler SNP.
# Output count files similar to those for Informative Reads.

die ("Usage: $0 <filename> ") unless (scalar(@ARGV)==1);
# PARAMETERS
my ($DATA_FILE) = $ARGV[0];

# CONSTANTS
my ($FLOAT_UNITY)=1.0;
my ($PSEUDOCOUNT)=1.0; 
my ($FIELDS_PER_LINE)=3;
my ($PASS,$FAIL)=(1,0);

# GLOBALS
my (%ALL_DATA); # hash ( gene, array_of_lines )

print STDERR "Reading $DATA_FILE...\n";
&read_infile();
&all_genes();
print STDERR "Done.\n";

# Load a clump of input lines that all pertain to the same gene.
sub all_genes () {
    my ($gene);
    my ($line);
    foreach $gene (sort (keys (%ALL_DATA))) {
	$line = one_gene ($gene);
	print STDERR "$line\n";
    }
}

# For one gene, parse every line, and retain the one line with largest numbers.
# Define largest as having the largest minimum (min_max).
# In case of a tie for min, define largest as having the largest maximum (max_max).
sub one_gene () {
    my ($gene) = shift;
    my ($elements) = scalar ( @{ $ALL_DATA{$gene} } );
    my ($line);
    my (@array);
    my (@FIELDS);
    my ($min_this_line,$max_this_line);
    my ($max_min,$max_max);
    my ($line_with_max_min);
    my ($ii,$jj);
    my ($INFINITY)=1000000;
    $max_min= -1;
    $max_max= -1;
    for ($ii=0; $ii<$elements; $ii++) {
	$line = @{$ALL_DATA{$gene}}[$ii];
	@FIELDS = split (',', $line);
	$min_this_line = $INFINITY;
	$max_this_line = 0;
	for ($jj=1; $jj<=24; $jj++) {
	    # Fields 4 - 9 are Col rev Read 1 (reps 1,2,3) and fwd Read 2 (reps 1,2,3).
	    # Fields 16-21 are Ler rev Read 1 (reps 1,2,3) and fwd Read 2 (reps 1,2,3).	    
	    if ($jj>=4 && $jj<=9 || $jj>=16 && $jj<=21) {
		if ($FIELDS[$jj]<$min_this_line) {
		    $min_this_line=$FIELDS[$jj];
		}
		if ($FIELDS[$jj]>$max_this_line) {
		    $max_this_line=$FIELDS[$jj];
		}
	    }
	}
	if ($min_this_line>$max_min || $min_this_line==$max_min && $max_this_line>$max_max) {
	    $max_min=$min_this_line;
	    $max_max=$max_this_line;
	    $line_with_max_min=$line;
	}
    }
    return $line_with_max_min;
}

# Input files like this:
# $ head Ler_x_Col.csv 
#AT1G55560.SNP1393,1,0,0,50,10,16,8,8,3,4,2,2,0,0,0,22,0,0,1,3,1,1,4,1
#AT1G55560.SNP1394,3,5,4,763,669,1007,661,462,1048,7,5,15,83,24,13,248,9,26,250,5,45,63,15,14
#AT1G55560.SNP1395,1,0,28,627,403,583,701,425,627,0,0,68,35,46,12,246,24,36,234,25,54,28,53,26
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
