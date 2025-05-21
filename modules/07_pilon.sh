#!/bin/bash

# 07_pilon.sh

# Sergio Alías-Segura

mkdir -p $PILON_OUT/$PILON_ASSEMBLY

ILLUMINA_F=$CUTADAPT_OUT/$(ls "$CUTADAPT_OUT" | grep "${STRAIN}_1")
ILLUMINA_R=$CUTADAPT_OUT/$(ls "$CUTADAPT_OUT" | grep "${STRAIN}_2")

CURRENT_ASSEMBLY=$PILON_IN

for ((i=1; i<=PILON_ITER; i++)); do

    echo "Iteration $i / $PILON_ITER"

    ITER_DIR=$PILON_OUT/$PILON_ASSEMBLY"/iter_"$i

    mkdir -p $ITER_DIR
    
    ln -s $CURRENT_ASSEMBLY $ITER_DIR

    CURRENT_ASSEMBLY=$ITER_DIR/$(basename "$CURRENT_ASSEMBLY")

    bwa index $CURRENT_ASSEMBLY

    bwa mem -t $PILON_THREADS \
            -o $ITER_DIR/bwamem.sam \
            $CURRENT_ASSEMBLY \
            $ILLUMINA_F \
            $ILLUMINA_R
    
    samtools view -b \
                  -o $ITER_DIR/bwamem.bam \
                  $ITER_DIR/bwamem.sam
                  
    samtools sort -o $ITER_DIR/bwamem_sorted.bam \
                  $ITER_DIR/bwamem.bam
    
    samtools index $ITER_DIR/bwamem_sorted.bam

    java -Xmx${PILON_RAM}G -jar $PILON_JAR --genome $CURRENT_ASSEMBLY \
                                           --bam $ITER_DIR/bwamem_sorted.bam \
                                           --output $PILON_ASSEMBLY"_pilon_"$i \
                                           --outdir $ITER_DIR \
                                           --threads $PILON_THREADS \
                                           --fix all \
                                           --vcf \
                                           --verbose

    CURRENT_ASSEMBLY=$ITER_DIR/$PILON_ASSEMBLY"_pilon_"$i".fasta"

done