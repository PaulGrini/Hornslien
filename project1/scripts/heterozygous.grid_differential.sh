#!/bin/sh
# Submit to grid the script that detects differential mapping per read.
# This will count reads that align to one parental allele with strong preference.

if [ -z "$SCRIPTDIR" ]; then echo "ERROR SCRIPTDIR NOT SET"; exit 1; fi
echo SCRIPT DIRECTORY $SCRIPTDIR
PWD=`pwd`
echo CURRENT DIRECTORY $PWD
SCRIPT=DetectDifferentialMapping.pl
echo CHECK SCRIPT ${SCRIPT}
if [ ! -f "${SCRIPTDIR}/${SCRIPT}" ]; then echo "ERROR SCRIPT NOT FOUND"; exit 2; fi
if [ -z "$1" ]; then echo "ERROR. MISSING PARAMETER: 1=ColLer 2=ColTsu"; exit 3; fi
PARAMETER=$1   # 1 => map to Col+Ler, 2 => map to Col+Tsu
OUT_SUFFIX="differential_mapping.txt"
SAMTOOLS=/usr/local/bin/samtools
# Memory determined by number of read IDs. The perl script keeps them in a hash.
QSUB="qsub -cwd -A MOLBAR -P 0716 -N DIFF -l memory=4g -j y "

if [ "${PARAMETER}" -eq 1 ]; then
    GENOMES="Col Ler"
else
    GENOMES="Col Tsu"
fi
echo GENOMES $GENOMES

PATTERN="*.bam"
for FF in ${PATTERN} ; do
    BAMFILE=${FF}
    RESULT=${BAMFILE}.${OUT_SUFFIX}
    ls -l "${SCRIPTDIR}/${SCRIPT}" 
    COMMAND="${SAMTOOLS} view ${BAMFILE} | ${SCRIPTDIR}/${SCRIPT} ${GENOMES} > ${RESULT}"
    JOBCONTROL="${QSUB} -o ${PWD} "
    echo ${JOBCONTROL} "${COMMAND}"
    ${JOBCONTROL} "${COMMAND}"
done

echo "DONE"
