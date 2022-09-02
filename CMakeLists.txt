cmake_minimum_required(VERSION 3.10)
project(glad)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)         # Generate compile_commands.json for ccls
set(CMAKE_SUPPRESS_REGENERATION ON)           # Remove ZERO_CHECK target
set_property(GLOBAL PROPERTY USE_FOLDERS ON)  # Group CMake targets inside a folder

file(GLOB SRC_FILES ${PROJECT_SOURCE_DIR}/src/*.c)
add_library(${PROJECT_NAME} STATIC ${SRC_FILES})
target_include_directories(${PROJECT_NAME} PUBLIC
    "${PROJECT_SOURCE_DIR}/include"
)
target_compile_features(${PROJECT_NAME} PRIVATE c_std_17)
if (NOT MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE
        "-Wall"
        "-Wextra"
        "-Wpedantic"
        "-Werror"

        "-Wall"
        "-Wextra"
        "-Wconversion"
        "-Wpedantic"
        "-Wshadow"
        "-Werror"
    )
else()
    target_compile_options(${PROJECT_NAME} PRIVATE
        "/W4"
        "/WX"
        "/wd5105"
    )
endif()

