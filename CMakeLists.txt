PROJECT(QtTests)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

INCLUDE(cmake_stuff/versions.cmake REQUIRED)
INCLUDE(cmake_stuff/options.cmake REQUIRED)
INCLUDE(cmake_stuff/findDependencies.cmake REQUIRED)
INCLUDE(cmake_stuff/compileroptions.cmake REQUIRED)
INCLUDE(cmake_stuff/generateDoc.cmake REQUIRED)
GENERATE_DOCUMENTATION(${PROJECT_SOURCE_DIR}/cmake_stuff/dox.in)
INCLUDE(cmake_stuff/buildFiles.cmake REQUIRED)

ADD_SUBDIRECTORY(src)
ADD_SUBDIRECTORY(tests)

INCLUDE(cmake_stuff/printInfo.cmake REQUIRED)

