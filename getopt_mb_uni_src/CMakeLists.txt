cmake_minimum_required (VERSION 2.6)
project (getopt C)

# set default build type: Release
if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE "Release")
endif(NOT CMAKE_BUILD_TYPE)

add_compile_definitions(EXPORTS_GETOPT)

set(GETOPT_SRC
	getopt.c
	getopt.h
	)

add_library(getopt SHARED ${GETOPT_SRC})

install(TARGETS getopt DESTINATION bin)
