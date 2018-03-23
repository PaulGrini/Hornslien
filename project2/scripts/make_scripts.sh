#!/bin/sh

./print_SNPs.sh | ./revcmp_SNP.sh | ./script_SNP.awk > count_SNP.sh