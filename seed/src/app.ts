import { PostgresDataBase } from "./database/postgresdatabase";
import { generateRandomUsers } from "./seed/users";

async function main() {

    try {
        const dbUrl = process.argv.at(2);
        const tableName = process.argv.at(3)
        const amount = process.argv.at(4);

        if (!dbUrl || !tableName || !amount)
            throw new Error('invalid arguments');

        if (!isNaN(tableName as any))
            throw new Error('table name can not be a number');

        if (!isNaN(dbUrl as any))
            throw new Error('url can not be a number');

        const postgresdb = new PostgresDataBase(dbUrl as string);
        await postgresdb.connect();
        const users = generateRandomUsers(+amount);
        await postgresdb.seed(tableName, users);
        await postgresdb.close();

    } catch (error: any) {        
        console.error(`error: ${error.message || error}`);
    }
    
}

main();