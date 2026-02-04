#!/bin/bash

# 10_quast.sh

# Sergio Alías-Segura

CONDA_ENV="quast"
ACTIVATED_ENV=0
if [[ "$CONDA_DEFAULT_ENV" != "$CONDA_ENV" ]]; then
    source ~/miniconda3/etc/profile.d/conda.sh
    conda activate "$CONDA_ENV"
    ACTIVATED_ENV=1
fi

ASSEMBLY_DIRS=(flye minimap2_miniasm spades spades_hybrid)

QUAST_IN=""

for dir in "${ASSEMBLY_DIRS[@]}"; do
    assembly_fa="$WDIR/$dir/$dir.fasta"
    [ -e "$assembly_fa" ] && QUAST_IN+="$assembly_fa "
done

for f in "$RACON_OUT"/*/*/*.fasta; do
    [ -e "$f" ] && QUAST_IN+="$f "
done

for f in "$PILON_OUT"/*/*/*.fasta; do
    [ -e "$f" ] && [ ! -L "$f" ] && QUAST_IN+="$f "
done

for f in "$MITO_OUT"/no_mito_*.fasta; do
    [ -e "$f" ] && [ ! -L "$f" ] && QUAST_IN+="$f "
done

QUAST_IN=$(echo "$QUAST_IN" | xargs)

QUAST_OPTS=()

[[ "$QUAST_GENOME" == "eukaryote" ]] && QUAST_OPTS+=(--eukaryote)
[[ "$QUAST_GENOME" == "fungus" ]] && QUAST_OPTS+=(--fungus)

mkdir -p $QUAST_OUT

quast.py -o $QUAST_OUT \
         "${QUAST_OPTS[@]}" \
         --threads $SLURM_CPUS \
         $QUAST_IN
