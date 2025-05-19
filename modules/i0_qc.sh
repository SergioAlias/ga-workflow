#!/bin/bash

# i0_qc.sh

# Sergio Alías-Segura

CONDA_ENV="shortqc"
ACTIVATED_ENV=0
if [[ "$CONDA_DEFAULT_ENV" != "$CONDA_ENV" ]]; then
    source ~/miniconda3/etc/profile.d/conda.sh
    conda activate "$CONDA_ENV"
    ACTIVATED_ENV=1
fi

## TODO change from here

if [ "$R_FLAG" = "False" ]; then
    QC_IN=$READ_PATH
    QC_OUT=$WDIR"/qc_before"
elif [ "$R_FLAG" = "True" ]; then
    QC_IN=$M1_OUT
    QC_OUT=$WDIR"/qc_after"
fi

mkdir -p $QC_OUT

for bam_file in $QC_IN/*.bam; do
    [[ "$bam_file" == *"$STRAIN"* ]] || continue
    python $LONGQC_PATH/longQC.py sampleqc \
                                  --preset pb-sequel \
                                  --output $QC_OUT/$(basename "${bam_file%%.*}") \
                                  --ncpu $QC_THREADS \
                                  $bam_file

done

if [[ "$ACTIVATED_ENV" -eq 1 ]]; then
    conda deactivate
fi

