#!/bin/bash

# i0_fastqc.sh

# Sergio Alías-Segura

CONDA_ENV="/mnt/lustre/home/salias/projects/sporeflow/.snakemake/conda/79e17fca0d658268a5aaac39ee2b11af_"
ACTIVATED_ENV=0
if [[ "$CONDA_DEFAULT_ENV" != "$CONDA_ENV" ]]; then
    source ~/miniconda3/etc/profile.d/conda.sh
    conda activate "$CONDA_ENV"
    ACTIVATED_ENV=1
fi

if [ "$R_FLAG" = "False" ]; then
    FASTQC_IN=$ILLUMINA_PATH
    FASTQC_OUT=$WDIR"/fastqc_before"
elif [ "$R_FLAG" = "True" ]; then
    FASTQC_IN=$CUTADAPT_OUT
    FASTQC_OUT=$WDIR"/fastqc_after"
fi

mkdir -p $FASTQC_OUT

fastqc --noextract \
       --outdir $FASTQC_OUT \
       --threads $SLURM_CPUS \
       $(ls $FASTQC_IN/*${STRAIN}*)
