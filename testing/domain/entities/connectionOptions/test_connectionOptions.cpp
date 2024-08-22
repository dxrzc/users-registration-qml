#include <QtTest>
#include "domain/entities/connectionOptions/connectionOptions.h"

class ConnectionOptionsTest: public QObject
{
    Q_OBJECT
private:
    const QString user = "user";
    const QString password = "pswrd";
    const quint64 PORT = 3000;
    const QString database = "mydb";
    const QString host = "localhost";
    const ConnectionOptions connectionOptions{host,user,password,database,PORT};

private slots:
    void equalityOperator()
    {
        ConnectionOptions opts {host,user,password,database,PORT};
        QVERIFY(opts == connectionOptions);
        opts.PORT = 1;
        QVERIFY(opts != connectionOptions);
    }
};

QTEST_MAIN(ConnectionOptionsTest);
#include "test_connectionOptions.moc"
