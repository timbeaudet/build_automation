--
-- Premake4 script for creating a Visual Studio, XCode or CodeLite workspace for the TEMPLATE_PROJECT_NAME project.
--   Requires Premake5 from: http://industriousone.com/
--
-----------------------------------------------------------------------------------------------------------------------

--Add command line option for running premake with this script:
--		Use: --name "TEMPLATE_PROJECT_FILE" to name the project, defaults to: TEMPLATE_PROJECT_FILE
newoption {
  trigger = "name",
  description = "Chosen project name.",
  value = "TEMPLATE_PROJECT_FILE",
}

if not _OPTIONS["name"] then
  _OPTIONS["name"] = "TEMPLATE_PROJECT_FILE"
end

--Documented at: http://industriousone.com/osget
local WINDOWS_SYSTEM_NAME = "windows"
local LINUX_SYSTEM_NAME = "linux"
local MACOSX_SYSTEM_NAME = "macosx"

--local MACIOS_SYSTEM_NAME = "macios"
--local ANDROID_SYSTEM_NAME = "android"

local SYSTEM_NAME = os.get()
local PROJECT_NAME = _OPTIONS["name"]

if _ACTION == "clean" then
  os.rmdir("../build/" .. WINDOWS_SYSTEM_NAME)
  os.rmdir("../build/" .. LINUX_SYSTEM_NAME)
  os.rmdir("../build/" .. MACOSX_SYSTEM_NAME)
end

local SCRIPT_EXTENSION = ".sh"
if (SYSTEM_NAME == WINDOWS_SYSTEM_NAME) then
  SCRIPT_EXTENSION = ".bat"
end

solution(PROJECT_NAME)
  location ("../build/" .. SYSTEM_NAME)
  
configurations { "debug", "release" }
project (PROJECT_NAME)
  location ("../build/" .. SYSTEM_NAME)
  language ("C++")
  kind     ("WindowedApp")
  
  files { "../source/**.h", "../source/**.cpp", "../source/**.mm", "../source/**.c" }  
  excludes { "../**/doxygen/**" }
  
  if (WINDOWS_SYSTEM_NAME ~= SYSTEM_NAME) then
	  excludes { "../**/windows/**" }
  end
  if (LINUX_SYSTEM_NAME ~= SYSTEM_NAME) then
	  excludes { "../**/linux/**" }
  end
  if (MACOSX_SYSTEM_NAME ~= SYSTEM_NAME) then
	  excludes { "../**/macosx/**" }
  end
  
  if (WINDOWS_SYSTEM_NAME == SYSTEM_NAME) then
	  libdirs {
      "../build/tb_external_libraries/libraries/msvc/x32"
	  }

    --TODO: TIM: Cleanup: tb_windows define should be removed and placed in tb_configuration.h
	  defines { "_WINDOWS", "WIN32", "tb_windows" }
    links { "OpenGL32", "OpenAL32", "glew32" }
  end
  
  if (MACOSX_SYSTEM_NAME == SYSTEM_NAME) then
    libdirs {
      "../build/tb_external_libraries/libraries/macosx/"
    }

  	buildoptions "-stdlib=libc++"
  	linkoptions "-stdlib=libc++"
    --TODO: TIM: Cleanup: tb_macosx define should be removed and placed in tb_configuration.h
  	defines { "tb_macosx" }
  	links { "AppKit.framework", "OpenGL.framework", "OpenAL.framework", "glew" }
  end
  
  includedirs {
  "../build/tb_external_libraries/includes/"
  }
  
  configuration "debug*"
    targetdir ("../build/" .. SYSTEM_NAME .. "/debug")
    objdir ("../build/" .. SYSTEM_NAME .. "/debug_objs" )
    defines { "_DEBUG", "DEBUG" }
    flags   { "Symbols", }
	  debugdir "../run"	
	--debugargs { "--nosplash", "--other" }
	  postbuildcommands { "../automated/post_build_debug" .. SCRIPT_EXTENSION }

  configuration "release*"
    targetdir ("../build/" .. SYSTEM_NAME .. "/release")
    objdir ("../build/" .. SYSTEM_NAME .. "/release_objs" )
    defines { "NDEBUG" }
    flags   { "Optimize", }
	  debugdir "../run"
	--debugargs { "--nosplash", "--other" }
	  postbuildcommands { "../automated/post_build_release" .. SCRIPT_EXTENSION }
