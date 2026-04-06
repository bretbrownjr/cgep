#include <cgep/cgep.hpp>
#include <gtest/gtest.h>

namespace cgep::test {
namespace {

TEST(CgepTest, Version) {
    EXPECT_FALSE(cgep::version().empty());
}

}  // namespace
}  // namespace cgep::test
