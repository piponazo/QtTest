#include <QtTest/QTest>
#include "QtTests4.h"

int main(int argc, char **argv)
{
   MyClassTest test1;
   int ret = QTest::qExec(&test1, argc, argv);

   return ret;
}
