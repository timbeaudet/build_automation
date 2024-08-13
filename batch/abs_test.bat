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

SET abs_return_value=0

ECHO Debug setting testExecutable
SET testExecutable=%abs_project_file_name%
IF DEFINED abs_test_executable (
	SET testExecutable=%abs_test_executable%
)

ECHO Debug testExecutable was set to: %testExecutable%

SET testFlag=--test
IF DEFINED abs_test_flag (
	SET testFlag=%abs_test_flag%
)

ECHO Debug testFlag was set to: %testFlag%

IF 0 == %abs_skip_testing% (
	PUSHD ..\run\
	(ECHO.)>>%abs_detailed_report_file%
	(ECHO.)>>%abs_detailed_report_file%
	(ECHO "running tests for /run/%testExecutable%_release %testFlag%")>>%abs_detailed_report_file%
	(ECHO --------------------------------------------------------)>>%abs_detailed_report_file%

	ECHO Debug trying to run CALL ../run/%testExecutable%_release %testFlag%

	(%testExecutable%_release %testFlag%)>>%abs_detailed_report_file%
	IF NOT 0 == %errorlevel% (
		(ECHO %abs_project_friendly_name% failed unit tests)>>%abs_detailed_report_file%
		SET abs_return_value=1
	)

	POPD
) ELSE (
	(ECHO.)>>%abs_detailed_report_file%
	(ECHO.)>>%abs_detailed_report_file%
	(ECHO "skipped running tests for /run/%testExecutable%_release %testFlag%")>>%abs_detailed_report_file%
	(ECHO --------------------------------------------------------)>>%abs_detailed_report_file%
)

ECHO Debug checking build hook
REM Call the user/project specific test hook script if it exists.
SET abs_project_test_hook="%CD%\abs_build_hooks\project_test.bat"
IF EXIST %abs_project_test_hook% (
	CALL %abs_project_test_hook%
	REM TODO: Check the return value from the hook and set failure if needed.
)

ECHO Debug Done test.bat
