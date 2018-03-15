#! /usr/local/bin/perl -w
use strict;

my ($GEN1)="Col";
my ($GEN2)="Ler";
if (scalar(@ARGV)==2) {
    $GEN1 = $ARGV[0];
    $GEN2 = $ARGV[1];
}

print STDERR "## Detect Differential Mapping\n";
print STDERR "## Expect two of each target e.g. AT1G01234.1_Col and AT1G01234.1_Ler\n"; 
print STDERR "## Expect data from bam sorted by read name'\n";
print STDERR "## Expect pipe from 'samtools view'\n";
print STDERR "## Genomes $GEN1 $GEN2\n";

my (@FIELDS);
my ($num_fields);
my ($inputs)=0;
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
    $cigar = $FIELDS[$SAM_CIGAR];   # like 151M
    $this_mapq = $FIELDS[$SAM_MAPQ];  # 0 or 1 is not unique, 5 is reliable, 30 is unique
    $secondTarget = $FIELDS[$SAM_RNEXT];   # either "=" for same target, or like AT1G01234.1_Ler
    $templateSize = $FIELDS[$SAM_TLEN];   # distance between mapped reads of a pair
    ++$inputs;
    if ($this_read ne $current_read) {
	&tabulate_one_read_pair();
	# Start to process a new group of mappings for this read.
	$current_read = $this_read;
	$lines_per_read=0;
	$gen1=0;
	$gen2=0;
	$discord = 0;
	$lowest_mapq=$MIN_MAPQ;  
	@TRANSCRIPT = ();
	@CIGAR = ();
	@MISMATCH = ();	
    }
    # Process one line of input.
    # Each input has one read ID but reports on the alignment of this read and its pair.
    # Expect inputs are sorted by read ID.
    # Expect up to 4 alignments per read ID: read1/genome1, read2/genome1, read1/genome2, read2/genome2.
    # Reject any read ID that does not have 4 alignments.
    # Reject any read ID with a discordant map on either genome.
    # For passing reads, require that one genome alignment is substantially better than the other.
    # These are the differentially mapped reads!
    ++$lines_per_read; 
    $lowest_mapq = $this_mapq if ($this_mapq < $lowest_mapq);  # retain min over all alignments per read ID
    $transcript = substr($target,0,11);  # like AT1G01234.1
    $genome = substr($target,-3);  # like Col, Ler, or Tsu
    $NM = "";
    for (my($i)=9; $i<$num_fields; $i++) {
	# Search all the non-required fields of the BAM.
	# These are tag:value pairs in any order
	my ($s) = $FIELDS[$i];
	if (substr($s,0,5) eq "NM:i:") {
	    $NM = $s;
	    last;
	}
    }
    die ("Did not find NM in $showinput") unless (substr($NM,0,5) eq "NM:i:");
    $mismatches = substr($NM,5);
    die ("Did not parse NM in $showinput") 
	unless ($mismatches >= 0);  # does this work like isnumber()?
    if ($secondTarget ne "=" || $templateSize > 400 || $templateSize < -400) {
	$discord = 1;
    }
    my ($quartet);  # array index
    if ($genome eq $GEN1) {  # Col
	$gen1++;	
	$quartet=$gen1-1; # use array index 0 or 1 
    } elsif ($genome eq $GEN2) {   # Ler
	$gen2++;
	$quartet=$gen2+1; # use array index 2 or 3
    } else {
	die ("Unrecognized genome $genome");
    }
    # store 4 cigars like "151M 151M 151M 151M" to detect good & bad mapping 
    $CIGAR[$quartet]=$cigar;
    # store 4 transcipts so we only process reads mapping to same transcript in both genomes
    $TRANSCRIPT[$quartet]=$transcript;  #
    # store 4 mismatch counts so we can compare mappings
    $MISMATCH[$quartet]=$mismatches;
}
# Special case: end of input
&tabulate_one_read_pair();

