#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QIcon>
#include "infraestructure/db/postgredatasource.h"
#include "interface/table/userTableModel.h"
#include "global/config/qml.h"
#include "global/config/database.h"

int main(int argc, char *argv[])
{
    QQuickStyle::setStyle(GlobalApplicationConfig::Qml::controlsStyle);

    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon("resources/app-icon.ico"));

    QQmlApplicationEngine engine;

    ErrorHandler *errorhandler = new ErrorHandler();
    engine.rootContext()->setContextProperty("errorhandler", errorhandler);

    qmlDto *dto = new qmlDto(new PostgreDataSource(
        errorhandler,
        GlobalApplicationConfig::Database::connectionName,
        GlobalApplicationConfig::Database::tableName
    ));

    engine.rootContext()->setContextProperty("QmlDto", dto);

    UserTableModel tb(dto);
    engine.rootContext()->setContextProperty("usersTable", &tb);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("appModule", "Main");

    return app.exec();
}
