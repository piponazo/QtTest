INCLUDE(cmake_stuff/utils.cmake           REQUIRED)

SET(EXTRA_C_FLAGS "")
SET(EXTRA_C_FLAGS_RELEASE "-DNDEBUG")
SET(EXTRA_C_FLAGS_DEBUG "-DDEBUG -O0")

IF (USE_CLANG)
   SET (CMAKE_C_COMPILER_ID            "Clang")
   SET (CMAKE_CXX_COMPILER_ID          "Clang")
   SET (CMAKE_C_COMPILER               "/usr/bin/clang")
   SET (CMAKE_CXX_COMPILER             "/usr/bin/clang++")

   SET (CMAKE_C_FLAGS                  "-Wall -std=c99")
   SET (CMAKE_C_FLAGS_DEBUG            "-g")
   SET (CMAKE_C_FLAGS_RELEASE          "-O2")

   SET (CMAKE_CXX_FLAGS                "-Wall")
   SET (CMAKE_CXX_FLAGS_DEBUG          "-g")
   SET (CMAKE_CXX_FLAGS_RELEASE        "-O2")
ENDIF()

IF ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
   execute_process(
   COMMAND ${CMAKE_CXX_COMPILER} -dumpversion OUTPUT_VARIABLE GCC_VERSION)
   if (NOT (GCC_VERSION VERSION_GREATER 4.7 OR GCC_VERSION VERSION_EQUAL 4.7))
      message(FATAL_ERROR "${PROJECT_NAME} c++11 support requires g++ 4.7 or greater.")
   endif ()

   SET(EXTRA_C_FLAGS "${EXTRA_C_FLAGS} -Wall")
   SET(EXTRA_C_FLAGS "${EXTRA_C_FLAGS} -Werror=return-type")
   SET(EXTRA_C_FLAGS "${EXTRA_C_FLAGS} -Wno-long-long") #Always necessary for Qt

   IF(WARNINGS_ANSI_ISO)
      #Warnings with c++11 and Release mode
      SET(EXTRA_C_FLAGS "${EXTRA_C_FLAGS} -Wstrict-aliasing=3")
   ELSE()
      SET(EXTRA_C_FLAGS "${EXTRA_C_FLAGS} -Wno-narrowing")
      SET(EXTRA_C_FLAGS "${EXTRA_C_FLAGS} -Wno-delete-non-virtual-dtor")
      SET(EXTRA_C_FLAGS "${EXTRA_C_FLAGS} -Wno-unnamed-type-template-args")
   ENDIF()

   IF(ENABLE_PROFILING)
      SET(EXTRA_C_FLAGS "${EXTRA_C_FLAGS} -pg")
      FOREACH(flags CMAKE_CXX_FLAGS CMAKE_C_FLAGS
                    CMAKE_CXX_FLAGS_RELEASE
                    CMAKE_C_FLAGS_RELEASE
                    CMAKE_CXX_FLAGS_DEBUG
                    CMAKE_C_FLAGS_DEBUG
                    EXTRA_C_FLAGS_RELEASE)
         string(REPLACE "-fomit-frame-pointer" "" ${flags} "${${flags}}")
         string(REPLACE "-ffunction-sections" "" ${flags} "${${flags}}")
      ENDFOREACH()
   ELSEIF(NOT APPLE AND NOT ANDROID)
      SET(EXTRA_C_FLAGS "${EXTRA_C_FLAGS} -ffunction-sections")
   ENDIF()

   IF(ENABLE_COVERAGE)
      SET(EXTRA_C_FLAGS "${EXTRA_C_FLAGS} --coverage")
   ENDIF()

   IF(NOT BUILD_SHARED_LIBS)
      SET(EXTRA_C_FLAGS "${EXTRA_C_FLAGS} -fPIC")
   ENDIF()

ELSEIF ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")

   SET(EXTRA_C_FLAGS "${EXTRA_C_FLAGS} -fdiagnostics-show-category=name")

ENDIF()

IF ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU" OR
    "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang" )

   IF(WARNINGS_ANSI_ISO)
      SET(EXTRA_C_FLAGS "${EXTRA_C_FLAGS} -pedantic")
      SET(EXTRA_C_FLAGS "${EXTRA_C_FLAGS} -Wcast-align")
      SET(EXTRA_C_FLAGS "${EXTRA_C_FLAGS} -Wextra")
   ENDIF()

   IF(WARNINGS_ARE_ERRORS)
      SET(EXTRA_C_FLAGS "${EXTRA_C_FLAGS} -Werror")
   ENDIF()

   IF(WARNINGS_EFFCPP)
      SET(EXTRA_C_FLAGS "${EXTRA_C_FLAGS} -Weffc++")
   ENDIF()

   SET(EXTRA_C_FLAGS "${EXTRA_C_FLAGS} -std=c++11")

ENDIF()

# Add user supplied extra options (optimization, etc...)
# ==========================================================
set(EXTRA_C_FLAGS "${EXTRA_C_FLAGS}" CACHE INTERNAL "Extra compiler options")
set(EXTRA_C_FLAGS_RELEASE "${EXTRA_C_FLAGS_RELEASE}" CACHE INTERNAL "Extra compiler options for Release build")
set(EXTRA_C_FLAGS_DEBUG "${EXTRA_C_FLAGS_DEBUG}" CACHE INTERNAL "Extra compiler options for Debug build")

#combine all "extra" options
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${EXTRA_C_FLAGS}")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} ${EXTRA_C_FLAGS_DEBUG}")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} ${EXTRA_C_FLAGS_RELEASE}")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${EXTRA_C_FLAGS}")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}  ${EXTRA_C_FLAGS_RELEASE}")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${EXTRA_C_FLAGS_DEBUG}")
