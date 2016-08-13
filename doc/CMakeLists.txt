if(NOT DEFINED MAN_DIR)
  set(MAN_DIR share/man)
endif(NOT DEFINED MAN_DIR)

add_subdirectory(man1)
add_subdirectory(man3)
add_subdirectory(man5)

# Local Variables:
# tab-width: 8
# mode: cmake
# indent-tabs-mode: t
# End:
# ex: shiftwidth=2 tabstop=8
