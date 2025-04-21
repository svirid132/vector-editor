import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Item {
    id: root
    implicitWidth: childrenRect.width
    signal save()
    property int mode: Panel.TEXT
    enum MODE {
        SELECTABLE,
        TEXT,
        RECT,
        OVAL
    }
    ColumnLayout {
        height: parent.height
        Button {
            highlighted: mode === Panel.SELECTABLE
            text: 'Selectable'
            onClicked: {
                root.mode = Panel.SELECTABLE
            }
        }
        Button {
            highlighted: mode === Panel.TEXT
            text: 'Текст'
            onClicked: {
                root.mode = Panel.TEXT
            }
        }
        Button {
            highlighted: mode === Panel.RECT
            text: 'Прямоугольник'
            onClicked: {
                root.mode = Panel.RECT
            }
        }
        Button {
            highlighted: mode === Panel.OVAL
            text: 'Круг'
            onClicked: {
                root.mode = Panel.OVAL
            }
        }
        Item {
            width: 1
            Layout.fillHeight: true
        }
        Button {
            id: savedBtn
            text: 'Сохранить'
            onClicked: {
                root.save()
            }
        }
    }
}
