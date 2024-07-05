#ifndef USER_H
#define USER_H

#include <QString>
#include <QMap>
#include "../birthdate/birthdate.h"

class User
{
private:
    QString m_username;
    QString m_email;
    QString m_phoneNumber;
    BirthDate m_birthdate;

public:
    User() = delete;
    User(const QString& username, const QString& email
         , const QString& phoneNumber, const BirthDate& birthdate);
    User(const User&);
    const QString& username() const noexcept;
    const QString& email() const noexcept;
    const QString& phoneNumber() const noexcept;
    QString& username();
    QString& email();
    QString& phoneNumber();
    const BirthDate& birthdate() const noexcept;
};

#endif // USER_H
