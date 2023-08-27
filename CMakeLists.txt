cmake_minimum_required(VERSION 3.10)
project(glad VERSION 1.0.0)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)         # Generate compile_commands.json for ccls
set(CMAKE_SUPPRESS_REGENERATION ON)           # Remove ZERO_CHECK target
set_property(GLOBAL PROPERTY USE_FOLDERS ON)  # Group CMake targets inside a folder

if (NOT MSVC)
    set(BASE_OPTIONS
        "-Wall"
        "-Wextra"
        "-Wconversion"
        "-Wpedantic"
        "-Wshadow"
        "-Werror"

        "-Wno-language-extension-token"
    )
else()
    set(BASE_OPTIONS
        "/W4"
        "/WX"
        "/wd5105"
        "/Zc:__cplusplus"
    )
endif()


# Install directory setup
include(GNUInstallDirs)
set(GLAD_INC_DIR ${CMAKE_INSTALL_INCLUDEDIR})

# Static library target
file(GLOB SRC_FILES ${PROJECT_SOURCE_DIR}/src/*.c)
file(GLOB_RECURSE GLAD_HEADERS ${PROJECT_SOURCE_DIR}/include/*.h)

add_library(glad STATIC ${SRC_FILES})
target_include_directories(glad
    PUBLIC
    #"${PROJECT_SOURCE_DIR}/include"
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:${GLAD_INC_DIR}>
)
target_compile_features(glad PRIVATE c_std_17)
target_compile_options(glad PRIVATE "${BASE_OPTIONS}")
add_library(glad::glad ALIAS glad)

# Setup install targets
include(CMakePackageConfigHelpers)
set(GLAD_CMAKE_DIR ${CMAKE_INSTALL_LIBDIR}/cmake/glad)
set(version_config "${PROJECT_BINARY_DIR}/glad-config-version.cmake")
set(project_config "${PROJECT_BINARY_DIR}/glad-config.cmake")
set(pkgconfig ${PROJECT_BINARY_DIR}/glad.pc)
set(targets_export_name glad-targets)
set(GLAD_LIB_NAME glad)

write_basic_package_version_file(
    ${version_config}
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
)

set(GLAD_LIB_DIR ${CMAKE_INSTALL_LIBDIR})
set(GLAD_PKGCONFIG_DIR ${CMAKE_INSTALL_LIBDIR}/pkgconfig)

# Create path
string(CONCAT libdir_for_pc_file "\${exec_prefix}" "/" "${GLAD_LIB_DIR}")
string(CONCAT includedir_for_pc_file "\${prefix}" "/" "${GLAD_INC_DIR}")

# pkg-config support
configure_file(
    ${PROJECT_SOURCE_DIR}/cmake/glad.pc.in  # Input file
    ${pkgconfig}
    @ONLY
)

# CMake package config
configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/glad.cmake.in
    ${project_config}
    INSTALL_DESTINATION ${GLAD_CMAKE_DIR}
)

# Setup install targets
set(INSTALL_TARGETS glad)

# Install library and headers
install(TARGETS ${INSTALL_TARGETS} EXPORT ${targets_export_name}
        LIBRARY DESTINATION ${GLAD_LIB_DIR}
        ARCHIVE DESTINATION ${GLAD_LIB_DIR}
        PUBLIC_HEADER DESTINATION "${GLAD_INC_DIR}/include"
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
install(FILES ${GLAD_HEADERS} DESTINATION "${GLAD_INC_DIR}")

export(TARGETS ${INSTALL_TARGETS} NAMESPACE glad::
       FILE ${PROJECT_BINARY_DIR}/${targets_export_name}.cmake)

# Install version, config and target files.
install(
    FILES ${project_config} ${version_config}
    DESTINATION ${GLAD_CMAKE_DIR}
)
install(EXPORT ${targets_export_name} DESTINATION ${GLAD_CMAKE_DIR}
        NAMESPACE glad::)

# TODO: pkg-config doesn't work as expected on Windows
install(FILES "${pkgconfig}" DESTINATION "${GLAD_PKGCONFIG_DIR}")
