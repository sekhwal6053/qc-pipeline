process MULTIQC {

    container 'docker://multiqc/multiqc:v1.27'

    input:
    path fastqc_results

    output:
    path "multiqc_report.html"
    path "multiqc_data"

    script:
    """
    multiqc . -o .
    """
}
