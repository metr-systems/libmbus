function(add_example SRCS)
  add_executable(${SRCS} ${CMAKE_CURRENT_LIST_DIR}/${SRCS}.c)
  target_link_libraries(${SRCS} PRIVATE libmbus::libmbus)
endfunction()

add_example(mbus-serial-request-data)
add_example(mbus-serial-request-data-multi-reply)
add_example(mbus-serial-scan)
add_example(mbus-serial-scan-secondary)
add_example(mbus-serial-select-secondary)
add_example(mbus-serial-set-address)
add_example(mbus-serial-switch-baudrate)
add_example(mbus-tcp-application-reset)
add_example(mbus-tcp-raw-send)
add_example(mbus-tcp-request-data)
add_example(mbus-tcp-request-data-multi-reply)
add_example(mbus-tcp-scan)
add_example(mbus-tcp-scan-secondary)
add_example(mbus-tcp-select-secondary)
