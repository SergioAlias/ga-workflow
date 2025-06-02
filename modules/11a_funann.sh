#!/bin/bash

# 11a_funann.sh

# Sergio Alías-Segura

CONDA_ENV="funannotate"
ACTIVATED_ENV=0
if [[ "$CONDA_DEFAULT_ENV" != "$CONDA_ENV" ]]; then
    source ~/miniconda3/etc/profile.d/conda.sh
    conda activate "$CONDA_ENV"
    ACTIVATED_ENV=1
fi

mkdir -p $FUNANN_OUT

funnanotate clean --input $NO_MITO_FILE \
                  --out "$FUNANN_OUT/$(basename "${NO_MITO_FILE%.*}")_clean.fasta" \
                  --pident $FUNANN_CLEAN_PIDENT \
                  --cov $FUNANN_CLEAN_COV \
                  --minlen $FUNANN_CLEAN_MINLEN

funannotate sort --input "$FUNANN_OUT/$(basename "${NO_MITO_FILE%.*}")_clean.fasta" \
                 --out "$FUNANN_OUT/$(basename "${NO_MITO_FILE%.*}")_sort.fasta" \
                 --base $FUNANN_SORT_BASE \
                 --minlen $FUNANN_SORT_MINLEN

funannotate mask --input "$FUNANN_OUT/$(basename "${NO_MITO_FILE%.*}")_sort.fasta" \
                 --out "$FUNANN_OUT/$(basename "${NO_MITO_FILE%.*}")_mask.fasta" \
                 --method tantan \
                 --cpus $FUNANN_MASK_CPUS

# TODO continue from here

if [[ "$ACTIVATED_ENV" -eq 1 ]]; then
    conda deactivate
fi