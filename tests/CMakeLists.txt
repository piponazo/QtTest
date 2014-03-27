IF(NOT GTEST_FOUND)
   MESSAGE(WARNING "GTest is not installed in your system so unit tests can't be compiled")
ENDIF()

IF(GTEST_FOUND AND BUILD_TESTS)
   INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR}/src ${GTEST_INCLUDE_DIRS} ${PROJECT_BINARY_DIR})
   LINK_LIBRARIES(${GTEST_BOTH_LIBRARIES} ${PROJECT_NAME})

#   FILE(GLOB srcs	"*.cpp")
#   SET(srcs	QtTests2.cpp QtTests2.h main.cpp)
   SET(srcs	QtTests3.cpp QtTests3.h main.cpp)
   ADD_EXECUTABLE(tests ${srcs})

   IF(ENABLE_COVERAGE)
      SETUP_TARGET_FOR_COVERAGE(coverageHtml    tests coverage)
   ENDIF()

   IF(ENABLE_COVERAGE_XML)
      SETUP_TARGET_FOR_COVERAGE_XML(coverageXml tests coverage)
   ENDIF()

ENDIF()

