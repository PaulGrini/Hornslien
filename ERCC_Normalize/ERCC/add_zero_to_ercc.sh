#!/bin/sh

SCRIPT="add_zero_to_ercc.pl"

for FF in *.count
do
    echo $FF
    ./${SCRIPT} ${FF} > ${FF}_with_zeros
done
