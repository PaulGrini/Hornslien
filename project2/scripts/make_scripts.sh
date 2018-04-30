#!/bin/sh

if [[ -z "${SCRIPTDIR}" ]]; then
    echo "Please set the SCRIPTDIR environment variable to the home of script_SNP.sh"
    exit 1
else
    export SCRIPTDIR="${SCRIPTDIR}"
    echo SCRIPTDIR ${SCRIPTDIR}
    ls -l ${SCRIPTDIR}/script_SNP.sh
fi

SNPSET="Undefined"
DATASET="Undefined"
PARAM="0"
if [ "$1" -eq "1" ]; then
    SNPSET="Col_Ler"
    DATASET="Col_x_Ler"
    PARAM="1"
fi
if [ "$1" -eq "2" ]; then
    SNPSET="Col_Ler"
    DATASET="Ler_x_Col"
    PARAM="2"
fi
if [ "$1" -eq "3" ]; then
    SNPSET="Col_Tsu"
    DATASET="Col_x_Tsu"
    PARAM="3"
fi
if [ "$1" -eq "4" ]; then
    SNPSET="Col_Tsu"
    DATASET="Tsu_x_Col"
    PARAM="4"
fi

# Assume the whole data set was saved to file like this.
# $ show-snps -H -C -T -x 10 Col_Ler.delta | ./parse_SNPs.sh 1 > parsed_SNPs.Col_Ler.txt

# Restricted data set.
export MYGENES="AT2G35670|AT4G25530|AT1G02580|AT1G65330|AT3G19350|AT5G26650|AT2G17690|AT4G13460|AT1G55560|AT2G32990|AT4G10640|AT5G60440|AT1G65300|AT5G26630"
 cat parsed_SNPs.${SNPSET}.txt | egrep "${MYGENES}" | ${SCRIPTDIR}/script_SNP.sh ${PARAM} > count_SNP.${DATASET}.sh
