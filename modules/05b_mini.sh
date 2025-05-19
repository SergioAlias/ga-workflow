#!/bin/bash

# 05b_mini.sh

# Sergio Alías-Segura

mkdir -p $MINI_OUT

$MINIMAP2_PATH/minimap2 -x ava-pb \
                        -t $MINIMAP2_THREADS \
                        -o $MINI_OUT/overlaps.paf \
                        $FASTPLONG_OUT/$STRAIN".fastq" \
                        $FASTPLONG_OUT/$STRAIN".fastq"

$MINIASM_PATH/miniasm -f $FASTPLONG_OUT/$STRAIN".fastq" \
                      $MINI_OUT/overlaps.paf \
                      > $MINI_OUT/miniasm.gfa

awk '/^S/{print ">"$2"\n"$3}' $MINI_OUT/miniasm.gfa > $MINI_OUT/minimap2_miniasm.fasta
