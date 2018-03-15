#!/bin/sh

if [ -z "$SCRIPTDIR" ]; then echo "ERROR SCRIPTDIR NOT SET"; exit 1; fi
echo SCRIPT DIRECTORY $SCRIPTDIR
CWD=`pwd`
echo CURRENT DIRECTORY $CWD
SCRIPT=run_trimmomatic.sh
echo CHECK SCRIPT ${SCRIPT}
if [ ! -f "${SCRIPTDIR}/${SCRIPT}" ]; then echo "ERROR SCRIPT NOT FOUND"; exit 2; fi

ADAPTERS="adapters.fasta"
if [ ! -f "${ADAPTERS}" ]; then echo "ERROR. MAKE A LOCAL COPY OF ADAPTERS."; exit 3; fi

# Avoid recursive processing of any files left from previous runs!
echo REMOVE LEFTOVERS
rm -iv trim.pair.*.fastq
rm -iv trim.sing.*.fastq

PATTERN="*_R1_*.fastq"
for FF in ${PATTERN} ; do
    R1=${FF}
    R2=`echo ${R1} | sed 's/_R1_/_R2_/'`
    echo R1 R2 $R1 $R2

    if [ -f "${R1}" ] && [ -f "${R2}" ]; then
	qsub -cwd -b n -A MOLBAR -P 0716 -N TRIMMO -l memory=2g -pe threaded 4 -j y -o ${CWD} ${SCRIPTDIR}/${SCRIPT} ${ADAPTERS} ${R1} ${R2}
    else
	echo "ERROR DATA FILES NOT FOUND ${R1}, ${R2}"
	exit 4
    fi	    
done
