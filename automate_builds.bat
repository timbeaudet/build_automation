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
SETLOCAL ENABLEDELAYEDEXPANSION

REM This is the set/list of scripts that will be called in the order given, left to right.
SET build_scripts=auto_update.bat auto_clean.bat auto_build.bat auto_test.bat auto_deploy.bat

REM Search the current directory for the build scripts before child directories, special case.
FOR %%f IN (%build_scripts%) DO (
	IF EXIST %%f (
		SET auto_return_value=0
		CALL %%f
		IF 0==!auto_return_value! (
			REM Continue like normal
		) ELSE (
			GOTO BreakSpecialForLoop
		)
	) ELSE (
		REM The %%f build script was not found.
	)
)

ECHO "Every script called ran successfully."
GOTO SkipSpecialErrorMessage
:BreakSpecialForLoop
ECHO "Script returned an error condition, early exit."
:SkipSpecialErrorMessage

REM Now searching each child directory recursively, which appears to be breadth-first
REM as it went cat, dog, bird, kitten, puppy when kitten was a child of cat and puppy
REM a child of dog.
FOR /r /d %%d IN (*) DO (
	PUSHD %%d\
	REM Running build scripts in: %%d
	SET auto_return_value=0
	FOR %%f IN (%build_scripts%) DO (
		IF 0==!auto_return_value! (
			IF EXIST %%f (
				CALL %%f
				IF 0==!auto_return_value! (
					REM Continue like normal
				) ELSE (
					ECHO "%%d\%%f" returned error condition: !auto_return_value!
					ECHO Skipping other build scripts within this directory.
				)
			)
		)
	)

	IF 0==!auto_return_value! (
		ECHO All build scripts within "%%d" ran successfully.
	)
	POPD
)

GOTO :EOF
PAUSE