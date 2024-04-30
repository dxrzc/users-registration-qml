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

class PostgreDataSource: public QObject,public DataSource
{
    Q_OBJECT
private:
    QSqlDatabase database;
    QString tableName;
    ErrorHandler* errorHandler;
    User fromQueryToUser(const QSqlQuery& query) const;
    void createTable();
    void tryToConnect();
    void userChecker(const User& user) const ;
    bool checkIfValueExists(const QString& userproperty,const QString& value) const ;
    bool checkIfUsernameAlreadyExists(const QString& username) const override;
    bool checkIfEmailAlreadyExists(const QString& email) const override;
    bool checkIfPhoneNumberAlreadyExists(const QString& phoneNumber)const override;
    
public:
    PostgreDataSource(const ConnectionOptions&, ErrorHandler*, QObject* parent = nullptr);
    ~PostgreDataSource();
    void saveUser(const User&) override;
    User getUserByName(const QString&) const override;    
    void getAllUsers(QList<User>&) const override;    
    bool dbIsOpen() const override;

public slots:
    void retryConnection();
};

#endif // POSTGREDATASOURCE_H
