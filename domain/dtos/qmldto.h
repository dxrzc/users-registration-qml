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
    Q_INVOKABLE void enableFilter(const QString&);
    Q_INVOKABLE void disableFilter();
    ~qmlDto();

signals:
    void userCreated(const User&);
    void filterEnabled(const QString&);
    void filterDisabled();
    void reloadTableData();
};

#endif // QMLDTO_H
