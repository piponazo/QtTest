#include "QtTests2.h"

void QtTests::SetUp()
{
   runStuffInOtherThreads();
   _class.init();
}

void QtTests::runStuffInOtherThreads()
{
   _class.moveToThread(&_thread);
   _thread.start();
}

void QtTests::TearDown()
{
   _thread.quit();
   _thread.wait();
}

TEST_F (QtTests, onTimerCalled)
{
   _thread.wait(5);
   ASSERT_TRUE(_class.wasOnTimerCalled());
}
