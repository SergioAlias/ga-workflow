#!/bin/bash

# Sergio Alías, 20250506
# Last modified 20260210

# daemon.sh

# Script for controlling genome assembly workflow (adapted to SLURM)

# Usage: ./daemon.sh [module-number] [-r]

if ! [[ "$1" =~ ^(0|1a|1b|1c|2|3|4|5a|5b|6|7|8|9a|9b|10|11a|11b|12|i0|i1|i2)$ ]]; then
  echo "Warning: No module number specified. Usage: ./daemon.sh [module-number] [-r]"
  exit 1
fi

export R_FLAG=False
if [[ "$2" == "-r" ]] ; then
    export R_FLAG=True
    [[ ! "$1" =~ ^(0|i0)$ ]] &&
    printf "\nWarning: -r option will be ignored for module $1\n"
fi

framework_dir=`dirname $0`
export CODE_PATH=$(readlink -f $framework_dir )
CONFIG_DAEMON=$CODE_PATH'/config.sh'
CLUSTER_CONFIG=$CODE_PATH'/cluster_config.sh'
export module=$1 
source $CONFIG_DAEMON
source $CLUSTER_CONFIG
export PATH=$CODE_PATH'/modules:'$PATH

TIMESTAMP=$(date +"%Y%m%d_%H%M")
LOGPATH=$WDIR"/logs"
mkdir -p $LOGPATH


## MODULE EXECUTION ##

LOGFILE="module_"$module"_"$TIMESTAMP".slurm.log"
FINAL_LOG="$LOGPATH/$LOGFILE"

printf "\nPacBio Genome assembly workflow\n" | tee -a $FINAL_LOG
printf "Sergio Alías-Segura, 2026\n\n" | tee -a $FINAL_LOG
printf "Using config: STRAIN=$STRAIN, WDIR=$WDIR\n" | tee -a $FINAL_LOG
printf "Submitting module $module ($SCRIPT_TO_RUN) to SLURM...\n" | tee -a $FINAL_LOG
printf "Resources: QUEUE=$SLURM_PARTITION, CPUS=$SLURM_CPUS, MEM=$SLURM_MEM, TIME=$SLURM_TIME\n\n" | tee -a $FINAL_LOG

job_id=$(sbatch \
    --job-name="$SCRIPT_TO_RUN" \
    --output="$FINAL_LOG" \
    --error="$FINAL_LOG" \
    --open-mode=append \
    --partition="$SLURM_PARTITION" \
    --cpus-per-task="$SLURM_CPUS" \
    --mem="$SLURM_MEM" \
    --time="$SLURM_TIME" \
    --parsable \
    --wrap="
        echo '--------------------------------'
        echo \"Running on node: \$(hostname)\"
        echo \"Start time: \$(date)\"
        echo '--------------------------------'
        echo ''
        
        export CODE_PATH=$CODE_PATH
        export module=$module
        export R_FLAG=$R_FLAG
        source $CONFIG_DAEMON
        export PATH=$CODE_PATH'/modules':\$PATH
        export SLURM_CPUS=$SLURM_CPUS
        export SLURM_MEM=$SLURM_MEM
        export SLURM_TIME=$SLURM_TIME
        
        time $SCRIPT_TO_RUN
        
        echo ''
        echo '--------------------------------'
        echo \"End time: \$(date)\"
        echo '--------------------------------'
        echo ''
    "
)

printf "Job submitted successfully! Job ID: $job_id\n"
printf "Logfile: $FINAL_LOG\n\n"