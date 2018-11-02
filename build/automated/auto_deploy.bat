@ECHO off

REM
REM Automated Build Script to automate the deploying of the project. This is currently very project specific and
REM only calls the project specific deploy script, however in the future the system may include options in the
REM configuration file that would allow uploading somewhere, like itch.io
REM
REM This may be run by an automated process to clean and/or build each project with an /automated/auto_ script.
REM
REM Available on github: https://www.github.com/timbeaudet/build_automation/ under the unliscense agreement.
REM -------------------------------------------------------------------------------------------------------------------

REM Call the user/project specific deploy hook script if it exists.
SET abs_project_deploy_hook="%CD%\abs_build_hooks\project_deploy.bat"
IF EXIST %abs_project_deploy_hook% (
	CALL %abs_project_deploy_hook%
	REM TODO: Check the return value from the hook and set failure if needed.
)

REM Nothing can really go terribly wrong in deploying until that todo is fixed, can it?
SET abs_return_value=0
