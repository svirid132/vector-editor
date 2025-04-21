#include "data/ItemCoordinate.h"
#include "CanvasExporter.h"
#include "CursorEditor.h"
#include "helper/UuidHelper.h"
#include "zoomer.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>

static QObject* uuidHelper_singletontype_provider(QQmlEngine*, QJSEngine*) {
    return new UuidHelper();
}

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QApplication app(argc, argv);

    QString path = QCoreApplication::applicationFilePath();
    qDebug() << QFileInfo(path).baseName();

    qmlRegisterSingletonType<CanvasExporter>("App.Backend", 1, 0, "CanvasExporter", [](QQmlEngine*, QJSEngine*) -> QObject* {
        return new CanvasExporter();
    });
    qmlRegisterSingletonType(QUrl("qrc:/MySingleton.qml"), "libs", 1, 0, "MySingleton");
    qmlRegisterSingletonType<UuidHelper>("libs", 1, 0, "UuidHelper", uuidHelper_singletontype_provider);
    qmlRegisterType<CursorEditor>("libs", 1, 0, "CursorEditor");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
