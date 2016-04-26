#!/bin/bash

#
# Automated Build Script for TEMPLATE_PROJECT_NAME to automate the building of both debug and release configurations 
#   of the project, including the post_build scripts that will build a release package.
#
# This may be run by an automated process to clean and/or build each project with an /automated/auto_ script.
#
#---------------------------------------------------------------------------------------------------------------------#

export CurrentDirectory=$(pwd)
cd ../

premake5 --file="make_project.lua" --name="TEMPLATE_PROJECT_FILE" xcode3

cd macosx/
echo Building debug...
xcodebuild -target "TEMPLATE_PROJECT_FILE" -configuration debug build

echo Building release...
xcodebuild -target "TEMPLATE_PROJECT_FILE" -configuration release build

cd $CurrentDirectory
