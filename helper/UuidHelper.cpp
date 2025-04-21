#include "uuidhelper.h"
#include <QUuid>

UuidHelper::UuidHelper(QObject *parent) : QObject(parent) {}

QString UuidHelper::generateUuid() {
    return QUuid::createUuid().toString(QUuid::WithoutBraces);
}
