@ECHO off

REM
REM Automated Build Script for TEMPLATE_PROJECT_NAME to copy the executable during a release build.
REM
REM Available on github: https://www.github.com/timbeaudet/build_automation/ under the unliscense agreement.
REM -------------------------------------------------------------------------------------------------------------------

SET toSlnDir=""
SET toRunDir="..\..\run\"

IF NOT DEFINED buildType SET buildType="release\"
REM IF NOT DEFINED exePostfix SET exePostfix=""

IF DEFINED exePostfix ( 
  IF EXIST "%toRunDir%TEMPLATE_PROJECT_FILE%exePostfix%.exe" (DEL "%toRunDir%TEMPLATE_PROJECT_FILE%exePostfix%.exe")
  COPY "%toSlnDir%%buildType%TEMPLATE_PROJECT_FILE.exe" "%toRunDir%\TEMPLATE_PROJECT_FILE%exePostfix%.exe" 
) ELSE ( 
  IF EXIST "%toRunDir%TEMPLATE_PROJECT_FILE.exe" (DEL "%toRunDir%TEMPLATE_PROJECT_FILE.exe")
  COPY "%toSlnDir%%buildType%TEMPLATE_PROJECT_FILE.exe" "%toRunDir%\TEMPLATE_PROJECT_FILE.exe"
)
