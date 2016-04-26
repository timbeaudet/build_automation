@ECHO off

REM
REM Automated Build Script for TEMPLATE_PROJECT_NAME to copy the executable during a debug build.
REM
REM -------------------------------------------------------------------------------------------------------------------

SET toSlnDir=""
SET toRunDir="..\..\run\"

IF NOT DEFINED buildType SET buildType="debug\"
IF NOT DEFINED exePostfix SET exePostfix="_debug"

IF DEFINED exePostfix ( 
  IF EXIST "%toRunDir%TEMPLATE_PROJECT_FILE%exePostfix%.exe" (DEL "%toRunDir%TEMPLATE_PROJECT_FILE%exePostfix%.exe")
  COPY "%toSlnDir%%buildType%TEMPLATE_PROJECT_FILE.exe" "%toRunDir%\TEMPLATE_PROJECT_FILE%exePostfix%.exe" 
) ELSE ( 
  IF EXIST "%toRunDir%TEMPLATE_PROJECT_FILE_debug.exe" (DEL "%toRunDir%TEMPLATE_PROJECT_FILE_debug.exe")
  COPY "%toSlnDir%%buildType%TEMPLATE_PROJECT_FILE.exe" "%toRunDir%\TEMPLATE_PROJECT_FILE_debug.exe"
)
