# tsx-nimrod
Nimrod files for TSX runs - Tinaroo@UQ

# Install rlpi in your home directory

1. module load R/3.5.0
2. setup local installations
  ```R
	.libPaths(new='~/R/x86_64-pc-linux-gnu-library/3.5/')
	dir.create('~/R/x86_64-pc-linux-gnu-library/3.5/', showWarnings = FALSE, recursive = TRUE)
	.libPaths()
	```
3. install packages: devtools, rlpi and its dependencies

# run nimrod
1. copy "lpi-filtered.csv" to current directory
2. change Output path in lpi_pln.pbs
3. and run
   ```sh
   qsub lpi_pln.pbs
   ```

Embedded-nimrod documentation: https://github.com/uq-rcc/nimrod-embedded
