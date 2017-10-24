#!/bin/bash

#
# Automated Build Script to automate the cleaning of the project.
#
# This may be run by an automated process to clean and/or build each project with an /automated/auto_ script.
#
# Available on github: https://www.github.com/timbeaudet/build_automation/ under the unliscense agreement.
#---------------------------------------------------------------------------------------------------------------------#

pushd ../

premake5 --file="TEMPLATE_PROJECT_FILE.lua" clean

kLinuxPlatform="Linux"
currentPlatform=`uname`
if [ $kLinuxPlatform == $currentPlatform ]; then
  #If any deployable gets created, delete it during cleaning.
  echo blah > /dev/null
else
  #If the Mac OS X delpoyable application package exists, delete it during project cleaning.
  if [ -d "${toRunDir}../TEMPLATE_PROJECT_NAME.app" ]; then
	rm -r "${toRunDir}../TEMPLATE_PROJECT_NAME.app"
  fi
fi

popd
