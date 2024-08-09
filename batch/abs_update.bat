@ECHO off

REM
REM Automated Build Script to automate the update process by grabbing the latest from the source
REM control repository, used here is Git if .git directory exists one directory back, or subversion (svn) if not.
REM
REM Available on github: https://www.github.com/timbeaudet/build_automation/ under the unlicense agreement.
REM -------------------------------------------------------------------------------------------------------------------

REM This should go back to project_root to update, which is expected to be 1 level back from: project_root/build/

REM Apparently %var% gets expanded upon reading the script and not during the running
REM the command so when used within a for loop, or IF?, oddities seem to ensue.
REM Enabling delayed expansion and using !var! causes the expansion to happen during
REM the command. Still I think I've seen oddities with regards to nested loops.
SETLOCAL enableextensions ENABLEDELAYEDEXPANSION

REM This is a temporary file use to spit out the contents of a command and read them
REM back in to check if the contents was empty, a 4 command hack to the bash solution.
SET init_external_update_file="temp_update_check_file.abs"

PUSHD ..\

IF NOT DEFINED abs_detailed_report_file (
	SET abs_detailed_report_file="conout$"
)

(ECHO.)>>%abs_detailed_report_file%
(ECHO.)>>%abs_detailed_report_file%
(ECHO updating from source control of %CD%)>>%abs_detailed_report_file%
(ECHO ========================================================)>>%abs_detailed_report_file%

SET found_updates=0

ECHO "UPDATING FROM: %CD%"

REM IF EXIST ".git\" (
REM 	git fetch origin
REM 	(git log HEAD..origin/master --oneline)>"%init_external_update_file%"
REM 	set size=0
REM 	FOR /f %%i in ("%init_external_update_file%") do set size=%%~zi
REM 	IF !size! gtr 0 (
REM 		ECHO "Found modifications, updating repository."
REM 		git pull --rebase
REM 		SET found_updates=1
REM 	) ELSE (
REM 		ECHO "No modifications were found."
REM 	)
REM 	DEL "%init_external_update_file%"
REM ) ELSE (
REM 	(svn merge --dry-run -r BASE:HEAD .)>"%init_external_update_file%"
REM 	set size=0
REM 	FOR /f %%i in ("%init_external_update_file%") do set size=%%~zi
REM 	IF !size! gtr 0 (
REM 		ECHO "Found modifications, updating repository."
REM 		(svn update --quiet --non-interactive)>>%abs_detailed_report_file%
REM 		SET found_updates=1
REM 	) ELSE (
REM 		ECHO "No modifications were found."
REM 	)
REM 	REM DEL "%init_external_update_file%"
REM )

REM The above does not account for svn externals and so when TurtleBrains or ICE is updated the
REM updates will not get pulled in. The following forces a pull/update to just grab anyway.

SET "using_git="
IF "%abs_source_control%" == "git" SET using_git=1
IF EXIST ".git\" SET using_git=1

IF defined using_git (
	git fetch origin
	ECHO "Forcing an update of the git repository."
	git pull --rebase
	SET found_updates=1
) ELSE (
	ECHO "Forcing an update of the svn repository."
	(svn update --quiet --non-interactive)>>%abs_detailed_report_file%
	SET found_updates=1
)

POPD

SET project_update_hook="%CD%\abs_build_hooks\project_update.bat"
IF EXIST %project_update_hook% (
	CALL %project_update_hook%
	REM TODO: Check the return value from the hook and set failure if needed.
)

REM Not exactly true, but nothing went wrong by default. This will set the value to 1 or 0 depending
REM on whether updates were found or not. NOTE: the primary script will not throw an error in this
REM very specific situation (abs_update script value 1) and instead will either continue or skip the
REM rest of the build steps for the current project depending on settings.
SET abs_return_value=%found_updates%
