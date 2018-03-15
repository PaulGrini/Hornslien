#!/bin/csh

foreach X (*.filtered)
echo $X
cat $X | tr ' ' ',' > $X.csv
paste $X.csv $X.de.sorted | tr '\t' ',' > $X.final.csv
end
