#include "TextCoordinate.h"

void AbstractCoordinate::createdPointF(QPointF pointF)
{
    m_createdPoint = pointF;
}

void AbstractCoordinate::bindingZoomer(Zoomer *zoomer)
{
    m_zoomer = zoomer;
}

QJsonObject AbstractCoordinate::serialize() {
    QJsonObject root;
    root["createdPoint"] = pointToJson(m_createdPoint);
    root["startPoint"] = pointToJson(m_startPoint);
    root["endPoint"] = pointToJson(m_endPoint);
    return root;
}

QJsonObject AbstractCoordinate::deserialize() {
    QJsonObject root;
    root["createdPoint"] = pointToJson(m_createdPoint);
    root["startPoint"] = pointToJson(m_startPoint);
    root["endPoint"] = pointToJson(m_endPoint);
    return root;
}


void TextCoordinate::initByCreatedPoint(QPointF pointF)
{

}
