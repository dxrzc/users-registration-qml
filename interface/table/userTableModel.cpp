#include "userTableModel.h"

UserTableModel::UserTableModel(qmlDto* dto_, QObject* parent): QAbstractTableModel(parent),dto(dto_)
{
    filterON = false;
    loadData();
    QObject::connect(dto,&qmlDto::createUserSignal,this,&UserTableModel::createUser);
    QObject::connect(dto,&qmlDto::enableFilter,this,&UserTableModel::enableFilter);
    QObject::connect(dto,&qmlDto::disableFilter,this,&UserTableModel::disableFilter);
    QObject::connect(dto,&qmlDto::reloadTableData,this,&UserTableModel::loadData);
}

void UserTableModel::loadData()
{
    dto->getAllUsers(usersList);
}

Q_INVOKABLE int UserTableModel::rowCount(const QModelIndex& parent) const
{    
    return (filterON) ? qmlList.count() : usersList.count();
}

Q_INVOKABLE int UserTableModel::columnCount(const QModelIndex& parent) const
{
    return 4;
}

Q_INVOKABLE QVariant UserTableModel::data(const QModelIndex& index, int role) const
{

    auto display = [&] <typename T>  (const T& list, const User& currentUser) -> QVariant
    {
        if (!index.isValid() || index.row() >= list.count() || index.row() < 0)
            return QVariant();

        switch (role)
        {
        case Qt::DisplayRole:
            switch (index.column())
            {
            case 0: return currentUser.username();
            case 1: return currentUser.email();
            case 2: return currentUser.phoneNumber();
            case 3: return currentUser.birthdate().toQString();
            }
        }

        return QVariant();
    };

    if(filterON)
        return display(qmlList,qmlList[index.row()].get());
    else
        return display(usersList,usersList[index.row()]);
}

void UserTableModel::createUser(const User& user)
{
    beginInsertRows(QModelIndex(), usersList.count(), usersList.count());
    usersList.append(user);
    endInsertRows();    
}

void UserTableModel::enableFilter(const QString &filter)
{
    qmlList.clear();
    filterON = true;

    for(const User& user: usersList)
        if(user.username().startsWith(filter) || user.email().startsWith(filter) || user.phoneNumber().startsWith(filter))
            qmlList.push_back(std::ref(user));
}

void UserTableModel::disableFilter()
{    
    filterON = false;
}

UserTableModel::~UserTableModel()
{
    delete dto;
}

