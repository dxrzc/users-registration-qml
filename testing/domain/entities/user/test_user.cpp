#include <QTest>
#include "domain/entities/user/user.h"

class UserTesting : public QObject
{
    Q_OBJECT
private:
    const QString username = "test";
    const QString email = "test@gmail.com";
    const QString phoneNumber = "987654321";
    const unsigned birthdate_year = 2000;
    const unsigned birthdate_month = 12;
    const unsigned birthdate_day = 7;
    BirthDate birthdate{birthdate_year,birthdate_month,birthdate_day};
    User user{username,email,phoneNumber,birthdate};

    // compares a user with the properties defined in this class
    void compareAttributes(const User& subjectUser)
    {
        QCOMPARE(subjectUser.username(), username);
        QCOMPARE(subjectUser.email(), email);
        QCOMPARE(subjectUser.phoneNumber(), phoneNumber);
        // bd
        QCOMPARE(subjectUser.birthdate().day(), birthdate_day);
        QCOMPARE(subjectUser.birthdate().month(), birthdate_month);
        QCOMPARE(subjectUser.birthdate().year(), birthdate_year);
    }

private slots:
    void getters()
    {
        compareAttributes(user);
    }

    void copyConstructor()
    {
        const User newUser = user;
        compareAttributes(newUser);
    }

    void equalityOperator()
    {
        const User newUser(user.username(),user.email(),user.phoneNumber(),user.birthdate());
        QVERIFY(user == newUser);
    }
};

QTEST_MAIN(UserTesting)
#include "test_user.moc"
