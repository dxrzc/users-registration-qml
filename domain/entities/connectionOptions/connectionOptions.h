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
};


#endif // CONNECTIONOPTIONS_H

