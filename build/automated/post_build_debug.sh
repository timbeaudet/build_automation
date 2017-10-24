#!/bin/bash

#
# Automated Build Script for TEMPLATE_PROJECT_NAME to copy the Linux or Mac OS X executable during a debug build.
#
#---------------------------------------------------------------------------------------------------------------------#

kLinuxPlatform="Linux"
currentPlatform=`uname`

export toSlnDir=""
export toRunDir="../../run/"

if [ -z ${buildType} ]; then
	export buildType="debug/"
	echo Build type was undefined, defining as: $buildType
fi

if [ -z ${exePostfix} ]; then
	export exePostfix="_debug"
	echo exePostfix was undefined, defining as: $exePostfix
fi

if [ $kLinuxPlatform = $currentPlatform ]; then
	cp "../linux/${buildType}/TEMPLATE_PROJECT_FILE_linux" "${toRunDir}TEMPLATE_PROJECT_FILE_linux${exePostfix}"
else
	#Copy the debug executable into the run directory, which can then be run via commandline from the run directory.
	if [ -d "${toRunDir}TEMPLATE_PROJECT_FILE${exePostfix}" ]; then
		rm "${toRunDir}TEMPLATE_PROJECT_FILE${exePostfix}"
	fi

	cp "../macosx/debug/TEMPLATE_PROJECT_FILE.app/Contents/MacOS/TEMPLATE_PROJECT_FILE" "${toRunDir}TEMPLATE_PROJECT_FILE${exePostfix}"
fi
