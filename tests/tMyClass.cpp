#include <gtest/gtest.h>
#include "MyClass.h"

TEST (MyClassTests, onTimerCalled)
{
   MyClass a;
   ASSERT_TRUE(a.wasOnTimerCalled());
}
