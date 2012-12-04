macro(URT_EXEC execname srcs)
  add_executable(${execname} ${srcs})
  target_link_libraries(${execname} ${UTAHRLE_LIBRARY})
  install(TARGETS ${execname} RUNTIME DESTINATION ${BIN_DIR})
endmacro()

# Local Variables:
# tab-width: 8
# mode: cmake
# indent-tabs-mode: t
# End:
# ex: shiftwidth=2 tabstop=8
