#!/bin/sh 

date
echo "Get all transcript IDs and sort them"
date
echo SORT
cat Both.*.differential_mapping.txt \
    | cut -d ' ' -f 2 | uniq | sort | uniq > tmp.useful_transcripts.txt

DATA[1]=Both.Col0_x_Col0_BR1_CAGATC_L007.differential_mapping.txt
DATA[2]=Both.ColxColBR2_S5_L008.differential_mapping.txt
DATA[3]=Both.Col0_x_Col0_BR3_CTTGTA_L007.differential_mapping.txt
DATA[4]=Both.Ler_x_Ler_BR1_ACAGTG_L007.differential_mapping.txt
DATA[5]=Both.LerxLerBR2_S6_L008.differential_mapping.txt
DATA[6]=Both.Ler_x_Ler_BR3_GCCAAT_L007.differential_mapping.txt

OUTF[1]=Col_Col_BR1
OUTF[2]=Col_Col_BR2
OUTF[3]=Col_Col_BR3
OUTF[4]=Ler_Ler_BR1
OUTF[5]=Ler_Ler_BR2
OUTF[6]=Ler_Ler_BR3

function runall () {
    date
    echo ITERATION $1
    MAPFILE=${DATA[$1]}
    OUTFILE=Table.${OUTF[$1]}.txt
    echo INPUT $MAPFILE
    echo OUTPUT $OUTFILE
    echo "Search for Col hits"
    grep " Col " $MAPFILE | cut -d ' ' -f 2 | sort | uniq -c > tmp.Col.txt
    echo "Search for Ler hits"
    grep " Ler " $MAPFILE | cut -d ' ' -f 2 | sort | uniq -c > tmp.Ler.txt

    echo "Join hits to IDs"
    join -2 2 -e '0' -a 1 -o 1.1,2.1 tmp.useful_transcripts.txt tmp.Col.txt > tmp.1.txt
    join -2 2 -e '0' -a 1 -o 1.1,2.1 tmp.useful_transcripts.txt tmp.Ler.txt > tmp.2.txt

    echo "Print columns: ID, Col-hits, Ler-hits"
    join tmp.1.txt tmp.2.txt > $OUTFILE
}

runall 1
runall 2
runall 3
runall 4
runall 5
runall 6

date
echo CLEANUP
rm tmp.*.txt
