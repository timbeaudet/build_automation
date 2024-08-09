@ECHO off

REM
REM Automated Build Script to automate the testing of the project. This is currently very project specific and
REM only calls the project specific test script, however in the future the system may include options in the
REM configuration file that would allow running the executables in testmode somehow.
REM
REM This may be run by an automated process to clean and/or build each project with an /automated/auto_ script.
REM
REM Available on github: https://www.github.com/timbeaudet/build_automation/ under the unlicense agreement.
REM -------------------------------------------------------------------------------------------------------------------

REM Call the user/project specific test hook script if it exists.
SET abs_project_test_hook="%CD%\abs_build_hooks\project_test.bat"
IF EXIST %abs_project_test_hook% (
	CALL %abs_project_test_hook%
	REM TODO: Check the return value from the hook and set failure if needed.
)

REM Nothing can really go terribly wrong in testing until that todo is fixed, can it?
SET abs_return_value=0
