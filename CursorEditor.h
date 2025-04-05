#ifndef CURSOREDITOR_H
#define CURSOREDITOR_H

#include <QQuickItem>


class CursorEditor : public QQuickItem
{
    Q_OBJECT
public:
    CursorEditor();

private:
    QCursor createCursorFromSvg(const QString &svgPath, QSize size = QSize(16, 16), QPoint hotspot = QPoint(0, 0));

signals:
};

#endif // CURSOREDITOR_H
