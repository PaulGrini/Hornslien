#!/bin/sh

if [ -z "$SCRIPTDIR" ]; then echo "ERROR SCRIPTDIR NOT SET"; exit 1; fi
echo SCRIPT DIRECTORY $SCRIPTDIR

function runde () {
    infile=${1}.three_reps_per_gene.filtered
    echo ${infile}
    
    if [ ! -f "${infile}" ]; then echo "ERROR: File not found ${infile}"; return; fi

    # Compute differential expression using the limma package.
    Rscript ${SCRIPTDIR}/limma.foldchange.r ${infile}

    # The R script changes the file format.
    # Gene names are converted to ordinals like "1", "2".
    # Rows are sorted by P-value.
    # One row of column headers is added.
    # Space-separated values are changed to comma-separated values.
    # Here, remove quotes, sort the csv, sort by the ordinal, and remove the header (which sorts first).
    cat ${infile}.de | tr -d '"' | sort -t"," -k1,1n | awk '{if (C++ >= 1) print $0;}' > ${infile}.de.sorted
}

runde   Col_x_Ler

runde	 Ler_x_Col

runde	 drm1_x_Ler

runde	 Ler_x_drm1

runde	 Ler_x_mea9

runde	 mea9_x_Ler

runde	 Ler_x_met1-3
	
runde	 Ler_x_met179

runde	 Ler_x_nrpE1

runde	 nrpE1_x_Ler

runde	 Ler_x_rdr6
	
runde	 rdr6_x_Ler
	
runde	 Col_x_Tsu

runde	 Tsu_x_Col

runde	 Tsu_x_met179

echo Done
