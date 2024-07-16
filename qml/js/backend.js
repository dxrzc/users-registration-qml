function retryDbConnection(){
    errorhandler.retryDBConnection();
}

function databaseIsOpen(){
    return QmlDto.databaseIsOpen();
}

function reloadTableData(){
    QmlDto.reloadTableData();
}

function userAlreadyExists(name){
    return QmlDto.userAlreadyExists(name);
}

function emailAlreadyExists(email){
    return QmlDto.emailAlreadyExists(email);
}

function phoneNumberAlreadyExists(number){
    return QmlDto.phoneNumberAlreadyExists(number);
}

function connectDb(hostname, port, user,password,db){
    QmlDto.connectDB(hostname,port,user,password,db);
}

function enableFilter(text){
    QmlDto.enableFilter(text);
}

function disableFilter(){
    QmlDto.disableFilter();
}

function createUser(user,email,phone,birthdate){
    QmlDto.createUser(user,email,phone,birthdate);
}

function deleteUser(username){
    QmlDto.deleteUser(username);
}

function updateUsername(username, newUsername){
    QmlDto.updateUsername(username,newUsername);
}

function updateUserEmail(email,newEmail){
    QmlDto.updateUserEmail(email,newEmail);
}

function updateUserPhone(phonenumber,newPhone){
    QmlDto.updateUserPhone(phonenumber,newPhone);
}
