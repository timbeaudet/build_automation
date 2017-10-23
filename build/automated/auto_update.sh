#!/bin/bash

#
# Automated Build Script to automate the update process by grabbing the latest from the source
# control repository, used here is subversion (svn) though it shouldn't be hard to modify to Git or Hg.
#
# This may be run by an automated process to clean and/or build each project with an /automated/auto_ script.
#
# Available on github: https://www.github.com/timbeaudet/build_automation under the Unlicense aggreement.
#---------------------------------------------------------------------------------------------------------------------#

# This should go back to project_root to update, which by default was 2 levels back from: project_root/build/automated/
pushd ../../ > /dev/null

printf "\n\nupdating from source control of %s\n" `pwd` >> "$abs_detailed_report_file"
printf "========================================================\n" >> "$abs_detailed_report_file"

svn update --quiet --non-interactive >> "$abs_detailed_report_file"

popd > /dev/null
