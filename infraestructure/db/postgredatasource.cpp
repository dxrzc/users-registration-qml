#include "postgredatasource.h"
#include <stdexcept>
#include <QSqlError>
#include <QSqlQuery>

PostgreDataSource::PostgreDataSource(ErrorHandler* errorHandler_, QObject* parent)
    : errorHandler(errorHandler_), QObject(parent)
{
    QObject::connect(errorHandler,&ErrorHandler::retryDBConnection,this,&PostgreDataSource::retryConnection);
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
    QSqlQuery query(QSqlDatabase::database(connectionName));
    const QString command = "CREATE TABLE %1 (username TEXT NOT NULL, birthdate DATE, email TEXT NOT NULL, phone TEXT NOT NULL)";
    const bool tableCreated = query.exec(command.arg(tableName));
    if (tableCreated)
        qDebug() << "Table created!!";
    else
        emit errorHandler->errorFromDataBase("Failed to create table");
}

void PostgreDataSource::tryToConnect()
{
    if (!QSqlDatabase::database(connectionName).open())
    {
        emit errorHandler->errorFromDataBase("Failed to connect to postgres");
        return;
    }

    if (!QSqlDatabase::database(connectionName).tables().contains(tableName))
        createTable();
}

bool PostgreDataSource::checkIfValueExists(const QString& userproperty, const QString& value) const
{
    if (userproperty != "email" && userproperty != "username" && userproperty != "phone")
    {
        QString message = "%1 is not a User property";
        emit errorHandler->internalError(message.arg(userproperty));
        return false;
    }

    QSqlQuery query(QSqlDatabase::database(connectionName));
    const QString command = "SELECT 1 FROM %1 WHERE %2 = '%3'";

    if (!query.exec(command.arg(tableName, userproperty, value)))
    {
        qDebug() << query.lastError().databaseText();
        emit errorHandler->errorFromDataBase("Failed to check user");
        return false;
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
    QSqlQuery query(QSqlDatabase::database(connectionName));
    const QString command = "INSERT INTO %1 (username,birthdate,email,phone) VALUES ('%2', '%3', '%4', '%5')";
    const bool userSaved = query.exec(command.arg(tableName, user.username(), user.birthdate().toQString(), user.email(), user.phoneNumber()));
    if (!userSaved)
        emit errorHandler->errorFromDataBase("Failed to save user");
}

// todo: is this function being used ¿?
User PostgreDataSource::getUserByName(const QString& name) const
{
    QSqlQuery query(QSqlDatabase::database(connectionName));
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
    if(dbIsOpen())
    {
        QSqlQuery query(QSqlDatabase::database(connectionName));
        const QString command = "SELECT * FROM %1";
        if (!query.exec(command.arg(tableName)))
        {
            emit errorHandler->errorFromDataBase("Error tryng to get users");
            return;
        }

        while (query.next())
            usersVector.push_back(fromQueryToUser(query));
    }
    else
        emit errorHandler->errorFromDataBase("Database is not open");
}

bool PostgreDataSource::dbIsOpen() const
{
    return QSqlDatabase::database(connectionName).isOpen();
}

void PostgreDataSource::connect(const ConnectionOptions & options)
{
    if (QSqlDatabase::contains(connectionName))
        QSqlDatabase::removeDatabase(connectionName);

    tableName = "myusers"; // MUST BE LOWERCASE
    QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL");
    db.setHostName(options.hostname);
    db.setPort(options.PORT);
    db.setUserName(options.user);
    db.setDatabaseName(options.database);
    db.setPassword(options.password);
    connectionName = db.connectionName();
    tryToConnect();
}

void PostgreDataSource::retryConnection()
{
    QSqlDatabase::database(connectionName).close();
    tryToConnect();
}
