include_directories(
	${UTAHRLE_INCLUDE_DIR}
	${CMAKE_CURRENT_SOURCE_DIR}
	)

add_executable(rleCLock rleClock.c font.c)
target_link_libraries(rleCLock utahrle)
