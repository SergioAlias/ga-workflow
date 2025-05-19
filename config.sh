#!/bin/bash

# config.sh


################################### 
## GLOBAL VARS ##
################################### 

export STRAIN="SP1_7"                                                #-----#    Strain code, should be included in filenames
export PROJ_NAME="assembly_"$STRAIN                                  #-----#    Project directory name
export WDIR="/mnt/data3/sergio_data3/scratch/projects/"$PROJ_NAME    #-----#    Project directory path
export READ_PATH=$CODE_PATH"/pacbio"                                 #-----#    Path where PacBio samples were linked and renamed
export ILLUMINA_PATH=$CODE_PATH"/illumina"                           #-----#    Path where Illumina samples were linked and renamed


###################################
## DAEMON MODULES ##
###################################

######  MODULE 0: QUALITY CONTROL #######

export LONGQC_PATH=$HOME"/bin/LongQC"    #-----# LongQC install path
export QC_THREADS=8                      #-----# Number of threads for LongQC. Must be at least 4 [default: 4]


######  MODULE 1a: READ SUBSAMPLING BY LONGEST SUBREADS (PER CLR) #######

export RSUB_ACTIVATE=False            #-----# True if you will run this module, False otherwise
[ "$RSUB_ACTIVATE" == "True" ] && \
export M1_OUT=$WDIR"/subsampling"     #-----# subsampled files outdir


######  MODULE 1b: CONVERTING SUBREADS INTO CCS (HIFI READS) #######

export CCS_ACTIVATE=False     #-----# True if you will run this module, False otherwise
[ "$CCS_ACTIVATE" == "True" ] && \
export M1_OUT=$WDIR"/ccs"     #-----# CCS files outdir
export CCS_THREADS=8          #-----# Number of threads to use, 0 means autodetection
export CCS_MINPASSES=3        #-----# Minimum number of full-length subreads required to generate CCS for a ZMW [default: 3]
export CCS_MINSNR=2.5         #-----# Minimum SNR of subreads to use for generating CCS [default: 2.5]
export CCS_TOPPASSES=60       #-----# Pick at maximum the top N passes for each ZMW [default: 60]
export CCS_MINLEN=10          #-----# Minimum draft length before polishing [default: 10]
export CCS_MAXLEN=5000        #-----# Maximum draft length before polishing [default: 5000]
export CCS_MINRQ=0.99         #-----# Minimum predicted accuracy in [0, 1]. [default: 0.99]
export CCS_LOGLEVEL=WARN      #-----# Set log level. Valid choices: (TRACE, DEBUG, INFO, WARN, FATAL) [default: WARN]


######  MODULE 2: MERGING FLOW CELLS #######

export MERGE_ACTIVATE=True         #-----# True if you will run this module, False otherwise
export MERGE_OUT=$WDIR"/merged"    #-----# merging outdir

[ "$CCS_ACTIVATE" != "True" ] && [ "$RSUB_ACTIVATE" != "True" ] && \
export M1_OUT=$READ_PATH          #-----# Changes input dir if module 1 is not performed


######  MODULE 3: CONVERTING BAM FILES INTO FASTQ #######

export BAM2FQ_OUT=$WDIR"/fastq"    #-----# FASTQ files outdir

[ "$MERGE_ACTIVATE" != "True" ] && \
export MERGE_OUT=$M1_OUT          #-----#  Changes input dir if module 2 is not performed


######  MODULE 4: LENGTH FILTERING #######

export FASTPLONG_ACTIVATE=True           #-----# True if you will run this module, False otherwise
export FASTPLONG_OUT=$WDIR"/filtered"    #-----# Fastplong outdir
export FASTPLONG_MIN_LEN=1000            #-----# Subreads with less length will be discarded


######  MODULE 5: ASSEMBLIES #######

[ "$FASTPLONG_ACTIVATE" != "True" ] && \
export FASTPLONG_OUT=$MERGE_OUT                  #-----#  Changes input dir if module 4 is not performed


######  MODULE 5a: ASSEMBLY WITH FLYE #######

export FLYE_OUT=$WDIR"/flye"       #-----# Flye outdir

if [ "$CCS_ACTIVATE" == "True" ]; then
    export FLYE_TYPE="hifi"        #-----# HiFi option if CCS were obtained...
else
    export FLYE_TYPE="raw"         #-----# ... or raw subread option otherwise
fi

export FLYE_THREADS=15             #-----# Number of threads to use [default: 1]
export FLYE_ITER=2                 #-----# Number of polishing iterations [default: 1]


######  MODULE 5b: ASSEMBLY WITH MINIMAP2 AND MINIASM #######

export MINI_OUT=$WDIR"/minimap2_miniasm"                    #-----# Minimap2 and Miniasm outdir
export MINIMAP2_PATH="/home/sioly/applications/minimap2"    #-----# Minimap2 installation path
export MINIMAP2_THREADS=15                                  #-----# Number of threads to use [default: 3]
export MINIASM_PATH="/home/sioly/applications/miniasm"      #-----# Miniasm installation path


######  MODULE 6: ASSEMBLY POLISHING WITH RACON #######

export RACON_ASSEMBLY="minimap2_miniasm"                        #-----# Assembly to polish. Valid choices: (flye, minimap2_miniasm)
export RACON_OUT=$WDIR"/racon"                                  #-----# Racon outdir
export RACON_PATH="/home/sioly/applications/racon/build/bin"    #-----# Racon installation path
export RACON_THREADS=15                                         #-----# Number of threads to use [default: 1]
export RACON_ITER=3                                             #-----# Number of polishing iterations


######  MODULE 8: ASSEMBLY QUALITY #######

export QUAST_OUT=$WDIR"/quast"                              #-----# QUAST outdir
export QUAST_PATH="/home/sioly/applications/quast.5.2.0"    #-----# QUAST installation path
export QUAST_THREADS=8                                      #-----# Number of threads to use


######  MODULE i0: FASTQC #######

export FASTQC_THREADS=2                      #-----# Number of threads for FastQC. Recommended: 2


######  MODULE i1: Cutadapt #######

export CUTADAPT_OUT=$WDIR"/cutadapt"                              #-----# Cutadapt outdir
export CUTADAPT_ADAPTER_F="AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC"    #-----# Adapter sequence for forward reads
export CUTADAPT_ADAPTER_R="AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT"     #-----# Adapter sequence for reverse reads
export CUTADAPT_THREADS=2                                         #-----# Number of threads for Cutadapt