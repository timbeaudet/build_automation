@ECHO off

setlocal EnableDelayedExpansion

IF EXIST auto_clean.bat (
	CALL auto_clean.bat
)

FOR /r /d %%a IN (*) DO (
	REM Set the default values for not so important flags, and clear out any important flags with var=
	SET abs_return_value=0
	SET abs_project_file_name=
	SET abs_project_friendly_name=
	SET abs_build_version_major=0
	SET abs_build_version_minor=0
	SET abs_build_version_revision=0
	SET abs_skip_if_no_updates=0

	REM This is a great idea, but has two major issues to dig deeper into:
	REM 1. The config is used for both batch and bash scripts so the .bat vs .sh can't be added to script file.
	REM 2. Windows batch filepaths use backslashes for directories and bash uses forward slashs.
	REM 1 is easy by not specifying extension until calling hook, 2 may or may not be a big deal?
	SET abs_hook_clean_script=
	SET abs_hook_update_script=
	SET abs_hook_build_script=
	SET abs_hook_test_script=
	SET abs_hook_deploy_script=

	PUSHD %%a\ > NUL
	IF EXIST auto_clean.bat (
		CALL auto_clean.bat
	)
	IF EXIST abs_build_configuration (
		REM Load the configuration settings from the abs_build_configuration file into environment variables.
		FOR /f "delims== tokens=1,2" %%G in (abs_build_configuration) do (
			set %%G=%%H
		)
		CALL abs_clean.bat
	)
	POPD
)

PAUSE
