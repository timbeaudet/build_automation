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

# Call the user/project specific test hook script if it exists.
abs_project_test_hook=`pwd`/abs_build_hooks/project_test.sh
if [[ -f "$abs_project_test_hook" ]]; then
	source "$abs_project_test_hook"
	# TODO: Check the return value from the hook and set failure if needed.
fi

# Nothing can really go terribly wrong in testing until that todo is fixed, can it?
abs_return_value=0
