# How to use

## IMGT/HLA

Clone the [IMGTHLA](https://github.com/ANHIG/IMGTHLA/) repository.
Following file and folder must exist :
- release_version.txt
- /alignments/

## Launch the script

`bash generate_db_hlascan.sh FOLDER_TO_IMGT_HLA_REPO`

## What does the script do?

The script extracts exons sequences for each gene/allele file `*_nuc.txt` contained in `/alignments/`,except for file `ClassI_nuc.txt` and try to generate a database file to be used with [hlascan](https://github.com/SyntekabioTools/HLAscan)

## Results

A file following hlascan database file format (especially `dataset/db/HLA-ALL.IMGT` file from `https://github.com/SyntekabioTools/HLAscan/releases/download/v2.0.0/dataset.zip`) is generated. File name is `HLA-ALL_${IMGT_VERSION}.IMGT`. Value of `IMGT_VERSION` is extracted from `release_version.txt` file.

Note that the format was deduced by reverse engeenering and may still contain errors.