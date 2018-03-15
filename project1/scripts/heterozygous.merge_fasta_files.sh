#!/bin/sh

# Build target FASTA files that offer two parental strains of each transcript.
# This will be useful for testing which parent is preferentially mapped by reads from heterozygotes.

# First, alter the FASTA defline so we can distinguish the two parental forms.
cat Col_x_Col.pilon4.fasta | sed 's/_pilon_pilon_pilon_pilon/_pilon4_Col/' > Col.tmp
cat Ler_x_Ler.pilon4.fasta | sed 's/_pilon_pilon_pilon_pilon/_pilon4_Ler/' > Ler.tmp
cat Tsu_x_Tsu.pilon4.fasta | sed 's/_pilon_pilon_pilon_pilon/_pilon4_Tsu/' > Tsu.tmp

# Second, make pairwise combinations in FASTA format.
cat Col.tmp Ler.tmp > Col_plus_Ler.fasta
cat Col.tmp Tsu.tmp > Col_plus_Tsu.fasta

# Third, index each combination FASTA.
bowtie2-build Col_plus_Ler.fasta Col_plus_Ler
bowtie2-build Col_plus_Tsu.fasta Col_plus_Tsu

# Clean up
rm Col.tmp Ler.tmp Tsu.tmp
