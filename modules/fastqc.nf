process FASTQC {

    tag "${sample_id}"

    container 'docker://biocontainers/fastqc:v0.11.9_cv8'

    input:
    tuple val(sample_id), path(reads)

    output:
    path "*_fastqc.html", emit: html
    path "*_fastqc.zip",  emit: zip

    script:
    """
    fastqc --threads ${task.cpus} ${reads}
    """
}