# Print totals
print STDERR "# $inputs AlignmentsParsed\n";
print STDERR "# $report_wrong_number_mappings PairsWithWrongNumberOfMappings\n";
print STDERR "# $report_too_few_genomes PairsWithTooFewGenomes\n";
print STDERR "# $report_low_mapq PairsWithLowMapQ\n";
print STDERR "# $report_discordant_mappings PairsWithDiscordantMappings\n";
print STDERR "# $report_different_transcripts PairsOnDifferentTranscripts\n";
print STDERR "# $report_total_indels PairsWithIndelDifference\n";
print STDERR "# $report_total_snps PairsWithSnpDifference\n";
print STDERR "# $report_total_findings PairsReported\n";

sub hasIndels () {
    my ($cigarString) = shift;
    if ($cigarString =~ /[ID]/) {
	return 1;
    }
    return 0;
}

sub tabulate_one_read_pair() {
    # Process mappings clumped by read.
    # Expect 4 mappings per read pair.
    if ($this_read lt $current_read) {
	#print STDERR "Was processing: $current_read\n";
	#print STDERR "    This input: $this_read\n";
	#die ("Inputs must be sorted by readname");
	# THIS DOES NOT WORK because samtools uses a funny sort, aware of multi-part numeric IDs.
    }
    if ( $inputs > 1 ) {
	# ignore first transition
	if ($lines_per_read != 4 ) {
	    # ignore pairs unless they map 4 times (2 reads * 2 genomes)
	    ++$report_wrong_number_mappings;
	} elsif ( $lowest_mapq < $MIN_MAPQ ) {
	    # ignore pairs unless map quality (uniqueness) is high
	    ++$report_low_mapq;
	} elsif ( $discord > 0 ) {
	    # ignore pairs unless they map well always
	    ++$report_discordant_mappings;
	} elsif ( $gen1<2 || $gen2<2) { 
	    # ignore pairs unles they map twice to each genome
	    ++$report_too_few_genomes;
	} elsif ($TRANSCRIPT[0] ne $TRANSCRIPT[1]
		 || $TRANSCRIPT[1] ne $TRANSCRIPT[2]
		 || $TRANSCRIPT[2] ne $TRANSCRIPT[3]) {
	    # Ignore pairs unless they map to same transcript always
	    ++$report_different_transcripts;
	} else {
	    my ($str1)="$CIGAR[0] $CIGAR[1]";
	    my ($str2)="$CIGAR[2] $CIGAR[3]";
	    if (! &hasIndels($str1) && ! &hasIndels($str2)) {
		if ($MISMATCH[0]+$MISMATCH[1] < $MISMATCH[2]+$MISMATCH[3]) {
		    print STDOUT 
			"$current_read $transcript $GEN1 SNP $MISMATCH[0] $MISMATCH[1] $MISMATCH[2] $MISMATCH[3]\n";
		    ++$report_total_snps;
		    ++$report_total_findings;
		} elsif ($MISMATCH[0]+$MISMATCH[1] > $MISMATCH[2]+$MISMATCH[3]) {
		    print STDOUT 
			"$current_read $transcript $GEN2 SNP $MISMATCH[0] $MISMATCH[1] $MISMATCH[2] $MISMATCH[3]\n";
		    ++$report_total_snps;
		    ++$report_total_findings;
		}
	    } elsif (! &hasIndels($str1) && &hasIndels($str2)) {
		print STDOUT 
		    "$current_read $transcript $GEN1 INDEL $CIGAR[0] $CIGAR[1] $CIGAR[2] $CIGAR[3]\n";
		++$report_total_indels;
		++$report_total_findings;
	    } elsif (! &hasIndels($str2) && &hasIndels($str1)) {
		print STDOUT 
		    "$current_read $transcript $GEN2 INDEL $CIGAR[0] $CIGAR[1] $CIGAR[2] $CIGAR[3]\n";
		++$report_total_indels;
		++$report_total_findings;
	    }
	}
    }
}
	
