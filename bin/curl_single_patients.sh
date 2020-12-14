#!/bin/bash

set -e
set -u

function showHelp() {
	#
	# Display commandline help on STDOUT.
	#
	cat <<EOH
======================================================================================================================
Script generate curl command, to upload all vcf files for patients in the patient file.
Usage:
	$(basename "${0}") OPTIONS
Options:
	-h	Show this help.
	-p	Patient file containing: vcf name (without extension), gender, project no, age, HPO terms.
	-d	The directory containing the vcf files.
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

while getopts "d:p:t:e:h" opt
do
	case "${opt}" in
		h)
			showHelp
			;;
		p)
			patientFile="${OPTARG}"
			;;
		d)
			vcfFileDir="${OPTARG}"
			;;
		t)
			token="${OPTARG}"
			;;
		e)
			email="${OPTARG}"
			;;
		*)
			"Unhandled option. Try $(basename "${0}") -h for help."
			;;
	esac
done

#
# Check commandline options.
#
if [[ -z "${patientFile:-}" ]]
then
	echo 'Must specify a patient file with -p.'
	exit 0
fi

if [[ -z "${vcfFileDir:-}" ]]
then
	echo 'Must specify a directory with vcf files with -d.'
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




for i in $(awk '{if (NR>1){{print $0}}}' "${patientFile}")
do
#	echo "${i}"	
	VCF=$(echo "${i}" | cut -d "," -f 1)
	GENDER=$(echo "${i}" | cut -d "," -f 2)
	PROJECT=$(echo "${i}" | cut -d "," -f 3)
	AGE=$(echo "${i}" | cut -d "," -f 4)
	HPO_TERMS=$(echo "${i}" | cut -d "," -f 5)

	echo "curl -F "user_token=${token}"\
	-F "user_email=${email}"\
	-F "snp_vcf_file=@/${vcfFileDir}/${VCF}.vcf.gz"\
	-F "gender=${GENDER}"\
	-F "project_id=${PROJECT}"\
	-F "age=${AGE}"\
	-F "hpo_terms=${HPO_TERMS}"\
	https://moon.diploid.com/samples.json"

	curl -F "user_token=${token}"\
	-F "user_email=${email}"\
	-F "snp_vcf_file=@/${vcfFileDir}/${VCF}.vcf.gz"\
	-F "gender=${GENDER}"\
	-F "project_id=${PROJECT}"\
	-F "age=${AGE}"\
	-F "hpo_terms=${HPO_TERMS}"\
	https://moon.diploid.com/samples.json

done
