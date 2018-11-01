@ECHO off

REM
REM Automated Build Script for TEMPLATE_PROJECT_NAME to automate the cleaning of the project.
REM
REM This may be run by an automated process to clean and/or build each project with an /automated/auto_ script.
REM
REM Available on github: https://www.github.com/timbeaudet/build_automation/ under the unliscense agreement.
REM -------------------------------------------------------------------------------------------------------------------

PUSHD ..\
premake5 --file="TEMPLATE_PROJECT_FILE.lua" clean
POPD
