import { Client } from "pg";
import { User } from "../seed/users";

export class PostgresDataBase {

    private readonly client: Client;

    constructor(connectionString: string) {
        this.client = new Client({ connectionString, })
    }

    async connect() {
        try {            
            await this.client.connect();
        } catch (error) {
            throw new Error('failed to connect to db');
        }
    }

    async seed(tableName: string ,users: User[]) {        

        await this.client.query({
            text: `DELETE FROM ${tableName}`
        });

        for (let i = 0; i < users.length; i++) {
            const query = {
                text: `INSERT INTO ${tableName}(username,birthdate,email,phone) VALUES($1, $2, $3, $4)`,
                values: [users[i].username, users[i].birthdate, users[i].email, users[i].phone],
            }

            await this.client.query(query)
        }

        console.log(`Database succesfully seeded: ${users.length}`);
    }

    async close() {
        try {
            await this.client.end();            
        } catch (error) {
            throw new Error('failed to close the database connection');
        }
    }

}