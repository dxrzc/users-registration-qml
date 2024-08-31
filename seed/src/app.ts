import { PostgresDataBase } from "./database/postgresdatabase";
import { generateRandomUsers } from "./seed/users";

async function main(){    

    try {
        
        const dbUrl = process.argv.at(2);
        const amount = process.argv[3];

        if (!dbUrl)
            throw new Error('url not provided');

        if (!amount)
            throw new Error('invalid arguments');


        if (!isNaN(dbUrl as any))
            throw new Error('url can not be a number');

        const postgresdb = new PostgresDataBase(dbUrl as string);
        await postgresdb.connect();
        const users = generateRandomUsers(+amount);
        await postgresdb.seed(users);
        await postgresdb.close();

    } catch (error: any) {

        console.error(`error: ${error.message || error}`);
    }
    
}

main();