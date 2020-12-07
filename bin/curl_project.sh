#!/bin/bash

set -e
set -u

function showHelp() {
	#
	# Display commandline help on STDOUT.
	#
	cat <<EOH
======================================================================================================================
Script to create project in Moon.
Usage:
	$(basename "${0}") OPTIONS
Options:
	-h	Show this help.
	-p	Project name.
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
while getopts "p:t:e:h" opt
do
	case "${opt}" in
		h)
			showHelp
			;;
		p)
			project="${OPTARG}"
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
if [[ -z "${project:-}" ]]
then
	echo 'Must specify a project name with -p.'
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

echo "curl -F "user_token=${token}"\
	-F "user_email=${email}"\
	-F "project[name]=${project}"\
	https://moon.diploid.com/projects.json"

curl -F "user_token=${token}"\
	-F "user_email=${email}"\
	-F "project[name]=${project}"\
	https://moon.diploid.com/projects.json
