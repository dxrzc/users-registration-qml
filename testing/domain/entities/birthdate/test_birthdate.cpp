#include <QObject>
#include <QTest>
#include "domain/entities/birthdate/birthdate.h"

class BirthdateTest: public QObject
{
    Q_OBJECT

private slots:
    void firstTesting()
    {
        QVERIFY(true);
    }
};

QTEST_MAIN(BirthdateTest)
#include "test_birthdate.moc"
