#!/bin/bash

# i2_spades.sh

# Sergio Alías-Segura

mkdir -p $SPADES_OUT

INPUT_F=$CUTADAPT_OUT/$(ls "$CUTADAPT_OUT" | grep "${STRAIN}_1")
INPUT_R=$CUTADAPT_OUT/$(ls "$CUTADAPT_OUT" | grep "${STRAIN}_2")

spades.py -1 $INPUT_F \
          -2 $INPUT_R \
          --pacbio $FASTPLONG_OUT/$STRAIN".fastq" \
          -o $SPADES_OUT \
          --threads $SPADES_THREADS \
          --memory $SPADES_RAM

mv $SPADES_OUT/contigs.fasta $SPADES_OUT/spades.fasta
