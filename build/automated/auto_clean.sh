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
	if [ -d "${toRunDir}../TEMPLATE_PROJECT_NAME.app" ]; then
		rm -r "${toRunDir}../TEMPLATE_PROJECT_NAME.app"
	fi
fi
