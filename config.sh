#!/bin/bash

# config.sh


################################### 
## GLOBAL VARS ##
################################### 

export STRAIN="BMYC7B7"                                   #-----#    Strain code, should be included in filenames
export PROJ_NAME="assembly_"$STRAIN                       #-----#    Project directory name
export WDIR="/scratch/salias/projects/"$PROJ_NAME         #-----#    Project directory path
export SCRIPTS=$CODE_PATH"/scripts"                       #-----#    Custom scripts path
export DATA_PATH='/home/salias/data'                      #-----#    Global data path
export READ_PATH=$CODE_PATH"/pacbio"                      #-----#    Path where long read samples were linked and renamed
export ILLUMINA_PATH=$DATA_PATH"/mycoides_marta_links"    #-----#    Path where Illumina samples were linked and renamed. Ignored if not used
export SEQ_TYPE="pb"                                      #-----#    Long read sequencing technology. Valid choices: (pb, ont). Ignored for Illumina-only assembly 


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


######  MODULE 1c: ONT ADAPTER TRIMMING #######

export PORECHOP_ACTIVATE=False                              #-----# True if you will run this module, False otherwise
[ "$PORECHOP_ACTIVATE" == "True" ] && \
export M1_OUT=$WDIR"/porechop"                              #-----# Porechop files outdir
export PORECHOP_PATH="/home/sioly/applications/Porechop"    #-----# Porechop installation path
export PORECHOP_THREADS=8                                   #-----# Number of threads to use for adapter alignment [default: 8]


######  MODULE 2: MERGING FLOW CELLS #######

export MERGE_ACTIVATE=True         #-----# True if you will run this module, False otherwise
export MERGE_OUT=$WDIR"/merged"    #-----# merging outdir

[ "$CCS_ACTIVATE" != "True" ] && \
[ "$RSUB_ACTIVATE" != "True" ] && \
[ "$PORECHOP_ACTIVATE" != "True" ] && \
export M1_OUT=$READ_PATH          #-----# Changes input dir if module 1 is not performed


######  MODULE 3: CONVERTING BAM FILES INTO FASTQ #######

export BAM2FQ_ACTIVATE=True        #-----# True if you will run this module, False otherwise
export BAM2FQ_OUT=$WDIR"/fastq"    #-----# FASTQ files outdir

[ "$MERGE_ACTIVATE" != "True" ] && \
export MERGE_OUT=$M1_OUT          #-----#  Changes input dir if module 2 is not performed


######  MODULE 4: LENGTH FILTERING #######

export FASTPLONG_ACTIVATE=True                      #-----# True if you will run this module, False otherwise
if [ "$SEQ_TYPE" == "pb" ]; then
    export FASTPLONG_OUT=$WDIR"/filtered_pacbio"    #-----# Fastplong outdir for PacBio reads
elif [ "$SEQ_TYPE" == "ont" ]; then
    export FASTPLONG_OUT=$WDIR"/filtered_ont"       #-----# Fastplong outdir for ONT reads
fi
export FASTPLONG_MIN_LEN=1000                       #-----# Subreads with less length will be discarded

[ "$BAM2FQ_ACTIVATE" != "True" ] && \
export BAM2FQ_OUT=$MERGE_OUT          #-----#  Changes input dir if module 2 is not performed


######  MODULE 5: ASSEMBLIES #######

[ "$FASTPLONG_ACTIVATE" != "True" ] && \
export FASTPLONG_OUT=$BAM2FQ_OUT          #-----#  Changes input dir if module 4 is not performed
export ASSEMBLY_TARGET="spades_hybrid"    #-----#  Assembly we will polish. Valid choices: (flye, minimap2_miniasm, spades, spades_hybrid)


######  MODULE 5a: ASSEMBLY WITH FLYE #######

export FLYE_OUT=$WDIR"/flye"          #-----# Flye outdir

if [ "$CCS_ACTIVATE" == "True" ]; then
    export FLYE_TYPE="pacbio-hifi"    #-----# HiFi option if CCS were obtained...
elif [ "$SEQ_TYPE" == "ont" ]; then
    export FLYE_TYPE="nano-hq"        #-----# ... ONT option...
else
    export FLYE_TYPE="pacbio-raw"     #-----# ... or PacBio raw subread option otherwise
