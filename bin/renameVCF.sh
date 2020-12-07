#!/bin/bash

set -e
set -u

function showHelp() {
        #
        # Display commandline help on STDOUT.
        #
        cat <<EOH
======================================================================================================================
Script to rename vcf files.
Usage:
        $(basename "${0}") OPTIONS
Options:
        -h      Show this help.
        -s      SampleFile, no header, column 1: original name, no extention, column 2: new name, no extention.

===============================================================================================================
EOH
        trap - EXIT
        exit 0
}

#
##
### Main.
##
#

#
# Get commandline arguments.
#
declare project=''
while getopts "s:h" opt
do
        case "${opt}" in
                h)
                        showHelp
                        ;;
                s)
                        sampleFile="${OPTARG}"
                        ;;
        esac
done

#
# Check commandline options.
#
if [[ -z "${sampleFile:-}" ]]
then
        echo 'Must specify a sample file with -s.'
        exit 0
fi


ml BCFtools


for i in $(awk '{{print $0}}' "${sampleFile}")
do
        #echo "${i}"
        EXTERNAL_SAMPLE_ID=$(echo "${i}" | cut -d "," -f 1)
        NEW_NAME=$(echo "${i}" | cut -d "," -f 2)
        echo "EXTERNAL_NAME:${EXTERNAL_SAMPLE_ID}"
        echo "NEW_NAME:${NEW_NAME}"


        #echo "bcftools view -h "${EXTERNAL_SAMPLE_ID}".final.vcf.gz > "${NEW_NAME}"header.txt"
        bcftools view -h "${EXTERNAL_SAMPLE_ID}.final.vcf.gz" > "${NEW_NAME}header.txt"

        #echo "perl -pi -e s'|"${EXTERNAL_SAMPLE_ID}"|"${NEW_NAME}"|'g "${NEW_NAME}"header.txt"
        perl -pi -e "s|${EXTERNAL_SAMPLE_ID}|${NEW_NAME}|g" "${NEW_NAME}header.txt"

        sed '/##GATKCommandLine.GenotypeGVCFs=<ID=GenotypeGVCFs/d' "${NEW_NAME}header.txt" > "${NEW_NAME}header2.txt"
        sed '/##GATKCommandLine.HaplotypeCaller=<ID=HaplotypeCaller/d' "${NEW_NAME}header2.txt" > "${NEW_NAME}headerFinal.txt"

        #echo "bcftools reheader -h "${NEW_NAME}"headerFinal.txt -o "${NEW_NAME}".vcf.gz "${EXTERNAL_SAMPLE_ID}".final.vcf.gz"
        bcftools reheader -h "${NEW_NAME}headerFinal.txt" -o "${NEW_NAME}.vcf.gz" "${EXTERNAL_SAMPLE_ID}.final.vcf.gz"

        rm "${NEW_NAME}header.txt"
        rm  "${NEW_NAME}header2.txt"
done
