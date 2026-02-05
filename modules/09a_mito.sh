#!/bin/bash

# 09a_mito.sh

# Sergio Alías-Segura

CONDA_ENV="tiara"
ACTIVATED_ENV=0
if [[ "$CONDA_DEFAULT_ENV" != "$CONDA_ENV" ]]; then
    source ~/miniconda3/etc/profile.d/conda.sh
    conda activate "$CONDA_ENV"
    ACTIVATED_ENV=1
fi

mkdir -p $MITO_OUT

tiara --input $CONTAM_IN \
      --output "$MITO_OUT/$(basename "${CONTAM_IN%.*}").tsv" \
      --to_fasta mit \
      --threads $MITO_THREADS \
      --prob_cutoff $MITO_PCUTOFF_1 $MITO_PCUTOFF_2 \
      --probabilities \
      --verbose

if [[ "$ACTIVATED_ENV" -eq 1 ]]; then
    conda deactivate
fi

ONLY_MITO_FILE="$MITO_OUT/mitochondrion_$(basename "${CONTAM_IN%.*}").fasta"

grep '^>' "$ONLY_MITO_FILE" | sed 's/^>//' > "$MITO_OUT/tmp_mito_ids.txt"

awk -v ids="$MITO_OUT/tmp_mito_ids.txt" '
    BEGIN {
        while ((getline line < ids) > 0) {
            mito[line] = 1
        }
    }
    /^>/ {
        header = $0
        seq_id = substr($0, 2)
        print_seq = !(seq_id in mito)
    }
    {
        if (print_seq) print
    }
' "$CONTAM_IN" > "$NO_MITO_FILE"

rm "$MITO_OUT/tmp_mito_ids.txt"