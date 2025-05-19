#!/bin/bash

# i0_fastqc.sh

# Sergio Alías-Segura

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
       --threads $FASTQC_THREADS \
       $(ls $FASTQC_IN/*${STRAIN}*)
