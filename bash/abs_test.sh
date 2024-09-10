#!/bin/bash

#
# Automated Build Script to automate the testing of the project. This is currently very project specific and
# only calls the project specific test script, however in the future the system may include options in the
# configuration file that would allow running the executables in testmode somehow.
#
# This may be run by an automated process to clean and/or build each project with an /automated/auto_ script.
#
# Available on github: https://www.github.com/timbeaudet/build_automation/ under the unlicense agreement.
#---------------------------------------------------------------------------------------------------------------------#

abs_return_value=0 #Everything is good, until it isn't.

testSystem=
kLinuxPlatform="Linux"
currentPlatform=`uname`
if [ $kLinuxPlatform = $currentPlatform ]; then
	testSystem=linux
else
	testSystem=macos
fi

testExecutable=${abs_project_file_name}
printf "\n\nDEBUG: testExe from filename: %s\n" ${testExecutable} >> "$abs_detailed_report_file"

if [ ! -z "${abs_test_executable}" ]; then
	testExecutable=${abs_test_executable}
	printf "\n\nDEBUG: testExe from config: %s\n" ${testExecutable} >> "$abs_detailed_report_file"
fi

testFlag=--test
if [ ! -z "${abs_test_flag}" ]; then
	testFlag=${abs_test_flag}
fi

if [[ $abs_skip_testing -ne 0 ]]; then
	printf "\n\nskipped running tests for: %s/%s%s_release %s\n" `pwd` ${testExecutable} ${testSystem} ${testFlag} >> "$abs_detailed_report_file"
	printf "========================================================\n" >> "$abs_detailed_report_file"
	return 0
fi

pushd ../run/ > /dev/null

printf "\n\nrunning tests for: %s/%s_%s_release %s\n" `pwd` ${testExecutable} ${testSystem} ${testFlag} >> "$abs_detailed_report_file"
printf "========================================================\n" >> "$abs_detailed_report_file"

"./${testExecutable}_${testSystem}_release" ${testFlag} 2 >> "$abs_detailed_report_file"
cat ./test_results.txt >> "$abs_detailed_report_file"
printf "\n\n" >> "$abs_detailed_report_file"

if [ $? -ne 0 ]; then
	abs_return_value=1
fi

popd > /dev/null


# Call the user/project specific test hook script if it exists.
abs_project_test_hook=`pwd`/abs_build_hooks/project_test.sh
if [[ -f "$abs_project_test_hook" ]]; then
	source "$abs_project_test_hook"
	# TODO: Check the return value from the hook and set failure if needed.
fi
