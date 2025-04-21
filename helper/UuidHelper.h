#ifndef UUIDHELPER_H
#define UUIDHELPER_H

#include <QObject>

class UuidHelper : public QObject
{
    Q_OBJECT
public:
    explicit UuidHelper(QObject *parent = nullptr);

    Q_INVOKABLE QString generateUuid();
};

#endif // UUIDHELPER_H
