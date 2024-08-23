#include <QObject>
#include <QTest>
#include <QSignalSpy>
#include <gtest/gtest.h>
#include <gmock/gmock.h>
#include "domain/dtos/qmldto.h"
#include "global/test/testdatabase-options.h"

class MockDataSource: public DataSource
{
public:
    static unsigned instances;

    MockDataSource(){++instances;}
    ~MockDataSource(){--instances;}

    MOCK_METHOD(void, updateUsername,(const QString &, const QString &), (override));
    MOCK_METHOD(void,updateEmail,(const QString &, const QString &),(override));
    MOCK_METHOD(void, updatePhoneNumber,(const QString &, const QString &),(override));
    MOCK_METHOD(void ,saveUser,(const User &),(override));
    MOCK_METHOD(void, deleteUser, (const QString &),(override));
    MOCK_METHOD(void,getAllUsers,(QList<User> &),(const override));
    MOCK_METHOD(bool,dbIsOpen, (),(const override));
    MOCK_METHOD(bool,checkIfUsernameAlreadyExists,(const QString &),(const override));
    MOCK_METHOD(bool,checkIfEmailAlreadyExists,(const QString &),(const override));
    MOCK_METHOD(bool,checkIfPhoneNumberAlreadyExists, (const QString &), (const override));
    MOCK_METHOD(void,connect,(const ConnectionOptions &), (override));
};

unsigned MockDataSource::instances = 0;

class QmlDtoTest: public QObject
{
    Q_OBJECT

private:
    MockDataSource* mockDataSource = new MockDataSource();
    qmlDto dto{mockDataSource};

    // helpers
    const QString testString1 = "testString1";
    const QString testString2 = "testString2";
    const User user{"user123","user@gmail.com","911", BirthDate(10,10,10)};
    const ConnectionOptions& connectionOptions = TestingConfig::databaseOptions;

private slots:
    // datasource functions must be called with

    void datasource_updateUsername_MustBeCalledWhen_updateUsername_WithTheSameArguments()
    {
        EXPECT_CALL(*mockDataSource,updateUsername(testString1,testString2)).Times(1);
        dto.updateUsername(testString1,testString2);
        QVERIFY(::testing::Mock::VerifyAndClearExpectations(mockDataSource));
    }

    void datasource_updateEmail_MustBeCalledWhen_updateUserEmail_WithTheSameArguments()
    {
        EXPECT_CALL(*mockDataSource,updateEmail(testString1,testString2)).Times(1);
        dto.updateUserEmail(testString1,testString2);
        QVERIFY(::testing::Mock::VerifyAndClearExpectations(mockDataSource));
    }

    void datasource_updatePhoneNumber_MustBeCalledWhen_updateUserPhone_WithTheSameArguments()
    {
        EXPECT_CALL(*mockDataSource,updatePhoneNumber(testString1,testString2)).Times(1);
        dto.updateUserPhone(testString1,testString2);
        QVERIFY(::testing::Mock::VerifyAndClearExpectations(mockDataSource));
    }

    void datasource_saveUser_MustBeCalledWhen_createUser_WithTheSameUserInfo()
    {
        EXPECT_CALL(*mockDataSource,saveUser(user)).Times(1);
        dto.createUser(user.username(),user.email(),user.phoneNumber(),user.birthdate().toQString());
        QVERIFY(::testing::Mock::VerifyAndClearExpectations(mockDataSource));
    }

    void datasource_deleteUser_MustBeCalledWhen_deleteUser_WithTheSameArguments()
    {
        EXPECT_CALL(*mockDataSource,deleteUser(testString1)).Times(1);
        dto.deleteUser(testString1);
        QVERIFY(::testing::Mock::VerifyAndClearExpectations(mockDataSource));
    }

    void datasource_getAllUsers_MustBeCalledWhen_getAllUsers_WithTheSameArguments()
    {
        QList<User> users {user};
        EXPECT_CALL(*mockDataSource,getAllUsers(users)).Times(1);
        dto.getAllUsers(users);
        QVERIFY(::testing::Mock::VerifyAndClearExpectations(mockDataSource));
    }

    void datasource_dbIsOpen_MustBeCalledWhen_databaseIsOpen_AndBeUsedAsAReturnValue()
    {
        const bool returnValue =  true;
        ON_CALL(*mockDataSource, dbIsOpen()).WillByDefault(::testing::Return(returnValue));
        EXPECT_CALL(*mockDataSource, dbIsOpen()).Times(1);

        const bool result = dto.databaseIsOpen();

        QCOMPARE(result,returnValue);
        QVERIFY(::testing::Mock::VerifyAndClearExpectations(mockDataSource));
    }

