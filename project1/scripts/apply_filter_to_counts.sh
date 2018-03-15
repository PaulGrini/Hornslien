#!/bin/sh

function filter () {
    pass=$1
    cross=$2
    
    if [ ! -f "${pass}" ]; then echo "ERROR: File not found ${pass}"; return; fi
    if [ ! -f "${cross}.three_reps_per_gene" ]; then echo "ERROR: File not found ${cross}"; return; fi

    join ${pass} ${cross}.three_reps_per_gene > ${cross}.three_reps_per_gene.filtered
    echo "Created new file ${cross}.three_reps_per_gene.filtered"
}

filter  Genes_Pass_Filter.Both.Col_Ler.txt Col_x_Ler

filter	Genes_Pass_Filter.Both.Col_Ler.txt Ler_x_Col

filter	Genes_Pass_Filter.Both.Col_Ler.txt Ler_x_drm1

filter	Genes_Pass_Filter.Both.Col_Ler.txt drm1_x_Ler

filter	Genes_Pass_Filter.Both.Col_Ler.txt Ler_x_mea9

filter	Genes_Pass_Filter.Both.Col_Ler.txt mea9_x_Ler

filter	Genes_Pass_Filter.Both.Col_Ler.txt Ler_x_met1-3
	
filter	Genes_Pass_Filter.Both.Col_Ler.txt Ler_x_met179

filter	Genes_Pass_Filter.Both.Col_Ler.txt Ler_x_nrpE1

filter	Genes_Pass_Filter.Both.Col_Ler.txt nrpE1_x_Ler

filter	Genes_Pass_Filter.Both.Col_Ler.txt Ler_x_rdr6
	
filter	Genes_Pass_Filter.Both.Col_Ler.txt rdr6_x_Ler
	
filter	Genes_Pass_Filter.Both.Col_Tsu.txt Col_x_Tsu

filter	Genes_Pass_Filter.Both.Col_Tsu.txt Tsu_x_Col

filter	Genes_Pass_Filter.Both.Col_Tsu.txt Tsu_x_met179

echo Done
