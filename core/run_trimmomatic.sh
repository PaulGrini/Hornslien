#!/bin/sh

# Trim the paired reads

# Trimmomatic expects adapter sequence in current directory.
# Choices include: TruSeq3-SE.fa TruSeq3-PE.fa NexteraPE-PE.fa
# TruSeq2 was for GA II. TruSeq3 is for HiSeq, NextSeq, MiSeq.
# The TruSeq3-PE-2.fa file contains TruSeq3-PE plus more. 

# Trimmomatic steps are (with examples)
#ILLUMINACLIP: (2:30:10) Cut adapter and other illumina-specific sequences from the read.
#SLIDINGWINDOW: (4:15) Perform a sliding window trimming, cutting once the average quality within the window falls below a threshold.
#LEADING: (3) Cut bases off the start of a read, if below a threshold quality
#TRAILING: (3) Cut bases off the end of a read, if below a threshold quality
#MINLEN: (36) Drop the read if it is below a specified length

# The Trinity defaults are
# "ILLUMINACLIP:trinityrnaseq/trinity-plugins/Trimmomatic/adapters/TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:4:5 LEADING:5 TRAILING:5 MINLEN:25"

if [ $# -ne 3 ]; then
    echo "ERROR. MISSING PARAMETER"
    echo "Usage: $0 <adapters.fasta> <R1.fastq> <R2.fastq>"
    exit 1
fi
ADAPTERS=$1
if [ ! -f "${ADAPTERS}" ]; then
    echo "ERROR MISSING FILE ${ADAPTERS}";
    exit 2
fi
PARAMETERS="ILLUMINACLIP:${ADAPTERS}:2:30:10 SLIDINGWINDOW:4:5 LEADING:5 TRAILING:5 MINLEN:100"
echo TRIM PARAMETERS $PARAMETERS

JPATH=/usr/local/packages/trimmomatic-0.35
JARFILE=trimmomatic-0.35.jar
echo "LOOKING FOR PROGRAM JAR FILE AND ADAPTER FILE"
echo JPATH ${JPATH}
echo JARFILE ${JARFILE}

ENCODING="-phred33"
ENCODING=""     # trimmomatic will determine this automatically
THREADS="-threads 4"

INFILE1=$2
INFILE2=$3
echo INFILE1 $INFILE1
echo INFILE2 $INFILE2

OUTPAIR1=trim.pair.${INFILE1}
OUTPAIR2=trim.pair.${INFILE2}
OUTSING1=trim.sing.${INFILE1}
OUTSING2=trim.sing.${INFILE2}

date
CMD="java -jar ${JPATH}/${JARFILE} PE ${ENCODING} ${INFILE1} ${INFILE2} ${OUTPAIR1} ${OUTSING1} ${OUTPAIR2} ${OUTSING2} ${PARAMETERS} ${THREADS}"
echo $CMD
$CMD
echo -n $?; echo " exit status"
date
echo "DONE"
