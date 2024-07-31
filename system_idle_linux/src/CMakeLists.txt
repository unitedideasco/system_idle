# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(system_idle_linux_library VERSION 1.0.0 LANGUAGES CXX)

add_library(system_idle_linux SHARED
  "system_idle_linux.cpp"
)

set_target_properties(system_idle_linux PROPERTIES
  PUBLIC_HEADER system_idle_linux.h
  OUTPUT_NAME "system_idle_linux"
)

target_compile_definitions(system_idle_linux PUBLIC DART_SHARED_LIB)
