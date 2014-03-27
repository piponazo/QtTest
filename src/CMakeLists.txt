FILE(GLOB hdrs "*.h")
FILE(GLOB srcs "*.cpp")

ADD_LIBRARY(${PROJECT_NAME} ${srcs} ${hdrs})

SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES   # create *nix style library versions + symbolic links
  DEFINE_SYMBOL catecCPP_EXPORTS
  VERSION ${VERSION}
  SOVERSION ${SOVERSION}
  CLEAN_DIRECT_OUTPUT 1                                   # allow creating static and shared libs without conflicts
  OUTPUT_NAME "${PROJECT_NAME}${DLLVERSION}")      # avoid conflicts between library and binary target names

TARGET_LINK_LIBRARIES(${PROJECT_NAME} ${QT_QTCORE_LIBRARIES})

INSTALL(TARGETS ${PROJECT_NAME}
  RUNTIME DESTINATION bin COMPONENT main			                  # Install the dll file in bin directory
  LIBRARY DESTINATION lib PERMISSIONS OWNER_READ OWNER_WRITE
    OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE COMPONENT main
  ARCHIVE DESTINATION lib COMPONENT main)			                  # Install the dll.a file in lib directory
