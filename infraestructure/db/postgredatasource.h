#ifndef POSTGREDATASOURCE_H
#define POSTGREDATASOURCE_H

#include "../../domain/errors/errorhandler.h"
#include "../../domain/datasource/Datasource.h"

#include <QSqlQuery>
#include <QSqlDatabase>
#include <QObject>


class PostgreDataSource: public QObject,public DataSource
{
    Q_OBJECT
private:
    QString connectionName;
    QString tableName;
    ErrorHandler* errorHandler;
    User fromQueryToUser(const QSqlQuery& query) const;
    void createTable();
    void tryToConnect();
    bool checkIfValueExists(const QString& userproperty,const QString& value) const ;
    bool checkIfUsernameAlreadyExists(const QString& username) const override;
    bool checkIfEmailAlreadyExists(const QString& email) const override;
    bool checkIfPhoneNumberAlreadyExists(const QString& phoneNumber)const override;
    
public:
    PostgreDataSource(ErrorHandler*, QObject* parent = nullptr);
    ~PostgreDataSource();
    void saveUser(const User&) override;
    User getUserByName(const QString&) const override;
    void getAllUsers(QList<User>&) const override;
    bool dbIsOpen() const override;
    // tries a new url
    void connect(const ConnectionOptions &) override;
    void deleteUser(const QString &) override;

public slots:
    // tries the same url
    void retryConnection();    
};

#endif // POSTGREDATASOURCE_H
