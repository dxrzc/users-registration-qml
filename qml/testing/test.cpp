#include <QtQuickTest>
#include <QQmlEngine>
#include <QQmlContext>
#include "infraestructure/db/postgredatasource.h"
#include "interface/table/userTableModel.h"

class Setup: public QObject
{
    Q_OBJECT

private:
    ErrorHandler* errorHandlerPtr;
    PostgreDataSource* datasourcePtr;
    qmlDto* dtoPtr;
    UserTableModel* userTableModelPtr;

    void clearDatabase()
    {
        QSqlQuery query(QSqlDatabase::database());
        const QString command = "DELETE FROM %1";
        query.exec(command.arg(datasourcePtr->getTableName()));
    }

    void freeResources()
    {
        delete userTableModelPtr;
        // table deletes dto
        // dto deletes datasource
        // datasource deletes errorhandler
    }

public:
    Setup(){}
    ~Setup(){}

public slots:

    // this is slower, but cleaner
    void applicationAvailable()
    {
        errorHandlerPtr = new ErrorHandler();
        datasourcePtr = new PostgreDataSource(errorHandlerPtr);
        dtoPtr = new qmlDto(datasourcePtr);
        userTableModelPtr = new UserTableModel(dtoPtr);

        ConnectionOptions connectionOptions ("localhost", "myuser", "12345","users", 5433);
        datasourcePtr->connect(connectionOptions);
    }

    void qmlEngineAvailable(QQmlEngine *engine)
    {
        engine->rootContext()->setContextProperty("myContextProperty", QVariant(true));
        engine->rootContext()->setContextProperty("errorhandler", errorHandlerPtr);
        engine->rootContext()->setContextProperty("QmlDto", dtoPtr);
        engine->rootContext()->setContextProperty("usersTable", userTableModelPtr);
    }

    void cleanupTestCase()
    {
        clearDatabase();
        freeResources();
    }
};

QUICK_TEST_MAIN_WITH_SETUP(qmlTest,Setup)
#include "test.moc"
