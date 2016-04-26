@ECHO off

REM
REM Simple batch script to create a Visual Studio project using premake5 and the make_project.lua script.
REM
REM -------------------------------------------------------------------------------------------------------------------

premake5 --file="make_project.lua" --name="TEMPLATE_PROJECT_FILE" vs2015
