#!/usr/bin/awk -f

BEGIN { OFS = ","; print "#!/bin/sh \n";}
{

    print "echo    \"" $1,$2,$3,$4,$5,$6, "fwd,R1\"";
    print "grep -c \"" $6 "\" Col_x_Ler_BR?_R1.seq";
    print "echo    \"" $1,$2,$3,$4,$5,$6, "fwd,R2\"";
    print "grep -c \"" $6 "\" Col_x_Ler_BR?_R2.seq";
    print "echo    \"" $1,$2,$3,$4,$5,$7, "rev,R1\"";
    print "grep -c \"" $7 "\" Col_x_Ler_BR?_R1.seq";
    print "echo    \"" $1,$2,$3,$4,$5,$7, "rev,R2\"";
    print "grep -c \"" $7 "\" Col_x_Ler_BR?_R2.seq";
    print "";
}

