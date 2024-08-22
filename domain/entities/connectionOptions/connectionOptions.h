#ifndef CONNECTIONOPTIONS_H
#define CONNECTIONOPTIONS_H

#include <QString>

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

    bool operator== (const ConnectionOptions& co) const noexcept
    {
        return (hostname == co.hostname && user == co.user && password == co.password && database == co.database && PORT == co.PORT);
    }
};


#endif // CONNECTIONOPTIONS_H

