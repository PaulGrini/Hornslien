#! /usr/local/bin/perl -w
use strict;

my (@FIELDS);
my ($num_fields);
my (%HITCOUNT);
my ($inputs)=0;
my ($outputs)=0;
my ($showinput);
my ($current_read)="";
my ($this_read);
my ($lines_per_read)=0;
my ($target);
my ($genome,$gen1,$gen2);
my ($cigar);
my (@CIGAR)=();
my ($NM,$mismatches);
my (@MISMATCH)=();
my ($transcript);
my (@TRANSCRIPT)=();
my ($discord)=0;
my ($this_mapq)=0;
my ($lowest_mapq)=0;
my ($secondTarget,$templateSize);
my ($report_wrong_number_mappings)=0;
my ($report_too_few_genomes)=0;
my ($report_low_mapq)=0;
my ($report_discordant_mappings)=0;
my ($report_different_transcripts)=0;
my ($report_total_indels)=0;
my ($report_total_snps)=0;
my ($report_total_findings)=0;

my ($SAM_MANDATORY_FIELDS)=11;
# subtract 1 to get FIELDS array index
my ($SAM_QNAME)=1-1;
my ($SAM_FLAG)=2-1;
my ($SAM_RNAME)=3-1;
my ($SAM_POS)=4-1;
my ($SAM_MAPQ)=5-1;
my ($SAM_CIGAR)=6-1;
my ($SAM_RNEXT)=7-1;
my ($SAM_PNEXT)=8-1;
my ($SAM_TLEN)=9-1;
my ($SAM_SEQ)=10-1;
my ($SAM_QUAL)=11-1;
my ($MIN_MAPQ)=5;   # arbitrary cutoff

while (<STDIN>) {
    chomp;
    $showinput=$_;
    @FIELDS=split;
    $num_fields = scalar(@FIELDS);
    die ("Only $num_fields fields") unless ($num_fields >= $SAM_MANDATORY_FIELDS);  
    $this_read = $FIELDS[$SAM_QNAME];
    $target = $FIELDS[$SAM_RNAME];   # like AT1G01234.1_Col
    $target = substr($target,0,11);  # like AT1G01234.1
    $cigar = $FIELDS[$SAM_CIGAR];   # like 151M
    ++$inputs;
    if ($this_read ne $current_read) {
	$HITCOUNT{$target} += 2;    # assume both reads of pair hit same gene
	$current_read = $this_read;
	$outputs++;
    }
}
print STDERR "# $inputs AlignmentsParsed\n";
foreach $target (keys (%HITCOUNT)) {
    print STDOUT "$target $HITCOUNT{$target}\n";
}
