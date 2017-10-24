--
-- Premake5 script for creating a Visual Studio, XCode or CodeLite workspace for the TEMPLATE_PROJECT_NAME project.
--   Requires Premake5 from: http://industriousone.com/
--
-- Available on github: https://www.github.com/timbeaudet/build_automation/ under the unliscense agreement.
-----------------------------------------------------------------------------------------------------------------------

newoption {
  trigger = "web",
  description = "Chosen build system to override for web.",
  value = "",
}

--Documented at: http://industriousone.com/osget
local WINDOWS_SYSTEM_NAME = "windows"
local LINUX_SYSTEM_NAME = "linux"
local MACOSX_SYSTEM_NAME = "macosx"
local WEB_SYSTEM_NAME = "web"
--local MACIOS_SYSTEM_NAME = "macios"
--local ANDROID_SYSTEM_NAME = "android"

local PROJECT_NAME = "TEMPLATE_PROJECT_FILE"
local SYSTEM_NAME = os.target()
if _OPTIONS["web"] then
  SYSTEM_NAME = WEB_SYSTEM_NAME
end

if _ACTION == "clean" then
  os.rmdir("../build/" .. WINDOWS_SYSTEM_NAME)
  os.rmdir("../build/" .. LINUX_SYSTEM_NAME)
  os.rmdir("../build/" .. MACOSX_SYSTEM_NAME)
  os.rmdir("../build/" .. WEB_SYSTEM_NAME)
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
  warnings ("Extra")
  
  files { "../source/**.h", "../source/**.cpp", "../source/**.mm", "../source/**.c" }  
  excludes { "../**/doxygen/**" }
  defines { "tb_without_networking", "tb_without_input_devices" }
  includedirs {
  "../build/tb_external_libraries/includes/"
  }  
  
----------------------------------------------------------------------- Windows Platform Specifics  
  if (WINDOWS_SYSTEM_NAME == SYSTEM_NAME) then
    libdirs {
      "../build/tb_external_libraries/libraries/msvc/x32",
      "C:/Program Files (x86)/Windows Kits/10/Lib/10.0.14393.0/um/x86/" --for dxguid
    }

    --TODO: TIM: Cleanup: tb_windows define should be removed and placed in tb_configuration.h
    defines { "_WINDOWS", "WIN32", "tb_windows" }
    links { "OpenGL32", "OpenAL32", "glew32" }
    flags { "StaticRuntime" }
    toolset "v140_xp"
    characterset ("MBCS")
    kind ("ConsoleApp")
  end
  
----------------------------------------------------------------------- Mac OS X Platform Specifics
  if (MACOSX_SYSTEM_NAME == SYSTEM_NAME) then
    libdirs {
      "../build/tb_external_libraries/libraries/macosx/"
    }

    buildoptions "-mmacosx-version-min=10.7"
    --linkoptions ""

--    buildoptions "-std=c++11 -stdlib=libc++ -mmacosx-version-min=10.7"
--    linkoptions "-stdlib=libc++"
    
    --TODO: TIM: Cleanup: tb_macosx define should be removed and placed in tb_configuration.h
    defines { "tb_macosx" }
    links { "AppKit.framework", "IOKit.framework", "OpenGL.framework", "OpenAL.framework", "glew" }
  end
  
----------------------------------------------------------------------- Linux Platform Specifics 
  if (LINUX_SYSTEM_NAME == SYSTEM_NAME) then
    libdirs {
      "../build/tb_external_libraries/libraries/linux/",
      "/opt/lib/"
    }
    includedirs {
      "/usr/includes/GL/"
    }
    buildoptions "-std=c++11"
    --TODO: TIM: Cleanup: tb_linux define should be removed and placed in tb_configuration.h
    defines { "tb_linux" } 
    links { "GL", "GLEW", "openal", "X11" }
    excludes { "../**/**.mm" }
  end

----------------------------------------------------------------------- Web (Emscripten) Platform Specifics 
  if (WEB_SYSTEM_NAME == SYSTEM_NAME) then
    buildoptions "-std=c++11"
    linkoptions "-stdlib=libc++"    
    defines { "tb_web" }
  end  

--------------------------------------------------------------------- Build Configuration Specifics/Overrides  
  configuration "debug*"
    targetdir ("../build/" .. SYSTEM_NAME .. "/debug")
    objdir ("../build/" .. SYSTEM_NAME .. "/debug/objects" )
    defines { "_DEBUG", "DEBUG" }
    symbols "On"
    debugdir "../run" 
  --debugargs { "--nosplash", "--other" }
    postbuildcommands { "../automated/post_build_debug" .. SCRIPT_EXTENSION }

  configuration "release*"
    targetdir ("../build/" .. SYSTEM_NAME .. "/release")
    objdir ("../build/" .. SYSTEM_NAME .. "/release/objects" )
    defines { "NDEBUG" }
    symbols "On"
    optimize "On"
    debugdir "../run"
  --debugargs { "--nosplash", "--other" }
    postbuildcommands { "../automated/post_build_release" .. SCRIPT_EXTENSION }
