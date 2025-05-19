#!/bin/bash

# 01b_ccs.sh

# Sergio Alías-Segura

CONDA_ENV="pbbioconda"
ACTIVATED_ENV=0
if [[ "$CONDA_DEFAULT_ENV" != "$CONDA_ENV" ]]; then
    source ~/miniconda3/etc/profile.d/conda.sh
    conda activate "$CONDA_ENV"
    ACTIVATED_ENV=1
fi

mkdir -p $M1_OUT

for bam_file in $READ_PATH/*.bam; do
    [[ "$bam_file" == *"$STRAIN"* ]] || continue
    prefix=$(basename "${bam_file%.subreads.bam}")
    ccs $bam_file \
        $M1_OUT/$prefix".ccs.bam" \
        --num-threads $CCS_THREADS \
        --min-passes $CCS_MINPASSES \
        --min-snr $CCS_MINSNR \
        --top-passes $CCS_TOPPASSES \
        --min-length $CCS_MINLEN \
        --max-length $CCS_MAXLEN \
        --min-rq $CCS_MINRQ \
        --report-file $M1_OUT/$prefix".ccs_report.txt" \
        --report-json $M1_OUT/$prefix".ccs_report.json" \
        --metrics-json $M1_OUT/$prefix".ccs_zmw_metrics.json" \
        --log-level $CCS_LOGLEVEL

done

if [[ "$ACTIVATED_ENV" -eq 1 ]]; then
    conda deactivate
fi