fi
export FLYE_THREADS=15                #-----# Number of threads to use [default: 1]
export FLYE_RAM=80                    #-----# RAM limit for Flye in Gb (managed by ulimit)
export FLYE_ITER=1                    #-----# Number of polishing iterations [default: 1]
export FLYE_ASMCOV=40                 #-----# Reduced coverage for initial disjointig assembly (typically, 40x is enough)
export FYLE_GSIZE="55m"               #-----# Estimated genome size (for example, 5m or 2.6g) 

######  MODULE 5b: ASSEMBLY WITH MINIMAP2 AND MINIASM #######

export MINI_OUT=$WDIR"/minimap2_miniasm"                    #-----# Minimap2 and Miniasm outdir
export MINIMAP2_PATH="/home/sioly/applications/minimap2"    #-----# Minimap2 installation path
export MINIMAP2_THREADS=15                                  #-----# Number of threads to use [default: 3]
export MINIASM_PATH="/home/sioly/applications/miniasm"      #-----# Miniasm installation path


######  MODULE 6: ASSEMBLY POLISHING WITH RACON #######

export RACON_ACTIVATE=True                                      #-----# True if you will run this module, False otherwise
export RACON_OUT=$WDIR"/racon"                                  #-----# Racon outdir
export RACON_PATH="/home/sioly/applications/racon/build/bin"    #-----# Racon installation path
export RACON_THREADS=15                                         #-----# Number of threads to use [default: 1]
export RACON_ITER=3                                             #-----# Number of polishing iterations


######  MODULE 7: ASSEMBLY POLISHING WITH PILON #######

export PILON_ACTIVATE=True                                        #-----# True if you will run this module, False otherwise

if [ "$RACON_ACTIVATE" == "True" ]; then
    export PILON_IN=$RACON_OUT/$ASSEMBLY_TARGET"/iter_"$RACON_ITER/$ASSEMBLY_TARGET"_racon_"$RACON_ITER".fasta"    #-----# Assembly file if Racon was used
else
    export PILON_IN=$WDIR/$ASSEMBLY_TARGET/$ASSEMBLY_TARGET".fasta"                                                #-----# Assembly file otherwise
fi

export PILON_OUT=$WDIR"/pilon"                                    #-----# Pilon outdir
export PILON_JAR="/home/sioly/applications/bin/pilon-1.24.jar"    #-----# Pilon file
export PILON_THREADS=8                                            #-----# Number of threads to use [default: 1]
export PILON_RAM=70                                               #-----# RAM limit for Pilon in Gb
export PILON_ITER=5                                               #-----# Number of polishing iterations


######  MODULE 8: CONTAMINATION CHECK #######

export CONTAM_OUT=$WDIR"/contam"    #-----# Contamination check outdir
export CONTAM_TAXID="31870"         #-----# NCBI taxon ID of the species. Examples: Colletotrichum graminicola, 31870; Fusarium flocciferum, 56642

if [ "$PILON_ACTIVATE" == "True" ]; then
    export CONTAM_IN=$PILON_OUT/$ASSEMBLY_TARGET"/iter_"$PILON_ITER/$ASSEMBLY_TARGET"_pilon_"$PILON_ITER".fasta"    #-----# Assembly file if Pilon was used
else
    export CONTAM_IN=$PILON_IN                                                                                      #-----# Assembly file otherwise
fi   


######  MODULE 9: MITOCHONDRIAL CONTIGS DETECTION #######

export MITO_OUT=$WDIR"/tiara"                                                  #-----# Mitochondrial contigs detection outdir
export MITO_THREADS=4                                                          #-----# Number of threads to use
export MITO_PCUTOFF_1=0.65                                                     #-----# Probability threshold needed for classification to a class in the first stage [default: 0.65]
export MITO_PCUTOFF_2=0.65                                                     #-----# Probability threshold needed for classification to a class in the second stage [default: 0.65]
export NO_MITO_FILE="$MITO_OUT/no_mito_$(basename "${CONTAM_IN%.*}").fasta"    #-----# Assembly outfile without mitochondrial contig(s)


######  MODULE 10: ASSEMBLY QUALITY #######

export QUAST_OUT=$WDIR"/quast"                              #-----# QUAST outdir
export QUAST_PATH="/home/sioly/applications/quast.5.2.0"    #-----# QUAST installation path
export QUAST_THREADS=8                                      #-----# Number of threads to use


