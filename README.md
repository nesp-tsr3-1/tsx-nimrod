# tsx-nimrod
Nimrod files for TSX runs - Tinaroo@UQ

# Install rlpi in your home directory

1. module load R/3.5.0
2. setup local installations
  ```R
	.libPaths(new='~/R/x86_64-pc-linux-gnu-library/3.5/')
	dir.create('~/R/x86_64-pc-linux-gnu-library/3.5/', showWarnings = FALSE, recursive = TRUE)
	.libPaths()

3. install packages: devtools, rlpi and its dependencies

# run nimrod
1. ssh into tinaroo
2. copy "lpi-filtered.csv" to project dir
3. change Output path in lpi_pln.pbs
4. and run
   	qsub lpi_pln.pbs

Embedded-nimrod documentation: https://github.com/uq-rcc/nimrod-embedded
