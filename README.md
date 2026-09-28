### Introduction

This workflow summarizes variant counts from public datasets (e.g., gnomAD) to 
estimate control cohort frequencies for downstream burden testing. It processes
aggregated variant counts by gene and category, producing a standardized summary
table that can be used as input for case-control association analyses.

The workflow is designed to:
- Process variant frequency data from public databases
- Summarize counts by gene and variant category
- Generate standardized output for burden testing workflows
- Support parallel processing of large datasets

### Usage

`--cohorts` is a required input CSV file containing cohort metadata and file locations.

The typical command looks like the following:

```bash
nextflow run genomicstools/tabulate-population-controls \
    -r main \
    --output_dir results/ \
    --cohorts input/cohorts_info.csv
```

### Inputs & Parameters

#### Input Files
- `cohorts`: CSV file with columns: cohort, key, file (VCF), index (TBI)

#### Variant Selection Parameters

**Filtering Categories**
- `categories`: Default 'Pathogenic,Damaging,Splicing,High,PTV,Stop,Rare,Unfiltered' - Comma-separated list of variant consequence categories to include
  - `Pathogenic`: ClinVar pathogenic variants
  - `Damaging`: Predicted damaging variants (SIFT/PolyPhen)
  - `Splicing`: Splice site affecting variants
  - `High`: High-impact variants
  - `PTV`: Protein-truncating variants (frameshift, stop gained, splice donor/acceptor)
  - `Stop`: Stop-gain variants
  - `Rare`: Rare variants (MAF < 0.01)
  - `Unfiltered`: All variants (no filtering)

### Output

- `summary/`: Tabulated variant counts by gene and category for each cohort
- `results/`: Processed summary files ready for downstream analysis