#include "MyClass.h"

MyClass::MyClass (QObject *parent) : QObject(parent), _timer(parent)
{
   connect(&_timer, SIGNAL(timeout()), this, SLOT(OnTimer()));
}

void MyClass::OnTimer()
{

}
