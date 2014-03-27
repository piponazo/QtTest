#include "QtTests3.h"
#include <QtCore/QCoreApplication>

void QtTests::SetUp()
{
   _app = QCoreApplication::instance(); // created in main.cpp
}

TEST_F (QtTests, onTimerCalled)
{
   QTimer::singleShot(3, _app, SLOT(quit()));
   _class.init(1);
   _app->exec();
   
   ASSERT_TRUE(_class.wasOnTimerCalled());
}
