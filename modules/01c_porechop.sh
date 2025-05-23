#!/bin/bash

# 01c_porechop.sh

# Sergio Alías-Segura

mkdir -p $M1_OUT

python3 $PORECHOP_PATH/porechop-runner.py -i $READ_PATH/$STRAIN".fastq.gz" \
                                          -o $M1_OUT/$STRAIN".fastq.gz" \
                                          --threads $PORECHOP_THREADS
