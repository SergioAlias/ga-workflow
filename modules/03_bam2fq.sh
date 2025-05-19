#!/bin/bash

# 03_bam2fq.sh

# Sergio Alías-Segura

mkdir -p $BAM2FQ_OUT

# the $STRAIN check on input is needed if module 2 was not performed
samtools bam2fq "$MERGE_OUT"/*"$STRAIN"*.bam > $BAM2FQ_OUT/$STRAIN".fastq"

