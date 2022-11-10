#!/bin/bash

IMGT_FOLDER=$1
IMGT_RELEASE_VERSION_FILE="${IMGT_FOLDER}/release_version.txt"
IMGT_ALIGNMENTS_FOLDER="${IMGT_FOLDER}/alignments/"

if [ ! -d "$IMGT_FOLDER" ];
then
    echo -e "Argument should be an IMGT/HLA folder from github\nYour argument '${IMGT_FOLDER}' does not exist. Please check." >>/dev/stderr
    exit 1
fi

if [ ! -f "$IMGT_RELEASE_VERSION_FILE" ];
then
    echo -e "Argument should be an IMGT/HLA folder from github\nYour argument '${IMGT_FOLDER}' is a folder BUT does not contain 'release_version.txt' mandatory file.\nPlease check if it is a correct IMGT/HLA folder from github." >>/dev/stderr
    exit 1
fi

if [ ! -d "$IMGT_ALIGNMENTS_FOLDER" ];
then
    echo -e "Argument should be an IMGT/HLA folder from github\nYour argument '${IMGT_FOLDER}' is a folder BUT does not contain '/alignments/' mandatory sub-folder.\nPlease check if it is a correct IMGT/HLA folder from github." >>/dev/stderr
    exit 1
fi

IMGT_VERSION=$(awk -F' ' '{if($2 == "version:"){print $4}}' ${IMGT_RELEASE_VERSION_FILE} )
echo "IMGT/HLA version ${IMGT_VERSION} detected !"

IMGT_OUTPUT_FILE="HLA-ALL_${IMGT_VERSION}.IMGT"

echo "File $PWD/${IMGT_OUTPUT_FILE} will be generated"

for filepath in ${IMGT_ALIGNMENTS_FOLDER}/*_nuc.txt; do
    FILENAME=$(basename ${filepath})
    if [[ $FILENAME == "ClassI_nuc.txt" ]];
    then
        echo "ignoring file $FILENAME...."
        continue
    fi
    echo "generate data for ${filepath}"
    gawk -f nuc_extract_exons.awk "${filepath}" >> ${IMGT_OUTPUT_FILE}
done

echo "File $PWD/${IMGT_OUTPUT_FILE} have been generated"