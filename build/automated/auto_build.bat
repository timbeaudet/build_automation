@ECHO off

REM
REM Automated Build Script for TEMPLATE_PROJECT_NAME to automate the building of both debug and release configurations 
REM   of the project, including the post_build scripts that will build a release package.
REM
REM This may be run by an automated process to clean and/or build each project with an /automated/auto_ script.
REM
REM -------------------------------------------------------------------------------------------------------------------

PUSHD ..\

premake5 --file="make_project.lua" --name="TEMPLATE_PROJECT_FILE" vs2015

REM Used on 32bit Windows XP machine with VisualStudio 2010
REM CALL "C:\Program Files\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"

REM Used on 64bit Windows 10 machine with VisualStudio 2015
CALL "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"

ECHO Building debug...
msbuild "windows/TEMPLATE_PROJECT_FILE.sln" /property:Configuration=debug

ECHO Building release...
msbuild "windows/TEMPLATE_PROJECT_FILE.sln" /property:Configuration=release

POPD
