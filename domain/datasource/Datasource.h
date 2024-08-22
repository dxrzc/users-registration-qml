#ifndef DATASOURCE_H
#define DATASOURCE_H

#include "domain/entities/user/user.h"
#include "domain/entities/connectionOptions/connectionOptions.h"

class DataSource
{
public:
    virtual void updateUsername(const QString&, const QString&) = 0;
    virtual void updateEmail(const QString&, const QString&) = 0;
    virtual void updatePhoneNumber(const QString&, const QString&) = 0;
    virtual void saveUser(const User&) = 0;
    virtual void deleteUser(const QString&) = 0;
    virtual User getUserByName(const QString&) const = 0;
    virtual void getAllUsers(QList<User>&) const = 0;
    virtual bool dbIsOpen() const = 0;
    virtual bool checkIfUsernameAlreadyExists(const QString&) const = 0;
    virtual bool checkIfEmailAlreadyExists(const QString&) const = 0;
    virtual bool checkIfPhoneNumberAlreadyExists(const QString&)const = 0;
    virtual void connect(const ConnectionOptions&) = 0;
    virtual ~DataSource() {};
};

#endif // DATASOURCE_H
