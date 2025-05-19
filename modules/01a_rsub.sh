#!/bin/bash

# 01a_rsub.sh

# Sergio Alías-Segura

mkdir -p $M1_OUT

find $READ_PATH -regex ".*${STRAIN}.*\.bam$" > $M1_OUT/subFiles.txt

SequelTools.sh -t S \
               -T l \
               -u $M1_OUT/subFiles.txt \
               -o $M1_OUT \
               -f b \
               -n $RSUB_THREADS \
               -v

