const urlRegularExpresion = /^(postgresql|postgres):\/\/(.*):(.*)@([^\/:]+):([0-9]+)\/(.*)$/;

function validateUrl(url){

    return urlRegularExpresion.test(url);
}

function getOptions(url){

    const userAndPassword  = url.slice(url.indexOf('//')+2,url.indexOf('@'));

    const user = userAndPassword.split(':')[0];
    const password = userAndPassword.split(':')[1];

    const hostnameAndPort = url.slice(url.indexOf('@')+1,url.lastIndexOf('/'));

    const hostname = hostnameAndPort.split(':')[0];
    const port = hostnameAndPort.split(':')[1];

    const databaseName = url.slice(url.lastIndexOf('/') +1);

    return [hostname,port,user,password,databaseName];
}
