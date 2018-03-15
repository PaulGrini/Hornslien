#!/bin/sh

if [ -z "$SCRIPTDIR" ]; then echo "ERROR SCRIPTDIR NOT SET"; exit 1; fi
echo SCRIPT DIRECTORY $SCRIPTDIR
PWD=`pwd`
echo CURRENT DIRECTORY $PWD
SCRIPT=run_bowtie.sh
echo CHECK SCRIPT ${SCRIPT}
if [ ! -f "${SCRIPTDIR}/${SCRIPT}" ]; then echo "ERROR SCRIPT NOT FOUND"; exit 2; fi
if [ -z "$1" ]; then echo "ERROR MISSING PARAMETER 1=ColLer 2=ColTsu"; exit 3; fi

PARAMETER=$1   # 1 => map to Col+Ler, 2 => map to Col+Tsu
echo PARAMETER $PARAMETER
BEST=2        # keep best 2 maps to measure differential mapping of heterozygous reads
echo BEST $BEST

function mapit () {
    for FF in ${PATTERN} ; do
	R1=${FF}
	R2=`echo ${R1} | sed 's/_R1_/_R2_/'`    
	PAIR=`echo ${R1} | sed 's/_R1_/_PAIR_/' | sed 's/.fastq//'`
	echo R1 $R1 R2 $R2 PAIR $PAIR
	if [ -f "${R1}" ] && [ -f "${R2}" ]; then
	    qsub -cwd -b n -A MOLBAR -P 0716 -N BOWTIE -pe threaded 4 -l "memory=2g" \
		 -j y -o ${PWD} ${SCRIPTDIR}/${SCRIPT} $BEST $TARGET $INDEX $R1 $R2 $PAIR
	else
	    echo "ERROR DATA FILES NOT FOUND ${R1}, ${R2}"
	    # Do not exit. Possibly keep looking for other files.
	fi
    done
}

if [ "${PARAMETER}" -eq 1 ]; then
    echo "MAP ALL TRIMMED FASTQ TO COL + LER"
    PATTERN="trim.pair.*_R1_*.fastq"
    TARGET=Col_plus_Ler.fasta
    INDEX=Col_plus_Ler
    mapit
else
    echo "MAP ALL TRIMMED FASTQ TO COL + TSU"
    
    PATTERN="trim.pair.*_R1_*.fastq"
    TARGET=Col_plus_Tsu.fasta
    INDEX=Col_plus_Tsu
    mapit
fi

exit


