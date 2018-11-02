#!/bin/bash

#
# Automated Build Script to automate the building of both debug and release configurations 
#   of the project, including the post_build scripts that will build a release package.
#
# This may be run by an automated process to clean and/or build each project with an /automated/auto_ script.
#
# Available on github: https://www.github.com/timbeaudet/build_automation/ under the unliscense agreement.
#---------------------------------------------------------------------------------------------------------------------#

#If there is not abs_detailed_report_file variable, use stdout to display report.
if [ -z ${abs_detailed_report_file+x} ]; then
	abs_detailed_report_file=/dev/stdout
fi

kLinuxPlatform="Linux"
currentPlatform=`uname`
if [ $kLinuxPlatform = $currentPlatform ]; then
	#Building a Linux project
	premake5 --file="$abs_project_file_name.lua" clean
	premake5 --file="$abs_project_file_name.lua" gmake
	
	printf "\n\nbuilding debug of: %s\n" `pwd` >> "$abs_detailed_report_file"
	printf "========================================================\n" >> "$abs_detailed_report_file"
	pushd linux > /dev/null
	# make config=debug 2>> "$abs_detailed_report_file"
	# if [ $? -ne 0 ]; then
	# 	abs_return_value=1
	# fi

	printf "\n\nbuilding release of: %s\n" `pwd` >> "$abs_detailed_report_file"
	printf "========================================================\n" >> "$abs_detailed_report_file"
	make config=release 2>> "$abs_detailed_report_file"
	if [ $? -ne 0 ]; then
		abs_return_value=1
	fi

	popd > /dev/null
else
	#Building a Mac OS X project
	premake5 --file="$abs_project_file_name.lua" xcode4

	cd macosx/
	echo Building debug...
	xcodebuild -target "$abs_project_file_name" -configuration debug build

	echo Building release...
	xcodebuild -target "$abs_project_file_name" -configuration release build
fi
