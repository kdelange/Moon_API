#!/bin/bash

set -e
set -u

function showHelp() {
	#
	# Display commandline help on STDOUT.
	#
	cat <<EOH
======================================================================================================================
Script generate curl command, to upload all vcf files of parents in the parents sample file.
Usage:
	$(basename "${0}") OPTIONS
Options:
	-h	Show this help.
	-p	Parents file containing: vcf name (without extension), gender, project no, age.
	-d	The directory containing the vcf files.
	-m	Moon JSON output file, containing all samples with Moon number.
	-t	token from moon. Connecting you to your moon account.
	-e	Email adres used by moon.

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
while getopts "d:p:m:t:e:h" opt
do
	case "${opt}" in
		h)
			showHelp
			;;
		p)
			parentsFile="${OPTARG}"
			;;
		d)
			vcfFileDir="${OPTARG}"
			;;
		m)
			MoonJson="${OPTARG}"
			;;
		t)
			token="${OPTARG}"
			;;
		e)
			email="${OPTARG}"
			;;	
	esac
done

#
# Check commandline options.
#
if [[ -z "${parentsFile:-}" ]]
then
	echo 'Must specify a parents file with -p.'
	exit 0
fi

if [[ -z "${vcfFileDir:-}" ]]
then
	echo 'Must specify a directory with vcf files with -d.'
	exit 0
fi

if [[ -z "${MoonJson}:-" ]]
then
	echo 'Must specify an output .json file for the samples in Moon.'
	exit 0
fi
if [[ -z "${token:-}" ]]
then
	echo 'Must specify your user token from moon with -t.'
	exit 0
fi
if [[ -z "${email:-}" ]]
then
	echo 'Must specify your email adres used by moon with -e.'
	exit 0
fi


for i in $(awk '{if (NR>1){{print $0}}}' "${parentsFile}")
do
#	echo "${i}"	
	VCF=$(echo "${i}" | cut -d "," -f 1)
	GENDER=$(echo "${i}" | cut -d "," -f 2)
	PROJECT=$(echo "${i}" | cut -d "," -f 3)

	echo "curl -F "user_token="${token}""\
     -F "user_email="${email}""\
     -F "snp_vcf_file=@/"${vcfFileDir}/${VCF}.vcf.gz""\
     -F "gender="${GENDER}""\
     -F "project_id="${PROJECT}""\
     https://moon.diploid.com/samples.json"

	curl -F "user_token="${token}""\
     -F "user_email="${email}""\
     -F "snp_vcf_file=@/"${vcfFileDir}/${VCF}.vcf.gz""\
     -F "gender="${GENDER}""\
     -F "project_id="${PROJECT}""\
     https://moon.diploid.com/samples.json

done

echo "curl -X GET -d "user_token="${token}"" -d "user_email="${email}"" https://moon.diploid.com/samples.json >> "${MoonJson}""
curl -X GET -d "user_token="${token}"" -d "user_email="${email}"" https://moon.diploid.com/samples.json >> "${MoonJson}"
