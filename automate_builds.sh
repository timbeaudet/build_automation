#!/usr/bin/env bash

#
# Automate Builds is a script to recursively search through a directory for automated build scripts and call each
#   in the specified order. Future revisions may allow the called script to return a value to continue or cancel the
#   calling of the remaining files.
#
# Available on github: https://www.github.com/timbeaudet/build_automation under the Unlicense aggreement.
# ---------------------------------------------------------------------------------------------------------------------

# This is the set/list of scripts that will be called in the order given, left to right.
declare -a build_scripts=("auto_update.sh" "auto_clean.sh" "auto_build.sh" "auto_test.sh" "auto_deploy.sh")

auto_build_setting_initial_directory=$(pwd)
echo "$auto_build_setting_initial_directory"

# Have the build bot email the report when set to 1. If not using mailsend/emailing feature, just set to 0.
auto_build_setting_email_report=1
abs_project_failed_flag=0

# When this is false, 0, the auto_update script will attempt to check the output from the source control update
# for any modified files and if no files have been modified cancel the build prematurely, in a non failure
# situation. Basically consider it an "immediately build upon change" mode that cancels out. Set 1 for nightlies.
# - maybe some day there will be an immediate build mode, not today -
# SET auto_build_setting_update_pass_always=1

# The abs_summary_report_file is the report that gets injected at the top of the email report, should provide a
# quick overview of all the projects that PASSED all build steps, as well as those that FAILED to complete.
abs_summary_report_file="$auto_build_setting_initial_directory/abs_summary_report.txt"
if [ -f "$abs_summary_report_file" ]; then rm "$abs_summary_report_file"; fi

# This abs_detailed_report_file is the report that contains all the warnings and errors for each project that reached 
# the build step, should they contain warnings or errors. Deleting it here, if exists, to empty it out.
abs_detailed_report_file="$auto_build_setting_initial_directory/auto_build_report.txt"
if [ -f "$abs_detailed_report_file" ]; then rm "$abs_detailed_report_file"; fi

# This should be set during each of the build steps, particularly for failures set this to a non-zero value which will
# halt the continuation of the remaining steps within that project and result in a FAILED build in final report.
abs_return_value=0

# Finished with setting up the auto_build_settings / options.
# ---------------------------------------------------------------------------------------------------------------------#

timeanddatenow=`date`
printf "Auto Build Robot is going to try building projects in\n" >> "$abs_summary_report_file"
printf "%s\n" "$auto_build_setting_initial_directory" >> "$abs_summary_report_file"
printf "Started at: %s\n\n" "$timeanddatenow" >> "$abs_summary_report_file"

printf "Auto Build Robot Detailed Report\n" >> "$abs_detailed_report_file"
printf "%s\n" "$auto_build_setting_initial_directory" >> "$abs_detailed_report_file"
printf "Started at: %s\n\n" "$timeanddatenow" >> "$abs_detailed_report_file"

# Above: Making the detailed and summary reports nice and tidy including introduction stuff.
# Below: Search the current directory for the build scripts before child directories.
# ---------------------------------------------------------------------------------------------------------------------#
for d in $(find . -type d -path ./"*automated"); do
	#We already know we are in an automated directory, no need to test.
	#This does skip the edge-case that the automated_builds script was run from a directory named 'automated'
	if [[ -d "$d" ]]; then
		found_script=0
		abs_return_value=0

		echo "Jumping into directory: $d"
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
						abs_project_failed_flag=1
						printf "FAILED: %s   ERROR: %s [stopping current project]\n" "$d/$f" "$abs_return_value" >> "$abs_summary_report_file"
						break
					fi

        		fi
        	fi
   		done

   		if [[ "$found_script" -eq 1 ]]; then
   			if [[ "$abs_return_value" -eq 0 ]]; then
   				printf "PASSED: %s ran successfully.\n" "$d" >> "$abs_summary_report_file"
   			fi
   		fi
    	popd > /dev/null
    fi # -d loop
done

timeanddatenow=`date`
printf "\nAuto Build Robot has finished building projects.\n" >> "$abs_summary_report_file"
printf "Finished at: %s\n\n" "$timeanddatenow" >> "$abs_summary_report_file"
printf "\nAuto Build Robot has finished building projects.\n" >> "$abs_detailed_report_file"
printf "Finished at: %s\n\n" "$timeanddatenow" >> "$abs_detailed_report_file"

# Finally now that all the projects have been built, or their failures logged, it is time to email the report.
# ---------------------------------------------------------------------------------------------------------------------#
if [[ "$auto_build_setting_email_report" -eq 1 ]]; then
#if [[ "$abs_project_failed_flag" -eq 0 ]]; then
#
	printf "\n\n=========================================\n" >> "$abs_summary_report_file"

	fail_state=": linux/macos success"
	if [[ "$abs_project_failed_flag" -eq 1 ]]; then
		fail_state=": LINUX/MACOS PROJECTS IN FAILURE STATE"
	fi
	echo "From: Auto Build Robot" > /tmp/abs_email_details.txt
	echo -e "Subject: Automated Build Report$fail_state\n\n" >> /tmp/abs_email_details.txt

	abs_email_report="$auto_build_setting_initial_directory/email_report.txt"
	cat "/tmp/abs_email_details.txt" "$abs_summary_report_file" "$abs_detailed_report_file" > "$abs_email_report"
	sendmail timbeaudet@yahoo.com < "$abs_email_report"

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
fi

printf "DONE LOOPING PROJECTS" >> "$abs_summary_report_file"
