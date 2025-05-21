#!/bin/bash

# i2_spades.sh

# Sergio Alías-Segura

mkdir -p $SPADES_OUT

INPUT_F=$CUTADAPT_OUT/$(ls "$CUTADAPT_OUT" | grep "${STRAIN}_1")
INPUT_R=$CUTADAPT_OUT/$(ls "$CUTADAPT_OUT" | grep "${STRAIN}_2")

SPADES_IN=()
SPADES_IN+=(-1 $INPUT_F)
SPADES_IN+=(-2 $INPUT_R)
[[ $SPADES_HYBRID == "True" ]] && \
SPADES_IN+=(--pacbio $FASTPLONG_OUT/$STRAIN".fastq")

echo "spades.py ${SPADES_IN[@]} \
          -o $SPADES_OUT \
          --threads $SPADES_THREADS \
          --memory $SPADES_RAM"

mv $SPADES_OUT/contigs.fasta $SPADES_OUT/spades.fasta
