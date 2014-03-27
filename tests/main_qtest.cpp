#include <QtTest/QTest>
#include <QtCore/QCoreApplication>
#include "QtTests4.h"

int main(int argc, char **argv)
{
   QCoreApplication app(argc, argv);

   MyClassTest test1;
   int ret = QTest::qExec(&test1);

   return ret;
}
