#include <gtest/gtest.h>
#include <string>

TEST(Equality, test_two_strings_equal) {
    std::string foo {"foo"};
    ASSERT_EQ("foo", foo);
}