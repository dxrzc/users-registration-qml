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

- In order to run, the application needs to access the Qt binaries
located in `your_qt_installation/your_qt_version/your_architecture/bin`.
- To access the database, the application also needs the PostgreSQL binaries,
so you can install postgres an add the `bin` path to your envs.
- The QtQSql module needs the `qsqlpsqld` (for debug) and `qsqlpsql`(for release) drivers,
you can find these files in the following directory: `your_qt_installation\your_qt_version\your_architecture\plugins\sqldrivers`.  
If you can't find them, you can build the drivers by yourself: 
   - Unix: https://doc.qt.io/qt-6/sql-driver.html#how-to-build-the-qpsql-plugin-on-unix-and-macos
   - Windows: https://doc.qt.io/qt-6/sql-driver.html#how-to-build-the-qpsql-plugin-on-windows


### Seed
To populate the database with initial user data, run the following commands:
(don't forget to run `npm install` in "seed" directory first). 
Make sure to run the app and connect to your database at least once in order 
for the table to be created before populating it.
- Linux
```
chmod +x run-seed.sh
./run-seed.sh <yourPostgresUrl> <tableName> <number of users>
```
- Windows (bash)
```
./run-seed.sh <yourPostgresUrl> <tableName> <number of users>
```

### Testing
1. Navigate to your build directory
2. run ``ctest``

## License
[See here](https://github.com/itsdrc/users-registration-qml/blob/main/LICENSE)

## Images
![image](https://github.com/user-attachments/assets/3719e89a-781c-4c1c-9d1a-0cec8a28329e)

