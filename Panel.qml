import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Item {
    implicitWidth: childrenRect.width
    ColumnLayout {
        Button {
            text: 'Текст'
            onClicked: {
                root.typeMouse = 'text'
            }
        }
        Button {
            text: 'Прямоугольник'
            onClicked: {
                root.typeMouse = 'rect'
            }
        }
        Button {
            text: 'Круг'
            onClicked: {
                root.typeMouse = 'oval'
            }
        }
    }
}
