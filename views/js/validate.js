.pragma library

function validateEmail(dto,email) {

    let status = false;

    if (email.includes('@') && email.includes('.') && email.length > 5)
        status = true;

    if(status)
        status = !(dto.emailAlreadyExists(email));

    return status;
}

function validateNumber(dto,number) {

    let status = false;

    if (number.length === 9)
        status = true

    if(status)
        status = !(dto.phoneNumberAlreadyExists(number));

    return status;
}

function validateUserName(dto,username) {

    let status = false;

    if(username.length > 3)
        status = true;

    if(status)
        status = !(dto.userAlreadyExists(username));

    return status;
}

function validateData(text,isPhoneNumber, isUsername, isEmail,dto) {

    switch (true) {

    case isPhoneNumber:
        return validateNumber(dto,text);
    case isEmail:
        return validateEmail(dto,text);
    case isUsername:
        return validateUserName(dto,text);
    default:
        throw new Error('INPUT DATA NOT DEFINED');
    }
}
