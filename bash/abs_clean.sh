#!/bin/bash

#
# Automated Build Script to automate the cleaning of the project.
#
# This may be run by an automated process to clean and/or build each project with an /automated/auto_ script.
#
# Available on github: https://www.github.com/timbeaudet/build_automation/ under the unlicense agreement.
#---------------------------------------------------------------------------------------------------------------------#

echo Running clean.sh from `pwd`

premake5 --file="$abs_project_file_name.lua" clean

kLinuxPlatform="Linux"
currentPlatform=`uname`
if [ $kLinuxPlatform == $currentPlatform ]; then
	: #No operation, if any deployable gets created, delete it during cleaning.
else
	#If the Mac OS X delpoyable application package exists, delete it during project cleaning.
	if [ -d "${toRunDir}../$abs_project_friendly_name.app" ]; then
		rm -r "${toRunDir}../$abs_project_friendly_name.app"
	fi
fi

# Call the user/project specific clean hook script if it exists.
abs_project_clean_hook=`pwd`/abs_build_hooks/project_clean.sh
if [[ -f "$abs_project_clean_hook" ]]; then
	source "$abs_project_clean_hook"
	# TODO: Check the return value from the hook and set failure if needed.
fi

# Nothing can really go terribly wrong in cleaning, can it?
abs_return_value=0
