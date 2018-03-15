#! /usr/local/bin/perl -w
use strict;

# The goal is to choose well-performing genes.
# Use mapped reads from a control i.e. reads from a homozygous cross mapped to heterzygous bait sequences.
# For example, map reads from a Col_x_Col cross to the Col_and_Ler transcript consensus FASTA.
# In this example, a gene is well-performing only if significantly the Col consensus attracts more reads than the Ler consensus.

# The procedure is:
# Take a list of genes and their mapped read counts.
# Apply minimum read count and minimum fold change filters.
# Write the list of genes that pass filter.

# Input format for CONTROL_FILE.
# Lines must contain gene space count space count.
# Example: AT1G02790.1 1398 74
# If a gene appears more than once, we assume those are results from biological replicates.
# For 3 biological replicates, you may supply the concatenation of 3 files.

# Input parameter EXPECT.
# Each input line contains a gene and two counts.
# Which count is expected to be larger?
# If told to expect the first count is larger, we require ((Count1-Count2)/Count2 > min_fold.

die ("Usage: $0 <filename> <1|2> <min_count> <min_total> <min_fold>") unless (scalar(@ARGV)==5);
# PARAMETERS
my ($CONTROL_FILE) = $ARGV[0];
my ($EXPECT) = $ARGV[1];  # For fold computation, which is expected bigger, 1 or 2?
my ($MIN_READS_PER_REPLICATE)=$ARGV[2];  # e.g. require min 50 reads in each replicate 
my ($MIN_READS_PER_GENE)=$ARGV[3];   # e.g. require min 200 reads total across replicates
my ($MIN_FOLD_PER_REPLICATE)=$ARGV[4];   # e.g. require min 5 fold increase in each replicate

# CONSTANTS
my ($FLOAT_UNITY)=1.0;
my ($PSEUDOCOUNT)=1.0;  // using 0.01 generated some astronomical fold changes
my ($FIELDS_PER_LINE)=3;
my ($PASS,$FAIL)=(1,0);

# GLOBALS
my (%LARGER_SUM_PER_GENE);  # column sum over replicates
my (%SMALLER_SUM_PER_GENE); # kept separate in case requirements change
my (%GENE_PASS_FAIL);  # 0 = fail, 1 = pass
my ($num_passed)=0;
my ($num_failed)=0;
my ($VERBOSE)=1;

print STDERR "# Filter data lines by these criteria.\n";
print STDERR "# Input filename $CONTROL_FILE\n";
print STDERR "# Require count $EXPECT is greater in each replicate.\n";
print STDERR "# Require min $MIN_READS_PER_REPLICATE reads in each replicate.\n";
print STDERR "# Require min $MIN_READS_PER_GENE reads in each gene.\n";
print STDERR "# Require min $MIN_FOLD_PER_REPLICATE fold change per replicate.\n";
print STDERR "# Pseudocount $PSEUDOCOUNT.\n";

print STDERR "Reading $CONTROL_FILE...\n";
&read_infile();
print STDERR "Compute totals\n";
&compute_totals();
print STDERR "Writing list of passed genes.\n";
&write_outfile();
print STDERR "Genes passed = $num_passed\n";
print STDERR "Genes failed = $num_failed\n";
print STDERR "Done.\n";

sub compute_totals() {
    my ($gene);
    foreach $gene (keys (%GENE_PASS_FAIL)) {
	if ($GENE_PASS_FAIL{$gene} == $PASS) {
	    my ($larger_sum) = $LARGER_SUM_PER_GENE{$gene};
	    my ($smaller_sum) = $SMALLER_SUM_PER_GENE{$gene};
	    die ("ERROR: No saved values for gene $gene")
		unless (defined($larger_sum) && defined($smaller_sum));
	    my ($total_reads) = $larger_sum+$smaller_sum;
	    if ($total_reads < $MIN_READS_PER_GENE) {
		$GENE_PASS_FAIL{$gene} = $FAIL;	    
		print STDERR "Failed gene $gene for total gene reads = $total_reads\n" unless ($VERBOSE==0);
	    }
	}
    }
}

sub write_outfile() {
    my ($gene);
    foreach $gene (keys (%GENE_PASS_FAIL)) {
	if ($GENE_PASS_FAIL{$gene} == $PASS) {
	    print STDOUT "$gene\n";
	    $num_passed++;
	} else {
	    $num_failed++;
	}
    }
}

sub read_infile () {
    my ($line);
    my (@FIELDS);
    my ($fields);
    my ($gene);
    my ($replicates);
    my ($cnt_passed,$cnt_failed)=(0,0);
    my ($larger_sum,$smaller_sum);
    open (CONTROL, "<$CONTROL_FILE") or die ("Cannot open $CONTROL_FILE");
    while (<CONTROL>) {
	chomp;
	$line = $_;
	# EXAMPLE: AT1G02790.1 1398 74
	@FIELDS = split (' ', $line);
	$fields = scalar(@FIELDS);
	die ("ERROR: Require same number of fields on every line")
	    unless ($fields == $FIELDS_PER_LINE);
	$gene=$FIELDS[0];
	if ($EXPECT==1) {
	    $larger_sum = $FIELDS[1];
	    $smaller_sum = $FIELDS[2];
	} else {
	    $larger_sum = $FIELDS[2];
	    $smaller_sum = $FIELDS[1];
	}	
	# If this is a new gene, set it to PASS.
	if (!defined($GENE_PASS_FAIL{$gene})) {
	    $GENE_PASS_FAIL{$gene} = $PASS;
	}
	$LARGER_SUM_PER_GENE{$gene} += $larger_sum;
	$SMALLER_SUM_PER_GENE{$gene} += $smaller_sum;
	# If this is a replicate of previously tested gene, proced only if it PASSed.
	if ($GENE_PASS_FAIL{$gene} == $PASS) {
	    my ($total_reads) = $larger_sum+$smaller_sum;
	    if ($total_reads < $MIN_READS_PER_REPLICATE) {
		$GENE_PASS_FAIL{$gene} = $FAIL;
		print STDERR "Failed gene $gene for total replicate reads = $total_reads\n" unless ($VERBOSE==0);
	    } else {
		my ($psum) = $smaller_sum;
		$psum += $PSEUDOCOUNT if ($psum==0);
		my ($fold) = $FLOAT_UNITY * ($larger_sum - $smaller_sum) / $psum;
		if ($fold < $MIN_FOLD_PER_REPLICATE) {
		    $GENE_PASS_FAIL{$gene} = $FAIL;
		    print STDERR "Failed gene $gene for replicate fold = $fold\n" unless ($VERBOSE==0);
		}
	    }
	}
    }
    close (CONTROL);
}
