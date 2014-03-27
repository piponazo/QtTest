#include "MyClass.h"

MyClass::MyClass (QObject *parent) : QObject(parent)
{
}

MyClass::~MyClass ()
{
   delete _timer;
}

void MyClass::init(const quint32 msecs)
{
   _timer = new QTimer(parent());
   connect(_timer, SIGNAL(timeout()), this, SLOT(OnTimer()));
   _timer->start(msecs);
}

void MyClass::OnTimer()
{
   _onTimerCalled = true;
}
