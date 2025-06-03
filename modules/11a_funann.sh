#!/bin/bash

# 11a_funann.sh

# Sergio Alías-Segura

CONDA_ENV="funannotate"
ACTIVATED_ENV=0
if [[ "$CONDA_DEFAULT_ENV" != "$CONDA_ENV" ]]; then
    source ~/miniconda3/etc/profile.d/conda.sh
    conda activate "$CONDA_ENV"
    ACTIVATED_ENV=1
fi

mkdir -p $FUNANN_OUT

# I don't like to do this but Funannotate won't allow me to set a tmpdir and I don't want garbage in the code dir
cd $FUNANN_OUT 

CLEAN_OUT="$FUNANN_OUT/$(basename "${NO_MITO_FILE%.*}")_clean.fasta"
SORT_OUT="$FUNANN_OUT/$(basename "${NO_MITO_FILE%.*}")_sort.fasta"
MASK_OUT="$FUNANN_OUT/$(basename "${NO_MITO_FILE%.*}")_mask.fasta"
PREDICT_OUT="$FUNANN_OUT/predict"

if [ ! -f "$CLEAN_OUT" ]; then
    echo "funnanotate clean..."
    funannotate clean --input $NO_MITO_FILE \
                      --out  $CLEAN_OUT \
                      --pident $FUNANN_CLEAN_PIDENT \
                      --cov $FUNANN_CLEAN_COV \
                      --minlen $FUNANN_CLEAN_MINLEN
else
    echo "Skipping clean: $CLEAN_OUT already exists"
fi

if [ ! -f "$SORT_OUT" ]; then
    echo "funnanotate sort..."
    funannotate sort --input $CLEAN_OUT \
                     --out $SORT_OUT \
                     --base $FUNANN_SORT_BASE \
                     --minlen $FUNANN_SORT_MINLEN
else
    echo "Skipping sort: $SORT_OUT already exists"
fi

if [ ! -f "$MASK_OUT" ]; then
    echo "funnanotate mask..."
    funannotate mask --input $SORT_OUT \
                     --out $MASK_OUT \
                     --method tantan \
                     --cpus $FUNANN_MASK_CPUS
else
    echo "Skipping mask: $MASK_OUT already exists"
fi

if [ ! -d "$FUNANNOTATE_DB" ]; then
    echo "funnanotate setup..."
    funannotate setup --install all
else
    echo "Skipping setup: $FUNANNOTATE_DB already exists"
fi

if [ ! -d "$PREDICT_OUT" ]; then
    echo "funnanotate predict..."
    funannotate predict --input $MASK_OUT \
                        --out $PREDICT_OUT \
                        --species $FUNANN_PREDICT_SPECIES \
                        --isolate $STRAIN \
                        --transcript_evidence $FUNANN_PREDICT_EVIDENCE_PATH/$FUNANN_PREDICT_TRANS_EVIDENCE
else
    echo "Skipping predict: $PREDICT_OUT already exists"
fi

if [[ "$ACTIVATED_ENV" -eq 1 ]]; then
    conda deactivate
fi