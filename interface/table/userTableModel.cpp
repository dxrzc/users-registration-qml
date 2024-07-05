#include "userTableModel.h"

UserTableModel::UserTableModel(qmlDto* dto_, QObject* parent): QAbstractTableModel(parent),dto(dto_)
{
    filterON = false;
    QObject::connect(dto,&qmlDto::databaseConnected,this,&UserTableModel::loadData);
    QObject::connect(dto,&qmlDto::createUserSignal,this,&UserTableModel::createUser);
    QObject::connect(dto,&qmlDto::deleteUserSignal,this,&UserTableModel::deleteUser);
    QObject::connect(dto,&qmlDto::updateUsernameSignal, this,&UserTableModel::updateUsername);
    QObject::connect(dto,&qmlDto::updateUserEmailSignal, this,&UserTableModel::updateUserEmail);
    QObject::connect(dto,&qmlDto::updateUserPhoneSignal, this,&UserTableModel::updateUserPhone);
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
    return 5;
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

void UserTableModel::deleteUser(const QString& username)
{
    // IMPORTANT: Use remove on qmlList first, or you'll get an invalid reference.
    if(filterON)
        qmlList.removeIf([&](const std::reference_wrapper<const User>& userRef){
            return userRef.get().username() == username;
        });

    usersList.removeIf([&](const User& user){
        return user.username() == username;
    });
}

void UserTableModel::enableFilter(const QString &filter)
{
    qmlList.clear();
    filterON = true;

    for(const User& user: usersList)
        if(user.username().startsWith(filter) || user.email().startsWith(filter) || user.phoneNumber().startsWith(filter))
            qmlList.push_back(std::ref(user));
}

void UserTableModel::updateUsername(const QString & username, const QString & newUsername)
{
    for(User& user:usersList)
    {
        if(user.username()== username)
            user.username() = newUsername;
    }
}

void UserTableModel::updateUserEmail(const QString & email, const QString &newEmail)
{
    for(User& user:usersList)
    {
        if(user.email()== email)
            user.email() = newEmail;
    }
}

void UserTableModel::updateUserPhone(const QString & phonenumber, const QString &newPhone)
{
    for(User& user:usersList)
    {
        if(user.phoneNumber()== phonenumber)
            user.phoneNumber() = newPhone;
    }
}

void UserTableModel::disableFilter()
{    
    filterON = false;
}

UserTableModel::~UserTableModel()
{
    delete dto;
}

