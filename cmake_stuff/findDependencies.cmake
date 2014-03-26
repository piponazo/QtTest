FIND_PACKAGE(Qt4 4.6.2 REQUIRED QUIET COMPONENTS QtCore)
FIND_PACKAGE(GTest)

INCLUDE(${QT_USE_FILE})

IF(BUILD_SHARED_LIBS)
   ADD_DEFINITIONS(-DQT_SHARED)
ELSE()
   ADD_DEFINITIONS(-DQT_STATIC)
ENDIF()

IF(${CMAKE_BUILD_TYPE} STREQUAL "Release")
   ADD_DEFINITIONS(-DQT_NO_DEBUG_OUTPUT)
   ADD_DEFINITIONS(-DQT_NO_WARNING_OUTPUT)
ENDIF()

SET(CMAKE_AUTOMOC ON)
