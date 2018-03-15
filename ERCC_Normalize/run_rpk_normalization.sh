#!/bin/sh

cd ERCC
for FF in  *with_zeros ; do
    echo $FF
    ../rpk_normalization.pl ../ERCC.lengths $FF > $FF.rpk
done
cd ..
cd Homozygous
for FF in  *with_zeros ; do
    echo $FF
    ../rpk_normalization.pl ../Imprinted_Transcript1.lengths $FF > $FF.rpk
done
cd ..
cd Ler
for FF in  *with_zeros ; do
    echo $FF
    ../rpk_normalization.pl ../Imprinted_Transcript1.lengths $FF > $FF.rpk
done
cd ..
cd Tsu
for FF in  *with_zeros ; do
    echo $FF
    ../rpk_normalization.pl ../Imprinted_Transcript1.lengths $FF > $FF.rpk
done
cd ..