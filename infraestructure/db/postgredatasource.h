#ifndef POSTGREDATASOURCE_H
#define POSTGREDATASOURCE_H

#include <QSqlQuery>
#include <QSqlDatabase>
#include <QObject>
#include "domain/errors/errorhandler.h"
#include "domain/datasource/Datasource.h"

class PostgreDataSource: public QObject, public DataSource
{
    Q_OBJECT
private:
    QString m_connectionName;
    QString m_tableName;
    ErrorHandler* m_errorHandler;
    User fromQueryToUser(const QSqlQuery&) const;
    void createTable();
    void tryToConnect();
    bool checkIfValueExists(const QString& userproperty,const QString& value) const ;

public:
    PostgreDataSource(ErrorHandler*, const QString& connectionName, const QString& tableName, QObject* parent = nullptr);
    ~PostgreDataSource();    
    bool checkIfUsernameAlreadyExists(const QString& username) const override;
    bool checkIfEmailAlreadyExists(const QString& email) const override;
    bool checkIfPhoneNumberAlreadyExists(const QString& phoneNumber)const override;
    void saveUser(const User& user) override;
    void connect(const ConnectionOptions& options) override;
    void deleteUser(const QString& username) override;
    void updateUsername(const QString& username, const QString& newUsername) override;
    void updateEmail(const QString& email, const QString& newEmail) override;
    void updatePhoneNumber(const QString& phonenumber, const QString& newPhoneNumber) override;
    void getAllUsers(QList<User>& usersList) const override;
    bool dbIsOpen() const override;
    const QString& tableName() const noexcept;
    const QString& connectionName() const noexcept;

public slots:
    void retryConnection();
};

#endif // POSTGREDATASOURCE_H
