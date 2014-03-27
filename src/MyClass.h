#include <QtCore/QObject>
#include <QtCore/QTimer>

class MyClass : public QObject
{
   Q_OBJECT
public:
   MyClass (QObject *parent = nullptr);

   bool wasOnTimerCalled() const
   {
      return _onTimerCalled;
   }

private slots:
   void OnTimer();

private:
   QTimer _timer;
   bool   _onTimerCalled = false;
}; // -----  end of class MyClass  -----