######  MODULE 11a: ANNOTATION WITH FUNANNOTATE #######

export FUNANNOTATE_DB="/mnt/data3/sergio_data3/funannotate_db"                       #-----# Directory where Funannotate databases will be stored (variable name fixed by Funannotate)
export GENEMARK_PATH="/home/sergio/bin/gmes_linux_64_4"                              #-----# GeneMark-ES/ET directory, where gmes_petap.pl is located (variable name fixed by Funannotate)

export FUNANN_OUT=$WDIR"/funannotate"                                                #-----# Funannotate outdir
export FUNANN_CLEAN_PIDENT=95                                                        #-----# Clean: percent identity of overlap [default: 95]
export FUNANN_CLEAN_COV=95                                                           #-----# Clean: percent coverage of overlap [default: 95]
export FUNANN_CLEAN_MINLEN=500                                                       #-----# Clean: minimum length of contig to keep [default: 500]
export FUNANN_SORT_BASE="scaffold"                                                   #-----# Sort: base name to relabel contigs [default: scaffold]
export FUNANN_SORT_MINLEN=0                                                          #-----# Sort: shorter contigs are discarded [default: 0]
export FUNANN_MASK_CPUS=4                                                            #-----# Mask: number of CPUs to use [default: 2]
export FUNANN_PREDICT_SPECIES="Fusarium_flocciferum"                                 #-----# Predict: species name (use quotes for binomial)
export FUNANN_PREDICT_EVIDENCE_PATH="/mnt/data3/sergio_data3/evidence"               #-----# Predict: path where evidence files are stored
export FUNANN_PREDICT_TRANS_EVIDENCE="Fustr1_EST_20180511_cluster_consensi.fasta"    #-----# Predict: mRNA/ESTs files to align to genome (not compressed)
export FUNANN_IPRSCAN_NUM=1000                                                       #-----# Iprscan: Number of FASTA files per chunk [default: 1000]
export FUNANN_IPRSCAN_PATH="/opt/interproscan/interproscan.sh"                       #-----# Iprscan: Path to interproscan.sh
export FUNANN_IPRSCAN_CPUS=2                                                         #-----# Iprscan: Number of InterProScan instances to run
export FUNANN_ANTISMASH_CPUS=8                                                       #-----# antiSMASH: How many CPUs to use in parallel [default: all CPUs]
export FUNANN_ANNOTATE_CPUS=8                                                        #-----# Annotate: Number of CPUs to use [default: 2]
export FUNANN_COMPARE_CPUS=4                                                         #-----# Compare: Number of CPUs to use [default: 2]


######  MODULE 12: ANNOTATION QUALITY #######

export BUSCO_OUT=$WDIR"/busco"              #-----# BUSCO outdir
export BUSCO_LINEAGE="hypocreales_odb10"    #-----# BUSCO lineage to be used
export BUSCO_CPUS=4                         #-----# number of CPUs to use [default: 1]


######  MODULE i0: FASTQC #######

# No config needed


######  MODULE i1: CUTADAPT #######

export CUTADAPT_ACTIVATE=False                                    #-----# True if you will run this module, False otherwise
export CUTADAPT_OUT=$WDIR"/cutadapt"                              #-----# Cutadapt outdir
export CUTADAPT_ADAPTER_F="AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC"    #-----# Adapter sequence for forward reads
export CUTADAPT_ADAPTER_R="AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT"     #-----# Adapter sequence for reverse reads
export CUTADAPT_THREADS=2                                         #-----# Number of threads for Cutadapt


######  MODULE i2: ASSEMBLY WITH SPADES #######

export SPADES_PATH="/home/salias/bin/SPAdes-4.2.0-Linux/bin"    #-----# SPAdes installation path
export SPADES_HYBRID=False                                      #-----# True if you want to use long reads too, False otherwise

if [ "$SPADES_HYBRID" == "True" ]; then
    export SPADES_NAME="spades_hybrid"    #-----# Name for SPAdes directory and FASTA file if hybrid assembly is performed
else
    export SPADES_NAME="spades"           #-----# Name otherwise
fi

export SPADES_OUT=$WDIR/$SPADES_NAME      #-----# SPAdes outdir

[ "$CUTADAPT_ACTIVATE" != "True" ] && \
export CUTADAPT_OUT=$ILLUMINA_PATH    #-----#  Changes input dir if module 4 is not performed