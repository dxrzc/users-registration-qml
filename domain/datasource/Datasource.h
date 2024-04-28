#ifndef DATASOURCE_H
#define DATASOURCE_H

#include "entities/user/user.h"

class DataSource
{
public:
    virtual void saveUser(const User&) = 0;
    virtual User getUserByName(const QString&) const = 0;
    virtual void getAllUsers(QList<User>&) const = 0;
    virtual bool dbIsOpen() const = 0;
    virtual bool checkIfUsernameAlreadyExists(const QString&) const = 0;
    virtual bool checkIfEmailAlreadyExists(const QString&) const = 0;
    virtual bool checkIfPhoneNumberAlreadyExists(const QString&)const = 0;
    virtual ~DataSource() {};
};

#endif // DATASOURCE_H
