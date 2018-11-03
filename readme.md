# Build Automation
This project contains a set of batch and bash scripts to automate the build process of applications for Windows, Mac and Linux. It may be specific to my needs, but feel free to use any bits that may be useful.

## About
By running ``automate_builds`` script, all projects within the current directory will be found and the build scripts will be ran. The project will get cleaned, then built. There are future plans to add support for updating the project before a clean build is performed, then potentially running a test and deploy script.

## Installation

> This build system assume the projects use premake5 scripts to create projects for Visual Studio, XCode or gmake.
> There may be other assumptions not yet listed; let me know.

### Windows

1. `git clone` the repository or download it. `C:/path/abs/`
2. Set PATH environment variable to point to location downloaded.
	- Press `Windows Key` type `System` and open.
	- Open `Advanced system settings`
	- Open `Environment Variables...`
	- Carefully select `Path` and click `Edit`
	- Add the path `C:/path/abs/batch`
3. Close any command prompts and reopen for the new path to be used.

I place ``automate_builds.bat`` and/or ``automate_builds.sh`` in a directory, *tools* that is included in my PATH.

The build folder gets placed in each separate project, and then make some wording/name changes as needed. This includes a make_project.lua script for premake5, and the automated scripts to clean and build a project.

### Unlicense
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>
