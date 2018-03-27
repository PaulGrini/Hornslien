#!/bin/sh

# The old way, based on show-coords.
# ./print_SNPs.sh | ./revcmp_SNP.sh | ./script_SNP.sh > count_SNP.sh

# The new way, based on show-snps. Process whole data set. This is slow.
# show-snps -H -C -T -x 10 Col_Ler.delta | ./parse_SNPs.sh | ./script_SNP.sh > count_SNP.sh

# The whole data set save to file.
# show-snps -H -C -T -x 10 Col_Ler.delta | ./parse_SNPs.sh > parsed_SNPs.txt

# Restricted data set.
export MYGENES="AT2G35670|AT4G25530|AT1G02580|AT1G65330|AT3G19350|AT5G26650|AT2G17690|AT4G13460|AT1G55560|AT2G32990|AT4G10640|AT5G60440|AT1G65300|AT5G26630"
 cat parsed_SNPs.txt | egrep "${MYGENES}" | ./script_SNP.sh > count_SNP.sh
