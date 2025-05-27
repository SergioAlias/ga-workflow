#!/bin/bash

# 04_fastplong.sh

# Sergio Alías-Segura

mkdir -p $FASTPLONG_OUT

if [[ -f "$BAM2FQ_OUT/${STRAIN}.fastq.gz" ]]; then
    FASTPLONG_IN=<(zcat "$BAM2FQ_OUT/${STRAIN}.fastq.gz")
elif [[ -f "$BAM2FQ_OUT/${STRAIN}.fastq" ]]; then
    FASTPLONG_IN="$BAM2FQ_OUT/${STRAIN}.fastq"
fi

fastplong --in $FASTPLONG_IN \
          --out $FASTPLONG_OUT"/"$prefix".fastq" \
          --disable_quality_filtering \
          --disable_adapter_trimming \
          --length_required $FASTPLONG_MIN_LEN \
          --html $FASTPLONG_OUT"/"$prefix"_report.html" \
          --json $FASTPLONG_OUT"/"$prefix"_report.json"


# Disables quality filtering, see https://www.biostars.org/p/452579/
# Disables adapter trimming, see https://github.com/yfukasawa/LongQC/issues/21#issuecomment-775832434

