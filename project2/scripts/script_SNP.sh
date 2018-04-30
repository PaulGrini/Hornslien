#!/bin/sh

DATASET="Undefined"
PARAM="0"
if [ "$1" -eq "1" ]; then
    DATASET="Col_x_Ler"
    PARAM="1"
fi
if [ "$1" -eq "2" ]; then
    DATASET="Ler_x_Col"
    PARAM="2"
fi
if [ "$1" -eq "3" ]; then
    DATASET="Col_x_Tsu"
    PARAM="3"
fi
if [ "$1" -eq "4" ]; then
    DATASET="Tsu_x_Col"
    PARAM="4"
fi

while read line; do
    set -- $line
    echo "echo    \""$1,$2,$3,$4,$5,$6,"fwd,R1\""
    echo "grep -c \""$6"\" ${DATASET}_BR?_R1.seq"
    echo "echo    \""$1,$2,$3,$4,$5,$6,"fwd,R2\""
    echo "grep -c \""$6"\" ${DATASET}_BR?_R2.seq"
    echo "echo    \""$1,$2,$3,$4,$5,$7,"rev,R1\""
    echo "grep -c \""$7"\" ${DATASET}_BR?_R1.seq"
    echo "echo    \""$1,$2,$3,$4,$5,$7,"rev,R2\""
    echo "grep -c \""$7"\" ${DATASET}_BR?_R2.seq"
    echo ""
done


