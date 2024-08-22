#include <QObject>
#include <QTest>
#include "domain/entities/birthdate/birthdate.h"

class BirthdateTest: public QObject
{
    Q_OBJECT
private:
    const unsigned year = 2000;
    const unsigned month = 20;
    const unsigned day = 1;
    const BirthDate bd{year,month,day};

private slots:
    void getters()
    {
        QCOMPARE(bd.year(),year);
        QCOMPARE(bd.month(),month);
        QCOMPARE(bd.day(),day);
    }

    void toQString()
    {
        const QString stringFormat = bd.toQString();
        const QString expected = "2000-20-1";
        QCOMPARE(expected, stringFormat);
    }

    void fromString()
    {
        const QString stringFormat = "2010-12-10";
        BirthDate bd = BirthDate::fromString(stringFormat);
        QCOMPARE(bd.year(),2010);
        QCOMPARE(bd.month(),12);
        QCOMPARE(bd.day(),10);
    }

    void equalityOperator()
    {
        BirthDate newBd(bd.year(),bd.month(),bd.day());
        QVERIFY(bd == newBd);
    }
};

QTEST_MAIN(BirthdateTest)
#include "test_birthdate.moc"
