#include <gtest/gtest.h>
#include <string>

#include "foo.h"

TEST(Foo, test_get_foo_returns_a_proper_string)
{
    std::string foo {getFoo()};
    ASSERT_EQ("Foo!", foo);
}