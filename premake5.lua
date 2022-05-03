GLAD_INCLUDE = path.getabsolute("include")

project "glad"
    kind "StaticLib"
    language "C"
    staticruntime "on"

    targetdir ("%{wks.location}/bin/%{cfg.buildcfg}/%{cfg.system}/%{prj.name}")
    objdir ("%{wks.location}/obj/%{cfg.buildcfg}/%{cfg.system}/%{prj.name}")

    files {
        "include/glad/glad.h",
        "include/KHR/khrplatform.h",
        "src/glad.c"
    }

    includedirs {
      GLAD_INCLUDE
    }

    filter "configurations:Debug"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        runtime "Release"
        optimize "on"

    filter "system:macosx"
        systemversion "latest"

    filter "system:linux"
        systemversion "latest"

    filter "system:windows"
        systemversion "latest"

