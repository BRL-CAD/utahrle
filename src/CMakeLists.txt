include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}/../include
  ${CMAKE_CURRENT_BINARY_DIR}
  )

if(MSVC)
  add_definitions(
    -DRLE_DLL_EXPORTS
    -DNO_DECLARE_MALLOC
    -DNEED_BSTRING
    -DNO_OPEN_PIPES
    )
endif(MSVC)

SET(LIBUTAHRLE_SOURCES
  Runput.c
  buildmap.c
  cmd_name.c
  colorquant.c
  dither.c
  float_to_exp.c
  hilbert.c
  inv_cmap.c
  rle_addhist.c
  rle_cp.c
  rle_error.c
  rle_getcom.c
  rle_getraw.c
  rle_getrow.c
  rle_getskip.c
  rle_global.c
  rle_hdr.c
  rle_open_f.c
  rle_putcom.c
  rle_putraw.c
  rle_putrow.c
  rle_raw_alc.c
  rle_rawrow.c
  rle_row_alc.c
  scanargs.c
  vaxshort.c
  )

add_library(utahrle SHARED ${LIBUTAHRLE_SOURCES})
target_link_libraries(utahrle ${M_LIBRARY})
set_target_properties(utahrle PROPERTIES VERSION 19.0.1 SOVERSION 19)
install(TARGETS utahrle
	RUNTIME DESTINATION ${BIN_DIR}
	LIBRARY DESTINATION ${LIB_DIR}
	ARCHIVE DESTINATION ${LIB_DIR})
add_library(utahrle-static STATIC ${LIBUTAHRLE_SOURCES})
target_link_libraries(utahrle-static ${M_LIBRARY})
install(TARGETS utahrle-static
	RUNTIME DESTINATION ${BIN_DIR}
	LIBRARY DESTINATION ${LIB_DIR}
	ARCHIVE DESTINATION ${LIB_DIR})
if(NOT WIN32)
  set_target_properties(utahrle-static PROPERTIES OUTPUT_NAME "utahrle")
endif(NOT WIN32)

set(UTAHRLE_LIBRARY utahrle)

add_subdirectory(tools)
add_subdirectory(cnv)

# Local Variables:
# tab-width: 8
# mode: cmake
# indent-tabs-mode: t
# End:
# ex: shiftwidth=2 tabstop=8
