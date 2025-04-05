#include "CursorEditor.h"

#include <QCursor>
#include <QGuiApplication>
#include <QPainter>
#include <QPixmap>
#include <QScreen>
#include <QSvgRenderer>

CursorEditor::CursorEditor() {
    // QCursor cursor = createCursorFromSvg(":/assets/cursor/selected-cursor.png");
    // setCursor(cursor);

    QCursor cr;

    QPixmap pixmap(":/assets/cursor/selected-cursor.png");
    QPixmap scaled = pixmap.scaled(16, 16, Qt::KeepAspectRatio, Qt::SmoothTransformation);
    QScreen *screen = QGuiApplication::primaryScreen();
    qreal dpr = screen->devicePixelRatio();
    qDebug() << dpr;
    // pixmap.fill(Qt::transparent); // прозрачный фон
    QCursor cursor(scaled, 0, 0);
    setCursor(cursor);
}

QCursor CursorEditor::createCursorFromSvg(const QString &svgPath, QSize size, QPoint hotspot)
{
    QSvgRenderer svg(svgPath);
    QPixmap pixmap(size);
    pixmap.fill(Qt::transparent); // прозрачный фон

    QPainter painter(&pixmap);
    svg.render(&painter);
    painter.end();

    return QCursor(pixmap, hotspot.x(), hotspot.y());
}
