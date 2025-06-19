#!/bin/bash

# 12_busco.sh

# Sergio Alías-Segura

mkdir -p $BUSCO_OUT

# I don't like to do this but BUSCO won't allow me to set a tmpdir and I don't want garbage in the code dir
cd $BUSCO_OUT

busco --in $FUNANN_OUT"/predict/annotate_results/"$FUNANN_PREDICT_SPECIES"_"$STRAIN".proteins.fa" \
      --out $FUNANN_PREDICT_SPECIES"_"$STRAIN \
      --out_path $BUSCO_OUT \
      --mode proteins \
      --lineage_dataset $BUSCO_LINEAGE \
      --cpu $BUSCO_CPUS

