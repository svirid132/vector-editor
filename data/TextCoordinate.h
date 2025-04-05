#ifndef TEXTCOORDINATE_H
#define TEXTCOORDINATE_H

#include "AbstarctCoordinate.h"

#include <QJsonObject>
#include <QObject>
#include <QPointF>
#include <QRectF>

class Zoomer;

struct TextCoordinate : public AbstractCoordinate
{
    Q_GADGET
public:

    Q_INVOKABLE void initByTextFormat(QPointF createdPoint);

    Q_INVOKABLE void createdPointF(QPointF pointF);
    Q_INVOKABLE QPointF vectorCreatedPoint();

    Q_INVOKABLE QJsonObject serialize();

    QPointF m_createdPoint;

signals:

protected:
    Zoomer* m_zoomer;
};

Q_DECLARE_METATYPE(TextCoordinate)

#endif // TEXTCOORDINATE_H
