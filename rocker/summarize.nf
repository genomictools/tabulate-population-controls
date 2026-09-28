process SUMMARIZE {
    tag "${cohort}:${category}"

    label 'simple'
    label 'rocker'

    publishDir("${params.output_dir}/summary", mode: 'copy')

    input:
    tuple val(cohort), val(key), val(category), path(file), val(n_variants)

    output:
    tuple val(cohort), val(category),
          path("${cohort}.${category}.summary.tsv"),
          env(n_variants)

    script:
    """
    #!/bin/bash
    echo -e "gene\tnvar\tac\tan\taf\tnhom" > ${cohort}.${category}.summary.tsv
    cat ${file} | \
    sort -u | \
    awk '
    {
        gene = \$1
        variant_key = gene SUBSEP \$2

        if (!(variant_key in seen)) {
            seen[variant_key] = 1
            nvar[gene]++
        }

        ac[gene] += \$3
        an[gene] += \$4
        if (\$5 != "." && \$5 != "") af[gene] += \$5
        nhom[gene] += \$6
    }
    END {
        for (gene in nvar) {
            printf "%s\t%d\t%d\t%d\t%f\t%d\\n", gene, nvar[gene], ac[gene], an[gene], af[gene], nhom[gene]
        }
    }
    ' \
    >> ${cohort}.${category}.summary.tsv

    # Count the number of samples and variants
    n_variants=\$(wc -l < ${cohort}.${category}.summary.tsv)
    """
}
