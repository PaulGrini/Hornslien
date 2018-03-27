#!/bin/sh

echo "#!/bin/sh"

while read line; do
    set -- $line
    echo "echo    \""$1,$2,$3,$4,$5,$6,"fwd,R1\""
    echo "grep -c \""$6"\" Col_x_Ler_BR?_R1.seq"
    echo "echo    \""$1,$2,$3,$4,$5,$6,"fwd,R2\""
    echo "grep -c \""$6"\" Col_x_Ler_BR?_R2.seq"
    echo "echo    \""$1,$2,$3,$4,$5,$7,"rev,R1\""
    echo "grep -c \""$7"\" Col_x_Ler_BR?_R1.seq"
    echo "echo    \""$1,$2,$3,$4,$5,$7,"rev,R2\""
    echo "grep -c \""$7"\" Col_x_Ler_BR?_R2.seq"
    echo ""
done


