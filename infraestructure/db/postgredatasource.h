#ifndef POSTGREDATASOURCE_H
#define POSTGREDATASOURCE_H

#include "../../domain/errors/errorhandler.h"
#include "../../domain/datasource/Datasource.h"
#include <QSqlQuery>
#include <QSqlDatabase>
#include <QObject>

struct ConnectionOptions
{
    QString hostname;
    QString user;
    QString password;
    QString database;
    quint64 PORT;
    ConnectionOptions() = delete;
    ConnectionOptions(const QString& hostname, const QString& user, const QString& password
                      , const QString& database, quint64 PORT) : hostname(hostname), user(user), password(password),
        database(database), PORT(PORT) {}
};

class PostgreDataSource: public DataSource
{
private:
    QSqlDatabase database;
    QString tableName;
    ErrorHandler* errorHandler;
    User fromQueryToUser(const QSqlQuery& query) const;
    void createTable();
    void userChecker(const User& user) const ;
    bool checkIfValueExists(const QString& userproperty,const QString& value) const ;
    bool checkIfUsernameAlreadyExists(const QString& username) const override;
    bool checkIfEmailAlreadyExists(const QString& email) const override;
    bool checkIfPhoneNumberAlreadyExists(const QString& phoneNumber)const override;
    
public:
    PostgreDataSource(const ConnectionOptions&, ErrorHandler*);
    ~PostgreDataSource();
    // Inherited via DataSource
    void saveUser(const User&) override;
    User getUserByName(const QString&) const override;

    // Inherited via DataSource
    void getAllUsers(QList<User>&) const override;

    // Inherited via DataSource
    bool dbIsOpen() const override;
};

#endif // POSTGREDATASOURCE_H
