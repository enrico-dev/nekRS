cmake_minimum_required(VERSION 3.10)
project(NekRS)
enable_language(C CXX Fortran)
include(FortranCInterface)

set(CMAKE_VERBOSE_MAKEFILE on)
SET(CMAKE_BUILD_TYPE Debug)

option(UDF_LOC ".udf file")

#Link:https://gitlab.kitware.com/cmake/community/wikis/doc/cmake/RPATH-handling
#set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
#set(CMAKE_SKIP_BUILD_RPATH FALSE)
#set(CMAKE_INSTALL_RPATH_USE_LINK_PATH FALSE)
#set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
#set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_RPATH};${CMAKE_INSTALL_PREFIX}/occa/lib")
#set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_RPATH};${CMAKE_INSTALL_PREFIX}/elliptic")
#set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_RPATH};${CMAKE_INSTALL_PREFIX}/parAlmond")
#set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_RPATH};${CMAKE_INSTALL_PREFIX}/libparanumal")
#set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_RPATH};${CMAKE_INSTALL_PREFIX}/gatherScatter")

###############################################################################
# Check compiler/MPI vendor, version and Fortran/C compatibility              #
###############################################################################
macro(check_compiler_id compiler)
  if (NOT "${compiler}" STREQUAL "GNU")
    message(FATAL_ERROR "NekRS only supports GNU compilers")
  endif ()
endmacro()

macro(check_compiler_version compiler_version)
  if (${compiler_version} LESS 6.2)
    message(FATAL_ERROR "NekRS only supports GNU compiler versions >= 6.2")
  endif ()
endmacro()

#check_compiler_id("${CMAKE_CXX_COMPILER_ID}")
#check_compiler_id("${CMAKE_C_COMPILER_ID}")
#check_compiler_id("${CMAKE_Fortran_COMPILER_ID}")
#
#check_compiler_version("${CMAKE_CXX_COMPILER_VERSION}")
#check_compiler_version("${CMAKE_C_COMPILER_VERSION}")
#check_compiler_version("${CMAKE_Fortran_COMPILER_VERSION}")

## Sanity checks for MPI
#set(MPI_C_COMPILER ${CMAKE_C_COMPILER})
#set(MPI_CXX_COMPILER ${CMAKE_CXX_COMPILER})
#set(MPI_Fortran_COMPILER ${CMAKE_Fortran_COMPILER})
#find_package(MPI REQUIRED)
#if(NOT MPI_FOUND)
#  message(FATAL_ERROR "MPI is not found for one of the languages: C/CXX/Fortran")
#endif()
#if (MPI_VERSION VERSION_LESS "3.1")
#  message(FATAL_ERROR "NekRS requires an MPI version >= 3.1")
#endif()

## Check Fortran/C interface
FortranCInterface_VERIFY(CXX)

## Use c++14
set(CMAKE_CXX_STANDARD 14)

###############################################################################
# Set compiler flags                                                          #
###############################################################################
find_package(OpenMP)
if (OPENMP_FOUND)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
endif()

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

if (DEFINED ENV{NEKRS_LIBP_DEFINES})
  set(LIBP_DEFINES "$ENV{NEKRS_LIBP_DEFINES}" CACHE STRING "")
else()
  set(LIBP_DEFINES "-DUSE_NULL_PROJECTION=1" CACHE STRING "")
endif()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${LIBP_DEFINES}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${LIBP_DEFINES}")

###############################################################################
# Generate nekrs.bashrc                                                       #
###############################################################################

configure_file(
        config/nekrs.conf.in
        ${CMAKE_BINARY_DIR}/nekrs.conf
        @ONLY)

###############################################################################
# Build OCCA                                                                  #
###############################################################################

add_subdirectory(3rd_party/occa)

###############################################################################
# Build Nek5000                                                               #
###############################################################################

add_subdirectory(3rd_party/nek5000)

###############################################################################
# Build HYPRE
###############################################################################

add_subdirectory(3rd_party/hypre/src)

