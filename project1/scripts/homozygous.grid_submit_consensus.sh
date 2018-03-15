#!/bin/sh

# Assumes transcript fasta and input bam files (plus their bai index files) in current directory.
# Parameter required:
# 1 => First round of Pilon, map trimmed reads to TAIR transcript fasta.
# 2 => Subsequent round of Pilon, map trimmed reads to the strain-specific Pilon consensus transcript fasta.

if [ -z "$SCRIPTDIR" ]; then echo "ERROR SCRIPTDIR NOT SET"; exit 1; fi
echo SCRIPT DIRECTORY $SCRIPTDIR
CWD=`pwd`
echo CURRENT DIRECTORY $CWD
SCRIPT=run_pilon.sh
echo CHECK SCRIPT ${SCRIPT}
if [ ! -f "${SCRIPTDIR}/${SCRIPT}" ]; then echo "ERROR SCRIPT NOT FOUND"; exit 2; fi

PARAMETER=$1
echo PARAMETER $PARAMETER

if [[ ${PARAMETER} == 1 ]]; then
    qsub -cwd -b n -A MOLBAR -P 0716 -N PILON -l memory=2g -j y -o ${CWD} ${SCRIPTDIR}/${SCRIPT} Imprinted_Transcripts1.fasta Col_x_Col.bam Col_x_Col.pilon${PARAMETER}
    qsub -cwd -b n -A MOLBAR -P 0716 -N PILON -l memory=2g -j y -o ${CWD} ${SCRIPTDIR}/${SCRIPT} Imprinted_Transcripts1.fasta Ler_x_Ler.bam Ler_x_Ler.pilon${PARAMETER}
    qsub -cwd -b n -A MOLBAR -P 0716 -N PILON -l memory=2g -j y -o ${CWD} ${SCRIPTDIR}/${SCRIPT} Imprinted_Transcripts1.fasta Tsu_x_Tsu.bam Tsu_x_Tsu.pilon${PARAMETER}
else
    qsub -cwd -b n -A MOLBAR -P 0716 -N PILON -l memory=2g -j y -o ${CWD} ${SCRIPTDIR}/${SCRIPT} Col_x_Col.fasta Col_x_Col.bam Col_x_Col.pilon${PARAMETER}
    qsub -cwd -b n -A MOLBAR -P 0716 -N PILON -l memory=2g -j y -o ${CWD} ${SCRIPTDIR}/${SCRIPT} Ler_x_Ler.fasta Ler_x_Ler.bam Ler_x_Ler.pilon${PARAMETER}
    qsub -cwd -b n -A MOLBAR -P 0716 -N PILON -l memory=2g -j y -o ${CWD} ${SCRIPTDIR}/${SCRIPT} Tsu_x_Tsu.fasta Tsu_x_Tsu.bam Tsu_x_Tsu.pilon${PARAMETER}
fi


