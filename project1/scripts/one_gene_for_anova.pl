#! /usr/bin/perl -w
use strict;

if (scalar(@ARGV) != 3) {
    &usage();
    die;
}

my($CROSS1)=shift;
my($CROSS2)=shift;
my($GENE)=shift;
#print STDERR "Reading from STDIN...\n";
#print STDERR "Writing to STDOUT...\n";

&process($CROSS1,$CROSS2,$GENE);

sub usage () {
    print STDERR (
	"Usage: $0 <cross> <gene> < file\n");
}

sub process {
    my($cross1)=shift;
    my($cross2)=shift;
    my($gene_name)=shift;
    my($line);
    my(@FIELDS);
    my($ii)=0;
    my($cn1) = "\"$cross1\"";
    my($cn2) = "\"$cross2\"";
    my($mat) = "\"mat\"";
    my($pat) = "\"pat\"";
    print STDOUT "\"cross\",\"parent\",\"reads\"\n";
    while (<STDIN>) {
	chomp;
	$line=$_;
	if ( substr($line,0,1) ne "#" ) {
	    if ( $line =~ /^${gene_name},/) {
		@FIELDS = split ( /,/, $line);
		print STDOUT "$cn1,$mat,$FIELDS[++$ii]\n";
		print STDOUT "$cn1,$pat,$FIELDS[++$ii]\n";
		print STDOUT "$cn1,$mat,$FIELDS[++$ii]\n";
		print STDOUT "$cn1,$pat,$FIELDS[++$ii]\n";
		print STDOUT "$cn1,$mat,$FIELDS[++$ii]\n";
		print STDOUT "$cn1,$pat,$FIELDS[++$ii]\n";
		print STDOUT "$cn2,$mat,$FIELDS[++$ii]\n";
		print STDOUT "$cn2,$pat,$FIELDS[++$ii]\n";
		print STDOUT "$cn2,$mat,$FIELDS[++$ii]\n";
		print STDOUT "$cn2,$pat,$FIELDS[++$ii]\n";
		print STDOUT "$cn2,$mat,$FIELDS[++$ii]\n";
		print STDOUT "$cn2,$pat,$FIELDS[++$ii]\n";
	    }
	}
    }
}
