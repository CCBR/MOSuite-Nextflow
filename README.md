# MOSuite-Nextflow

Nextflow pipeline for differential multi-omics analysis with [Multi-OmicsSuite](https://github.com/CCBR/MOSuite)

[![build](https://github.com/CCBR/MOSuite-Nextflow/actions/workflows/build-nextflow.yml/badge.svg)](https://github.com/CCBR/MOSuite-Nextflow/actions/workflows/build-nextflow.yml)
[![docs](https://github.com/CCBR/MOSuite-Nextflow/actions/workflows/docs-mkdocs.yml/badge.svg)](https://github.com/CCBR/MOSuite-Nextflow/actions/workflows/docs-mkdocs.yml)

See the website for detailed information, documentation, and examples:
<https://ccbr.github.io/MOSuite-Nextflow/>

## Quickstart

View CLI options:

```sh
mosuite-nxf --help
```

Initialize and run MOSuite with test data:

```sh
# initialize the project directory
mosuite-nxf init --output /data/$USER/mosuite-project

# preview the jobs that will run
mosuite-nxf run --output /data/$USER/mosuite-project \
   --mode local -profile test -preview

# launch a run on slurm
mosuite-nxf run --output /data/$USER/mosuite-project \
   --mode slurm -profile test
```

## Help & Contributing

Come across a **bug**? Open an [issue](https://github.com/CCBR/MOSuite-Nextflow/issues) and include a minimal reproducible example.

Have a **question**? Ask it in [discussions](https://github.com/CCBR/MOSuite-Nextflow/discussions).

Want to **contribute** to this project? Check out the [contributing guidelines](docs/contributing.md).

## References

View the MOSuite R package: <https://github.com/CCBR/MOSuite>
