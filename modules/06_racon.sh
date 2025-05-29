#!/bin/bash

# 06_racon.sh

# Sergio Alías-Segura

mkdir -p $RACON_OUT/$ASSEMBLY_TARGET

CURRENT_ASSEMBLY=$WDIR/$ASSEMBLY_TARGET/$ASSEMBLY_TARGET".fasta"

for ((i=1; i<=RACON_ITER; i++)); do

    echo "Iteration $i / $RACON_ITER"

    ITER_DIR=$RACON_OUT/$ASSEMBLY_TARGET"/iter_"$i

    mkdir -p $ITER_DIR

    $MINIMAP2_PATH/minimap2 -x map-$SEQ_TYPE \
                            -t $MINIMAP2_THREADS \
                            -o $ITER_DIR/minimap.racon.paf \
                            $CURRENT_ASSEMBLY \
                            $FASTPLONG_OUT/$STRAIN".fastq"

    NEXT_ASSEMBLY=$ITER_DIR/$ASSEMBLY_TARGET"_racon_"$i".fasta"

    $RACON_PATH/racon $FASTPLONG_OUT/$STRAIN".fastq" \
                      $ITER_DIR/minimap.racon.paf \
                      $CURRENT_ASSEMBLY \
                      --threads $RACON_THREADS \
                      > $NEXT_ASSEMBLY
    
    CURRENT_ASSEMBLY=$NEXT_ASSEMBLY

done
