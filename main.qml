import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "qrc:/javascript/math.js" as Math

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    ImageEdior {
        anchors.fill: parent
        imageSource: 'qrc:/assets/evrazia_157x107_FR.jpg'
    }

    Component.onCompleted: {
        const mat = [
          [1, 0, 0],
          [0, 1, 0],
          [0, 0, 1], // последняя строка фиксированная
        ];
        const p = Math.multiMatrixToPoint(mat, {x: 1, y: 1})
    }
}
