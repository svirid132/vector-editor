#ifndef CANVASEXPORTER_H
#define CANVASEXPORTER_H

#include <QObject>
#include <QImage>
#include <QByteArray>
#include <QFile>
#include <QDebug>
#include <QFileDialog>
#include <QApplication>

class CanvasExporter : public QObject {
    Q_OBJECT
public:
    explicit CanvasExporter(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE void saveCanvasImage(const QString &dataUrl) {
        QWidget *parent = QApplication::activeWindow(); // если используется QWidget
        QString fileName = QFileDialog::getSaveFileName(
            parent,
            "Сохранить как",
            "E:/project-data/editor/canvas.jpg",
            "JPEG файл (*.jpg);;PNG файл (*.png);;Все файлы (*)"
            );

        // Удаляем префикс "data:image/png;base64,"
        QString base64Data = dataUrl.section(',', 1); // Берёт всё после запятой
        QByteArray imageBytes = QByteArray::fromBase64(base64Data.toUtf8());

        QImage image;
        if (!image.loadFromData(imageBytes, "PNG")) {
            qWarning() << "Не удалось загрузить изображение из данных!";
            return;
        }

        // Сохраняем
        if (!image.save(fileName, "JPG", 90)) {
            qWarning() << "Не удалось сохранить изображение!";
        } else {
            qDebug() << "Изображение успешно сохранено!";
        }
    }
};

#endif // CANVASEXPORTER_H
