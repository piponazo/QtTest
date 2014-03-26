#------------------------------------------------------
# Build type
#------------------------------------------------------
SET(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Configs" FORCE)
IF(DEFINED CMAKE_BUILD_TYPE)
   SET_PROPERTY(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS ${CMAKE_CONFIGURATION_TYPES})
ENDIF()

IF(NOT CMAKE_BUILD_TYPE)
   SET(CMAKE_BUILD_TYPE "Debug")
ENDIF()

# ----------------------------------------------------------------------------
#   PROJECT CONFIGURATION
#   force some variables that could be defined in the command line to be written to cache
#   Don't be paranoiac with -Weffc++ flag. It throws a lot of warnings in correct code.
# ----------------------------------------------------------------------------
OPTION(USE_CLANG            "Use Clang compiler"                                            OFF)
OPTION(WARNINGS_ARE_ERRORS  "Treat warnings as errors"                                      ON)
OPTION(WARNINGS_ANSI_ISO    "Issue all the mandatory diagnostics Listed in C standard"      ON)
OPTION(WARNINGS_EFFCPP      "Issue all the warnings listed in the book of Scot Meyers"      OFF)
OPTION(ENABLE_PROFILING     "Enable profiling in Valgrind (Add flags: -g -fno_inline)"      OFF)
OPTION(ENABLE_SSE           "SSE instructions"                                              ON)
OPTION(ENABLE_SSE2          "SSE2 instructions"                                             ON)
OPTION(ENABLE_SSE3          "SSE3 instructions"                                             ON)
OPTION(ENABLE_COVERAGE      "Perform code coverage in HTML"                                OFF)
OPTION(ENABLE_COVERAGE_XML  "Perform code coverage in XML for jenkins integration"         OFF)

OPTION(INSTALL_DOC          "Install documentation in system"                               OFF)
OPTION(USE_MATHJAX          "Generate doc-formulas via mathjax instead of latex"            OFF)
OPTION(USE_DOT              "Diagram generation with graphviz"                              ON)
OPTION(USE_LATEX            "Build latex documentation"                                     OFF)
OPTION(USE_CHM              "Build CHM Windows documentation"                               OFF)

OPTION(BUILD_SHARED_LIBS    "Build shared libraries"                                        ON)
OPTION(BUILD_TESTS          "Build application tests"                                       OFF)

IF (ENABLE_COVERAGE)
   INCLUDE(cmake_stuff/code_coverage.cmake)
ENDIF()

IF (ENABLE_COVERAGE_XML)
   INCLUDE(cmake_stuff/code_coverage_xml.cmake)
ENDIF()

IF (ENABLE_COVERAGE AND NOT BUILD_TESTS)
   MESSAGE(WARNING "It's necessary to build unitary tests for checking code coverage")
ENDIF()

SET(CMAKE_INCLUDE_DIRS_CONFIGCMAKE ${CMAKE_INSTALL_PREFIX}/include  CACHE PATH "Output directory for headers")
SET(CMAKE_LIB_DIRS_CONFIGCMAKE     ${CMAKE_INSTALL_PREFIX}/lib      CACHE PATH "Output directory for libraries")
