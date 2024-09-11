# Users registration app
Application to register users in Postgres SQL database using Qt Framework and C++

## Features 
- Create users
- Data validation
- Search for users
- Update user information
- Delete users

## Tecnologies and languages
- C++ 20
- CMake
- Qt Framework
- QML 
- Google Test (gmock)
- Docker
- Node Js, Typescript and Faker

## Installation

## Development

### Requirements
- Qt6 installation with at least the follwing modules
  - QtTest
  - QtSql
  - QtQuick
  - QtQuickTest
  - QtQuickControls
- PostgreSQL drivers: Required for QtSql 
- Docker (optionally, your own database for development)
- Node: Required for seed

### Seed
To populate the database with initial user data, run the following commands:
- Linux
```
chmod +x run-seed.sh
./run-seed.sh <yourPostgresUrl> <number of users>
```

### Testing

## License
[See here](https://github.com/itsdrc/users-registration-qml/blob/main/LICENSE)

## Images
