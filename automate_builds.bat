@ECHO off

REM
REM Automate Builds is a script to recursively search through a directory for automated build scripts and call each
REM   in the specified order. Future revisions may allow the called script to return a value to continue or cancel the
REM   calling of the remaining files.
REM
REM ---------------------------------------------------------------------------------------------------------------------#

REM Apparently %var% gets expanded upon reading not during the command so when used
REM within a for loop, oddities ensue. Enabling delayed expansion and using !var!
REM causes the expansion to happen during command, still I think there is some more
REM oddities with regards to nested loops, and it appears %%f or %%d must be single
REM letter variable names, I attempted to use currentScript and childDirectory.
SETLOCAL enableextensions ENABLEDELAYEDEXPANSION

REM This is the set/list of scripts that will be called in the order given, left to right.
SET build_scripts=auto_update.bat auto_clean.bat auto_build.bat auto_test.bat auto_deploy.bat

REM 
SET auto_build_setting_initial_directory=%CD%

REM Have the build bot email the report when set to 1. If not using mailsend/emailing feature, just set to 0.
SET auto_build_setting_email_report=1
SET abs_project_failed_flag=0

REM When this is false, 0, the auto_update script will attempt to check the output from the source control update
REM for any modified files and if no files have been modified cancel the build prematurely, in a non failure
REM situation. Basically consider it an "immediately build upon change" mode that cancels out. Set 1 for nightlies.
REM - maybe some day there will be an immediate build mode, not today -
REM SET auto_build_setting_update_pass_always=1

REM The abs_summary_report_file is the report that gets injected at the top of the email report, should provide a
REM quick overview of all the projects that PASSED all build steps, as well as those that FAILED to complete.
SET abs_summary_report_file="R:/abs_output.txt"

REM This abs_detailed_report_file is the report that contains all the warnings and errors for each project that reached 
REM the build step, should they contain warnings or errors. Deleting it here to empty it out.
SET abs_detailed_report_file="R:/auto_build_report.txt"
DEL %abs_detailed_report_file%

REM This should be set during each of the build steps, particularly for failures set this to a non-zero value which will
REM halt the continuation of the remaining steps within that project and result in a FAILED build in final report.
SET abs_return_value=0

REM Finished with setting up the auto_build_settings / options.
REM ---------------------------------------------------------------------------------------------------------------------#

(ECHO Auto Build Robot is going to try building projects in)>%abs_summary_report_file%
(ECHO %auto_build_setting_initial_directory%)>>%abs_summary_report_file%
(ECHO.)>>%abs_summary_report_file%

REM Above: Making the immediate report nice and tidy including introduction stuff.
REM Below: Search the current directory for the build scripts before child directories, special case: duplicate code.
REM ---------------------------------------------------------------------------------------------------------------------#

REM Perform a test to ensure that the automated substring exists somewhere in the path, it would be nice to check
REM if it is the most active directory. fail on path/automated/more/path/ and succeed: path/automated/
SET working_directory=%CD%
ECHO Primary Working Directory is: %working_directory%
ECHO."%working_directory%" | findstr /C:automated 1>nul
IF NOT errorlevel 1 (
	SET found_script=0
	FOR %%f IN (%build_scripts%) DO (
		IF EXIST %%f (
			SET found_script=1
			SET abs_return_value=0
			CALL %%f
			IF 0==!abs_return_value! (
				REM Continue like normal
			) ELSE (
				SET abs_project_failed_flag=1
				GOTO BreakSpecialForLoop
			)
		) ELSE (
			REM The %%f build script was not found.
		)
	)
) ELSE (
	ECHO Skipping the primary directory search.
)

IF 1==!found_script! (
	(ECHO "Scripts in root directory ran successfully.")>>%abs_summary_report_file%
)
GOTO SkipSpecialErrorMessage
:BreakSpecialForLoop
(ECHO "A script in root directory returned an error condition.")>>%abs_summary_report_file%
:SkipSpecialErrorMessage

REM The above loop may get deprecated as it is likely not to be terribly useful and become a maintenance headache.
REM Below: Begin recursively searching each directory to call the build scripts from within.
REM ---------------------------------------------------------------------------------------------------------------------#

REM Now searching each child directory recursively, which appears to be breadth-first
REM as it went cat, dog, bird, kitten, puppy when kitten was a child of cat and puppy
REM a child of dog.
FOR /r /d %%d IN (*) DO (
	PUSHD %%d\

	SET pathLocalToCurrent=%%d
	REM Perform a test to ensure that the automated substring exists somewhere in the path, it would be nice to check
	REM if it is the most active directory. fail on path/automated/more/path/ and succeed: path/automated/
	ECHO."!pathLocalToCurrent!" | findstr /C:automated 1>nul
	IF NOT errorlevel 1 (
		ECHO Searching Directory: !pathLocalToCurrent!
		REM	SET pathLocalToCurrent=!pathLocalToCurrent:C:\development\auto_build_test_area=!
		REM	(ECHO Attempting to build: !pathLocalToCurrent!)>>%abs_summary_report_file%
		REM Above two lines is an attempt to strip most of the initial working directory from the path. Failed.

		SET found_script=0
		SET abs_return_value=0
		FOR %%f IN (%build_scripts%) DO (
			IF 0==!abs_return_value! (
				IF EXIST %%f (
					SET found_script=1
					CALL %%f
					IF 0==!abs_return_value! (
						REM Continue on to the next build phase.
					) ELSE (
						SET abs_project_failed_flag=1
						(ECHO FAILED: "!pathLocalToCurrent!\%%f"   ERROR: !abs_return_value! [stopping current project])>>!abs_summary_report_file!
					)
				)
			)
		)

		IF 0==!abs_return_value! (
			IF 1==!found_script! (
				(ECHO PASSED: "!pathLocalToCurrent!" ran successfully.)>>!abs_summary_report_file!
			)
		)
	) ELSE (
		REM Skipping file in a path without automated.
	)
	POPD
)

REM Finally now that all the projects have been built, or their failures logged, it is time to email the report.
REM ---------------------------------------------------------------------------------------------------------------------#
IF 1==%auto_build_setting_email_report% (
IF 1==%abs_project_failed_flag% (
	(ECHO.
	 ECHO.
	 ECHO =========================================
	 ECHO.
 	)>>!abs_summary_report_file!

	SET abs_email_report="R:\email_report.txt"
	COPY !abs_summary_report_file!+!abs_detailed_report_file! !abs_email_report!

	REM The following script should set a variable named auto_build_settings_mailsend_credentials which contains the
	REM following options to connect to the mail server to send an email. For security reasons, duh, this credentials
	REM script should not be commited to source control, so be sure to set ignore properties.
	REM SET auto_build_setting_mailsend_credentials=-to you@work.com -from your_robot@gmail.com -user your_robot -pass robots_password
	CALL "automate_builds_set_credentials.bat"

	IF DEFINED auto_build_setting_mailsend_credentials (
		SET auto_build_setting_mailsend_connection=-ssl -port 465 -auth -smtp smtp.gmail.com
		SET mailsend_message=-v -name "Auto Build Robot" -subject "Automated Build Report" -mime-type "text/plain" -msg-body !abs_email_report!
		mailsend !auto_build_setting_mailsend_credentials! !auto_build_setting_mailsend_connection! !mailsend_message! -q
	) ELSE (
		ECHO Warning: Unable to use mailsend to send an email, credentials were not setup properly.
	)
)
)

GOTO :EOF
PAUSE