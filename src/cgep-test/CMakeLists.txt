find_package(GTest REQUIRED)
add_executable(cgep-test)
target_sources(cgep-test
  PRIVATE
    cgep-color-test.cpp
    cgep-options-test.cpp
    cgep-version-test.cpp
)
target_link_libraries(cgep-test PRIVATE
  cgep::cgep
  GTest::gmock
  GTest::gmock_main
  GTest::gtest
)

include(GoogleTest)
gtest_discover_tests(cgep-test)
