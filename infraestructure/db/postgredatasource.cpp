#include "postgredatasource.h"
#include <stdexcept>
#include <QSqlError>
#include <QSqlQuery>

PostgreDataSource::PostgreDataSource(const ConnectionOptions& options, ErrorHandler* errorHandler_)
    : errorHandler(errorHandler_)
{
    tableName = "myusers"; // MUST BE LOWERCASE
    database = QSqlDatabase::addDatabase("QPSQL");
    database.setHostName(options.hostname);
    database.setPort(options.PORT);
    database.setUserName(options.user);
    database.setDatabaseName(options.database);
    database.setPassword(options.password);
    if (database.open())
        qDebug() << "Connected!!";
    else
        emit errorHandler->errorFromDataBase("Failed to connect to postgres");

    if (!database.tables().contains(tableName))
        createTable();
}

PostgreDataSource::~PostgreDataSource()
{
    delete errorHandler;
}

User PostgreDataSource::fromQueryToUser(const QSqlQuery& query) const
{
    User user((query.value("username").toString()), (query.value("email").toString())
              , (query.value("phone").toString()), BirthDate::fromString((query.value("birthdate").toString())));
    return user;
}

void PostgreDataSource::createTable()
{
    QSqlQuery query(database);
    const QString command = "CREATE TABLE %1 (username TEXT NOT NULL, birthdate DATE, email TEXT NOT NULL, phone TEXT NOT NULL)";
    const bool tableCreated = query.exec(command.arg(tableName));
    if (tableCreated)
        qDebug() << "Table created!!";
    else
        emit errorHandler->errorFromDataBase("Failed to create table");
}

void PostgreDataSource::userChecker(const User& user) const
{
    if (checkIfUsernameAlreadyExists(user.username()))
        emit errorHandler->userAlreadyExists();

    if (checkIfEmailAlreadyExists(user.email()))        
        emit errorHandler->emailAlreadyExists();

    if (checkIfPhoneNumberAlreadyExists(user.phoneNumber()))
        emit errorHandler->phoneNumberAlreadyExists();
}

bool PostgreDataSource::checkIfValueExists(const QString& userproperty, const QString& value) const
{
    if (userproperty != "email" && userproperty != "username" && userproperty != "phone")
    {
        QString message = "%1 is not a User property";
        throw std::runtime_error(message.arg(userproperty).toStdString());
    }

    QSqlQuery query(database);
    const QString command = "SELECT 1 FROM %1 WHERE %2 = '%3'";
    if (!query.exec(command.arg(tableName, userproperty, value)))
    {
        qDebug() << query.lastError().databaseText();
        throw std::runtime_error("Failed to check user");
    }

    return query.next();
}

bool PostgreDataSource::checkIfUsernameAlreadyExists(const QString& username) const
{
    return checkIfValueExists("username", username);
}

bool PostgreDataSource::checkIfEmailAlreadyExists(const QString& email) const
{
    return checkIfValueExists("email", email);
}

bool PostgreDataSource::checkIfPhoneNumberAlreadyExists(const QString& phoneNumber) const
{
    return checkIfValueExists("phone", phoneNumber);
}

void PostgreDataSource::saveUser(const User& user)
{
    try {

        userChecker(user);
        QSqlQuery query(database);
        const QString command = "INSERT INTO %1 (username,birthdate,email,phone) VALUES ('%2', '%3', '%4', '%5')";
        const bool userSaved = query.exec(command.arg(tableName, user.username(), user.birthdate().toQString(), user.email(), user.phoneNumber()));
        if (!userSaved)
        {
            const QString errorMessage = query.lastError().databaseText();
            throw std::runtime_error("Failed to save user: "+ errorMessage.toStdString());
        }

    } catch (const std::exception& e) {

        emit errorHandler->errorFromDataBase(e.what());
    }
}

User PostgreDataSource::getUserByName(const QString& name) const
{
    QSqlQuery query(database);
    const QString command = "SELECT * FROM %1 WHERE username = '%2'";

    if (!query.exec(command.arg(tableName, name)))
        throw std::runtime_error(query.lastError().databaseText().toStdString());

    if (query.next())
        return fromQueryToUser(query);
    else
        throw std::runtime_error("User not found");
}

void PostgreDataSource::getAllUsers(QList<User>& usersVector) const
{
    QSqlQuery query(database);
    const QString command = "SELECT * FROM %1";
    if (!query.exec(command.arg(tableName)))
        qDebug() << query.lastError().databaseText();

    while (query.next())
        usersVector.push_back(fromQueryToUser(query));
}

bool PostgreDataSource::dbIsOpen() const
{
    return database.isOpen();
}
