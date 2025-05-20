#!/bin/bash

# i1_cutadapt.sh

# Sergio Alías-Segura

mkdir -p $CUTADAPT_OUT

cutadapt $(ls $ILLUMINA_PATH/*${STRAIN}*) \
         --adapter TruSeq_F=$CUTADAPT_ADAPTER_F \
         -A TruSeq_R=$CUTADAPT_ADAPTER_R \
         --cores $CUTADAPT_THREADS \
         --output $CUTADAPT_OUT/${STRAIN}_1_cutadapt.fastq.gz \
         --paired-output $CUTADAPT_OUT/${STRAIN}_2_cutadapt.fastq.gz

