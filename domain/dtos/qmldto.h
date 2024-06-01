#ifndef QMLDTO_H
#define QMLDTO_H

#include <QObject>
#include "../datasource/Datasource.h"

class qmlDto : public QObject
{
    Q_OBJECT

private:
    DataSource* datasource;

public:
    explicit qmlDto(DataSource* dataspource,QObject *parent = nullptr);

    void getAllUsers(QList<User>&);
    Q_INVOKABLE bool userAlreadyExists(const QString&);
    Q_INVOKABLE bool emailAlreadyExists(const QString&);
    Q_INVOKABLE bool phoneNumberAlreadyExists(const QString&);
    Q_INVOKABLE void createUser(const QString& username, const QString& email, const QString& phoneNumber, const QString& birthdate);
    Q_INVOKABLE bool databaseIsOpen();
    Q_INVOKABLE void connectDB(const QString& hostname, quint64 port, const QString& user, const QString& password, const QString& database);
    ~qmlDto();

signals:
    void createUserSignal(const User&);
    void enableFilter(const QString&);
    void disableFilter();
    void reloadTableData();
    void databaseConnected();
};

#endif // QMLDTO_H
