#!/bin/bash

#
# Automate Builds is a script to recursively search through a directory for automated build scripts and call each
#   in the specified order. Future revisions may allow the called script to return a value to continue or cancel the
#   calling of the remaining files.
#
#---------------------------------------------------------------------------------------------------------------------#

build_scripts=("auto_update.sh" "auto_clean.sh" "auto_build.sh" "auto_test.sh" "auto_deploy.sh")

echo "Starting auto run from: $(pwd)"

for d in ./ */ **/*; do
    for f in "${build_scripts[@]}" ; do
        if [ -f "$d/$f" ]; then
            export CurrentDirectory=$(pwd)
            cd $d
            sh "$f"
            cd $CurrentDirectory          
        fi
    done
done

exit 1
