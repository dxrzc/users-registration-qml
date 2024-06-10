#include "qmldto.h"

qmlDto::qmlDto(DataSource* ds,QObject *parent)
    : QObject{parent}
{
    datasource = ds;
}

void qmlDto::getAllUsers(QList<User> & list)
{
    datasource->getAllUsers(list);
}

bool qmlDto::userAlreadyExists(const QString & username)
{
    return datasource->checkIfUsernameAlreadyExists(username);
}

bool qmlDto::emailAlreadyExists(const QString & email)
{
    return datasource->checkIfEmailAlreadyExists(email);
}

bool qmlDto::phoneNumberAlreadyExists(const QString & phonenumber)
{
    return datasource->checkIfPhoneNumberAlreadyExists(phonenumber);
}

void qmlDto::createUser(const QString &username, const QString &email, const QString &phoneNumber, const QString &birthdate)
{
    User user(username, email, phoneNumber, BirthDate::fromString(birthdate));
    datasource->saveUser(user);

    emit createUserSignal(user);
}

bool qmlDto::databaseIsOpen()
{
    return datasource->dbIsOpen();
}

void qmlDto::connectDB(const QString &hostname, quint64 port, const QString &user, const QString &password, const QString &database)
{
    ConnectionOptions options (hostname, user,password,database,port);
    datasource->connect(options);
    if(datasource->dbIsOpen())
        emit databaseConnected();
}

qmlDto::~qmlDto()
{
    delete datasource;
}
