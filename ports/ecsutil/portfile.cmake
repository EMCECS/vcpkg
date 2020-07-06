
vcpkg_fail_port_install(ON_ARCH "arm" ON_TARGET "UWP" "Linux" "OSX")
if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
    set(PLATFORM x86)
endif()

if (VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    set(ECSUtil_CONFIGURATION_RELEASE Release)
    set(ECSUtil_CONFIGURATION_DEBUG Debug)
else()
    if (VCPKG_CRT_LINKAGE STREQUAL dynamic)
        set(ECSUtil_CONFIGURATION_RELEASE "Release Lib")
        set(ECSUtil_CONFIGURATION_DEBUG "Debug Lib")
    else()
        set(ECSUtil_CONFIGURATION_RELEASE "Release Lib Static")
        set(ECSUtil_CONFIGURATION_DEBUG "Debug Lib Static")
    endif()
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO EMCECS/ecs-object-client-windows-cpp
    REF v1.0.7.13
    SHA512 f0642e7413227e6ee81b5ca22085f4647fbbe3fe5b85a266cc607cbe981dea34dc1efab590aca785fd9b7e87bfcd296d03cc162f101b06c0e5c965d48d965b4f
    HEAD_REF master
)

vcpkg_install_msbuild(
    SOURCE_PATH ${SOURCE_PATH}
    PROJECT_SUBPATH ECSUtil.sln
    PLATFORM ${PLATFORM}
    LICENSE_SUBPATH license.txt
    TARGET ECSUtil
    RELEASE_CONFIGURATION ${ECSUtil_CONFIGURATION_RELEASE}
    DEBUG_CONFIGURATION ${ECSUtil_CONFIGURATION_DEBUG}
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()

file(COPY ${SOURCE_PATH}/ECSUtil DESTINATION ${CURRENT_PACKAGES_DIR}/include FILES_MATCHING PATTERN *.h)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/ECSUtil/res ${CURRENT_PACKAGES_DIR}/tools)
file(REMOVE ${CURRENT_PACKAGES_DIR}/bin/NatvisAddIn.dll ${CURRENT_PACKAGES_DIR}/debug/bin/NatvisAddIn.dll)
if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()
