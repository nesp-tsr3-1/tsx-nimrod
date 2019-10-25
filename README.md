# tsx-nimrod
Nimrod files for TSX runs

# Install rlpi in your home dirctory

1. module load R/3.5.0
2. setup local installations
> .libPaths(new='~/R/x86_64-pc-linux-gnu-library/3.5/')
> dir.create('~/R/x86_64-pc-linux-gnu-library/3.5/', showWarnings = FALSE, recursive = TRUE)
> .libPaths()
3. install packages: devtools, rlpi and its dependencies

# run nimrod
change paths in lpi_pln.pbs accordinly
and run

qsub lpi_pln.pbs

