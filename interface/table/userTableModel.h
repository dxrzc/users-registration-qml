#ifndef USERTABLEMODEL_H
#define USERTABLEMODEL_H

#include <qqml.h>
#include <QAbstractTableModel>
#include <QList>
#include "../../domain/dtos/qmldto.h"

class UserTableModel : public QAbstractTableModel
{
    Q_OBJECT
    QML_ELEMENT
    QML_ADDED_IN_VERSION(1, 1)

private:
    qmlDto* dto;
    QList<User> usersList;
    QList<std::reference_wrapper<const User>> qmlList;
    bool filterON;

public:
    UserTableModel(): dto(nullptr), QAbstractTableModel(nullptr){}
    UserTableModel(qmlDto* , QObject* parent = nullptr);    
    Q_INVOKABLE int rowCount(const QModelIndex& parent) const override;
    Q_INVOKABLE int columnCount(const QModelIndex& parent) const override;
    Q_INVOKABLE QVariant data(const QModelIndex& index, int role) const override;    
    ~UserTableModel();

public slots:
    void loadData();
    void createUser(const User&);
    void enableFilter(const QString& filter);
    void disableFilter();
};

#endif // USERTABLEMODEL_H
