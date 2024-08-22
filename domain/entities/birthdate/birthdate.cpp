#include "birthdate.h"
#include <QChar>
#include <QList>

BirthDate::BirthDate(unsigned year, unsigned month, unsigned day)
    : m_day(day), m_month(month), m_year(year) {}

QString BirthDate::toQString() const
{
    const QString asString = QString::number(m_year) + "-" + QString::number(m_month) + "-" + QString::number(m_day);
    return asString;
}

unsigned BirthDate::year() const noexcept { return m_year; }
unsigned BirthDate::month() const noexcept { return m_month; }
unsigned BirthDate::day() const noexcept { return m_day; }

BirthDate BirthDate::fromString(const QString &birthdateAsString)
{
    QList<unsigned> dateList{0, 0, 0};
    unsigned it = 0;
    QString aux;

    for (QChar ch : birthdateAsString)
    {
        if (ch != '-')
            aux.append(ch);
        else
        {
            dateList[it++] = aux.toInt();
            aux = "";
        }
    }
    dateList[it] = aux.toInt();
    return BirthDate(dateList[0], dateList[1], dateList[2]);
}

bool BirthDate::operator==(const BirthDate& b) const noexcept
{
    if(m_year == b.m_year && m_month == b.m_month && m_day == b.m_day)
        return true;
    return false;
}
