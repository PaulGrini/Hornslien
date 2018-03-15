#!/bin/tcsh

    foreach X ( trim.pair.*.gene_counts )
	sort $X > $X.sorted
    end
    
    foreach X ( trim.pair.*.gene_counts.sorted )
	join -a 1 -e "0" -o "0 2.2" Imprinted_Transcript1.accessions $X > $X.with_zeros
    end

