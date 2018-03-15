#! /usr/bin/perl -w
use strict;

my ($COLUMN_PAIR_NORMALIZATION)=1;  # use 1 normalize by sum of reads in any mat+pat column pair, 0 for none
my ($ADJUSTMENT)=1000000;
my ($DIVIDE_MATERNAL_BY)=2;   # use 1 for no change, 2 for half

my ($cross1name);
my ($cross1column); # Put Col0 (always in column 1 of input) in column 1 or 2 of output?
my (@cross1files);
my ($cross2name);
my ($cross2column);
my (@cross2files);

if (scalar(@ARGV) != 10) {
    &usage();
    die;
}

$cross1name=shift;
$cross1column=shift;
$cross1files[0]=shift;
$cross1files[1]=shift;
$cross1files[2]=shift;

$cross2name=shift;
$cross2column=shift;
$cross2files[0]=shift;
$cross2files[1]=shift;
$cross2files[2]=shift;

sub usage () {
    print STDERR (
	"Usage: prepare_anova(\n".
	"Ler_x_Col\n".
	"2\n".
	"Ler_x_Col_BR1_CGATGT_L007_PAIR_001.Columns_Col_Ler\n".
	"LerxColBR2_S1_L008_PAIR_001.Columns_Col_Ler\n".
	"LerxColBR3_S2_L008_PAIR_001.Columns_Col_Ler\n".
	"Ler_x_Met1-3\n".
	"2\n".
	"Ler_x_met1-3_BR1_ATGTCA_L001_PAIR_001.Columns_Col_Ler\n".
	"Ler_x_met1-3_BR3_GTCCGC_L008_PAIR_001.Columns_Col_Ler\n".
	"Ler_x_met1-3_BR4_GTGAAA_L008_PAIR_001.Columns_Col_Ler\n");
}

my ($outfile)= $cross1name . "_vs_" . $cross2name . ".cross.matrix.csv";
my (@MATRIX);
my ($next_column);
my (@ONE_FILE);
my ($MEASURES)=2;
my ($REPLICATES)=3;
my ($OUTPUT_COLUMNS)= 1 + 6 + 6;  # gene, 3*(mat,pat), 3*(mat,pat)
&create_matrix();
&normalize_matrix() if (1==$COLUMN_PAIR_NORMALIZATION);
&print_matrix();

exit 0;

sub normalize_matrix() {
    my ($row,$rows);
    my ($col,$cols);
    $rows=scalar(@MATRIX);
    $cols=$OUTPUT_COLUMNS;
    my (@SUMS);
    my ($pair_sum);
    my ($old_val,$new_val);
    # Always skip col=0 which holds gene name
    for ($row=0; $row<$rows; $row++) {	
	for ($col=1; $col<$cols; $col++) {
	    $SUMS[$col]+=$MATRIX[$row][$col];
	}
    }
    for ($col=1; $col<$cols; $col+=2) {
	$pair_sum = $SUMS[$col]+$SUMS[$col+1];
	$SUMS[$col]=$pair_sum;
	$SUMS[$col+1]=$pair_sum;
    }
    for ($row=0; $row<$rows; $row++) {	
	for ($col=1; $col<$cols; $col++) {
	    $old_val= $MATRIX[$row][$col];
	    $new_val= $ADJUSTMENT * $MATRIX[$row][$col] / $SUMS[$col];
	    if ($old_val>0 && $new_val<0.005) {
		print STDERR "WARNING: Count old_val normalized to zero in gene $MATRIX[$row][0]\n";
	    }
	    $MATRIX[$row][$col]= $new_val;
	}
    }
}

sub print_matrix () {
    my ($row,$rows);
    my ($col,$cols);
    $rows=scalar(@MATRIX);
    $cols=$OUTPUT_COLUMNS;
    open ("OUTF", ">$outfile") or die ("Cannot open $outfile");
    print OUTF "## Tables for ANOVA\n";
    print OUTF "## Cross1: $cross1name\n"; 
    print OUTF "##         Col0 input in column 1, output in column $cross1column\n";
    print OUTF "##         Input 1 $cross1files[0]\n";
    print OUTF "##         Input 2 $cross1files[1]\n";
    print OUTF "##         Input 3 $cross1files[2]\n";
    print OUTF "## Cross2: $cross2name\n";
    print OUTF "##         Col0 input in column 1, output in column $cross2column\n";
    print OUTF "##         Input 1 $cross2files[0]\n";
    print OUTF "##         Input 2 $cross2files[1]\n";
    print OUTF "##         Input 3 $cross2files[2]\n";
    print OUTF "## Output matrix has $rows rows.\n";
    print OUTF "## Columns are: cross1/replicate1/mat, cross1/replicate1/pat, cross1,replicate2/mat, ...\n";
    for ($row=0; $row<$rows; $row++) {	
	printf OUTF "%s," , $MATRIX[$row][0]; # gene
	for ($col=1; $col<$cols-1; $col++) {
	    printf OUTF "%4.2f," , $MATRIX[$row][$col];
	}	
	printf OUTF "%4.2f\n" , $MATRIX[$row][$col];
    }
    close (OUTF);
}
    
sub create_matrix () {
    $next_column=0;
    &load_files (1);
    &load_files (2);
}

sub load_files () {
    my ($which_cross)=shift;
    my ($filename)="x";
    my ($replicate);
    my ($column_for_col)=0;
    for ($replicate = 0; $replicate < $REPLICATES; $replicate++) {
	if ($which_cross==1) {
	    $filename = $cross1files[$replicate] ;
	    $column_for_col = $cross1column;
	} else {
	    $filename = $cross2files[$replicate] ;
	    $column_for_col = $cross2column;
	}
	&load_one_file($filename,$column_for_col);
	&add_one_file_to_matrix();
    }
}

sub add_one_file_to_matrix() {
    my ($row);
    my ($maternal_count,$paternal_count);
    if ($next_column==0) {
	for ($row=0; $row<scalar(@ONE_FILE); $row++) {
	    $MATRIX[$row][$next_column]=$ONE_FILE[$row][0]; 
	}
	$next_column++;
    }
    for ($row=0; $row<scalar(@ONE_FILE); $row++) {
	$maternal_count = $ONE_FILE[$row][1];
	$paternal_count = $ONE_FILE[$row][2];
	$maternal_count /= $DIVIDE_MATERNAL_BY;
	$MATRIX[$row][$next_column+0] = $maternal_count;
	$MATRIX[$row][$next_column+1] = $paternal_count;
    }
    $next_column += 2; # each  file adds two columns
}

sub load_one_file() {
    my ($filename)=shift;
    my ($column_for_col)=shift;
    die ("Invalid column_for_col $column_for_col") unless ($column_for_col==1 || $column_for_col==2);
    my ($column_for_other) = ($column_for_col==1) ? 2 : 1;
    my ($line);
    my (@FIELDS);
    my ($num)=0;
    open (INF, "<$filename") or die ("Cannot open $filename");
    while (<INF>) {
	chomp;
	$line=$_;
	@FIELDS=split(' ',$line);
	$ONE_FILE[$num][0]=$FIELDS[0]; # gene
	$ONE_FILE[$num][$column_for_col]=$FIELDS[1]; # read count for Col0
	$ONE_FILE[$num][$column_for_other]=$FIELDS[2]; # read count for other
	$num++;
    }
    close (INF);
}

