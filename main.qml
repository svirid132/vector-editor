import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "qrc:/javascript/math.js" as Math
import libs 1.0

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    ImageEditor {
        anchors.fill: parent
        imageSource: 'qrc:/assets/evrazia_157x107_FR.jpg'
    }

    property var ss: {
        return MySingleton.testProp1
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
