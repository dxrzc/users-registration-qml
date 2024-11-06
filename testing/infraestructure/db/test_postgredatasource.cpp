#include <QTest>
#include <QSignalSpy>
#include "infraestructure/db/postgredatasource.h"
#include "global/test/testdatabase-options.h"
#include "helper_invalidConnection.h"

class PostgreDataSourceTest: public QObject
{
    Q_OBJECT

private:
    ErrorHandler* errorHandler = new ErrorHandler();
    const QString connectionName = "cpp-testing-connection";
    const QString tableName = "testusers";
    PostgreDataSource datasource {errorHandler,connectionName,tableName};

    // HELPERS

    QtMessageHandler defaultMsgHandler; // used to ignore a warning
    User testuser{"username","myemail","myphoneNumber",BirthDate(2000,12,12)};    

    void cleanupDatabase()
    {
        QSqlQuery query(QSqlDatabase::database(connectionName));
        const QString command =  "DELETE FROM %1";
        query.exec(command.arg(datasource.tableName()));
    }

    void connectToDatabase()
    {
        datasource.connect(TestingConfig::databaseOptions);
        if(!datasource.dbIsOpen())        
            qFatal()<< "Could not connect to database. Testing aborted";
    }

private slots:
    void initTestCase()
    {
        defaultMsgHandler = qInstallMessageHandler([](QtMsgType type, const QMessageLogContext &context, const QString &msg){
            // ignore this specific warning
            if (msg.contains("QSqlQuery::exec: database not open") || msg.contains("QSqlQuery::prepare: database not open"))
                return;
            // other messages keep as usual
            qt_message_output(type, context, msg);
        });
        connectToDatabase();
    }

    void init()
    {
        cleanupDatabase();
    }

    void tableNameGetter()
    {
        QCOMPARE(datasource.tableName(),tableName);
    }

    void connectionNameGetter()
    {
        QCOMPARE(datasource.connectionName(),connectionName);
    }

    // if "initTestCase()" worked good, db should be open
    void dbIsOpen_MustReturn_true_if_DbOpen()
    {
        QVERIFY(datasource.dbIsOpen());
    }

    void connect_MustEmit_errorFromDatabase_ifFailedToConnect()
    {
        QSignalSpy spy(InvalidConnection::instance().errorHandler(),&ErrorHandler::errorFromDataBase);
        InvalidConnection::instance().datasource().connect(InvalidConnection::invalidConnectionOptions);
        QCOMPARE(spy.count(),1);
        QCOMPARE(spy.takeLast().at(0),"Failed to connect to database");
    }

    void saveUser_MustSave_UserSuccefully()
    {
        datasource.saveUser(testuser);

        QSqlQuery query (QSqlDatabase::database(connectionName));
        const QString command = "SELECT * FROM %1";
        query.exec(command.arg(datasource.tableName()));

        if(query.next())
        {
            QCOMPARE(query.value("username").toString(),testuser.username());
            QCOMPARE(query.value("email").toString(),testuser.email());
            QCOMPARE(query.value("phone").toString(),testuser.phoneNumber());
            QCOMPARE(BirthDate::fromString(query.value("birthdate").toString()),testuser.birthdate());
        }
        else        
            QVERIFY(false);
    }

    void saveUser_MustEmit_errorFromDatabase_ifFailedToSavedUser()
    {
        QSignalSpy spy(InvalidConnection::instance().errorHandler(),&ErrorHandler::errorFromDataBase);
        InvalidConnection::instance().datasource().saveUser(testuser);
        QCOMPARE(spy.count(),1);
        QCOMPARE(spy.takeLast().at(0),"Failed to save user");
    }

    void deleteUser_MustDelete_UserSuccefully()
    {
        datasource.saveUser(testuser);

        datasource.deleteUser(testuser.username());

        QSqlQuery query (QSqlDatabase::database(connectionName));
        const QString command = "SELECT * FROM %1";
        query.exec(command.arg(datasource.tableName()));

        if(query.next())
            QVERIFY(false);
        else
            QVERIFY(true);
    }

    void deleteUser_MustEmit_errorFromDatabase_ifFailedToDeleteUser()
    {
        QSignalSpy spy(InvalidConnection::instance().errorHandler(),&ErrorHandler::errorFromDataBase);
        // Attempt to update with a not opened db will cause a error signal emission
        InvalidConnection::instance().datasource().deleteUser("user-name");
        QCOMPARE(spy.count(),1);
        QCOMPARE(spy.takeLast().at(0),"Failed to delete user");
    }

    void updateUsername_MustUpdate_UserSuccefully()
    {
        datasource.saveUser(testuser);

        const QString newUsername = "new-test-username";
        datasource.updateUsername(testuser.username(),newUsername);

        QSqlQuery query (QSqlDatabase::database(connectionName));
        const QString command = "SELECT * FROM %1";
        query.exec(command.arg(datasource.tableName()));

        if(query.next())
        {
            QCOMPARE(query.value("username").toString(),newUsername);
            // the rest of the data must be intact
            QCOMPARE(query.value("email").toString(),testuser.email());
            QCOMPARE(query.value("phone").toString(),testuser.phoneNumber());
            QCOMPARE(BirthDate::fromString(query.value("birthdate").toString()),testuser.birthdate());
        }
        else
            QVERIFY(false);
    }

    void updateUsername_MustEmit_errorFromDatabase_ifFailedToUpdateUsername()
    {
        QSignalSpy spy(InvalidConnection::instance().errorHandler(),&ErrorHandler::errorFromDataBase);
        // Attempt to update with a not opened db will cause a error signal emission
        InvalidConnection::instance().datasource().updateUsername("old-username","new-username");
        QCOMPARE(spy.count(),1);
        QCOMPARE(spy.takeLast().at(0),"Failed to update username");
    }

