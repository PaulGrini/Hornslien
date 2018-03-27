#!/bin/sh

# Input
# $ show-snps -H -C -T -x 10 Col_Ler.delta
# 58	G	A	58	27	58	GAACTCTCGTGCTCAAAGATC	GAACTCTCGTACTCAAAGATC	1	1	AT2G17690.1_pilon4_Col	AT2G17690.1_pilon4_Ler
# 85	T	C	85	27	85	GGCCAAAGCATACAAACTATT	GGCCAAAGCACACAAACTATT	1	1	AT2G17690.1_pilon4_Col	AT2G17690.1_pilon4_Ler

# Desired output
# AT2G17690 COL AT2G17690.SNP6 1209 G TGGGAGATAAGGCGATTGTGA TCACAATCGCCTTATCTCCCA
# AT2G17690 LER AT2G17690.SNP6 1209 C TGGGAGATAACGCGATTGTGA TCACAATCGCGTTATCTCCCA

PREV="NONE"
COUNTER=0
while read line; do
    set -- $line
    GENE=${11:0:9}
    let COUNTER=COUNTER+1
    SNP=${GENE}.SNP${COUNTER}
    COL_FWD=`echo ${7} | tr -d '.' | tr -d '-' `
    LER_FWD=`echo ${8} | tr -d '.' | tr -d '-' `
    COL_REV=`echo ${COL_FWD} | rev | tr 'A' 'a' | tr 'C' 'c' | tr 'G' 'g' | tr 'T' 't' | tr 'a' 'T' | tr 'c' 'G' | tr 'g' 'C' | tr 't' 'A' `
    LER_REV=`echo ${LER_FWD} | rev | tr 'A' 'a' | tr 'C' 'c' | tr 'G' 'g' | tr 'T' 't' | tr 'a' 'T' | tr 'c' 'G' | tr 'g' 'C' | tr 't' 'A' `

    echo ${GENE} COL ${SNP} $1 $2 ${COL_FWD} ${COL_REV}
    echo ${GENE} LER ${SNP} $4 $3 ${LER_FWD} ${LER_REV}
done
