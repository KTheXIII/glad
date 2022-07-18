cmake_minimum_required(VERSION 3.10)
project(glad)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)         # Generate compile_commands.json for ccls
set(CMAKE_SUPPRESS_REGENERATION ON)           # Remove ZERO_CHECK target
set_property(GLOBAL PROPERTY USE_FOLDERS ON)  # Group CMake targets inside a folder

set(CMAKE_C_STANDARD 17)
set(CMAKE_CXX_STANDARD 17)

# warnings and errors
if (NOT MSVC)
    string(JOIN " " CMAKE_C_FLAGS
        ${CMAKE_C_FLAGS}
        "-Wall"
        "-Wextra"
        "-Wpedantic"
        "-Werror"
    )
else()
    string(JOIN " " CMAKE_C_FLAGS
        ${CMAKE_C_FLAGS}
        "/W4"
        "/WX"
        "/wd5105"
    )
    # output to just `lib` directory instead of `lib/Release` or `lib/Debug` on msvc
    foreach( OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES} )
        string(TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
        set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
        set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY})
        set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})
    endforeach( OUTPUTCONFIG CMAKE_CONFIGURATION_TYPES )
endif()

include_directories(${PROJECT_SOURCE_DIR}/include)
file(GLOB SRC_FILES ${PROJECT_SOURCE_DIR}/src/*.c)

add_library(${PROJECT_NAME} STATIC ${SRC_FILES})
target_include_directories(${PROJECT_NAME} INTERFACE ${PROJECT_SOURCE_DIR}/include)
