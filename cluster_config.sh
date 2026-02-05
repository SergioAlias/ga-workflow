## SLURM DEFAULTS ##

SLURM_PARTITION="short" 
SLURM_TIME="0-02:00:00" # D-HH:MM:SS  
SLURM_MEM="8G"           
SLURM_CPUS="1"           
SCRIPT_TO_RUN=""

## MODULE SLURM PARAMS ##

case "$module" in
    "0")
        SCRIPT_TO_RUN="00_qc.sh"
        SLURM_CPUS="4"
        SLURM_MEM="8G"
        SLURM_TIME="0-01:00:00"
        ;;
    "1a")
        SCRIPT_TO_RUN="01a_rsub.sh"
        SLURM_CPUS="8"
        SLURM_MEM="16G"
        SLURM_TIME="0-04:00:00"
        ;;
    "1b")
        SCRIPT_TO_RUN="01b_ccs.sh"
        SLURM_CPUS="24"
        SLURM_MEM="64G"
        SLURM_TIME="0-23:59:00"
        ;;
    "1c")
        SCRIPT_TO_RUN="01c_porechop.sh"
        SLURM_CPUS="16"
        SLURM_MEM="32G"
        SLURM_TIME="0-04:00:00"
        ;;
    "2")
        SCRIPT_TO_RUN="02_merge.sh"
        SLURM_CPUS="1"
        SLURM_MEM="4G"
        SLURM_TIME="0-01:00:00"
        ;;
    "3")
        SCRIPT_TO_RUN="03_bam2fq.sh"
        SLURM_CPUS="4"
        SLURM_MEM="8G"
        SLURM_TIME="0-03:00:00"
        ;;
    "4")
        SCRIPT_TO_RUN="04_fastplong.sh"
        SLURM_CPUS="2"
        SLURM_MEM="4G"
        SLURM_TIME="0-01:00:00"
        ;;
    "5a")
        SLURM_PARTITION="long"
        SCRIPT_TO_RUN="05a_flye.sh"
        SLURM_CPUS="32"
        SLURM_MEM="128G"
        SLURM_TIME="2-00:00:00"
        ;;
    "5b")
        SCRIPT_TO_RUN="05b_mini.sh"
        SLURM_CPUS="24" # Must consider MINIMAP2_THREADS in config.sh
        SLURM_MEM="64G"
        SLURM_TIME="0-12:00:00"
        ;;
    "6")
        SCRIPT_TO_RUN="06_racon.sh"
        SLURM_CPUS="24" # Must consider MINIMAP2_THREADS and RACON_THREADS in config.sh
        SLURM_MEM="64G"
        SLURM_TIME="0-23:59:00"
        ;;
    "7")
        SCRIPT_TO_RUN="07_pilon.sh"
        SLURM_CPUS="24"
        SLURM_MEM="64G"
        SLURM_TIME="0-23:59:00"
        ;;
    "8")
        SCRIPT_TO_RUN="08_contam.sh"
        SLURM_CPUS="8"
        SLURM_MEM="16G"
        SLURM_TIME="0-02:00:00"
        ;;
    "9a")
        SCRIPT_TO_RUN="09a_mito.sh"
        SLURM_CPUS="4"
        SLURM_MEM="8G"
        SLURM_TIME="0-01:00:00"
        ;;
    "10")
        SCRIPT_TO_RUN="10_quast.sh"
        SLURM_CPUS="8"
        SLURM_MEM="8G"
        SLURM_TIME="0-00:15:00"
        ;;
    "11a")
        SCRIPT_TO_RUN="11a_funann.sh"
        SLURM_CPUS="16"
        SLURM_MEM="32G"
        SLURM_TIME="0-12:00:00"
        ;;
    "12")
        SCRIPT_TO_RUN="12_busco.sh"
        SLURM_CPUS="8"
        SLURM_MEM="16G"
        SLURM_TIME="0-04:00:00"
        ;;
    "i0")
        SCRIPT_TO_RUN="i0_fastqc.sh"
        SLURM_CPUS="2"
        SLURM_MEM="4G"
        SLURM_TIME="0-01:00:00"
        ;;
    "i1")
        SCRIPT_TO_RUN="i1_cutadapt.sh"
        SLURM_CPUS="4"
        SLURM_MEM="4G"
        SLURM_TIME="0-02:00:00"
        ;;
    "i2")
        SLURM_PARTITION="long" 
        SCRIPT_TO_RUN="i2_spades.sh"
        SLURM_CPUS="10" # default: 16
        SLURM_MEM="100G" # default: 250
        SLURM_TIME="2-00:00:00"
        ;;
    *)
        echo "Error: No entry on cluster_config.sh for module $module"
        exit 1
        ;;
esac