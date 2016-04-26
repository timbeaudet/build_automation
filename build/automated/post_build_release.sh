#!/bin/bash

#
# Automated Build Script for TEMPLATE_PROJECT_NAME to package the Mac OS X application during a release build.
#
#---------------------------------------------------------------------------------------------------------------------#

export toSlnDir=""
export toRunDir="../../run/"

if [ -z ${buildType} ]; then
	export buildType="release"
	echo Build type was undefined, defining as: $buildType
fi

if [ -z ${exePostfix} ]; then
	export exePostfix=""
	echo exePostfix was undefined, defining as: $exePostfix
fi

#If the Mac OS X application package already exists, first delete it before recreating.
if [ -d "${toRunDir}../TEMPLATE_PROJECT_NAME.app" ]; then
  rm -r "${toRunDir}../TEMPLATE_PROJECT_NAME.app"
fi

#Make the directory structure of the Mac OS X application package, then copy executable and data into package.
mkdir -p "${toRunDir}../TEMPLATE_PROJECT_NAME.app"
mkdir -p "${toRunDir}../TEMPLATE_PROJECT_NAME.app/Contents"
mkdir -p "${toRunDir}../TEMPLATE_PROJECT_NAME.app/Contents/MacOS"
mkdir -p "${toRunDir}../TEMPLATE_PROJECT_NAME.app/Contents/Resources"
mkdir -p "${toRunDir}../TEMPLATE_PROJECT_NAME.app/Contents/Resources/data"
cp "../macosx/${buildType}/TEMPLATE_PROJECT_FILE.app/Contents/MacOS/TEMPLATE_PROJECT_FILE" "${toRunDir}../TEMPLATE_PROJECT_NAME.app/Contents/MacOS/TEMPLATE_PROJECT_NAME"
cp -r "${toRunDir}data/" "${toRunDir}../TEMPLATE_PROJECT_NAME.app/Contents/Resources/data/"

#Copy the executable into the run directory, if using source-control this could be committed and shared with team.
if [ -d "${toRunDir}TEMPLATE_PROJECT_FILE${exePostfix}" ]; then
	rm "${toRunDir}TEMPLATE_PROJECT_FILE${exePostfix}"
fi

cp "../macosx/${buildType}/TEMPLATE_PROJECT_FILE.app/Contents/MacOS/TEMPLATE_PROJECT_FILE" "${toRunDir}TEMPLATE_PROJECT_FILE${exePostfix}"
