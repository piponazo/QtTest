#include <QtCore/QObject>
#include <QtCore/QTimer>

class MyClass : public QObject
{
   Q_OBJECT
public:
   MyClass (QObject *parent = nullptr);

private slots:
   void OnTimer();

private:
   QTimer _timer;
}; // -----  end of class MyClass  -----

