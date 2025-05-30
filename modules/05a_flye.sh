#!/bin/bash

# 05a_flye.sh

# Sergio Alías-Segura

CONDA_ENV="flye"
ACTIVATED_ENV=0
if [[ "$CONDA_DEFAULT_ENV" != "$CONDA_ENV" ]]; then
    source ~/miniconda3/etc/profile.d/conda.sh
    conda activate "$CONDA_ENV"
    ACTIVATED_ENV=1
fi

mkdir -p $FLYE_OUT

ulimit -v $((FLYE_RAM * 1024 * 1024))

flye --$FLYE_TYPE \
     $FASTPLONG_OUT/$STRAIN".fastq" \
     --iterations $FLYE_ITER \
     --genome-size $FYLE_GSIZE \
     --out-dir $FLYE_OUT \
     --threads $FLYE_THREADS

# You may want to add --scaffold
# You may want to add --asm-coverage $FLYE_ASMCOV

mv $FLYE_OUT"/assembly.fasta" $FLYE_OUT"/flye.fasta"

if [[ "$ACTIVATED_ENV" -eq 1 ]]; then
    conda deactivate
fi

