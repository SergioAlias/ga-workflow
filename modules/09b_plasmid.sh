#!/bin/bash

# 09b_plasmid.sh

# Sergio Alías-Segura

CONDA_ENV="mob_suite"
ACTIVATED_ENV=0
if [[ "$CONDA_DEFAULT_ENV" != "$CONDA_ENV" ]]; then
    source ~/miniconda3/etc/profile.d/conda.sh
    conda activate "$CONDA_ENV"
    ACTIVATED_ENV=1
fi

mob_recon --infile $CONTAM_IN \
          --outdir $PLASMID_OUT \
          --num_threads $SLURM_CPUS \
          --sample_id $STRAIN

if [[ "$ACTIVATED_ENV" -eq 1 ]]; then
    conda deactivate
fi