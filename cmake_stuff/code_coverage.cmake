#
# 2012-01-31, Lars Bilke
# - Enable Code Coverage
#
# 2013-09-17, Joakim Söderberg
# - Added support for Clang.
# - Some additional usage instructions.
#
# Do not forget to use the flags -fprofile-arcs -ftest-coverage (or --coverage)

FIND_PROGRAM(GCOV_PATH gcov)
FIND_PROGRAM(LCOV_PATH lcov)
FIND_PROGRAM(GENHTML_PATH genhtml)

IF(NOT GCOV_PATH)
	MESSAGE(FATAL_ERROR "gcov not found! Aborting...")
ENDIF() # NOT GCOV_PATH

IF(NOT CMAKE_COMPILER_IS_GNUCXX)
	# Clang version 3.0.0 and greater now supports gcov as well.
	MESSAGE(WARNING "Compiler is not GNU gcc! Clang Version 3.0.0 and greater supports gcov as well, but older versions don't.")

	IF(NOT "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
		MESSAGE(FATAL_ERROR "Compiler is not GNU gcc! Aborting...")
	ENDIF()
ENDIF()

IF ( NOT CMAKE_BUILD_TYPE STREQUAL "Debug" )
  MESSAGE( WARNING "Code coverage results with an optimized (non-Debug) build may be misleading" )
ENDIF()


# Param _targetname  The name of new the custom make target
# Param _testrunner  The name of the target which runs the tests.
#     MUST return ZERO always, even on errors.
#     If not, no coverage report will be created!
# Param _outputname  lcov output is generated as _outputname.info
#                       HTML report is generated in _outputname/index.html
# Optional fourth parameter is passed as arguments to _testrunner
#   Pass them in list form, e.g.: "-j;2" for -j 2
FUNCTION(SETUP_TARGET_FOR_COVERAGE _targetname _testrunner _outputname)

   SET(NEED_LCOV_VERSION 1.10)
	IF(NOT LCOV_PATH)
		MESSAGE(FATAL_ERROR "lcov not found! Aborting...")
    ELSE()
      exec_program(lcov ARGS --version OUTPUT_VARIABLE LCOV_V)
      string (REGEX REPLACE "lcov: LCOV version ([0-9].[0-9])" "\\1" LCOV_VERSION "${LCOV_V}")
      IF (${LCOV_VERSION} VERSION_LESS NEED_LCOV_VERSION)
         message(FATAL_ERROR "GCOV VERSION MINOR THAN ${NEED_LCOV_VERSION}")
      ENDIF()
	ENDIF()

   IF(NOT GENHTML_PATH)
      MESSAGE(FATAL_ERROR "genhtml not found! Aborting...")
   ENDIF() # NOT GENHTML_PATH

	# Setup target
	ADD_CUSTOM_TARGET(${_targetname}

		# Cleanup lcov
		${LCOV_PATH} --directory . --zerocounters

		# Run tests
		COMMAND ${_testrunner} ${ARGV3}

		# Capturing lcov counters and generating report
		COMMAND ${LCOV_PATH} --directory . --capture --output-file ${_outputname}.info
		COMMAND ${LCOV_PATH} --remove ${_outputname}.info 'gtests/*' '/usr/*' --output-file ${_outputname}.info.cleaned
		COMMAND ${GENHTML_PATH} -o ${_outputname} ${_outputname}.info.cleaned
		COMMAND ${CMAKE_COMMAND} -E remove ${_outputname}.info ${_outputname}.info.cleaned

		WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
		COMMENT "Resetting code coverage counters to zero.\nProcessing code coverage counters and generating report."
	)

	# Show info where to find the report
	ADD_CUSTOM_COMMAND(TARGET ${_targetname} POST_BUILD
		COMMAND ;
		COMMENT "Open ./${_outputname}/index.html in your browser to view the coverage report."
	)

ENDFUNCTION() # SETUP_TARGET_FOR_COVERAGE

