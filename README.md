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

## Building from Source

### Requirements
- Qt6 installation with at least the following modules
  - QtTest
  - QtSql
  - QtQuick
  - QtQuickTest
  - QtQuickControls
- PostgreSQL drivers: Required for QtSql 
- Docker (optionally, your own database for development)
- Node: Required for seed

### Build
Steps for building
```
git clone https://github.com/itsdrc/users-registration-qml.git
cd users-registration-qml
cmake -DCMAKE_PREFIX_PATH=<qtInstallation>/<version>/<arch> -S . -B build
cd build
cmake --build .
```

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
