# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(system_idle_linux_library VERSION 1.0.0 LANGUAGES CXX C)

# ========== X11/XCB plugin ==========

add_library(system_idle_linux_x11 SHARED
  "x11.cpp"
)

set_target_properties(system_idle_linux_x11 PROPERTIES
  PUBLIC_HEADER system_idle_linux_x11.h
  OUTPUT_NAME "system_idle_linux_x11"
)

target_include_directories(system_idle_linux_x11 PUBLIC xcb_utils)
target_link_libraries(system_idle_linux_x11 "xcb" "xcb-screensaver")
target_compile_definitions(system_idle_linux_x11 PUBLIC DART_SHARED_LIB)

# ========== Wayland plugin ==========

add_library(system_idle_linux_wayland SHARED
  "wayland-protocol.c"
  "wayland.cpp"
)

set_target_properties(system_idle_linux_wayland PROPERTIES
  PUBLIC_HEADER system_idle_linux_wayland.h
  OUTPUT_NAME "system_idle_linux_wayland"
)

target_include_directories(system_idle_linux_wayland PUBLIC xcb_utils)
target_link_libraries(system_idle_linux_wayland "wayland-server" "wayland-client")
target_compile_definitions(system_idle_linux_wayland PUBLIC DART_SHARED_LIB)
