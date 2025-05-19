#!/bin/bash

# 04_fastplong.sh

# Sergio Alías-Segura

mkdir -p $FASTPLONG_OUT

for fq_file in $BAM2FQ_OUT/*.fastq; do
    prefix=$(basename "${fq_file%.fastq}")
    fastplong --in $fq_file \
              --out $FASTPLONG_OUT"/"$prefix".fastq" \
              --disable_quality_filtering \
              --disable_adapter_trimming \
              --length_required $FASTPLONG_MIN_LEN \
              --html $FASTPLONG_OUT"/"$prefix"_report.html" \
              --json $FASTPLONG_OUT"/"$prefix"_report.json"
done

# Disables quality filtering, see https://www.biostars.org/p/452579/
# Disables adapter trimming, see https://github.com/yfukasawa/LongQC/issues/21#issuecomment-775832434

