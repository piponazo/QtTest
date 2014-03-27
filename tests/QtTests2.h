#include "MyClass.h"
#include <gtest/gtest.h>
#include <QtCore/QThread>

class QtTests : public ::testing::Test
{
protected:
   virtual void SetUp();
   virtual void TearDown();
   virtual void runStuffInOtherThreads();

   QThread    _thread;
   MyClass    _class;
}; // -----  end of class QtTests  -----
