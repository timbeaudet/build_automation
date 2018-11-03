#!/bin/bash

#
# Automated Build Script to automate the update process by grabbing the latest from the source
# control repository, used here is subversion (svn) though it shouldn't be hard to modify to Git or Hg.
#
# This may be run by an automated process to clean and/or build each project with an /automated/auto_ script.
#
# Available on github: https://www.github.com/timbeaudet/build_automation/ under the unliscense agreement.
#---------------------------------------------------------------------------------------------------------------------#

# This should go back to project_root to update, which by default is 1 levels back from: project_root/build/
pushd ../ > /dev/null

#If there is not abs_detailed_report_file variable, use stdout to display report.
if [ -z ${abs_detailed_report_file+x} ]; then
	abs_detailed_report_file=/dev/stdout
fi

printf "\n\nupdating from source control of %s\n" `pwd` >> "$abs_detailed_report_file"
printf "========================================================\n" >> "$abs_detailed_report_file"

# TODO: There was a project that contained returning a value when there were no svn updates.
# would be good to put that in here and return a value indicating whether things were updated or not.

# TODO: Would be nice to use git by default if user has a git repo.
# TODO: Would be nice to call build/initialize_externals.sh if that file exists.
svn update --quiet --non-interactive >> "$abs_detailed_report_file"

popd > /dev/null

# Call the user/project specific update hook script if it exists.
abs_project_update_hook=`pwd`/abs_build_hooks/project_update.sh
if [[ -f "$abs_project_update_hook" ]]; then
	source "$abs_project_update_hook"
	# TODO: Check the return value from the hook and set failure if needed.
fi

# Nothing can really go terribly wrong in updating, can it?
abs_return_value=0
