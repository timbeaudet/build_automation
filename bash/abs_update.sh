#!/bin/bash

#
# Automated Build Script to automate the update process by grabbing the latest from the source
# control repository, used here is Git if .git directory exists one directory back, or subversion (svn) if not.
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

found_updates=0

# if [[ -d .git ]]; then
# 	git fetch origin
# 	if [[ $(git log HEAD..origin/master --oneline) ]]; then
# 		echo "Found modifications, updating repository."
# 		git pull --rebase
# 		found_updates=1
# 	fi
# else
# 	if [[ $(svn merge --dry-run -r BASE:HEAD .) ]]; then
# 		echo "Found modifications, updating repository."
# 		svn update --quiet --non-interactive >> "$abs_detailed_report_file"
# 		found_updates=1
# 	fi
# fi

# The above does not account for svn externals and so when TurtleBrains or ICE is updated the
# updates will not get pulled in. The following forces a pull/update to just grab anyway.
if [[ -d .git ]] || [[ "$abs_source_control" == "git" ]]; then
	git fetch origin
	echo "Forcing an update of git repository." >> "$abs_detailed_report_file"
	git pull --rebase
	found_updates=1
else
	echo "Forcing an update of svn repository." >> "$abs_detailed_report_file"
	svn update --quiet --non-interactive >> "$abs_detailed_report_file"
	found_updates=1
fi

popd > /dev/null

# Call the user/project specific update hook script if it exists.
abs_project_update_hook=`pwd`/abs_build_hooks/project_update.sh
if [[ -f "$abs_project_update_hook" ]]; then
	source "$abs_project_update_hook"
	# TODO: Check the return value from the hook and set failure if needed.
fi

# Not exactly true, but nothing went wrong by default. This will set the value to 1 or 0 depending
# on whether updates were found or not. NOTE: the primary script will not throw an error in this
# very specific situation (abs_update script value 1) and instead will either continue or skip the
# rest of the build steps for the current project depending on settings.
abs_return_value=$found_updates
