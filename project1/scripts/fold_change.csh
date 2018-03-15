#!/bin/csh

foreach A ( Col*.Columns_Col_Ler )
cat $A | awk '{X=$2; Y=$3; P=0.01; if (Y==0)Y+=P; F = (X - Y + P) / (Y); print F;}' | sort -n > cnt.$A
end

foreach A ( Ler*.Columns_Col_Ler )
cat $A | awk '{X=$3; Y=$2; P=0.01; if (Y==0)Y+=P; F = (X - Y + P) / (Y); print F;}' | sort -n > cnt.$A
end

foreach A ( Col*.Columns_Col_Tsu )
cat $A | awk '{X=$2; Y=$3; P=0.01; if (Y==0)Y+=P; F = (X - Y + P) / (Y); print F;}' | sort -n > cnt.$A
end

foreach A ( Tsu*.Columns_Col_Tsu )
cat $A | awk '{X=$3; Y=$2; P=0.01; if (Y==0)Y+=P; F = (X - Y + P) / (Y); print F;}' | sort -n > cnt.$A
end
