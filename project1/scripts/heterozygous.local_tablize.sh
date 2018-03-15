#!/bin/sh 

# Form CSV files from all the local *.differential_mapping.txt files.
# This operation is perfomed locally, not on grid.
# This operation uses temp files and may not be safe to run in parallel.
# This could be more efficient in perl (avoid two greps and two sorts).
# For usability, we should test that inputs exist and are sorted.

if [ $# -ne 5 ]
then
    echo "ERROR: Usage: $0 <accessions> <strain> <strain> <infile> <outfile>"
    exit 1
fi
ACCESSIONS=$1   # e.g. Imprinted_Transcript1.accessions (assumed sorted)
STRAIN1=$2      # e.g. Col (must match values in field 2 of infile)
STRAIN2=$3      # e.g. Ler (must match values in field 2 of infile)
INFILE=$4       # e.g. trim.pair.reads1.bam.differential_mapping.txt
OUTFILE=$5      # e.g. reads1.Columns_Col_Ler
echo ACCESSIONS $ACCESSIONS
echo STRAINS $STRAIN1 $STRAIN2
echo INFILE $INFILE
echo OUTFILE $OUTFILE

date
echo "SORT ACCESSIONS"
TMP1="tmp.${STRAIN1}.txt"
TMP2="tmp.${STRAIN2}.txt"
TMP3="tmp.${TMP1}"
TMP4="tmp.${TMP2}"
echo TEMPFILES $TMP1 $TMP2 $TMP3 $TMP4

echo "EXTRACT $STRAIN1 HITS"
grep " ${STRAIN1} " $INFILE | cut -d ' ' -f 2 | sort -T . | uniq -c > $TMP1
echo "EXTRACT $STRAIN2 HITS"
grep " ${STRAIN2} " $INFILE | cut -d ' ' -f 2 | sort -T . | uniq -c > $TMP2

echo "Join hits to IDs"
join -2 2 -e '0' -a 1 -o 1.1,2.1 $ACCESSIONS $TMP1 > $TMP3
join -2 2 -e '0' -a 1 -o 1.1,2.1 $ACCESSIONS $TMP2 > $TMP4

echo "Print columns: ID, Col-hits, Ler-hits"
join $TMP3 $TMP4 > $OUTFILE

date
echo CLEANUP
rm $TMP1 $TMP2 $TMP3 $TMP4
echo DONE
