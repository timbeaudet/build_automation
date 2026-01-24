@ECHO off

REM
REM Automated Build Script for TEMPLATE_PROJECT_NAME to automate the building of both debug and release configurations 
REM   of the project, including the post_build scripts that will build a release package.
REM
REM This may be run by an automated process to clean and/or build each project with an /automated/auto_ script.
REM
REM Available on github: https://www.github.com/timbeaudet/build_automation/ under the unlicense agreement.
REM -------------------------------------------------------------------------------------------------------------------

REM 2026-01-24: This was added to attempt to fix a false-positive that was discovered today (2026-01-24) when trying
REM   to fix nightly builds when Rushcremental was failing. Once Rushcremental passed, it actually had a compiler
REM   error when building Public build for a missing semi-colon after tb_debug_log(), TurtleBrains now covers that
REM   for future potential mishaps, but the nightly build "succeeded", even ran the tests, and it should have failed
REM   due to the build failure.
REM
REM   My assumption was the SET abs_build_had_failure=1 INSIDE of the `IF 0 == %abs_skip_public_config%` condition
REM   was ignored because of delayed expansion stuff. However, when I tried adding the DelayedExpansion, and using
REM   !errorlevel! inside public config and/or !abs_build_had_failure! at the bottom then it ALWAYS failed even when
REM   there were zero errors compiling. At first I thought the false-positive was fixed, but then it always failed.
REM
REM   THERE IS A POTENTIAL FALSE POSITIVE IF PUBLIC IS THE ONLY BUILD CONFIGURATION THAT FAILS.
REM
REM Apparently %var% gets expanded upon reading the script and not during the running
REM the command so when used within a for loop, or IF?, oddities seem to ensue.
REM Enabling delayed expansion and using !var! causes the expansion to happen during
REM the command. Still I think I've seen oddities with regards to nested loops.
REM SETLOCAL enableextensions ENABLEDELAYEDEXPANSION

SET abs_build_had_failure=0

premake5 --file="%abs_project_file_name%.lua" vs2015

IF NOT DEFINED DevEnvDir (
	REM Used on cheetah: 32bit Windows XP machine with VisualStudio 2010
	REM CALL "C:\Program Files\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"
	REM Used on falcon: 64bit Windows 10 machine with VisualStudio 2015
	REM CALL "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"
	REM Used on moose: 64bit Windows 10 machine with VisualStudio 2022 Community
	CALL "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
)

IF NOT DEFINED abs_detailed_report_file (
	ECHO WARNING: abs_detailed_report_file was not set.
	SET abs_detailed_report_file="auto_build_report.txt"
)

(ECHO.)>>%abs_detailed_report_file%
(ECHO.)>>%abs_detailed_report_file%
(ECHO building debug of %CD%)>>%abs_detailed_report_file%
(ECHO "windows/%abs_project_file_name%.sln")>>%abs_detailed_report_file%
(ECHO --------------------------------------------------------)>>%abs_detailed_report_file%
(ECHO.)>>%abs_detailed_report_file%
CALL make_project.bat --windows --build --debug
IF NOT 0 == %errorlevel% (
	(ECHO debug build failed)>>%abs_detailed_report_file%
	SET abs_build_had_failure=1
)

(ECHO.)>>%abs_detailed_report_file%
(ECHO.)>>%abs_detailed_report_file%
(ECHO building release of %CD%)>>%abs_detailed_report_file%
(ECHO "windows/%abs_project_file_name%.sln")>>%abs_detailed_report_file%
(ECHO --------------------------------------------------------)>>%abs_detailed_report_file%
(ECHO.)>>%abs_detailed_report_file%
CALL make_project.bat --windows --build --release
IF NOT 0 == %errorlevel% (
	(ECHO release build failed)>>%abs_detailed_report_file%
	SET abs_build_had_failure=1
)

IF 0 == %abs_skip_public_config% (
	(ECHO.)>>%abs_detailed_report_file%
	(ECHO.)>>%abs_detailed_report_file%
	(ECHO building public of %CD%)>>%abs_detailed_report_file%
	(ECHO "windows/%abs_project_file_name%.sln")>>%abs_detailed_report_file%
	(ECHO --------------------------------------------------------)>>%abs_detailed_report_file%
	(ECHO.)>>%abs_detailed_report_file%
	CALL make_project.bat --windows --build --public
	IF NOT 0 == %errorlevel% (
		(ECHO public build failed)>>%abs_detailed_report_file%
		SET abs_build_had_failure=1
	)
)

REM Call the user/project specific build hook script if it exists.
SET abs_project_build_hook="%CD%\abs_build_hooks\project_build.bat"
IF EXIST %abs_project_build_hook% (
	CALL %abs_project_build_hook%
)

REM Wrap up by setting the return value to 0 for success or an error-code on failure.
if 0==%abs_build_had_failure% (
	REM Everything actually went as expected!
	SET abs_return_value=0
) ELSE (
	REM Not everything went to plan, return the failure!
	SET abs_return_value=2
)
