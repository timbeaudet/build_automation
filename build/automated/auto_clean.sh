#!/bin/bash

#
# Automated Build Script for TEMPLATE_PROJECT_NAME to automate the cleaning of the project.
#
# This may be run by an automated process to clean and/or build each project with an /automated/auto_ script.
#
#---------------------------------------------------------------------------------------------------------------------#

export CurrentDirectory=$(pwd)
cd ../

premake5 --file="make_project.lua" --name="TEMPLATE_PROJECT_FILE" clean

#If the shippable Mac OS X application package exists, delete it during project cleaning.
if [ -d "${toRunDir}../TEMPLATE_PROJECT_NAME.app" ]; then
  rm -r "${toRunDir}../TEMPLATE_PROJECT_NAME.app"
fi

cd $CurrentDirectory
