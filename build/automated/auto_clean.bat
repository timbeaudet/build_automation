@ECHO off

REM
REM Automated Build Script for TEMPLATE_PROJECT_NAME to automate the cleaning of the project.
REM
REM This may be run by an automated process to clean and/or build each project with an /automated/auto_ script.
REM
REM Available on github: https://www.github.com/timbeaudet/build_automation/ under the unliscense agreement.
REM -------------------------------------------------------------------------------------------------------------------

premake5 --file="%abs_project_file_name%.lua" clean

SET project_clean_hook="%CD%\abs_build_hooks\project_clean.bat"
IF EXIST %project_clean_hook% (
	ECHO Found and calling project specific clean hook.
	CALL %project_clean_hook%
)