    void updateEmail_MustUpdate_EmailSuccefully()
    {
        datasource.saveUser(testuser);

        const QString newEmail = "mytestemail@gmail.com";
        datasource.updateEmail(testuser.email(),newEmail);

        QSqlQuery query (QSqlDatabase::database(connectionName));
        const QString command = "SELECT * FROM %1";
        query.exec(command.arg(datasource.tableName()));

        if(query.next())
        {
            QCOMPARE(query.value("email").toString(),newEmail);
            // the rest of the data must be intact
            QCOMPARE(query.value("username").toString(),testuser.username());
            QCOMPARE(query.value("phone").toString(),testuser.phoneNumber());
            QCOMPARE(BirthDate::fromString(query.value("birthdate").toString()),testuser.birthdate());
        }
        else
            QVERIFY(false);
    }

    void updateEmail_MustEmit_errorFromDatabase_ifFailedToUpdateEmail()
    {
        QSignalSpy spy(InvalidConnection::instance().errorHandler(), &ErrorHandler::errorFromDataBase);
        // Attempt to update with a not opened db will cause a error signal emission
        InvalidConnection::instance().datasource().updateEmail("old-email@example.com", "new-email@example.com");
        QCOMPARE(spy.count(), 1);
        QCOMPARE(spy.takeLast().at(0).toString(), "Failed to update user email");
    }


    void updatePhoneNumber_MustUpdate_PhoneSuccefully()
    {
        datasource.saveUser(testuser);

        const QString newPhone = "102382329";
        datasource.updatePhoneNumber(testuser.phoneNumber(),newPhone);

        QSqlQuery query (QSqlDatabase::database(connectionName));
        const QString command = "SELECT * FROM %1";
        query.exec(command.arg(datasource.tableName()));

        if(query.next())
        {
            QCOMPARE(query.value("phone").toString(), newPhone);
            // the rest of the data must be intact
            QCOMPARE(query.value("username").toString(),testuser.username());
            QCOMPARE(query.value("email").toString(),testuser.email());
            QCOMPARE(BirthDate::fromString(query.value("birthdate").toString()),testuser.birthdate());
        }
        else
            QVERIFY(false);
    }

    void updatePhoneNumber_MustEmit_errorFromDatabase_ifFailedToUpdatePhoneNumber()
    {
        QSignalSpy spy(InvalidConnection::instance().errorHandler(), &ErrorHandler::errorFromDataBase);
        // Attempt to update with a not opened db will cause a error signal emission
        InvalidConnection::instance().datasource().updatePhoneNumber("old-phone-number", "new-phone-number");
        QCOMPARE(spy.count(), 1);
        QCOMPARE(spy.takeLast().at(0), "Failed to edit user phone");
    }

    void getAllUsers_MustReturn_AllUsersSuccefully()
    {
        // users to insert
        User user1{"username1","myemail@1","phon1",BirthDate(2000,12,9)};
        User user2{"username2","myemail@2","phon2",BirthDate(1996,11,11)};
        User user3{"username3","myemail@3","phon3",BirthDate(2000,2,1)};

        datasource.saveUser(user1);
        datasource.saveUser(user2);
        datasource.saveUser(user3);

        const QList<User> testUsersList {user1,user2,user3};

        QList<User> usersInDbList;
        datasource.getAllUsers(usersInDbList);

        // using User equality operator
        QCOMPARE(testUsersList,usersInDbList);
    }

    void connect_MustEmit_errorFromDatabase_ifFailedToCreateTable()
    {
        const QString invalidTableName = "IN-VALID-TABLE-NAME-##";
        auto* test_errorHandler = new ErrorHandler();
        PostgreDataSource test_datasource (test_errorHandler,"new-test-connection",invalidTableName);

        QSignalSpy spy(test_errorHandler,&ErrorHandler::errorFromDataBase);

        test_datasource.connect(TestingConfig::databaseOptions);

        QCOMPARE(spy.count(),1);
        QCOMPARE(spy.takeLast().at(0),"Failed to create table");
    }

    void checkIfUsernameAlreadyExists_MustWorkSuccesfully()
    {
        QVERIFY(!datasource.checkIfUsernameAlreadyExists(testuser.username()));
        datasource.saveUser(testuser);
        QVERIFY(datasource.checkIfUsernameAlreadyExists(testuser.username()));
    }

    void checkIfEmailAlreadyExists_MustWorkSuccesfully()
    {
        QVERIFY(!datasource.checkIfEmailAlreadyExists(testuser.email()));
        datasource.saveUser(testuser);
        QVERIFY(datasource.checkIfEmailAlreadyExists(testuser.email()));
    }

    void checkIfPhoneNumberAlreadyExists_MustWorkSuccesfully()
    {
        QVERIFY(!datasource.checkIfPhoneNumberAlreadyExists(testuser.phoneNumber()));
        datasource.saveUser(testuser);
        QVERIFY(datasource.checkIfPhoneNumberAlreadyExists(testuser.phoneNumber()));
    }

    // this is a private function
    void checkIfValueExists_MustEmit_errorFromDatabase_ifFailedToFindUser()
    {
        QSignalSpy spy(InvalidConnection::instance().errorHandler(), &ErrorHandler::errorFromDataBase);
        InvalidConnection::instance().datasource().checkIfUsernameAlreadyExists("name");
        QCOMPARE(spy.count(), 1);
        QCOMPARE(spy.takeLast().at(0), "Failed to check user");
    }

    void cleanupTestCase()
    {
        cleanupDatabase();
        qInstallMessageHandler(defaultMsgHandler);
    }

};

QTEST_MAIN(PostgreDataSourceTest)
#include "test_postgredatasource.moc"
