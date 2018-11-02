@ECHO off

REM
REM Automated Build Script to automate the update process by grabbing the latest from the source
REM control repository, used here is subversion (svn) though it shouldn't be hard to modify to Git or Hg.
REM
REM This may be run by an automated process to clean and/or build each project with an /automated/auto_ script.
REM
REM Available on github: https://www.github.com/timbeaudet/build_automation/ under the unliscense agreement.
REM -------------------------------------------------------------------------------------------------------------------

REM This should go back to project_root to update, which by default is 1 level back from: project_root/build/

IF NOT DEFINED abs_detailed_report_file (
	ECHO WARNING: abs_detailed_report_file was not set.
	SET abs_detailed_report_file="auto_build_report.txt"
)

(ECHO.)>>%abs_detailed_report_file%
(ECHO.)>>%abs_detailed_report_file%
(ECHO updating from source control of %CD%)>>%abs_detailed_report_file%
(ECHO ========================================================)>>%abs_detailed_report_file%

PUSHD ..\
(svn update --quiet --non-interactive)>>%abs_detailed_report_file%
POPD

SET project_update_hook="%CD%\abs_build_hooks\project_update.bat"
IF EXIST %project_update_hook% (
	ECHO Found and calling project specific update hook.
	CALL %project_update_hook%
)
