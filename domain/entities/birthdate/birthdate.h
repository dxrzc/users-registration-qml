#ifndef BIRTHDATE_H
#define BIRTHDATE_H

#include <QString>
#include <QMap>

class BirthDate
{
private:
    unsigned m_year;
    unsigned m_month;
    unsigned m_day;
public:
    BirthDate() = delete;
    BirthDate(unsigned year, unsigned month, unsigned day);
    QString toQString() const;
    static BirthDate fromString(const QString&);
    unsigned year() const noexcept;
    unsigned month() const noexcept;
    unsigned day() const noexcept;
    bool operator==(const BirthDate&) const noexcept;
};

#endif // BIRTHDATE_H
