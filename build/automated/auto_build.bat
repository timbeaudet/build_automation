@ECHO off

REM
REM Automated Build Script for TEMPLATE_PROJECT_NAME to automate the building of both debug and release configurations 
REM   of the project, including the post_build scripts that will build a release package.
REM
REM This may be run by an automated process to clean and/or build each project with an /automated/auto_ script.
REM
REM Available on github: https://www.github.com/timbeaudet/build_automation/ under the unliscense agreement.
REM -------------------------------------------------------------------------------------------------------------------

premake5 --file="%abs_project_file_name%.lua" vs2015

IF NOT DEFINED DevEnvDir (
	REM Used on 32bit Windows XP machine with VisualStudio 2010
	REM CALL "C:\Program Files\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"
	REM Used on 64bit Windows 10 machine with VisualStudio 2015
	CALL "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"
)

IF NOT DEFINED abs_detailed_report_file (
	ECHO WARNING: abs_detailed_report_file was not set.
	SET abs_detailed_report_file="auto_build_report.txt"
)

(ECHO.)>>%abs_detailed_report_file%
(ECHO.)>>%abs_detailed_report_file%
(ECHO building debug of %CD%)>>%abs_detailed_report_file%
(ECHO --------------------------------------------------------)>>%abs_detailed_report_file%
(ECHO.)>>%abs_detailed_report_file%
REM Without /maxcpucount msbuild will only use a single core, can specify a number /maxcpucount:2 or leave blank for all.
REM /nologo hides a few lines being printed that we don't care about.
REM /verbosity:quiet seems to give only warnings and errors about building the project.
REM /flp1 is short for fileloggerparemeters:1 and sets up log file location and appends to it.
SET extra_options=/nologo /maxcpucount /verbosity:quiet /flp1:logfile=%abs_detailed_report_file%;verbosity=quiet;append=true
msbuild "windows/%abs_project_file_name%.sln" /property:Configuration=debug %extra_options%
IF NOT 0 == %errorlevel% (
	ECHO debug build failed
	SET abs_return_value=1
)

(ECHO.)>>%abs_detailed_report_file%
(ECHO.)>>%abs_detailed_report_file%
(ECHO building release of %CD%)>>%abs_detailed_report_file%
(ECHO --------------------------------------------------------)>>%abs_detailed_report_file%
(ECHO.)>>%abs_detailed_report_file%
msbuild "windows/%abs_project_file_name%.sln" /property:Configuration=release %extra_options%
IF NOT 0 == %errorlevel% (
	ECHO release build failed
	SET abs_return_value=1
)

ECHO checking if %project_build_hook% exists.
IF EXIST %project_build_hook% (
	ECHO Found and calling project specific build hook.
	CALL %project_build_hook%
)
