# Build Automation
This project contains a set of batch and bash scripts to automate the build process of applications for Windows, Mac and Linux. It may be specific to my needs, but feel free to use any bits that may be useful.

###Why
By running ``automate_builds`` script, all projects within the current directory will be found and the build scripts will be ran. The project will get cleaned, then built. There are future plans to add support for updating the project before a clean build is performed, then potentially running a test and deploy script.

###Installation
I place ``automate_builds.bat`` and/or ``automate_builds.sh`` in a directory, *tools* that is included in my PATH.

The build folder gets placed in each separate project, and then make some wording/name changes as needed. This includes a make_project.lua script for premake5, and the automated scripts to clean and build a project.