###############################################################################
# Build libP                                                                  #
###############################################################################

include(config/libparanumal.cmake)


###############################################################################
# NekRS targets
###############################################################################

set(CASE_UDF_CPP ${CMAKE_CURRENT_BINARY_DIR}/case_udf.cpp)
configure_file(${UDF_LOC} ${CASE_UDF_CPP} COPYONLY)
add_library(libUDF SHARED ${CASE_UDF_CPP})
set_target_properties(libUDF PROPERTIES OUTPUT_NAME UDF)
target_include_directories(libUDF PUBLIC 
  src
  src/core
  src/nekInterface
        src/udf
        3rd_party/occa/include
        ${CMAKE_BINARY_DIR}/3rd_party/occa
        3rd_party/libparanumal/libs/gatherScatter
        3rd_party/libparanumal/libs/parAlmond
        3rd_party/libparanumal/include
        3rd_party/libparanumal/solvers/elliptic
        src/3rd_party/libparanumal/include
        )
target_link_libraries(libUDF PUBLIC libocca libparanumal)

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  if (${CMAKE_VERSION} VERSION_LESS "3.13")
    set_target_properties(libUDF PROPERTIES LINK_FLAGS "-undefined dynamic_lookup")
  else ()
    target_link_options(libUDF PRIVATE -undefined dynamic_lookup)
  endif ()
endif ()

add_library(libnek5000_nekrs SHARED src/nekInterface/nekInterface.f)
set_target_properties(libnek5000_nekrs PROPERTIES OUTPUT_NAME nek5000_nekrs)
# TODO: Discover -fcray-pointers properly
target_compile_options(libnek5000_nekrs PRIVATE -fcray-pointer -fdefault-real-8 -fdefault-double-8)
target_include_directories(libnek5000_nekrs PRIVATE src/nekInterface)
target_link_libraries(libnek5000_nekrs PRIVATE libnek5000)

set(NEKRS_SRC
        src/nekrs.cpp
        src/core/cfl.cpp
        src/core/filter.cpp
        src/core/bcMap.cpp
        src/core/insSetup.cpp
        src/core/runTime.cpp
        src/core/tombo.cpp
        src/core/cds.cpp
        src/udf/udf.cpp
        src/mesh/meshSetup.cpp
        src/mesh/meshNekReader.cpp
        src/mesh/meshPhysicalNodesHex3D.cpp
        src/core/occaDeviceConfig.cpp
        src/nekInterface/nekInterfaceAdapter.cpp
        src/core/parReader.cpp
        src/core/configReader.cpp
        src/core/tinyexpr.c
        src/core/timer.cpp
        src/plugins/avg.cpp
        src/plugins/velRecycling.cpp
        ${CASE_UDF_CPP}
        ## To get fortran flags
        src/dummy.f
        )

add_library(libnekrs ${NEKRS_SRC})
set_target_properties(libnekrs PROPERTIES OUTPUT_NAME nekrs)
target_include_directories(libnekrs PUBLIC
        src
        src/mesh
        src/core
        src/udf
        src/nekInterface
        )
target_link_libraries(libnekrs PUBLIC
        libocca
        libparanumal
        libelliptic
        libparAlmond
        libgs
        ${CMAKE_DL_LIBS}
        )

add_dependencies(libnekrs libnek5000_nekrs)
add_dependencies(libnekrs libUDF)

add_executable(nekrs src/main.cpp)
target_link_libraries(nekrs PUBLIC libnekrs)

#################################################################################
### Install                                                                     #
#################################################################################
## Install dependencies and examples
#configure_file(install_script.in.cmake install_script.cmake @ONLY)
#install(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/install_script.cmake)
#
##install nekRS
#install(TARGETS nekrs-lib nekrs-bin
#  RUNTIME DESTINATION bin
#  LIBRARY DESTINATION lib
#  PUBLIC_HEADER DESTINATION include
#  PRIVATE_HEADER DESTINATION include
#)
