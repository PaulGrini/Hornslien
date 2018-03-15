#!/usr/bin/perl

use strict;
my ($counts_file)=shift;
my ($one_name);
my ($one_count)=0;
my ($names_file)="all_ercc_names.txt";
my (%ERCC_COUNTS);

print STDERR "Reading $names_file ...\n";
open (NAMES, "<$names_file") or die;
while (<NAMES>) {
    my ($line) = $_;
    if ($line =~ /(ERCC-\d+)/) {
	$one_name = $1;
	$ERCC_COUNTS{$one_name}=0;
    } else {
	die ("Unrecognized ERCC name: $line");
    }
}
close (NAMES);
print STDERR "Loaded " . scalar(keys(%ERCC_COUNTS)) . "ERCC names.\n";
    
print STDERR "Reading $counts_file\n";
open (COUNTS, "<$counts_file");
while (<COUNTS>) {
    my ($line) = $_;
    if ($line =~ /(\d+)\s(ERCC-\d+)/) {
	$one_count=$1;
	$one_name=$2;
	die ("Two counts for one ERCC: $line") unless ($ERCC_COUNTS{$one_name} == 0);
	$ERCC_COUNTS{$one_name} = $one_count;
    } else {
	print STDERR "Unrecognized name in ERCC count: $line";
    }
}
close (COUNTS);

print STDERR "Writing to STDOUT ...\n";
my ($ercc);
foreach $ercc (sort(keys(%ERCC_COUNTS))) {
    print STDOUT "$ercc $ERCC_COUNTS{$ercc}\n";
}
