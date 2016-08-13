function(URT_EXEC execname srcs)
  add_executable(${execname} ${srcs})
  target_link_libraries(${execname} utahrle)
  install(TARGETS ${execname} RUNTIME DESTINATION ${BIN_DIR})
endfunction()

add_subdirectory(libutahrle)
if(BUILD_SHARED_LIBS)
  if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/tools)
    add_subdirectory(tools)
  endif(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/tools)
  if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/cnv)
    add_subdirectory(cnv)
  endif(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/cnv)
endif(BUILD_SHARED_LIBS)

# Local Variables:
# tab-width: 8
# mode: cmake
# indent-tabs-mode: t
# End:
# ex: shiftwidth=2 tabstop=8
