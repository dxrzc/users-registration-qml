#include "user.h"

User::User(const QString& username, const QString& email,
           const QString& phoneNumber, const BirthDate& birthDate)
    :m_username(username), m_email(email), m_phoneNumber(phoneNumber),
    m_birthdate(birthDate) {}

User::User(const User& anotherUser) :m_username(anotherUser.m_username),
    m_birthdate(anotherUser.m_birthdate), m_email(anotherUser.m_email),
    m_phoneNumber(anotherUser.m_phoneNumber) {}

const QString& User::username() const noexcept
{
    return m_username;
}

const QString& User::email() const noexcept
{
    return m_email;
}

const QString& User::phoneNumber() const noexcept
{
    return m_phoneNumber;
}

const BirthDate& User::birthdate() const noexcept
{
    return m_birthdate;
}
