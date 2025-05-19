#!/bin/bash

# 02_merge.sh

# Sergio Alías-Segura

mkdir -p $MERGE_OUT

# the $STRAIN check on input is needed if module 1 was not performed
samtools merge $MERGE_OUT/"${STRAIN}.merged.bam" "$M1_OUT"/*"$STRAIN"*.bam

