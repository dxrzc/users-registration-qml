#include "postgredatasource.h"
#include <QSqlError>
#include <QSqlQuery>

PostgreDataSource::PostgreDataSource(ErrorHandler* m_errorHandler_, const QString& connectionName, const QString& tableName, QObject* parent):
    m_errorHandler(m_errorHandler_), QObject(parent)
{    
    m_connectionName = connectionName;
    m_tableName = tableName;    
    QObject::connect(m_errorHandler,&ErrorHandler::retryDBConnection,this,&PostgreDataSource::retryConnection);
}

PostgreDataSource::~PostgreDataSource()
{
    delete m_errorHandler;
}

User PostgreDataSource::fromQueryToUser(const QSqlQuery& query) const
{
    User user((query.value("username").toString()), (query.value("email").toString())
              , (query.value("phone").toString()), BirthDate::fromString((query.value("birthdate").toString())));
    return user;
}

void PostgreDataSource::createTable()
{
    QSqlQuery query(QSqlDatabase::database(m_connectionName,false));
    const QString command = "CREATE TABLE %1 (username TEXT NOT NULL, birthdate DATE, email TEXT NOT NULL, phone TEXT NOT NULL)";
    const bool tableCreated = query.exec(command.arg(m_tableName));
    if (!tableCreated)
        emit m_errorHandler->errorFromDataBase("Failed to create table");
}

void PostgreDataSource::tryToConnect()
{
    if (!QSqlDatabase::database(m_connectionName,false).open())
    {
        emit m_errorHandler->errorFromDataBase("Failed to connect to database");
        return;
    }

    if (!QSqlDatabase::database(m_connectionName,false).tables().contains(m_tableName))
        createTable();
}

bool PostgreDataSource::checkIfValueExists(const QString& userproperty, const QString& value) const
{
    if (userproperty != "email" && userproperty != "username" && userproperty != "phone")
    {
        QString message = "%1 is not a User property";
        emit m_errorHandler->internalError(message.arg(userproperty));
        return false;
    }

    QSqlQuery query(QSqlDatabase::database(m_connectionName,false));

    const QString command = "SELECT 1 FROM %1 WHERE %2=?";
    query.prepare(command.arg(m_tableName,userproperty));
    query.addBindValue(value);
    const bool sucessfullQuery = query.exec();

    if (!sucessfullQuery)
    {
        emit m_errorHandler->errorFromDataBase("Failed to check user");
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
    QSqlQuery query(QSqlDatabase::database(m_connectionName,false));

    const QString command = "INSERT INTO %1 (username,birthdate,email,phone) VALUES (?,?,?,?)";
    query.prepare(command.arg(m_tableName));
    query.addBindValue(user.username());
    query.addBindValue(user.birthdate().toQString());
    query.addBindValue(user.email());
    query.addBindValue(user.phoneNumber());

    const bool userSaved = query.exec();
    if (!userSaved)
        emit m_errorHandler->errorFromDataBase("Failed to save user");
}

void PostgreDataSource::updateUsername(const QString &username, const QString &newUsername)
{
    QSqlQuery query(QSqlDatabase::database(m_connectionName,false));

    const QString command = "UPDATE %1 SET username=? WHERE username=?";
    query.prepare(command.arg(m_tableName));
    query.addBindValue(newUsername);
    query.addBindValue(username);

    const bool userModified = query.exec();
    if(!userModified || query.numRowsAffected() == 0)
        emit m_errorHandler-> errorFromDataBase("Failed to update username");
}

void PostgreDataSource::updateEmail(const QString &email, const QString &newEmail)
{
    QSqlQuery query(QSqlDatabase::database(m_connectionName,false));

    const QString command = "UPDATE %1 SET email=? WHERE email=?";
    query.prepare(command.arg(m_tableName));
    query.addBindValue(newEmail);
    query.addBindValue(email);

    const bool userModified = query.exec();
    if(!userModified || query.numRowsAffected() == 0)
        emit m_errorHandler-> errorFromDataBase("Failed to update user email");
}

void PostgreDataSource::updatePhoneNumber(const QString &phonenumber, const QString &newPhoneNumber)
{
    QSqlQuery query(QSqlDatabase::database(m_connectionName,false));

    const QString command = "UPDATE %1 SET phone=? WHERE phone=?";
    query.prepare(command.arg(m_tableName));
    query.addBindValue(newPhoneNumber);
    query.addBindValue(phonenumber);

    const bool userModified = query.exec();
    if(!userModified || query.numRowsAffected() == 0)
        emit m_errorHandler-> errorFromDataBase("Failed to edit user phone");
}

const QString &PostgreDataSource::tableName() const noexcept
{
    return m_tableName;
}

const QString &PostgreDataSource::connectionName() const noexcept
{
    return m_connectionName;
}

void PostgreDataSource::getAllUsers(QList<User>& usersVector) const
{
    if(dbIsOpen())
    {
        QSqlQuery query(QSqlDatabase::database(m_connectionName,false));
        const QString command = "SELECT * FROM %1";
        if (!query.exec(command.arg(m_tableName)))
        {
            emit m_errorHandler->errorFromDataBase("Error tryng to get users");
            return;
        }

        while (query.next())
            usersVector.push_back(fromQueryToUser(query));
    }
    else
        emit m_errorHandler->errorFromDataBase("Database is not open");
}

bool PostgreDataSource::dbIsOpen() const
{
    return QSqlDatabase::database(m_connectionName,false).isOpen();
}

void PostgreDataSource::connect(const ConnectionOptions & options)
{
    if (QSqlDatabase::contains(m_connectionName))
        QSqlDatabase::removeDatabase(m_connectionName);

    QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL",m_connectionName);
    db.setHostName(options.hostname);
    db.setPort(options.PORT);
    db.setUserName(options.user);
    db.setDatabaseName(options.database);
    db.setPassword(options.password);
    tryToConnect();
}

void PostgreDataSource::deleteUser(const QString & username)
{
    QSqlQuery query(QSqlDatabase::database(m_connectionName,false));

    const QString command = "DELETE FROM %1 WHERE username=?";
    query.prepare(command.arg(m_tableName));
    query.addBindValue(username);

    const bool userDeleted = query.exec();
    if (!userDeleted || query.numRowsAffected() == 0)
        emit m_errorHandler->errorFromDataBase("Failed to delete user");
}

void PostgreDataSource::retryConnection()
{
    QSqlDatabase::database(m_connectionName,false).close();
    tryToConnect();
}
