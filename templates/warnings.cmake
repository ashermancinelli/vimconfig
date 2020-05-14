add_library(warnings INTERFACE)

# Some options taken from Jason Turner
# <https://github.com/lefticus/cpp_box/blob/master/CMakeLists.txt>
target_compile_options(warnings
  INTERFACE
    -Wall
    -Wextra
    -Wshadow            # warn the user if a variable
                        # declaration shadows one from a
                        # parent context
    -Wnon-virtual-dtor  # warn the user if a class
                        # with virtual functions
                        # has a non-virtual
                        # destructor. This helps
                        # catch hard to track down
                        # memory errors
    -Wpedantic          # Warn on nonstandard C++
    -Wunused
    -Wconversion        # Warn on lossy conversions
    -Wnull-dereference
    -Wdouble-promotion  # Warn on implicit conversion from
                        # float to double
    -Wformat=2          # Warn on possibly insecure formatting
                        # when using printf
  )

if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
  message(STATUS "Found GNU compiler extensions")
  target_compile_options(warnings
    INTERFACE
      -Wmisleading-indentation    # Warn on indented blocks
                                  # that are not really blocks
      -Wduplicated-cond           # Warn on if/else chain with
                                  # duplicated conditions
      -Wduplicated-branches       # Warn on if/else chains with
                                  # duplicated code
      -Wuseless-cast              # Warn when casting to the same type
    )
endif()
