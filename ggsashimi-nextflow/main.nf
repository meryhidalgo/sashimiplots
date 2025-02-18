#!/usr/bin/env Nextflow
nextflow.enable.dsl=2

include {processCSV; sashimi} from './modules/create_plots'

// ---- Input files ----
sashimi_palette = Channel.value(projectDir + "/assets/palette.txt")

gtf = Channel.value(params.ref_gtf)

plots_csv = Channel.fromPath(params.plots_config)

input_bams = Channel.fromPath("$params.input_bam/*.bam", checkIfExists: true)

tsv = Channel.value(params.bam_tsv)

// ---- Run the pipeline ----
workflow {
    
    processCSV(plots_csv) | flatten \
    | set { bams_tsvs }

    sashimi(input_bams, gtf, sashimi_palette, bams_tsvs)

}
