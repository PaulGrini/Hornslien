#!/bin/sh

source /usr/local/common/env/python.sh

echo -n "PWD "; pwd
# Do this when using the -t option on qsub.
echo SGE_TASK_ID $SGE_TASK_ID
JOB=$SGE_TASK_ID
echo JOB $JOB
VAL1=$((${JOB}*2-1))
VAL2=$((${JOB}*2))
echo VAL1 $VAL1
echo VAL2 $VAL2

INDEX=ERCC92
echo INDEX $INDEX

DATA[1]=Col0_x_Col0_BR1_CAGATC_L007_R1_001.fastq.gz
DATA[2]=Col0_x_Col0_BR1_CAGATC_L007_R2_001.fastq.gz
DATA[3]=Col0_x_Col0_BR3_CTTGTA_L007_R1_001.fastq.gz
DATA[4]=Col0_x_Col0_BR3_CTTGTA_L007_R2_001.fastq.gz
DATA[5]=Col0_x_Ler_BR2_TGACCA_L007_R1_001.fastq.gz
DATA[6]=Col0_x_Ler_BR2_TGACCA_L007_R2_001.fastq.gz
DATA[7]=Col0_x_Tsu_BR1_ATGTCA_L008_R1_001.fastq.gz
DATA[8]=Col0_x_Tsu_BR1_ATGTCA_L008_R2_001.fastq.gz
DATA[9]=Col0_x_Tsu_BR2_AGTTCC_L001_R1_001.fastq.gz
DATA[10]=Col0_x_Tsu_BR2_AGTTCC_L001_R2_001.fastq.gz
DATA[11]=Col0_x_Tsu_BR3_CCGTCC_L008_R1_001.fastq.gz
DATA[12]=Col0_x_Tsu_BR3_CCGTCC_L008_R2_001.fastq.gz
DATA[13]=ColxColBR2_S5_L008_R1_001.fastq.gz
DATA[14]=ColxColBR2_S5_L008_R2_001.fastq.gz
DATA[15]=ColxLerBR3_S3_L008_R1_001.fastq.gz
DATA[16]=ColxLerBR3_S3_L008_R2_001.fastq.gz
DATA[17]=ColxLerBR4_S4_L008_R1_001.fastq.gz
DATA[18]=ColxLerBR4_S4_L008_R2_001.fastq.gz
DATA[19]=drm1_x_Ler_BR1_GCCAAT_L006_R1_001.fastq.gz
DATA[20]=drm1_x_Ler_BR1_GCCAAT_L006_R2_001.fastq.gz
DATA[21]=drm1_x_Ler_BR2_CAGATC_L006_R1_001.fastq.gz
DATA[22]=drm1_x_Ler_BR2_CAGATC_L006_R2_001.fastq.gz
DATA[23]=drm1_x_Ler_BR4_AGTCAA_L007_R1_001.fastq.gz
DATA[24]=drm1_x_Ler_BR4_AGTCAA_L007_R2_001.fastq.gz
DATA[25]=Ler_x_Col_BR1_CGATGT_L007_R1_001.fastq.gz
DATA[26]=Ler_x_Col_BR1_CGATGT_L007_R2_001.fastq.gz
DATA[27]=LerxColBR2_S1_L008_R1_001.fastq.gz
DATA[28]=LerxColBR2_S1_L008_R2_001.fastq.gz
DATA[29]=LerxColBR3_S2_L008_R1_001.fastq.gz
DATA[30]=LerxColBR3_S2_L008_R2_001.fastq.gz
DATA[31]=Ler_x_drm1_BR1_AGTTCC_L007_R1_001.fastq.gz
DATA[32]=Ler_x_drm1_BR1_AGTTCC_L007_R2_001.fastq.gz
DATA[33]=Ler_x_drm1_BR2_CTTGTA_L006_R1_001.fastq.gz
DATA[34]=Ler_x_drm1_BR2_CTTGTA_L006_R2_001.fastq.gz
DATA[35]=Ler_x_drm1_BR3_ATGTCA_L007_R1_001.fastq.gz
DATA[36]=Ler_x_drm1_BR3_ATGTCA_L007_R2_001.fastq.gz
DATA[37]=Ler_x_Ler_BR1_ACAGTG_L007_R1_001.fastq.gz
DATA[38]=Ler_x_Ler_BR1_ACAGTG_L007_R2_001.fastq.gz
DATA[39]=LerxLerBR2_S6_L008_R1_001.fastq.gz
DATA[40]=LerxLerBR2_S6_L008_R2_001.fastq.gz
DATA[41]=Ler_x_Ler_BR3_GCCAAT_L007_R1_001.fastq.gz
DATA[42]=Ler_x_Ler_BR3_GCCAAT_L007_R2_001.fastq.gz
DATA[43]=Ler_x_mea9_BR1_GTCCGC_L002_R1_001.fastq.gz
DATA[44]=Ler_x_mea9_BR1_GTCCGC_L002_R2_001.fastq.gz
DATA[45]=Ler_x_mea9_BR2_GTGAAA_L002_R1_001.fastq.gz
DATA[46]=Ler_x_mea9_BR2_GTGAAA_L002_R2_001.fastq.gz
DATA[47]=Ler_x_mea9_BR3_ACAGTG_L003_R1_001.fastq.gz
DATA[48]=Ler_x_mea9_BR3_ACAGTG_L003_R2_001.fastq.gz
DATA[49]=Ler_x_met1-3_BR1_ATGTCA_L001_R1_001.fastq.gz
DATA[50]=Ler_x_met1-3_BR1_ATGTCA_L001_R2_001.fastq.gz
DATA[51]=Ler_x_met1-3_BR3_GTCCGC_L008_R1_001.fastq.gz
DATA[52]=Ler_x_met1-3_BR3_GTCCGC_L008_R2_001.fastq.gz
DATA[53]=Ler_x_met1-3_BR4_GTGAAA_L008_R1_001.fastq.gz
DATA[54]=Ler_x_met1-3_BR4_GTGAAA_L008_R2_001.fastq.gz
DATA[55]=Ler_x_met179_BR1_GCCAAT_L008_R1_001.fastq.gz
DATA[56]=Ler_x_met179_BR1_GCCAAT_L008_R2_001.fastq.gz
DATA[57]=Ler_x_met179_BR2_CAGATC_L008_R1_001.fastq.gz
DATA[58]=Ler_x_met179_BR2_CAGATC_L008_R2_001.fastq.gz
DATA[59]=Ler_x_met179_BR3_CTTGTA_L008_R1_001.fastq.gz
DATA[60]=Ler_x_met179_BR3_CTTGTA_L008_R2_001.fastq.gz
DATA[61]=Ler_x_nrpE1_BR1_AGTCAA_L002_R1_001.fastq.gz
DATA[62]=Ler_x_nrpE1_BR1_AGTCAA_L002_R2_001.fastq.gz
DATA[63]=Ler_x_nrpE1_BR2_AGTTCC_L002_R1_001.fastq.gz
DATA[64]=Ler_x_nrpE1_BR2_AGTTCC_L002_R2_001.fastq.gz
DATA[65]=Ler_x_nrpE1_BR4_CGATGT_L003_R1_001.fastq.gz
DATA[66]=Ler_x_nrpE1_BR4_CGATGT_L003_R2_001.fastq.gz
DATA[67]=Ler_x_rdr6_BR1_CTTGTA_L003_R1_001.fastq.gz
DATA[68]=Ler_x_rdr6_BR1_CTTGTA_L003_R2_001.fastq.gz
DATA[69]=Ler_x_rdr6_BR2_TGACCA_L006_R1_001.fastq.gz
DATA[70]=Ler_x_rdr6_BR2_TGACCA_L006_R2_001.fastq.gz
DATA[71]=Ler_x_rdr6_BR4_ACAGTG_L006_R1_001.fastq.gz
DATA[72]=Ler_x_rdr6_BR4_ACAGTG_L006_R2_001.fastq.gz
DATA[73]=mea9_x_Ler_BR1_ATGTCA_L002_R1_001.fastq.gz
DATA[74]=mea9_x_Ler_BR1_ATGTCA_L002_R2_001.fastq.gz
DATA[75]=mea9_x_Ler_BR2_CCGTCC_L002_R1_001.fastq.gz
DATA[76]=mea9_x_Ler_BR2_CCGTCC_L002_R2_001.fastq.gz
DATA[77]=mea9_x_Ler_BR3_TGACCA_L003_R1_001.fastq.gz
DATA[78]=mea9_x_Ler_BR3_TGACCA_L003_R2_001.fastq.gz
DATA[79]=nrpE1_x_Ler_BR1_CCGTCC_L001_R1_001.fastq.gz
DATA[80]=nrpE1_x_Ler_BR1_CCGTCC_L001_R2_001.fastq.gz
DATA[81]=nrpE1_x_Ler_BR2_GTCCGC_L001_R1_001.fastq.gz
DATA[82]=nrpE1_x_Ler_BR2_GTCCGC_L001_R2_001.fastq.gz
DATA[83]=nrpE1_x_Ler_BR4_GTGAAA_L001_R1_001.fastq.gz
DATA[84]=nrpE1_x_Ler_BR4_GTGAAA_L001_R2_001.fastq.gz
DATA[85]=rdr6_x_Ler_BR1_GCCAAT_L003_R1_001.fastq.gz
DATA[86]=rdr6_x_Ler_BR1_GCCAAT_L003_R2_001.fastq.gz
DATA[87]=rdr6_x_Ler_BR2_CAGATC_L003_R1_001.fastq.gz
DATA[88]=rdr6_x_Ler_BR2_CAGATC_L003_R2_001.fastq.gz
DATA[89]=rdr6_x_Ler_BR3_CGATGT_L006_R1_001.fastq.gz
DATA[90]=rdr6_x_Ler_BR3_CGATGT_L006_R2_001.fastq.gz
DATA[91]=Tsu_x_Col0_BR1_AGTCAA_L008_R1_001.fastq.gz
DATA[92]=Tsu_x_Col0_BR1_AGTCAA_L008_R2_001.fastq.gz
DATA[93]=Tsu_x_Col0_BR3_AGTTCC_L008_R1_001.fastq.gz
DATA[94]=Tsu_x_Col0_BR3_AGTTCC_L008_R2_001.fastq.gz
DATA[95]=Tsu_x_Col0_BR4_AGTCAA_L001_R1_001.fastq.gz
DATA[96]=Tsu_x_Col0_BR4_AGTCAA_L001_R2_001.fastq.gz
DATA[97]=Tsu_x_met179_BR1_CGATGT_L008_R1_001.fastq.gz
DATA[98]=Tsu_x_met179_BR1_CGATGT_L008_R2_001.fastq.gz
DATA[99]=Tsu_x_met179_BR2_TGACCA_L008_R1_001.fastq.gz
DATA[100]=Tsu_x_met179_BR2_TGACCA_L008_R2_001.fastq.gz
DATA[101]=Tsu_x_met179_BR3_ACAGTG_L008_R1_001.fastq.gz
DATA[102]=Tsu_x_met179_BR3_ACAGTG_L008_R2_001.fastq.gz
DATA[103]=Tsu_x_Tsu_BR1_CCGTCC_L007_R1_001.fastq.gz
DATA[104]=Tsu_x_Tsu_BR1_CCGTCC_L007_R2_001.fastq.gz
DATA[105]=Tsu_x_Tsu_BR2_GTCCGC_L007_R1_001.fastq.gz
DATA[106]=Tsu_x_Tsu_BR2_GTCCGC_L007_R2_001.fastq.gz
DATA[107]=Tsu_x_Tsu_BR3_GTGAAA_L007_R1_001.fastq.gz
DATA[108]=Tsu_x_Tsu_BR3_GTGAAA_L007_R2_001.fastq.gz

