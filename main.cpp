#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include<QQmlContext>
#include "infraestructure/db/postgredatasource.h"
#include "interface/table/userTableModel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    ConnectionOptions options(
        "localhost",
        "myuser", // user
        "12345", // pass
        "users", // db
        5433);

    ErrorHandler* errorhandler = new ErrorHandler();
    engine.rootContext()->setContextProperty("errorhandler", errorhandler);

    qmlDto* dto = new qmlDto(new PostgreDataSource(options,errorhandler));
    engine.rootContext()->setContextProperty("QmlDto",dto);

    UserTableModel tb(dto);
    engine.rootContext()->setContextProperty("usersTable", &tb);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("users-registration-qml", "Main");

    return app.exec();
}
