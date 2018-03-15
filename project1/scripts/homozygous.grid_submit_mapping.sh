#!/bin/sh

if [ -z "$SCRIPTDIR" ]; then echo "ERROR SCRIPTDIR NOT SET"; exit 1; fi
echo SCRIPT DIRECTORY $SCRIPTDIR
PWD=`pwd`
echo CURRENT DIRECTORY $PWD
SCRIPT=run_bowtie.sh
echo CHECK SCRIPT ${SCRIPT}
if [ ! -f "${SCRIPTDIR}/${SCRIPT}" ]; then echo "ERROR SCRIPT NOT FOUND"; exit 2; fi

PARAMETER=$1    # 1 or higher
BEST=1
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
    echo MAP ALL TRIMMED FASTQ TO SPECIES REFERENCE
    PATTERN="trim.pair.*_R1_*.fastq"
    TARGET=Imprinted_Transcript1.fasta
    INDEX=INDEX
    mapit
else
    echo MAP ALL TRIMMED FASTQ TO STRAIN REFERENCE
    
    PATTERN="trim.pair.Col*_R1_*.fastq"
    TARGET=Col_x_Col.fasta
    INDEX=Col_x_Col
    mapit

    PATTERN="trim.pair.Ler*_R1_*.fastq"
    TARGET=Ler_x_Ler.fasta
    INDEX=Ler_x_Ler
    mapit

    PATTERN="trim.pair.Tsu*_R1_*.fastq"
    TARGET=Tsu_x_Tsu.fasta
    index=Tsu_x_Tsu
    mapit
fi

exit


