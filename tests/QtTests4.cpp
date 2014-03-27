#include "QtTests4.h"
#include "MyClass.h"
#include <QtTest/QTest>

void MyClassTest::testSlotCalled()
{
   MyClass c(this);
   c.init(1);

   QTest::qWait(5);

   QVERIFY(c.wasOnTimerCalled() == true);
}

QTEST_MAIN(MyClassTest)
