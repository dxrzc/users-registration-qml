.pragma library

function generateArray(base, top) {
    let ar = [];
    for (let i = base; i !== top; i++)
        ar.push(i);
    return ar;
}

function selectMonth(month) {
    let top = 0;
    switch (month) {
        case "February":
            top = 30;
            break;
        case "January":
        case "March":
        case "May":
        case "July":
        case "August":
        case "October":
        case "December":
            top = 32;
            break;
        default:
            top = 31;
            break;
    }
    return generateArray(1, top);
}
