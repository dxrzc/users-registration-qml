.pragma library

// just inserts text on the focusing component
function insertTextOnComponent (text, testCase){

    for(let i= 0;i< text.length; i++){
        let key = text[i]
        testCase.keyClick(key);
    }
}
