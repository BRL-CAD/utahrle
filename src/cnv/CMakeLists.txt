include_directories(
	${UTAHRLE_INCLUDE_DIR}
	${${CMAKE_PROJECT_NAME}_SOURCE_DIR}/include
	${CMAKE_CURRENT_SOURCE_DIR}
	${CMAKE_CURRENT_SOURCE_DIR}/rletogif
)

# Disabled due to various external dependancies:
#	iristorle
#	pgmtorle
#	ppmtorle
#	rastorle
#	rletocgm
#	rletoiris
#	rletoppm
#	rletorast
#	rletotiff
#	tifftorle

add_executable(aliastorle aliastorle.c)
add_executable(cubitorle cubitorle.c)
add_executable(giftorle giftorle.c)
add_executable(graytorle graytorle.c)
# add_executable(iristorle iristorle.c)
add_executable(painttorle painttorle.c)
# add_executable(pgmtorle pgmtorle.c)
# add_executable(ppmtorle ppmtorle.c)
# add_executable(rastorle rastorle.c)
add_executable(rawtorle rawtorle.c)
add_executable(rletoabA60 rletoabA60.c)
add_executable(rletoalias rletoalias.c)
add_executable(rletoascii rletoascii.c)
# add_executable(rletocgm rletocgm.c)
add_executable(rletogray rletogray.c)
# add_executable(rletoiris rletoiris.c)
add_executable(rletopaint rletopaint.c)
# add_executable(rletoppm rletoppm.c)
add_executable(rletops rletops.c)
# add_executable(rletorast rletorast.c)
add_executable(rletoraw rletoraw.c)
add_executable(rletorla rletorla.c)
add_executable(rletotarga rletotarga.c)
# add_executable(rletotiff rletotiff.c)
add_executable(rletovcr rletovcr.c)
add_executable(targatorle targatorle.c)
# add_executable(tifftorle tifftorle.c)
add_executable(vcrtorle vcrtorle.c)
add_executable(wasatchrle wasatchrle.c)
add_executable(xbmtorle xbmtorle.c)

add_executable(rletoabA62 rletoabA62/rle.c rletoabA62/rletoabA62.c)
add_executable(rletogif rletogif/compgif.c rletogif/gifencod.c rletogif/rletogif.c)

target_link_libraries(aliastorle utahrle)
target_link_libraries(cubitorle utahrle)
target_link_libraries(giftorle utahrle)
target_link_libraries(graytorle utahrle)
#target_link_libraries(iristorle utahrle)
target_link_libraries(painttorle utahrle)
#target_link_libraries(pgmtorle utahrle)
#target_link_libraries(ppmtorle utahrle)
#target_link_libraries(rastorle utahrle)
target_link_libraries(rawtorle utahrle)
target_link_libraries(rletoabA60 utahrle)
target_link_libraries(rletoalias utahrle)
target_link_libraries(rletoascii utahrle)
#target_link_libraries(rletocgm utahrle)
target_link_libraries(rletogray utahrle)
#target_link_libraries(rletoiris utahrle)
target_link_libraries(rletopaint utahrle)
#target_link_libraries(rletoppm utahrle)
target_link_libraries(rletops utahrle)
#target_link_libraries(rletorast utahrle)
target_link_libraries(rletoraw utahrle)
target_link_libraries(rletorla utahrle)
target_link_libraries(rletotarga utahrle)
#target_link_libraries(rletotiff utahrle)
target_link_libraries(rletovcr utahrle)
target_link_libraries(targatorle utahrle)
#target_link_libraries(tifftorle utahrle)
target_link_libraries(vcrtorle utahrle)
target_link_libraries(wasatchrle utahrle)
target_link_libraries(xbmtorle utahrle)

target_link_libraries(rletoabA62 utahrle)
target_link_libraries(rletogif utahrle)
