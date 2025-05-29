#!/bin/bash

# 09_mito.sh

# Sergio Alías-Segura

CONDA_ENV="tiara"
ACTIVATED_ENV=0
if [[ "$CONDA_DEFAULT_ENV" != "$CONDA_ENV" ]]; then
    source ~/miniconda3/etc/profile.d/conda.sh
    conda activate "$CONDA_ENV"
    ACTIVATED_ENV=1
fi

mkdir -p $MITO_OUT

tiara --input $CONTAM_IN \
      --output "$MITO_OUT/$(basename "${CONTAM_IN%.*}").tsv" \
      --to_fasta mit \
      --threads $MITO_THREADS \
      --prob_cutoff $MITO_PCUTOFF_1 $MITO_PCUTOFF_2 \
      --probabilities \
      --verbose

if [[ "$ACTIVATED_ENV" -eq 1 ]]; then
    conda deactivate
fi

