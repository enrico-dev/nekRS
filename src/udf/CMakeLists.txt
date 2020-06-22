project(libUDF)
cmake_minimum_required(VERSION 2.8)
enable_language(C CXX)

set (CMAKE_CXX_STANDARD 14)

set(CMAKE_SHARED_LIBRARY_SUFFIX ".so")

set(CMAKE_VERBOSE_MAKEFILE on)

set (CMAKE_CXX_STANDARD 14)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} $ENV{NEKRS_LIBP_DEFINES}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} $ENV{NEKRS_LIBP_DEFINES}")

set(NEKRS_HOME $ENV{NEKRS_HOME})
set(HDRDIR      ${NEKRS_HOME}/libparanumal/include)
set(OGSDIR      ${NEKRS_HOME}/gatherScatter)
set(GSDIR       ${NEKRS_HOME}/gslib)
set(ALMONDDIR   ${NEKRS_HOME}/parAlmond)
set(ELLIPTICDIR ${NEKRS_HOME}/elliptic)
set(CDSDIR      ${NEKRS_HOME}/cds)
set(INSDIR      ${NEKRS_HOME}/ins)
set(INCLUDE_DIRS
  ${CMAKE_CURRENT_SOURCE_DIR}/../..
  ${INSDIR} 
  ${CDSDIR}
  ${HDRDIR}
  ${OGSDIR}
  ${GSDIR}
  ${ELLIPTICDIR}
  ${ALMONDDIR}
  ${NEKRS_HOME}
  ${NEKRS_HOME}/include
  ${NEKRS_HOME}/include/core
  ${NEKRS_HOME}/include/udf
  ${NEKRS_HOME}/include/nekInterface
  ${NEKRS_HOME}/occa/include
)

execute_process(COMMAND bash -c "cp -f ${FILENAME} ${CMAKE_CURRENT_SOURCE_DIR}/udf.cpp")
add_library(UDF SHARED udf.cpp)
target_include_directories(UDF PRIVATE ${INCLUDE_DIRS} ${UDF_DIR})

if(APPLE)
    target_link_libraries(UDF "-Wl,-undefined -Wl,dynamic_lookup")
endif()
set_target_properties(UDF PROPERTIES LINKER_LANGUAGE CXX)

message("UDF CXXFLAGS: ${CMAKE_CXX_FLAGS}")
