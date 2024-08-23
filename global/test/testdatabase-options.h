#ifndef TESTDATABASE_OPTIONS_H
#define TESTDATABASE_OPTIONS_H

#include "domain/entities/connectionOptions/connectionOptions.h"

namespace TestingConfig {
    inline const ConnectionOptions databaseOptions("localhost","myusertest","12345","userstest",5433);
}

#endif // TESTDATABASE-OPTIONS_H
