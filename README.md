# Fungal Genome Assembly Workflow 🧬🍄

This repository provides a modular, bash-based workflow for fungal genome assembly using PacBio, ONT and/or Illumina reads.

<img src="./img/workflow.png">

Modules with dotted lines are not implemented yet.

## Before you start

This is an **_ad hoc_ pipeline** developed for a specific server environment. That means:
- Some programs are expected to be pre-installed system-wide (e.g., available in `/usr/bin` or similar).
- Some tools come from user-managed Conda environments (see below).
- Others may require manual installation (e.g., in `$HOME/bin`).

You **must check and update the paths for all required software in `config.sh`** and ensure the programs are available as expected, specially if you are using this workflow in a different server.

For programs that require a Conda environment, I highly recommend installing [Miniconda](https://docs.anaconda.com/free/miniconda/index.html) and then installing [Mamba](https://anaconda.org/conda-forge/mamba) for a lightweight and fast experience. I provide YAML files under `/envs` to create all neccesary environments with `mamba env create -f <file.yml>`. Check module code and `config.sh` to know if you need a Conda environment for that one.


## How to run the workflow

1. **Edit the configuration:** Open `config.sh` and set all relevant variables. Each module has its own parameters and some of them have activation flags (`*_ACTIVATE`). It is **very important** to set `config.sh` correctly so the pipeline sets input and output files for each module accordingly. For example, if you are not going to run module 1a, **it is not enough not to run it**: you **must** set `RSUB_ACTIVATE` to False. Otherwise, module 2 will try to use the non-existent output of module 1a as input. 

2. **Run a module:** Launch the desired module by specifying its number:

```bash
./daemon.sh N
```

Replace `N` with the module number you want to run (`0`, `1a`, `1b`, `2`, `3`, `4`, `5a`, `5b`, `6`, `7`, `8`, `i0`, `i1`, `i2`).

For modules **0** (LongQC) and **i0** (FASTQC), you can use the optional `-r` flag:

```bash
./daemon.sh 0 -r
./daemon.sh i0 -r
```
The `-r` flag indicates that QC should be repeated after running module 1a/1b (long reads) or i1 (short reads), to check the quality of processed reads. For other modules, the `-r` flag is ignored.

## Workflow Modules

Each module is run separately through the `daemon.sh` controller. Modules are:

- **0**: Quality Control with LongQC
- **1a**: Read Subsampling by Longest Subreads per CLR
- **1b**: Converting Subreads into CCS (HiFi Reads)
- **2**: Merging SMRT Cells
- **3**: Converting BAM Files into FASTQ
- **4**: Length Filtering with fastplong
- **5a**: Assembly with Flye
- **5b**: Assembly with Minimap2 and Miniasm
- **6**: Assembly Polishing with Racon
- **7**: Assembly Polishing with short reads with Pilon
- **8**: Assembly Quality with QUAST
- **i0**: FastQC (Illumina)
- **i1**: Cutadapt (Illumina)
- **i2**: Assembly with SPAdes (Illumina, but long reads are also accepted for hybrid assembly)

Each module creates logs in your project directory under `/logs`.

For full details on parameters, see comments in `config.sh`. For a visual understanding of the workflow, see the picture above.

## Examples

```bash
# PacBio HiFi assembly from raw subreads
./daemon.sh 0         # Quality Control
./daemon.sh 1b        # Convert to CCS (HiFi) [OPTIONAL]
./daemon.sh 0 -r      # Repeat QC on processed reads
./daemon.sh 2         # Merge SMRT cells [OPTIONAL]
./daemon.sh 3         # Convert BAM to FASTQ
./daemon.sh 4         # Filter by length [OPTIONAL]
./daemon.sh 5a        # Assemble with Flye
./daemon.sh 6         # Polish assembly
./daemon.sh i0        # Quality control of short reads
./daemon.sh i1        # Adapter trimming [OPTIONAL]
./daemon.sh i0 -r     # Repeat QC on processed short reads
./daemon.sh 7         # Polish assembly with short reads
./daemon.sh 8         # Assess assembly quality


# Illumina and PacBio subread hybrid assembly
./daemon.sh i0        # Quality control of short reads
./daemon.sh i1        # Adapter trimming [OPTIONAL]
./daemon.sh i0 -r     # Repeat QC on processed short reads
./daemon.sh 0         # Quality Control
./daemon.sh 2         # Merge SMRT cells [OPTIONAL]
./daemon.sh 3         # Convert BAM to FASTQ
./daemon.sh 4         # Filter by length [OPTIONAL]
./daemon.sh i2        # Assemble with SPAdes
./daemon.sh 6         # Polish assembly
./daemon.sh 7         # Polish assembly with short reads
./daemon.sh 8         # Assess assembly quality


# ONT assembly without short reads (WARNING: module 0 does not work for ont yet)
./daemon.sh 0         # Quality Control
./daemon.sh 1c        # ONT Adapter trimming [OPTIONAL]
./daemon.sh 0 -r      # Repeat QC on processed reads
./daemon.sh 4         # Filter by length [OPTIONAL]
./daemon.sh 5a        # Assemble with Flye
./daemon.sh 6         # Polish assembly
./daemon.sh 8         # Assess assembly quality
```

## Contact

If you are struggling with something related to the workflow, feel free to [open an issue](https://github.com/SergioAlias/ga-workflow/issues/new) or contact me: **salias[at]ucm[dot]com**.
