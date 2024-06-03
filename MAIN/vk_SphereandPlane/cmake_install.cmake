# Install script for directory: /home/hpclab/Documents/RT_vulkan/SDK/vk_SphereandPlane

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/hpclab/Documents/RT_vulkan/nvpro-samples/_install")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin_x64/vk_vk_SphereandPlane_KHR_app" AND
       NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin_x64/vk_vk_SphereandPlane_KHR_app")
      file(RPATH_CHECK
           FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin_x64/vk_vk_SphereandPlane_KHR_app"
           RPATH "")
    endif()
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin_x64" TYPE EXECUTABLE FILES "/home/hpclab/Documents/RT_vulkan/nvpro-samples/bin_x64/Release/vk_vk_SphereandPlane_KHR_app")
    if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin_x64/vk_vk_SphereandPlane_KHR_app" AND
       NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin_x64/vk_vk_SphereandPlane_KHR_app")
      if(CMAKE_INSTALL_DO_STRIP)
        execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin_x64/vk_vk_SphereandPlane_KHR_app")
      endif()
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin_x64_debug/vk_vk_SphereandPlane_KHR_app" AND
       NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin_x64_debug/vk_vk_SphereandPlane_KHR_app")
      file(RPATH_CHECK
           FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin_x64_debug/vk_vk_SphereandPlane_KHR_app"
           RPATH "")
    endif()
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin_x64_debug" TYPE EXECUTABLE FILES "/home/hpclab/Documents/RT_vulkan/nvpro-samples/bin_x64/Release/vk_vk_SphereandPlane_KHR_app")
    if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin_x64_debug/vk_vk_SphereandPlane_KHR_app" AND
       NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin_x64_debug/vk_vk_SphereandPlane_KHR_app")
      if(CMAKE_INSTALL_DO_STRIP)
        execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin_x64_debug/vk_vk_SphereandPlane_KHR_app")
      endif()
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin_x64/vk_vk_SphereandPlane_KHR/spv" TYPE FILE FILES
      "/home/hpclab/Documents/RT_vulkan/SDK/vk_SphereandPlane/spv/frag_shader.frag.spv"
      "/home/hpclab/Documents/RT_vulkan/SDK/vk_SphereandPlane/spv/passthrough.vert.spv"
      "/home/hpclab/Documents/RT_vulkan/SDK/vk_SphereandPlane/spv/post.frag.spv"
      "/home/hpclab/Documents/RT_vulkan/SDK/vk_SphereandPlane/spv/raytrace.rgen.spv"
      "/home/hpclab/Documents/RT_vulkan/SDK/vk_SphereandPlane/spv/raytrace.rmiss.spv"
      "/home/hpclab/Documents/RT_vulkan/SDK/vk_SphereandPlane/spv/raytraceShadow.rmiss.spv"
      "/home/hpclab/Documents/RT_vulkan/SDK/vk_SphereandPlane/spv/rcvsphere.rchit.spv"
      "/home/hpclab/Documents/RT_vulkan/SDK/vk_SphereandPlane/spv/rcvsphere.rint.spv"
      "/home/hpclab/Documents/RT_vulkan/SDK/vk_SphereandPlane/spv/triangle.rchit.spv"
      "/home/hpclab/Documents/RT_vulkan/SDK/vk_SphereandPlane/spv/vert_shader.vert.spv"
      )
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin_x64_debug/vk_vk_SphereandPlane_KHR/spv" TYPE FILE FILES
      "/home/hpclab/Documents/RT_vulkan/SDK/vk_SphereandPlane/spv/frag_shader.frag.spv"
      "/home/hpclab/Documents/RT_vulkan/SDK/vk_SphereandPlane/spv/passthrough.vert.spv"
      "/home/hpclab/Documents/RT_vulkan/SDK/vk_SphereandPlane/spv/post.frag.spv"
      "/home/hpclab/Documents/RT_vulkan/SDK/vk_SphereandPlane/spv/raytrace.rgen.spv"
      "/home/hpclab/Documents/RT_vulkan/SDK/vk_SphereandPlane/spv/raytrace.rmiss.spv"
      "/home/hpclab/Documents/RT_vulkan/SDK/vk_SphereandPlane/spv/raytraceShadow.rmiss.spv"
      "/home/hpclab/Documents/RT_vulkan/SDK/vk_SphereandPlane/spv/rcvsphere.rchit.spv"
      "/home/hpclab/Documents/RT_vulkan/SDK/vk_SphereandPlane/spv/rcvsphere.rint.spv"
      "/home/hpclab/Documents/RT_vulkan/SDK/vk_SphereandPlane/spv/triangle.rchit.spv"
      "/home/hpclab/Documents/RT_vulkan/SDK/vk_SphereandPlane/spv/vert_shader.vert.spv"
      )
  endif()
endif()

