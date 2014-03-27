#include "MyClass.h"
#include <gtest/gtest.h>
#include <QtCore/QThread>

class QCoreApplication;

class QtTests : public ::testing::Test
{
protected:
   virtual void SetUp();

   QCoreApplication * _app;
   MyClass    _class;
}; // -----  end of class QtTests  -----
