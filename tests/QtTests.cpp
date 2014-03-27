#include "QtTests.h"
#include <gtest/gtest.h>
#include <QtCore/QTimer>
#include <QtCore/QCoreApplication>
#include <QtCore/QDebug>

QtTests::QtTests (QObject *parent): QObject(parent)
{
   QTimer::singleShot(0, this, SLOT(runTests()));
}

void QtTests::runTests()
{
   qDebug() << "Before running tests";
    _testsResult = RUN_ALL_TESTS();
   qDebug() << "After running tests";
    QCoreApplication::instance()->quit();
   qDebug() << "After Quit";
}
