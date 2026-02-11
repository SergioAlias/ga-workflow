#!/bin/bash

# 11b_bakta.sh

# Sergio Alías-Segura

CONDA_ENV="bakta"
ACTIVATED_ENV=0
if [[ "$CONDA_DEFAULT_ENV" != "$CONDA_ENV" ]]; then
    source ~/miniconda3/etc/profile.d/conda.sh
    conda activate "$CONDA_ENV"
    ACTIVATED_ENV=1
fi

mkdir -p $BAKTA_OUT

for fasta_file in "$PLASMID_OUT"/*.fasta; do
    filename=$(basename "$fasta_file")
    base_name="${filename%.*}"
    current_outdir="$BAKTA_OUT/$base_name"

    echo "Annotating with Bakta: $base_name"

    bakta --db $BAKTA_DB \
          --verbose \
          --genus $BAKTA_GENUS \
          --species $BAKTA_SPECIES \
          --gram $BAKTA_GRAM \
          --output $current_outdir \
          --prefix $base_name \
          --threads $SLURM_CPUS \
          $fasta_file

done