    void datasource_checkIfUsernameAlreadyExists_MustBeCalledWhen_userAlreadyExists_WithTheSameArguments()
    {
        const bool returnValue = false;
        ON_CALL(*mockDataSource,checkIfUsernameAlreadyExists(testString1)).WillByDefault(::testing::Return(returnValue));
        EXPECT_CALL(*mockDataSource, checkIfUsernameAlreadyExists(testString1)).Times(1);

        const bool result = dto.userAlreadyExists(testString1);

        QCOMPARE(result,returnValue);
        QVERIFY(::testing::Mock::VerifyAndClearExpectations(mockDataSource));
    }

    void datasource_checkIfEmailAlreadyExists_MustBeCalledWhen_emailAlreadyExists_WithTheSameArguments()
    {
        const bool returnValue = true;
        ON_CALL(*mockDataSource,checkIfEmailAlreadyExists(testString1)).WillByDefault(::testing::Return(returnValue));
        EXPECT_CALL(*mockDataSource, checkIfEmailAlreadyExists(testString1)).Times(1);

        const bool result = dto.emailAlreadyExists(testString1);

        QCOMPARE(result,returnValue);
        QVERIFY(::testing::Mock::VerifyAndClearExpectations(mockDataSource));
    }

    void datasource_checkIfPhoneNumberAlreadyExists_MustBeCalledWhen_phoneNumberAlreadyExists_WithTheSameArguments()
    {
        const bool returnValue = false;
        ON_CALL(*mockDataSource,checkIfPhoneNumberAlreadyExists(testString1)).WillByDefault(::testing::Return(returnValue));
        EXPECT_CALL(*mockDataSource, checkIfPhoneNumberAlreadyExists(testString1)).Times(1);

        const bool result = dto.phoneNumberAlreadyExists(testString1);

        QCOMPARE(result,returnValue);
        QVERIFY(::testing::Mock::VerifyAndClearExpectations(mockDataSource));
    }

    void datasource_connect_MustBeCalledWhen_connectDb_WithTheSameConnectionOptions()
    {
        EXPECT_CALL(*mockDataSource, connect(connectionOptions)).Times(1);
        dto.connectDB(connectionOptions.hostname,connectionOptions.PORT,connectionOptions.user,connectionOptions.password,connectionOptions.database);
        QVERIFY(::testing::Mock::VerifyAndClearExpectations(mockDataSource));
    }

    void datasource_dbIsOpen_MustBeCalledWhen_connectDb()
    {
        EXPECT_CALL(*mockDataSource, dbIsOpen()).Times(1);
        dto.databaseIsOpen();
        QVERIFY(::testing::Mock::VerifyAndClearExpectations(mockDataSource));
    }

    // signals must be emitted

    void emit_updateUsernameSignal_If_UsernameUpdatedSuccesfully()
    {
        QSignalSpy spy(&dto,&qmlDto::updateUsernameSignal);
        dto.updateUsername("","");
        QCOMPARE(spy.count(),1);
    }

    void emit_updateUserEmailSignal_If_EmailUpdatedSuccesfully()
    {
        QSignalSpy spy(&dto,&qmlDto::updateUserEmailSignal);
        dto.updateUserEmail("","");
        QCOMPARE(spy.count(),1);
    }

    void emit_updateUserPhone_If_UserPhoneUpdatedSuccesfully()
    {
        QSignalSpy spy(&dto,&qmlDto::updateUserPhoneSignal);
        dto.updateUserPhone("","");
        QCOMPARE(spy.count(),1);
    }

    void emit_createUserSignal_If_UserCreatedSuccesfully()
    {
        QSignalSpy spy(&dto,&qmlDto::createUserSignal);
        dto.createUser(user.username(),user.email(),user.phoneNumber(),user.birthdate().toQString());
        QCOMPARE(spy.count(),1);
    }

    void emit_deleteUserSignal_if_UserDeletedSuccesfully()
    {
        QSignalSpy spy(&dto,&qmlDto::deleteUserSignal);
        dto.deleteUser("");
        QCOMPARE(spy.count(),1);
    }

    void emit_databaseConnected_if_DatabaseConnectedSuccesfully()
    {
        ON_CALL(*mockDataSource,dbIsOpen()).WillByDefault(::testing::Return(true));
        QSignalSpy spy(&dto,&qmlDto::databaseConnected);
        dto.connectDB("",quint64(),"","","");
        QCOMPARE(spy.count(),1);
    }

    // destructor

    void destroyDatasourceWhenDtoDestroyed()
    {
        const unsigned currentInstances = MockDataSource::instances;
        MockDataSource* testDatasource = new MockDataSource();
        qmlDto* qmldto = new qmlDto(testDatasource);
        delete qmldto;
        QCOMPARE(currentInstances,MockDataSource::instances);
    }
};

QTEST_MAIN(QmlDtoTest)
#include "test_qmldto.moc"
