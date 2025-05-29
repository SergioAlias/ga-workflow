#!/bin/bash

# 08_contam.sh

# Sergio Alías-Segura

mkdir -p $CONTAM_OUT

PYTHONUNBUFFERED=1 python3 $SCRIPTS/contamination-check.py -query $CONTAM_IN \
                                                           -taxon $CONTAM_TAXID \
                                                           -out $CONTAM_OUT
