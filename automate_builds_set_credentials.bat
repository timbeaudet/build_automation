@ECHO off

REM
REM This is a helper script to Automate Builds master script to set the mailsend credentials used to email the development
REM reports. It is separated for a slightly better security practices and therefor should not be committed to source
REM control and instead set to ignore.
REM
REM ---------------------------------------------------------------------------------------------------------------------#

SET auto_build_setting_mailsend_credentials=-to you@work.com -from your_robot@gmail.com -user your_robot -pass robots_password