#ifndef ZOOMER_H
#define ZOOMER_H

#include "data/ItemCoordinate.h"
#include <QMatrix3x3>
#include <QObject>
#include <QPointF>
#include <QQuickItem>

class Zoomer : public QQuickItem
{
    Q_OBJECT
    // Ограничивающий размер. По этому размеру:
    // Матрица центрирует Item
    // Не дает зуму слишком уменьшить или увеличить Item
    // Привязывет стороны Item к сторонам parent Item, чтобы края Item не углибились внутрь parent Item
    Q_PROPERTY(QSizeF boundingSize READ boundingSize WRITE setBoundingSize NOTIFY boundingSizeChanged FINAL)
public:
    explicit Zoomer(QQuickItem *parent = nullptr);

    Q_INVOKABLE QPointF handlePoint(QPointF p);
    Q_INVOKABLE QPointF internalHandledPoint(QPointF p);
    Q_INVOKABLE void resetZoom();
    Q_INVOKABLE void zoomItem(QQuickItem* item, QPointF start, QPointF end);
    Q_INVOKABLE double multi(double num);

    Q_INVOKABLE void zoom(float delta, QPointF p);
    Q_INVOKABLE void adjustToSize(QSizeF size);

    Q_INVOKABLE ItemCoordinate createItemCoordinate();

    QSizeF boundingSize() const;
    void setBoundingSize(const QSizeF &newBoundingSize);

    QVector3D applyMatrix(const QMatrix3x3& m, const QVector3D& v);
signals:
    void zoomed();
    void boundingSizeChanged();

private:
    QMatrix3x3 makeMatrix3x3(std::initializer_list<float> values);
    QMatrix3x3 m_matrix;
    QSizeF m_boundingSize;
};

#endif // ZOOMER_H
