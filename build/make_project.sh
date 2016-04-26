#!/bin/bash

#
# Simple batch script to create a XCode project using premake5 and the make_project.lua script.
#
#----------------------------------------------------------------------------------------------------------------------

premake5 --file="make_project.lua" --name="TEMPLATE_PROJECT_FILE" xcode3
