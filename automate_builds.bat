@ECHO off

REM
REM Automate Builds is a script to recursively search through a directory for automated build scripts and call each
REM   in the specified order. Future revisions may allow the called script to return a value to continue or cancel the
REM   calling of the remaining files.
REM
REM ---------------------------------------------------------------------------------------------------------------------#

setlocal EnableDelayedExpansion

SET build_scripts=auto_update.bat auto_clean.bat auto_build.bat auto_test.bat auto_deploy.bat

FOR %%i IN (%build_scripts%) DO (
	IF EXIST %%i (
		CALl %%i
	)
)

FOR /r /d %%a IN (*) DO (
	SET CurrentDirectory="%CD%"
	CD %%a\
	FOR %%i IN (%build_scripts%) DO (
		IF EXIST %%i (
			CALL %%i
		)
	)
	CD "%CurrentDirectory%"
)

PAUSE