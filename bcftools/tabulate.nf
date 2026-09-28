process TABULATE {
    tag "${cohort}:${key}:${category}"

    label 'simple'
    label 'bcftools'

    publishDir("${params.output_dir}/variants", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(category),
          path(file), path(index),
          val(n_variants)

    output:
    tuple val(cohort), val(key), val(category),
          path("${cohort}.${key}.${category}.tsv"),
          env(n_variants)

    script:
    """
    #!/bin/bash
    # Get frequency
    bcftools +split-vep \
        -a ${params.vep_tag} \
        -c ${params.aggregate_by} \
        -s worst \
        -f '%${params.aggregate_by}\t%CHROM:%POS:%REF:%ALT\t%AC_nfe\t%AN_nfe\t%AF_nfe\t%nhomalt_nfe\n' \
        ${file} \
        > ${cohort}.${key}.${category}.tsv

    # Count the number of variants
    n_variants=\$(wc -l < ${cohort}.${key}.${category}.tsv)
    """
}