R1=${DATA[${VAL1}]}
R2=${DATA[${VAL2}]}
echo R1 $R1
echo R2 $R2
GROUP=$(printf "group%03d" $JOB)
GROUP=` echo ${R1} | sed 's/_R1_001.fastq.gz//' `
echo GROUP $GROUP
echo DESCRIP $GROUP $R1 $R2

function runit () {
    echo "RUN COMMAND"
    echo ${CMD}
    date
    nice ${CMD}
    echo -n $?;    echo " exit status"
    date
}

# This is the command to align reads using the index.
# The command has 'small' and 'large' binaries.
# Use small unless the target genome is > 4GB.
export BOWTIE_ALIGN=/usr/local/bin/bowtie2
#export BOWTIE_ALIGN=/usr/local/bin/bowtie2-align-s
#export BOWTIE_ALIGN=/usr/local/bin/bowtie2-align-l

THREADS="4"
ALIGNMENT="--end-to-end --fast"
#ALIGNMENT="--fast-local"
FASTQ="-q  --phred33"
#OPTIONS="-mm" # dangerous on grid
OPTIONS="--no-unal --no-mixed --no-discordant"  # sam will containly only good maps
#OPTIONS="--no-unal"  # sam will containly only good mapped reads
CMD="${BOWTIE_ALIGN} -p ${THREADS} ${OPTIONS} ${ALIGNMENT} ${FASTQ} -x ${INDEX} -1 ${R1} -2 ${R2} -S ${GROUP}.sam"
runit

samtools view ${GROUP}.sam | cut -f 3 | sort | uniq -c > ${GROUP}.count

exit

echo "CONVERT SAM TO BAM"
CMD="samtools sort -@ ${THREADS} -T ${GROUP} -o ${GROUP}.bam ${GROUP}.sam"
runit

echo "BAM INDEX"
CMD="samtools index ${GROUP}.bam"
runit

echo "OK TO DELETE SAM ONCE BAM HAS TESTED OK"
echo "DONE"
