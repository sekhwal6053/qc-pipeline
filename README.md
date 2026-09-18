# QC Pipeline

A modular **Nextflow DSL2** pipeline for quality control of paired-end NGS sequencing data using **FastQC** and **MultiQC**. The pipeline uses **Apptainer containers** for reproducible software environments and has been tested on an **ACCESS Jetstream2 Ubuntu 24.04 virtual machine**.

## Workflow

Paired-end FASTQ → FastQC → MultiQC → QC Report

## Pipeline Structure

    qc-pipeline/
    ├── main.nf
    ├── nextflow.config
    ├── README.md
    └── modules/
        ├── fastqc.nf
        └── multiqc.nf

`main.nf` defines the main Nextflow DSL2 workflow, while individual bioinformatics tools are implemented as separate modules under the `modules/` directory. `nextflow.config` contains the execution resources, Apptainer configuration, work directory, and input parameters.

## Requirements

The following software is required on the host system:

- Java
- Nextflow
- Apptainer

FastQC and MultiQC do not need to be installed directly because they are executed using Apptainer containers.

Check the installations using:

    java -version
    nextflow -version
    apptainer --version

## Input

The pipeline accepts paired-end compressed FASTQ files following the naming convention:

    sample_1.fastq.gz
    sample_2.fastq.gz

For example:

    ERR103042_1.fastq.gz
    ERR103042_2.fastq.gz

The input location is specified using `params.reads` in `nextflow.config`.


## Running the Pipeline

Navigate to the pipeline directory:

    cd qc-pipeline

Run the workflow:

    nextflow run main.nf

Nextflow will execute FastQC on the paired-end FASTQ files and then use MultiQC to generate a consolidated quality-control report.

## Output

Final results are organized as:

    results/
    ├── fastqc/
    │   ├── sample_1_fastqc.html
    │   ├── sample_1_fastqc.zip
    │   ├── sample_2_fastqc.html
    │   └── sample_2_fastqc.zip
    │
    └── multiqc/
        ├── multiqc_report.html
        └── multiqc_data/

The individual FastQC HTML files contain quality-control reports for each FASTQ file. `multiqc_report.html` provides a combined summary of all FastQC results.

## Jetstream2 Storage Configuration

For the current ACCESS Jetstream2 environment, large sequencing datasets, Nextflow intermediate files, and Apptainer containers are stored on the persistent `ngs-data` volume rather than the VM root disk.

Current organization:

    /media/volume/ngs-data/
    ├── projects/
    │   └── qc-pipeline/
    ├── containers/
    ├── apptainer-cache/
    ├── nextflow/
    │   └── work/
    └── references/

The Nextflow work directory is configured as:

    /media/volume/ngs-data/nextflow/work

and Apptainer container/cache files are stored on the persistent data volume to prevent large files from filling the VM root disk.

These paths are specific to the current Jetstream2 environment and can be changed for other computing environments.

## Data

Raw sequencing data and large analysis files are not included in this GitHub repository. Files such as FASTQ, BAM, SAM, Apptainer images, and Nextflow work files should remain on the analysis/storage system rather than being committed to GitHub.

Examples:

    *.fastq
    *.fastq.gz
    *.bam
    *.sam
    *.sif
    work/

## Future Development

This QC workflow is the first component of a larger modular NGS analysis pipeline. Additional DSL2 modules can be incorporated for preprocessing, alignment, quantification, and downstream analysis.

Planned workflow:

    FASTQ
      |
    FastQC
      |
    Cutadapt
      |
    FastQC
      |
    Bowtie2 / STAR
      |
    Samtools
      |
    Quantification
      |
    MultiQC

The modular design allows additional bioinformatics tools and workflows to be added while keeping individual processes organized and reusable.
