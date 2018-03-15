#!/bin/sh

source /usr/local/common/env/python.sh
export BOWTIE_BUILD=/usr/local/bin/bowtie2-build
#export BOWTIE_ALIGN=/usr/local/bin/bowtie2-align-s  # small genome
#export BOWTIE_ALIGN=/usr/local/bin/bowtie2-align-l  # large genome
export BOWTIE_ALIGN=/usr/local/bin/bowtie2           # any genome

THREADS="4"
#ALIGNMENT="--end-to-end --fast"
#ALIGNMENT="--fast-local"
ALIGNMENT="--end-to-end"
FASTQ="-q  --phred33"
#OPTIONS="-mm" # shared memory, dangerous on grid
OPTIONS="--no-unal --no-mixed --no-discordant"  # only good maps in sam

BEST=$1
TARGET=$2
INDEX=$3
R1=$4
R2=$5
BASE=$6
echo -n "PWD "; pwd

echo "RETAIN BEST: $BEST"
echo "MAP TO FASTA: $TARGET"
echo "FASTQ OF READ1: $R1"
echo "FASTQ OF READ2: $R2"
echo "SAM AND BAM FILE: $BASE"

if [ "$BEST" -gt "1" ]; then
    OPTIONS="${OPTIONS} -k $BEST "
fi

function runit () {
    echo "RUN COMMAND"
    echo ${CMD}
    date
    nice ${CMD}
    echo -n $?;    echo " exit status"
    date
}

# This is the command for building the index.
# Run this exactly once.
# Do not run this in parallel with similar jobs.
if [ -e "${INDEX}.1.bt2" ]
then
    echo "Will re-use existing index."
else
    CMD="${BOWTIE_BUILD} ${TARGET} ${INDEX}"
    runit
fi
ls -l *.bt2
    
CMD="${BOWTIE_ALIGN} -p ${THREADS} ${OPTIONS} ${ALIGNMENT} ${FASTQ} -x ${INDEX} -1 ${R1} -2 ${R2} -S ${BASE}.sam"
runit

if [ "$BEST" -gt "1" ]; then
    # When looking for multiple mappings per read, bam should be sorted by read.
    # Since mappings are already listed by read, do not sort.
    echo "CONVERT SAM TO BAM"
    CMD="samtools view -h -b -o ${BASE}.bam ${BASE}.sam"    
else
    # When looking for one best map per read, bam should be sorted by target.
    echo "SORT SAM TO BAM"
    CMD="samtools sort -@ ${THREADS} -O bam -T ${BASE} -o ${BASE}.bam ${BASE}.sam"
fi
runit

date
echo "DONE"
