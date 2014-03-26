INCLUDE(cmake_stuff/utils.cmake           REQUIRED)

SET(EXTRA_C_FLAGS "")
SET(EXTRA_C_FLAGS_RELEASE "-DNDEBUG")
SET(EXTRA_C_FLAGS_DEBUG "-DDEBUG -O0")
SET(EXTRA_EXE_LINKER_FLAGS "")
SET(EXTRA_EXE_LINKER_FLAGS_RELEASE "")
SET(EXTRA_EXE_LINKER_FLAGS_DEBUG "")

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

   add_extra_compiler_option(-Wall)
   add_extra_compiler_option(-Werror=return-type)
   add_extra_compiler_option(-Wno-long-long) #Always necessary for Qt
   add_extra_compiler_option(-Wno-maybe-uninitialized) #Simulator Antonio
   #add_extra_compiler_option(-Wno-variadic-macros) #To avoid errors in gstreamer

   IF(WARNINGS_ANSI_ISO)
      add_extra_compiler_option(-Wstrict-aliasing=3) #Warnings with c++11 and Release mode
   ELSE()
      add_extra_compiler_option(-Wno-narrowing)
      add_extra_compiler_option(-Wno-delete-non-virtual-dtor)
      add_extra_compiler_option(-Wno-unnamed-type-template-args)
   ENDIF()

   IF(ENABLE_SSE)
      add_extra_compiler_option(-msse)
   ENDIF()
   IF(ENABLE_SSE2)
      add_extra_compiler_option(-msse2)
   ENDIF()
   IF(ENABLE_SSE3)
      add_extra_compiler_option(-msse3)
   ENDIF()

   IF(X86 AND NOT MINGW64 AND NOT X86_64 AND NOT APPLE)
      add_extra_compiler_option(-march=i686)
   ELSEIF(${CMAKE_SYSTEM_PROCESSOR} MATCHES arm*) # Specific flags for beagleboard
      add_extra_compiler_option(-mtune=cortex-a8)
      add_extra_compiler_option(-march=armv7-a)
      add_extra_compiler_option(-mfloat-abi=softfp)
      add_extra_compiler_option(-mfpu=neon)
      add_extra_compiler_option(-ftree-vectorizen)
   ENDIF()

   IF(ENABLE_PROFILING)
      add_extra_compiler_option("-pg -g")
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
      add_extra_compiler_option(-ffunction-sections)
   ENDIF()

   IF(ENABLE_COVERAGE)
      SET(EXTRA_C_FLAGS "${EXTRA_C_FLAGS} -fprofile-arcs -ftest-coverage")
   ENDIF()

   IF(NOT BUILD_SHARED_LIBS)
      SET(LINKER_LIBS ${LINKER_LIBS} stdc++)
      SET(EXTRA_C_FLAGS "-fPIC ${EXTRA_C_FLAGS}")
   ENDIF()

ELSEIF ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")

   SET(EXTRA_C_FLAGS "${EXTRA_C_FLAGS} -fdiagnostics-show-category=name")

ENDIF()

IF ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU" OR
    "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang" )

   IF(WARNINGS_ANSI_ISO)
      add_extra_compiler_option(-pedantic)
      add_extra_compiler_option(-Wcast-align)
      add_extra_compiler_option(-Wextra)
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
set(EXTRA_EXE_LINKER_FLAGS "${EXTRA_EXE_LINKER_FLAGS}" CACHE INTERNAL "Extra linker flags")
set(EXTRA_EXE_LINKER_FLAGS_RELEASE "${EXTRA_EXE_LINKER_FLAGS_RELEASE}" CACHE INTERNAL "Extra linker flags for Release build")
set(EXTRA_EXE_LINKER_FLAGS_DEBUG "${EXTRA_EXE_LINKER_FLAGS_DEBUG}" CACHE INTERNAL "Extra linker flags for Debug build")

#combine all "extra" options
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${EXTRA_C_FLAGS}")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} ${EXTRA_C_FLAGS_DEBUG}")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} ${EXTRA_C_FLAGS_RELEASE}")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${EXTRA_C_FLAGS}")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}  ${EXTRA_C_FLAGS_RELEASE}")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${EXTRA_C_FLAGS_DEBUG}")

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${EXTRA_EXE_LINKER_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} ${EXTRA_EXE_LINKER_FLAGS_RELEASE}")
set(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} ${EXTRA_EXE_LINKER_FLAGS_DEBUG}")
