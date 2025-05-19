#!/bin/bash

# Sergio Alías, 20250506
# Last modified 20250515

# daemon.sh

# Script for controlling genome assembly workflow

# Usage: ./daemon.sh [module-number] [-r]

if ! [[ "$1" =~ ^(0|1a|1b|2|3|4|5a|5b|6|7|8)$ ]]; then
  echo "Warning: No module number specified. Usage: ./daemon.sh [module-number] [-r]"
  exit 1
fi

export R_FLAG=False
if [[ "$2" == "-r" ]] ; then
    export R_FLAG=True
    [[ ! "$1" =~ ^(0)$ ]] &&
    printf "\nWarning: -r option will be ignored for module $1\n"
fi

framework_dir=`dirname $0`
export CODE_PATH=$(readlink -f $framework_dir )
CONFIG_DAEMON=$CODE_PATH'/config.sh'
export module=$1 
source $CONFIG_DAEMON
export PATH=$CODE_PATH'/modules:'$PATH

TIMESTAMP=$(date +"%Y%m%d_%H%M")
LOGFILE="module_"$module"_"$TIMESTAMP".log"
LOGPATH=$WDIR"/logs"
mkdir -p $LOGPATH

printf "\nPacBio Genome assembly workflow\n\n" | tee -a "$LOGPATH"/"$LOGFILE"
printf "Sergio Alías-Segura, 2025\n\n" | tee -a "$LOGPATH"/"$LOGFILE"
printf "Using config: STRAIN=$STRAIN, WDIR=$WDIR\n\n" | tee -a "$LOGPATH"/"$LOGFILE" 
printf -- "--------------------\n\n" | tee -a "$LOGPATH"/"$LOGFILE" 


## MODULE EXECUTION ##

if [ "$module" == "0" ] ; then
    # MODULE 0: QUALITY CONTROL
    printf "Launching module 0: Quality Control\n\n" | tee -a "$LOGPATH"/"$LOGFILE" 
    printf -- "--------------------\n\n" | tee -a "$LOGPATH"/"$LOGFILE" 
    { time 00_qc.sh; } 2>&1 | tee -a "$LOGPATH"/"$LOGFILE"
    printf "\nLogfile: $LOGFILE\n"

elif [ "$module" == "1a" ] ; then
    # MODULE 1a: READ SUBSAMPLING BY LONGEST SUBREADS (PER CLR)
    printf "Launching module 1a: Read subsampling by longest subreads (per CLR)\n\n" | tee -a "$LOGPATH"/"$LOGFILE"
    printf -- "--------------------\n\n" | tee -a "$LOGPATH"/"$LOGFILE" 
    { time 01a_rsub.sh; } 2>&1 | tee -a "$LOGPATH"/"$LOGFILE"
    printf "\nLogfile: $LOGFILE\n"

elif [ "$module" == "1b" ] ; then
    # MODULE 1b: CONVERTING SUBREADS INTO CCS (HIFI READS)
    printf "Launching module 1b: Converting subreads into CCS (HiFi reads)\n\n" | tee -a "$LOGPATH"/"$LOGFILE"
    printf -- "--------------------\n\n" | tee -a "$LOGPATH"/"$LOGFILE" 
    { time 01b_ccs.sh; } 2>&1 | tee -a "$LOGPATH"/"$LOGFILE"
    printf "\nLogfile: $LOGFILE\n"

elif [ "$module" == "2" ] ; then
    # MODULE 2: MERGING SMRT CELLS
    printf "Launching module 2: Merging SMRT cells\n\n" | tee -a "$LOGPATH"/"$LOGFILE"
    printf -- "--------------------\n\n" | tee -a "$LOGPATH"/"$LOGFILE" 
    { time 02_merge.sh; } 2>&1 | tee -a "$LOGPATH"/"$LOGFILE"
    printf "\nLogfile: $LOGFILE\n"

elif [ "$module" == "3" ] ; then
    # MODULE 3: CONVERTING BAM FILES INTO FASTQ
    printf "Launching module 3: Converting BAM files into FASTQ\n\n" | tee -a "$LOGPATH"/"$LOGFILE"
    printf -- "--------------------\n\n" | tee -a "$LOGPATH"/"$LOGFILE" 
    { time 03_bam2fq.sh; } 2>&1 | tee -a "$LOGPATH"/"$LOGFILE"
    printf "\nLogfile: $LOGFILE\n"

elif [ "$module" == "4" ] ; then
    # MODULE 4: LENGTH FILTERING
    printf "Launching module 4: Length filtering\n\n" | tee -a "$LOGPATH"/"$LOGFILE"
    printf -- "--------------------\n\n" | tee -a "$LOGPATH"/"$LOGFILE" 
    { time 04_fastplong.sh; } 2>&1 | tee -a "$LOGPATH"/"$LOGFILE"
    printf "\nLogfile: $LOGFILE\n" 

elif [ "$module" == "5a" ] ; then
    # MODULE 5a: ASSEMBLY WITH FLYE
    printf "Launching module 5a: Assembly with Flye\n\n" | tee -a "$LOGPATH"/"$LOGFILE"
    printf -- "--------------------\n\n" | tee -a "$LOGPATH"/"$LOGFILE" 
    { time 05a_flye.sh; } 2>&1 | tee -a "$LOGPATH"/"$LOGFILE"
    printf "\nLogfile: $LOGFILE\n"

elif [ "$module" == "5b" ] ; then
    # MODULE 5b: ASSEMBLY WITH MINIMAP2 AND MINIASM
    printf "Launching module 5b: Assembly with Minimap2 and Miniasm\n\n" | tee -a "$LOGPATH"/"$LOGFILE"
    printf -- "--------------------\n\n" | tee -a "$LOGPATH"/"$LOGFILE" 
    { time 05b_mini.sh; } 2>&1 | tee -a "$LOGPATH"/"$LOGFILE"
    printf "\nLogfile: $LOGFILE\n"

elif [ "$module" == "6" ] ; then
    # MODULE 6: ASSEMBLY POLISHING WITH RACON
    printf "Launching module 6: Assembly polishing with Racon\n\n" | tee -a "$LOGPATH"/"$LOGFILE"
    printf -- "--------------------\n\n" | tee -a "$LOGPATH"/"$LOGFILE" 
    { time 06_racon.sh; } 2>&1 | tee -a "$LOGPATH"/"$LOGFILE"
    printf "\nLogfile: $LOGFILE\n" 

elif [ "$module" == "7" ] ; then
    # MODULE 8: ASSEMBLY QUALITY
    printf "Launching module 8: Assembly quality\n\n" | tee -a "$LOGPATH"/"$LOGFILE"
    printf -- "--------------------\n\n" | tee -a "$LOGPATH"/"$LOGFILE" 
    { time 08_quast.sh; } 2>&1 | tee -a "$LOGPATH"/"$LOGFILE"
    printf "\nLogfile: $LOGFILE\n" 

fi
