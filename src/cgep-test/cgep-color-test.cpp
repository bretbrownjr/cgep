#include <cgep/cgep.hpp>
#include <gtest/gtest.h>
#include <gmock/gmock.h>

#include <array>
#include <format>

namespace cgep::test {
namespace {

constexpr auto has_color = [](Color color) {
    for (auto c : enumerators_of<Color>()) {
        if (c == color) {
            return true;
        }
    }
    return false;
};

static_assert(has_color(Color::red));
static_assert(has_color(Color::green));
static_assert(has_color(Color::blue));
static_assert(!has_color(static_cast<Color>(-1)));

TEST(CgepTest, ToColor) {
    EXPECT_EQ(to_color("red"), Color::red);
    EXPECT_EQ(to_color("green"), Color::green);
    EXPECT_EQ(to_color("blue"), Color::blue);
    EXPECT_EQ(to_color("yellow"), std::nullopt);
}

static_assert(to_color("red") == Color::red);
static_assert(to_color("green") == Color::green);
static_assert(to_color("blue") == Color::blue);
static_assert(to_color("yellow") == std::nullopt);

TEST(CgepTest, EnumeratorsOfColor) {
    EXPECT_TRUE(has_color(Color::red));
    EXPECT_TRUE(has_color(Color::green));
    EXPECT_TRUE(has_color(Color::blue));

    using ::testing::Contains;
    auto colors = enumerators_of<Color>();
    EXPECT_EQ(colors.size(), 3);
    // use ranges contains to do unordered contains check
    EXPECT_THAT(colors, Contains(Color::red));
    EXPECT_THAT(colors, Contains(Color::green));
    EXPECT_THAT(colors, Contains(Color::blue));
}

TEST(CgepTest, name_of) {
    EXPECT_EQ(name_of(Color::red), "red");
    EXPECT_EQ(name_of(Color::green), "green");
    EXPECT_EQ(name_of(Color::blue), "blue");
    EXPECT_EQ(name_of(static_cast<Color>(-1)), "<unknown>");
}

TEST(CgepTest, value_of) {
    EXPECT_EQ(value_of(Color::red), 0);
    EXPECT_EQ(value_of(Color::green), 1);
    EXPECT_EQ(value_of(Color::blue), 2);
    EXPECT_EQ(value_of(static_cast<Color>(-1)), -1);
}

TEST(CgepTest, ToString) {
    EXPECT_EQ(to_string(Color::red), "red");
    EXPECT_EQ(to_string(Color::green), "green");
    EXPECT_EQ(to_string(Color::blue), "blue");
    EXPECT_EQ(to_string(static_cast<Color>(-1)), "<unknown>");
}

TEST(CgepTest, ToStringView) {
    EXPECT_EQ(ToStringView(Color::red), "red");
    EXPECT_EQ(ToStringView(Color::green), "green");
    EXPECT_EQ(ToStringView(Color::blue), "blue");
}

static_assert(name_of(Color::red) == "red");
static_assert(name_of(Color::green) == "green");
static_assert(name_of(Color::blue) == "blue");
static_assert(name_of(static_cast<Color>(-1)) == "<unknown>");

TEST(CgepTest, ColorFormatter) {
    EXPECT_EQ(std::format("{}", Color::red), "red");
    EXPECT_EQ(std::format("{}", Color::green), "green");
    EXPECT_EQ(std::format("{}", Color::blue), "blue");
    EXPECT_EQ(std::format("{}", static_cast<Color>(-1)), "<unknown>");
}

}  // namespace
}  // namespace cgep::test
