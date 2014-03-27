#include <QtCore/QObject>
#include <QtCore/QTimer>

class MyClass : public QObject
{
   Q_OBJECT
public:
   MyClass (QObject *parent = nullptr);
   ~MyClass ();

   bool wasOnTimerCalled() const
   {
      return _onTimerCalled;
   }

   void init(const quint32 msecs=1);

private slots:
   void OnTimer();

private:
   QTimer *_timer = nullptr;
   bool   _onTimerCalled = false;
}; // -----  end of class MyClass  -----

