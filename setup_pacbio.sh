#!/bin/bash

# setup_pacbio.sh

# Script for creating symbolic links to raw PacBio data

# Useful because files for multiple flow cells of the same sample have identical filenames
# This way we can have all links in the same dir with flow cell information in the filename

SRC_DIR="/mnt/data3/sergio_data3/genomas"
OUT_DIR="/mnt/data3/sergio_data3/assembly/pacbio"
SUBDIRS=("SOIL_SP1_7_cell1" "SOIL_SP1_7_cell2" "SOIL_SP10_2_cell1")

mkdir -p $OUT_DIR

for SUB in "${SUBDIRS[@]}"; do
    TAG="${SUB##*_}"
    STRAIN="${SUB%_*}"
    SRC_SUB="$SRC_DIR/$SUB"

    for FILE in "$SRC_SUB"/*; do
        [ -e "$FILE" ] || continue

        BASENAME="$(basename "$FILE")"

        if [[ "$BASENAME" == *"$STRAIN"* ]]; then
            PREFIX="${BASENAME%%$STRAIN*}$STRAIN"
            SUFFIX="${BASENAME#*$STRAIN}"
            NEW_NAME="${PREFIX}_${TAG}${SUFFIX}"
        else
            NEW_NAME="$BASENAME"
        fi

        ln -s "$FILE" "$OUT_DIR/$NEW_NAME"
    done
done
