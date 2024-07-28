.pragma library

function validateEmail(email) {
    return (email.includes('@') && email.includes('.') && email.length > 5);
}

function validateNumber(number) {
    return (number.length === 9)
}

function validateUserName(username) {
    return (username.length > 3)
}

function validateData(text,isPhoneNumber, isUsername, isEmail) {
    switch (true) {
    case isPhoneNumber:
        return validateNumber(text);
    case isEmail:
        return validateEmail(text);
    case isUsername:
        return validateUserName(text);
    }
}
