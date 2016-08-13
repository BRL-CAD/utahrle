set(LIBUTAHRLE_PUBLIC_HDRS
  exit_status.h
  pyramid.h
  rle.h
  rle_code.h
  rle_config.h
  rle_put.h
  rle_raw.h
  )

set(LIBUTAHRLE_PRIVATE_HDRS
  colorquant.h
  )

if(NOT SKIP_INSTALL_FILES AND NOT SKIP_INSTALL_ALL)
  install(FILES ${LIBUTAHRLE_PUBLIC_HDRS} DESTINATION include)
endif(NOT SKIP_INSTALL_FILES AND NOT SKIP_INSTALL_ALL)

# Local Variables:
# tab-width: 8
# mode: cmake
# indent-tabs-mode: t
# End:
# ex: shiftwidth=2 tabstop=8
