import QtQuick 2.15
import '../'

// Базовый item для painter
// Тут происходит идет обработка zoom и mouse
Canvas {
    id: root
    required property ImageZoomer zoomer
    required property MouseArea observeMouseArea
    property int mouseStatus: ItemPainter.DEFAULT
    enum MOUSE_STATUS {
        DEFAULT,
        PRESSED
    }
    // все точки unzoomed
    property point zoomedPressedPoint
    property point pressedPoint
    property point vectorTranslate

    // от мыши
    signal pressed(var mouse)
    signal translatePressed(var mouse)

    // требования painter
    signal cancled()

    Connections{
        target: observeMouseArea
        function onPositionChanged(mouse) {
            if (root.mouseStatus === ItemPainter.PRESSED) {
                const point = zoomer.unzoomedPoint({x: mouse.x, y: mouse.y})
                root.vectorTranslate = Qt.point(point.x - root.pressedPoint.x, point.y - root.pressedPoint.y)
                root.translatePressed(mouse)
            }
        }
        function onPressed(mouse) {
            root.zoomedPressedPoint = Qt.point(mouse.x, mouse.y)
            const point = root.zoomer.unzoomedPoint({x: mouse.x, y: mouse.y})
            root.pressedPoint = Qt.point(point.x, point.y)
            root.mouseStatus = ItemPainter.PRESSED
            root.pressed(mouse)
        }
        function onReleased(mouse) {
            root.mouseStatus = ItemPainter.DEFAULT
        }
    }

    Connections {
        id: zoomerConnection
        target: root.zoomer
        function onZoomed() {
            root.requestPaint()
        }
    }
}
