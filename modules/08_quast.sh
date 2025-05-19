#!/bin/bash

# 08_quast.sh

# Sergio Alías-Segura

ASSEMBLY_DIRS=(flye minimap2_miniasm)

QUAST_IN=""

for dir in "${ASSEMBLY_DIRS[@]}"; do
    assembly_fa="$WDIR/$dir/$dir.fasta"
    [ -e "$assembly_fa" ] && QUAST_IN+="$assembly_fa "
done

for f in "$RACON_OUT"/*/*/*.fasta; do
    [ -e "$f" ] && QUAST_IN+="$f "
done

QUAST_IN=$(echo "$QUAST_IN" | xargs)

mkdir -p $QUAST_OUT

python3 $QUAST_PATH/quast.py -o $QUAST_OUT \
                             --fungus \
                             --threads $QUAST_THREADS \
                             $QUAST_IN
