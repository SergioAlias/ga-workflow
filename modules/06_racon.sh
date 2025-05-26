#!/bin/bash

# 06_racon.sh

# Sergio Alías-Segura

mkdir -p $RACON_OUT/$RACON_ASSEMBLY

CURRENT_ASSEMBLY=$WDIR/$RACON_ASSEMBLY/$RACON_ASSEMBLY".fasta"

for ((i=1; i<=RACON_ITER; i++)); do

    echo "Iteration $i / $RACON_ITER"

    ITER_DIR=$RACON_OUT/$RACON_ASSEMBLY"/iter_"$i

    mkdir -p $ITER_DIR

    $MINIMAP2_PATH/minimap2 -x map-pb \
                            -t $MINIMAP2_THREADS \
                            -o $ITER_DIR/minimap.racon.paf \
                            $CURRENT_ASSEMBLY \
                            $FASTPLONG_OUT/$STRAIN".fastq"

    NEXT_ASSEMBLY=$ITER_DIR/$RACON_ASSEMBLY"_racon_"$i".fasta"

    $RACON_PATH/racon $FASTPLONG_OUT/$STRAIN".fastq" \
                      $ITER_DIR/minimap.racon.paf \
                      $CURRENT_ASSEMBLY \
                      --threads $RACON_THREADS \
                      > $NEXT_ASSEMBLY
    
    CURRENT_ASSEMBLY=$NEXT_ASSEMBLY

done
