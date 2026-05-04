// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#include <cgep/cgep.hpp>
#include <gtest/gtest.h>

#include <array>
#include <string_view>

namespace cgep::test {
namespace {

TEST(CgepTest, ParseOptionsUsesDefaults) {
    const auto args = std::array<std::string_view, 0>{};
    const auto opts = parse(args);
    EXPECT_EQ(opts.file_name, "input.txt");
    EXPECT_EQ(opts.count, 1);
}

TEST(CgepTest, ParseOptionsParsesProvidedValues) {
    const auto args = std::array{
        std::string_view{"--file_name"},
        std::string_view{"data.txt"},
        std::string_view{"--count"},
        std::string_view{"7"},
    };
    const auto opts = parse(args);
    EXPECT_EQ(opts.file_name, "data.txt");
    EXPECT_EQ(opts.count, 7);
}

TEST(CgepTest, ParseOptionsFirstFlagWins) {
    const auto args = std::array{
        std::string_view{"--count"},
        std::string_view{"2"},
        std::string_view{"--count"},
        std::string_view{"4"},
    };
    const auto opts = parse(args);
    EXPECT_EQ(opts.count, 2);
}

}  // namespace
}  // namespace cgep::test
