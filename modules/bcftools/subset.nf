process SUBSET {
    tag "${cohort}:${key}"

    label 'simple'
	label 'bcftools'

    publishDir("${params.output_dir}/subsets", mode: 'copy')

    input:
    tuple val(cohort), val(key), path(file), path(index)

    output:
    tuple val(cohort), val(key),
          path("${cohort}.${key}.subset.vcf.gz"),
          path("${cohort}.${key}.subset.vcf.gz.tbi"),
          env(n_variants)

    script:
    """
    #!/bin/bash
    # Subset by key
    bcftools view -r ${key} --threads ${task.cpus} ${file} -Oz -o ${cohort}.${key}.subset.vcf.gz

    # Index the VCF
    tabix ${cohort}.${key}.subset.vcf.gz

    # Count the number of samples and variants
    n_variants=\$(bcftools index -n ${cohort}.${key}.subset.vcf.gz)
    """
}

