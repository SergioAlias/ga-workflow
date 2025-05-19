#!/bin/bash

# setup_illumina.sh

# Script for creating symbolic links to raw Illumina data

SRC_DIR="/mnt/data3/sergio_data3/genomas"
OUT_DIR="/mnt/data3/sergio_data3/assembly/illumina"

mkdir -p $OUT_DIR

for fq in "$SRC_DIR"/*.fastq.gz; do
    ln -s "$fq" "$OUT_DIR/$(basename "$fq")"
done
