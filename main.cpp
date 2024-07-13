#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include<QQmlContext>
#include "infraestructure/db/postgredatasource.h"
#include "interface/table/userTableModel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    ErrorHandler* errorhandler = new ErrorHandler();
    engine.rootContext()->setContextProperty("errorhandler", errorhandler);

    qmlDto* dto = new qmlDto(new PostgreDataSource(errorhandler));
    engine.rootContext()->setContextProperty("QmlDto",dto);

    UserTableModel tb(dto);
    engine.rootContext()->setContextProperty("usersTable", &tb);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("qmlModule", "Main");

    return app.exec();
}
