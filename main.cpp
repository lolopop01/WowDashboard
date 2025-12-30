#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "backend/ApiClient.h"
#include "backend/StatusService.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // --- Backend ---
    ApiClient api;
    StatusService statusService(&api);

    engine.rootContext()->setContextProperty("statusService", &statusService);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection
    );

    engine.loadFromModule("WowDashboard", "Main");

    return app.exec();
}
