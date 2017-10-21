#!/usr/bin/env bash

#
# Automate Builds is a script to recursively search through a directory for automated build scripts and call each
#   in the specified order. Future revisions may allow the called script to return a value to continue or cancel the
#   calling of the remaining files.
#
# ---------------------------------------------------------------------------------------------------------------------

# This is the set/list of scripts that will be called in the order given, left to right.
declare -a build_scripts=("auto_update.sh" "auto_clean.sh" "auto_build.sh" "auto_test.sh" "auto_deploy.sh")

auto_build_setting_initial_directory=$(pwd)
echo "$auto_build_setting_initial_directory"

# Have the build bot email the report when set to 1. If not using mailsend/emailing feature, just set to 0.
auto_build_setting_email_report=1

# When this is false, 0, the auto_update script will attempt to check the output from the source control update
# for any modified files and if no files have been modified cancel the build prematurely, in a non failure
# situation. Basically consider it an "immediately build upon change" mode that cancels out. Set 1 for nightlies.
# - maybe some day there will be an immediate build mode, not today -
# SET auto_build_setting_update_pass_always=1

# The abs_summary_report_file is the report that gets injected at the top of the email report, should provide a
# quick overview of all the projects that PASSED all build steps, as well as those that FAILED to complete.
abs_summary_report_file="$auto_build_setting_initial_directory/abs_output.txt"
rm "$abs_summary_report_file"

# This abs_detailed_report_file is the report that contains all the warnings and errors for each project that reached 
# the build step, should they contain warnings or errors. Deleting it here to empty it out.
abs_detailed_report_file="$auto_build_setting_initial_directory/auto_build_report.txt"
rm "$abs_detailed_report_file"

# This should be set during each of the build steps, particularly for failures set this to a non-zero value which will
# halt the continuation of the remaining steps within that project and result in a FAILED build in final report.
abs_return_value=0

# Finished with setting up the auto_build_settings / options.
# ---------------------------------------------------------------------------------------------------------------------#

printf "Auto Build Robot is going to try building projects in\n" >> "$abs_summary_report_file"
printf "%s\n\n" "$auto_build_setting_initial_directory" >> "$abs_summary_report_file"

# Above: Making the immediate report nice and tidy including introduction stuff.
# Below: Search the current directory for the build scripts before child directories.
# ---------------------------------------------------------------------------------------------------------------------#
for d in $(find . -type d -path ./"*automated"); do
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
   	    			#The source in "source script.sh" is important to pass abs variables to and from the called script.
       	    		source "$f"

					if [[ "$abs_return_value" -eq 0 ]]; then
						# Continue on to the next build phase.
						echo pass > /dev/null
					else
						printf "FAILED: %s   ERROR: %s [stopping current project]\n" "$d/$f" "$abs_return_value" >> "$abs_summary_report_file"
						break
					fi

        		fi
        	fi
   		done

   		if [[ "$found_script" -eq 1 ]]; then
   			if [[ "$abs_return_value" -eq 0 ]]; then
   				printf "PASSED: %s ran successfully.\n" "$d/$f" >> "$abs_summary_report_file"
   			fi
   		fi
    	popd > /dev/null
    fi # -d loop
done

# Finally now that all the projects have been built, or their failures logged, it is time to email the report.
# ---------------------------------------------------------------------------------------------------------------------#
# if [[ "$auto_build_setting_email_report" -eq 1 ]]; then
#
#	printf "\n\n-----------------------------------------\n" >> "$abs_summary_report_file"
#
#	abs_email_report="$auto_build_setting_initial_directory/email_report.txt"
#	COPY "$abs_summary_report_file"+"$abs_detailed_report_file" "$abs_email_report"
#
	# The following script should set a variable named auto_build_settings_mailsend_credentials which contains the
	# following options to connect to the mail server to send an email. For security reasons, duh, this credentials
	# script should not be commited to source control, so be sure to set ignore properties.
	# SET auto_build_setting_mailsend_credentials=-to you@work.com -from your_robot@gmail.com -user your_robot -pass robots_password
#	source "automate_builds_set_credentials.sh"

#	IF DEFINED auto_build_setting_mailsend_credentials (
#		SET auto_build_setting_mailsend_connection=-ssl -port 465 -auth -smtp smtp.gmail.com
#		SET mailsend_message=-v -name "Auto Build Robot" -subject "Automated Build Report" -mime-type "text/plain" -msg-body !abs_email_report!
#		mailsend !auto_build_setting_mailsend_credentials! !auto_build_setting_mailsend_connection! !mailsend_message! -q
#	) ELSE (
#		ECHO Warning: Unable to use mailsend to send an email, credentials were not setup properly.
#	)
#fi


printf "DONE LOOPING PROJECTS" >> "$abs_summary_report_file"
