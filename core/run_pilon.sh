#!/bin/sh

# Requirement: a samtools index for each bam
# samtools index <bam>
# Uses about 18 GB RAM

FASTA=$1
BAMFILE=$2
BASENAME=$3

echo FASTA $FASTA
echo BAMFILE $BAMFILE
echo BASENAME $BASENAME
OUTPUTS=${BASENAME}    # Pilon writes *.fasta and *.changes

JAVA="/usr/local/bin/java"
which ${JAVA}
${JAVA} -showversion |& head -n 4
PILON="${JAVA} -Xmx16G -jar /local/ifs2_pi_data/jmiller/software/pilon/pilon-1.18.jar"
echo PILON ${PILON}

# Here are some interesting options
OPTIONS="--diploid "   # assume diploid
OPTIONS="--vcf"   # output a VCF
OPTIONS="--variant"   # heuristic for variants not assembly
OPTIONS="--fix all"   # correct bases, indels, and local misassembly and write a FASTA file
OPTIONS="--changes"   # show changes to the FASTA

# This set of options to generate the ColCol or the LerLer genome.
OPTIONS="--fix all --changes"
echo OPTIONS ${OPTIONS}

date
echo START PILON
${PILON} --genome ${FASTA} --frags ${BAMFILE} ${OPTIONS} --output ${OUTPUTS}
echo -n $?; echo " exit status"
echo DONE PILON
date
