import {faker} from '@faker-js/faker'

export interface User {
    username: string,
    birthdate: Date,
    email: string,
    phone: string,
}

function createRandomUser(): User{
    return {        
        username: faker.person.firstName(), // name no dots.
        birthdate: faker.date.birthdate(),
        email: faker.internet.email(),
        phone: faker.helpers.fromRegExp(/[0-9]{9}/)
    };
}

export function generateRandomUsers(count: number): User[]{

    const users: User[] = faker.helpers.multiple(createRandomUser, {
        count,
    });

    return users;
}
