#ifndef ITEMCOORDINATE_H
#define ITEMCOORDINATE_H

#include "AbstarctCoordinate.h"

#include <QJsonObject>
#include <QObject>
#include <QPointF>
#include <QRectF>

class Zoomer;

struct ItemCoordinate : public AbstractCoordinate
{
    Q_GADGET
public:
};

Q_DECLARE_METATYPE(ItemCoordinate)

#endif // ITEMCOORDINATE_H
