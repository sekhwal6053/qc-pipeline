nextflow.enable.dsl=2

include { FASTQC } from './modules/fastqc'
include { MULTIQC } from './modules/multiqc'


params.reads = '/media/volume/ngs-data/projects/fastq-test/raw/*_{1,2}.fastq.gz'


workflow {

    reads_ch = Channel
        .fromFilePairs(params.reads, checkIfExists: true)

    FASTQC(reads_ch)

    fastqc_results = FASTQC.out.zip.mix(FASTQC.out.html)

    MULTIQC(fastqc_results.collect())
}
