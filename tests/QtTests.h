#include <QtCore/QObject>

class QtTests : public QObject
{
   Q_OBJECT
public:
   QtTests (QObject *parent=nullptr);
   int getTestsResult() const
   {
      return _testsResult;
   }

private slots:
   void runTests();

private:
   int _testsResult = 0;
}; // -----  end of class QtTests  -----

