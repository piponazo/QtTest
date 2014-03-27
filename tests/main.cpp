#include <gtest/gtest.h>
#include <QtCore/QCoreApplication>
#include "QtTests.h"

int main(int argc, char **argv)
{
   ::testing::InitGoogleTest(&argc, argv);
   QCoreApplication app(argc, argv);

   return RUN_ALL_TESTS();

//   QtTests tests;
//   app.exec();
//   return tests.getTestsResult();
}
