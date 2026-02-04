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
[[ $SPADES_MODE == "isolate" ]] && \
SPADES_IN+=(--isolate)

$SPADES_PATH/spades.py ${SPADES_IN[@]} \
                       -o $SPADES_OUT \
                       --threads $SLURM_CPUS \
                       --memory ${SLURM_MEM%[Gg]*} # strip the G/g

mv $SPADES_OUT/scaffolds.fasta $SPADES_OUT/$SPADES_NAME".fasta"
