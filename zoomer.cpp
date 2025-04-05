#include "zoomer.h"

#include <QVector3D>

Zoomer::Zoomer(QQuickItem *parent)
    : QQuickItem{parent}
{
    m_matrix.setToIdentity();
}

void Zoomer::zoom(float zoom, QPointF p)
{
    float px =  static_cast<float>(p.x());
    float py = static_cast<float>(p.y());
    QMatrix3x3 m_translate_1 = makeMatrix3x3({1.0f, 0.0f, 0.0f,
                                     0.0f, 1.0f, 0.0f,
                                     -px, -py, 1.0f});
    QMatrix3x3 m_scale = makeMatrix3x3({zoom, 0.0f, 0.0f,
                                   0.0f, zoom, 0.0f,
                                   0.0f, 0.0f, 1.0f});
    QMatrix3x3 m_translate_2 = makeMatrix3x3({1.0f, 0.0f, 0.0f,
                                     0.0f, 1.0f, 0.0f,
                                     px, py, 1.0f});
    m_matrix = m_translate_2 * m_scale * m_translate_1 * m_matrix;
    emit zoomed();
}

QPointF Zoomer::handlePoint(QPointF p)
{
    QVector3D vector(p.x(), p.y(), 1);
    QVector3D res = applyMatrix(m_matrix, vector);
    return res.toPointF();
}

QPointF Zoomer::internalHandledPoint(QPointF p) {
    QMatrix3x3 intSx = makeMatrix3x3({1 / m_matrix.data()[0], 0.0f, 0.0f,
                                      0.0f, 1 / m_matrix.data()[4], 0.0f,
                                      0.0f, 0.0f, 1.0f});
    QMatrix3x3 intTx = makeMatrix3x3({1.0f, 0.0f, 0.0f,
                                      0.0f, 1.0f, 0.0f,
                                      -m_matrix.data()[6], -m_matrix.data()[7], 1.0f});
    QMatrix3x3 intMat = intSx * intTx;
    QVector3D vector(p.x(), p.y(), 1);
    QVector3D res = applyMatrix(intMat, vector);
    return res.toPointF();
}

void Zoomer::resetZoom()
{
    m_matrix.setToIdentity();
    emit zoomed();
}

void Zoomer::zoomItem(QQuickItem *item, QPointF start, QPointF end)
{
    QPointF zoomedStart = handlePoint(start);
    QPointF zoomedEnd = handlePoint(end);
    item->setProperty("x", zoomedStart.x());
    item->setProperty("y", zoomedStart.y());
    double width = zoomedEnd.x() - zoomedStart.x();
    double height = zoomedEnd.y() - zoomedStart.y();
    item->setProperty("width", width);
    item->setProperty("height", height);
}

double Zoomer::multi(double num)
{
    return m_matrix.data()[0] * num;
}

void Zoomer::adjustToSize(QSizeF sizeArg)
{
    qreal imageRatio =  sizeArg.width() / sizeArg.height();
    qreal winRatio = size().width() / size().height();
    m_matrix.setToIdentity();
    QPointF startPoint(0, 0);
    QPointF endPoint(sizeArg.width(), sizeArg.height());
    if (imageRatio > winRatio) {
        float widthRatio =  static_cast<float>(size().width() / sizeArg.width());
        QMatrix3x3 m_scale = makeMatrix3x3({widthRatio, 0.0f, 0.0f,
                                          0.0f, widthRatio, 0.0f,
                                          0.0f, 0.0f, 1.0f});
        m_matrix = m_scale * m_matrix;
        QPointF zoomedStartPoint = handlePoint(startPoint);
        QPointF zoomedEndPoint = handlePoint(endPoint);
        float ty = static_cast<float>((size().height() - zoomedEndPoint.y() - zoomedStartPoint.y()) / 2);
        QMatrix3x3 m_translate = makeMatrix3x3({1.0f, 0.0f, 0.0f,
                                         0.0f, 1.0f, 0.0f,
                                         0.0f, ty, 1.0f});
        m_matrix = m_translate * m_matrix;
    } else {
        float heightRatio =  static_cast<float>(size().height() / sizeArg.height());
        QMatrix3x3 m_scale = makeMatrix3x3({heightRatio, 0.0f, 0.0f,
                                       0.0f, heightRatio, 0.0f,
                                       0.0f, 0.0f, 1.0f});
        m_matrix = m_scale * m_matrix;
        QPointF zoomedStartPoint = handlePoint(startPoint);
        QPointF zoomedEndPoint = handlePoint(endPoint);
        float tx = static_cast<float>((size().width() - zoomedEndPoint.x() - zoomedStartPoint.x()) / 2);
        QMatrix3x3 m_translate = makeMatrix3x3({1.0f, 0.0f, 0.0f,
                                                0.0f, 1.0f, 0.0f,
                                                tx, 0.0f, 1.0f});
        m_matrix = m_translate * m_matrix;
    }
    emit zoomed();
}

ItemCoordinate Zoomer::createItemCoordinate()
{
    ItemCoordinate itemCoordinate;
    // itemCoordinate.bindingZoomer(this);
    return itemCoordinate;
}

QVector3D Zoomer::applyMatrix(const QMatrix3x3& m, const QVector3D& v) {
    return QVector3D(
        m(0, 0) * v.x() + m(0, 1) * v.y() + m(0, 2) * v.z(),
        m(1, 0) * v.x() + m(1, 1) * v.y() + m(1, 2) * v.z(),
        m(2, 0) * v.x() + m(2, 1) * v.y() + m(2, 2) * v.z()
        );
}

QMatrix3x3 Zoomer::makeMatrix3x3(std::initializer_list<float> values) {
    QMatrix3x3 mat;
    int i = 0;
    for (float val : values) {
        mat.data()[i++] = val;
        if (i >= 9) break;
    }
    return mat;
}

QSizeF Zoomer::boundingSize() const
{
    return m_boundingSize;
}

void Zoomer::setBoundingSize(const QSizeF &newBoundingSize)
{
    if (m_boundingSize == newBoundingSize)
        return;
    m_boundingSize = newBoundingSize;
    emit boundingSizeChanged();
}
