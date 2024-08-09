#!/bin/bash

#
# Automated Build Script to automate the building of both debug and release configurations 
#   of the project, including the post_build scripts that will build a release package.
#
# This may be run by an automated process to clean and/or build each project with an /automated/auto_ script.
#
# Available on github: https://www.github.com/timbeaudet/build_automation/ under the unlicense agreement.
#---------------------------------------------------------------------------------------------------------------------#

abs_build_had_failure=0

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
	make -j $(nproc) config=debug 2>> "$abs_detailed_report_file"
	#make_project.sh -j $(nproc) --linux --debug 2>> "$abs_detailed_report_file"
	if [ $? -ne 0 ]; then
		abs_build_had_failure=1
	fi

	printf "\n\nbuilding release of: %s\n" `pwd` >> "$abs_detailed_report_file"
	printf "========================================================\n" >> "$abs_detailed_report_file"
	make -j $(nproc) config=release 2>> "$abs_detailed_report_file"
	if [ $? -ne 0 ]; then
		abs_build_had_failure=1
	fi

	if [ 0 -eq $abs_skip_public_config ]; then
		printf "\n\nbuilding public of: %s\n" `pwd` >> "$abs_detailed_report_file"
		printf "========================================================\n" >> "$abs_detailed_report_file"
		make -j $(nproc) config=public 2>> "$abs_detailed_report_file"
		if [ $? -ne 0 ]; then
			abs_build_had_failure=1
		fi
	fi

	popd > /dev/null
else
	#Building a Mac OS X project
	premake5 --file="$abs_project_file_name.lua" xcode4

	#pushd linux/ > /dev/null
	printf "\n\nbuilding debug of: %s\n" `pwd` >> "$abs_detailed_report_file"
	printf "========================================================\n" >> "$abs_detailed_report_file"
	#xcodebuild -target "$abs_project_file_name" -configuration debug build
	make_project.sh --build --debug
	if [ $? -ne 0 ]; then
		abs_build_had_failure=1
	fi

	printf "\n\nbuilding release of: %s\n" `pwd` >> "$abs_detailed_report_file"
	printf "========================================================\n" >> "$abs_detailed_report_file"
	xcodebuild -target "$abs_project_file_name" -configuration release build

	#popd > /dev/null
fi

# Call the user/project specific build hook script if it exists.
abs_project_build_hook=`pwd`/abs_build_hooks/project_build.sh
if [[ -f "$abs_project_build_hook" ]]; then
	source "$abs_project_build_hook"
	# TODO: Check the return value from the hook and set abs_build_had_failure if failed.
fi

# Wrap up by setting the return value to 0 for success or an error-code on failure.
if [ 0 -eq $abs_build_had_failure ]; then
	# Everything actually went as expected!
	abs_return_value=0
else
	# Not everything went to plan, return the failure!
	abs_return_value=2
fi
