#ifndef HELPER_INVALIDCONNECTION_H
#define HELPER_INVALIDCONNECTION_H

#include "infraestructure/db/postgredatasource.h"
#include "global/test/testdatabase-options.h"

// Use this singleton to test errors, since its using
// an invalid connection options.
class InvalidConnection
{
    InvalidConnection(const InvalidConnection&) = delete;
    InvalidConnection& operator=(const InvalidConnection&) = delete;

private:
    ErrorHandler* m_errorHandler = new ErrorHandler();
    PostgreDataSource m_datasource;

    InvalidConnection():
        m_datasource(m_errorHandler,"invalidConnection","invalidconnectiontable"){}

public:
    static const ConnectionOptions invalidConnectionOptions;

    static InvalidConnection& instance()
    {
        static InvalidConnection instance_;
        return instance_;
    }

    ErrorHandler* errorHandler() const noexcept
    {
        return m_errorHandler;
    }

    PostgreDataSource& datasource() noexcept
    {
        return m_datasource;
    }
};

const ConnectionOptions InvalidConnection::invalidConnectionOptions = []{
    auto options = TestingConfig::databaseOptions;
    options.PORT = 1;
    return options;
}();

#endif // HELPER_INVALIDCONNECTION_H
