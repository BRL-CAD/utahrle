include_directories(
	${UTAHRLE_INCLUDE_DIR}
	${CMAKE_CURRENT_SOURCE_DIR}
	)

URT_EXEC(rleCLock "rleClock.c;font.c")
