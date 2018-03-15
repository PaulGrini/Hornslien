#!/usr/bin/perl

use strict;
my ($lengths_file)=shift;
my ($counts_file)=shift;
my (%LENGTHS);

print STDERR "Reading $lengths_file ...\n";
open (LENS, "<$lengths_file") or die;
while (<LENS>) {
    my ($one_name,$one_len);
    my ($line) = $_;
    if ($line =~ /(\d+)\s+(\S+)/) {
	$one_len = $1;
	$one_name = $2;
	$LENGTHS{$one_name}=$one_len;
    } else {
	die ("Cannot parse: $line");
    }
}
close (LENS);
print STDERR "Loaded " . scalar(keys(%LENGTHS)) . " lengths.\n";
    
print STDERR "Reading $counts_file\n";
open (COUNTS, "<$counts_file");
my ($KILOBASE) = 1000;
while (<COUNTS>) {
    my ($one_name,$one_len,$one_count);
    my ($normalized,$scaling);
    my ($line) = $_;
    if ($line =~ /(\S+)\s+(\d+)/) {
	$one_name=$1;
	$one_count=$2;	
    } else {
	die ("Cannot parse: $line");
    }
    $one_len = $LENGTHS{$one_name};
    die ("Unrecognized name: $one_name") unless (defined($one_len));
    $scaling = $one_len / $KILOBASE;
    die ("Divide by zero: $one_name") if ($scaling == 0);
    $normalized = $one_count / $scaling;
    my ($integer_value) = int($normalized+0.5);
    print STDOUT "$one_name $integer_value\n";
}
close (COUNTS);

