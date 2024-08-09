@ECHO off

REM
REM Automated Build Script for TEMPLATE_PROJECT_NAME to automate the cleaning of the project.
REM
REM This may be run by an automated process to clean and/or build each project with an /automated/auto_ script.
REM
REM Available on github: https://www.github.com/timbeaudet/build_automation/ under the unlicense agreement.
REM -------------------------------------------------------------------------------------------------------------------

premake5 --file="%abs_project_file_name%.lua" clean

REM Call the user/project specific clean  hook script if it exists.
SET abs_project_clean_hook="%CD%\abs_build_hooks\project_clean.bat"
IF EXIST %abs_project_clean_hook% (
	CALL %abs_project_clean_hook%
)

REM Nothing can really go terribly wrong in cleaning, can it?
SET abs_return_value=0
