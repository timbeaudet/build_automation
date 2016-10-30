#!/bin/bash

#
# Simple batch script to create a XCode project using premake5 and the make_project.lua script.
#
#----------------------------------------------------------------------------------------------------------------------

kLinuxPlatform="Linux"
currentPlatform=`uname`

if [ $kLinuxPlatform = $currentPlatform ]; then
  premake5 --file="make_project.lua" --name="TEMPLATE_PROJECT_FILE" codelite
else
  premake5 --file="make_project.lua" --name="TEMPLATE_PROJECT_FILE" xcode3
fi
