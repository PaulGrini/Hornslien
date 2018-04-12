#!/bin/sh

cat count_SNP.Col_x_Ler.log | sed 's/^Col_x_Ler.*://' | awk 'BEGIN {FS=","} ; {C++; if (C == 1) P[1]=$3; else P[C]=$0; if (C == 4) {C=0; print P[1]","P[2]","P[3]","P[4];}}' | awk 'BEGIN {FS=","} ; {C++; if (C == 1) P=$0; else P=sprintf("%s,%d,%d,%d",P,$2,$3,$4); if (C==8){print P;C=0;}}' > Col_x_Ler.csv

cat count_SNP.Ler_x_Col.log | sed 's/^Ler_x_Col.*://' | awk 'BEGIN {FS=","} ; {C++; if (C == 1) P[1]=$3; else P[C]=$0; if (C == 4) {C=0; print P[1]","P[2]","P[3]","P[4];}}' | awk 'BEGIN {FS=","} ; {C++; if (C == 1) P=$0; else P=sprintf("%s,%d,%d,%d",P,$2,$3,$4); if (C==8){print P;C=0;}}' > Ler_x_Col.csv

