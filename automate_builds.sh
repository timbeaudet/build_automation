#!/usr/bin/env bash

#
# Automate Builds is a script to recursively search through a directory for automated build scripts and call each
#   in the specified order. Future revisions may allow the called script to return a value to continue or cancel the
#   calling of the remaining files.
#
# <!-- Copyright (c) 2017 Tim Beaudet - All Rights Reserved -->
# ---------------------------------------------------------------------------------------------------------------------

# This is the set/list of scripts that will be called in the order given, left to right.
declare -a build_scripts=("auto_update.sh" "auto_clean.sh" "auto_build.sh" "auto_test.sh" "auto_deploy.sh")

auto_build_setting_initial_directory=`pwd`
echo "$auto_build_setting_initial_directory"

found_script=0
abs_return_value=0
for d in `find . -type d -path ./"*automated"`; do
	#We already know we are in an automated directory, no need to test.
	#This does skip the edge-case that the automated_builds script was run from a directory named 'automated'
	if [[ -d "$d" ]]; then
		found_script=0
		abs_return_value=0
		pushd "$d"		
   		for f in "${build_scripts[@]}" ; do
   			if [[ "$abs_return_value" -eq 0 ]]; then
    	    	if [ -f "$f" ]; then
   	    			found_script=1
       	    		. "$f"

#      	    		IF 0==!abs_return_value! (
#						REM Continue on to the next build phase.
#					) ELSE (
#						(ECHO FAILED: "!pathLocalToCurrent!\%%f"   ERROR: !abs_return_value! [stopping current project])>>!abs_summary_report_file!
#					)

					if [[ "$abs_return_value" -eq 0 ]]; then
						# Continue on to the next build phase.
						echo pass > /dev/null
					else
						echo fail
					fi

        		fi
        	fi
   		done
    	popd > /dev/null
    fi # -d loop
done

