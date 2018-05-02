#!/bin/sh

echo "Parameter = $1"
if [ "$1" -eq "1" ]; then
    echo "Col_x_Ler"
    cat count_SNP.Col_x_Ler.log | sed 's/^Col_x_Ler.*://' | awk 'BEGIN {FS=","} ; {C++; if (C == 1) P[1]=$3; else P[C]=$0; if (C == 4) {C=0; print P[1]","P[2]","P[3]","P[4];}}' | awk 'BEGIN {FS=","} ; {C++; if (C == 1) P=$0; else P=sprintf("%s,%d,%d,%d",P,$2,$3,$4); if (C==8){print P;C=0;}}' > SNP.Col_x_Ler.csv
fi
if [ "$1" -eq "2" ]; then
    echo "Ler_x_Col"
    cat count_SNP.Ler_x_Col.log | sed 's/^Ler_x_Col.*://' | awk 'BEGIN {FS=","} ; {C++; if (C == 1) P[1]=$3; else P[C]=$0; if (C == 4) {C=0; print P[1]","P[2]","P[3]","P[4];}}' | awk 'BEGIN {FS=","} ; {C++; if (C == 1) P=$0; else P=sprintf("%s,%d,%d,%d",P,$2,$3,$4); if (C==8){print P;C=0;}}' > SNP.Ler_x_Col.csv
fi
if [ "$1" -eq "3" ]; then
    echo "Col_x_Tsu"
    cat count_SNP.Col_x_Tsu.log | sed 's/^Col_x_Tsu.*://' | awk 'BEGIN {FS=","} ; {C++; if (C == 1) P[1]=$3; else P[C]=$0; if (C == 4) {C=0; print P[1]","P[2]","P[3]","P[4];}}' | awk 'BEGIN {FS=","} ; {C++; if (C == 1) P=$0; else P=sprintf("%s,%d,%d,%d",P,$2,$3,$4); if (C==8){print P;C=0;}}' > SNP.Col_x_Tsu.csv
fi
if [ "$1" -eq "4" ]; then
    echo "Tsu_x_Col"
    cat count_SNP.Tsu_x_Col.log | sed 's/^Tsu_x_Col.*://' | awk 'BEGIN {FS=","} ; {C++; if (C == 1) P[1]=$3; else P[C]=$0; if (C == 4) {C=0; print P[1]","P[2]","P[3]","P[4];}}' | awk 'BEGIN {FS=","} ; {C++; if (C == 1) P=$0; else P=sprintf("%s,%d,%d,%d",P,$2,$3,$4); if (C==8){print P;C=0;}}' > SNP.Tsu_x_Col.csv
fi


