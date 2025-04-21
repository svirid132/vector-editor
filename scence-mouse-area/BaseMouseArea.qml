import QtQuick 2.15
import QtQuick.Window 2.2
import '../'
import 'qrc:/javascript/math.js' as Math

MouseArea {
    id: root
    required property ImageScene scene
    property var elements: scene.elements
    required property ImageZoomer zoomer
    property int pressedButton: -1
    property var pressedPoint
    property bool isPressed: false
    hoverEnabled: true
    acceptedButtons: Qt.AllButtons
    cursorShape: Qt.BlankCursor
    z: 1000
    onPressed: {
        pressedButton = mouse.button
        pressedPoint = zoomer.unzoomedPoint({x: mouse.x, y: mouse.y})
        isPressed = true

        if (pressedButton === Qt.MiddleButton) {
            zoomer.saveZoom()
            root.pressedPoint = pressedPoint
        }
        root.forceActiveFocus()
        // handleClick(mouse)
    }
    onPositionChanged: {
        cursorImage.x = mouse.x
        cursorImage.y = mouse.y

        if (!isPressed) {
            return
        }
        if (pressedButton === Qt.MiddleButton) {
            zoomer.restoreZoom()
            const posPoint = zoomer.unzoomedPoint({x: mouse.x, y: mouse.y})
            const moveVector = Math.getVector(pressedPoint, posPoint)
            zoomer.translate(moveVector)
            zoomer.limitImageToScreen()
        }
    }
    onReleased: {
        isPressed = false
    }
    onWheel: {
        if (wheel.modifiers & Qt.ControlModifier) {
            const point = Qt.point(wheel.x, wheel.y)
            const delta = wheel.angleDelta.y / 120
            const zoom = 1 + delta / 10
            zoomer.zoom(zoom, {x: point.x, y: point.y})
        }
    }

    Image {
        id: cursorImage
        source: 'qrc:/assets/cursor/selected-cursor.svg'
        width: 32 * Screen.devicePixelRatio
        height: 32 * Screen.devicePixelRatio
        visible: root.containsMouse
    }

    Component.onCompleted: {
        // handleClick({x: 300, y: 300})
    }
    property point globalClickedPoint: Qt.point(0, 0)
    property string typeMouse: 'NONE'
    function handleClick(mouse) {
        const point = {x: mouse.x, y: mouse.y}
        const createdPoint = zoomer.unzoomedPoint(point)
        const comp = Qt.createComponent("painter/TextPainter.qml")
        const element = ({
                             type: 'text',
                             lines: [
                                 'sdklgjskgkljg',
                                 '0123456789',
                                 'fl',
                                 '0123456789'
                             ],
                             fontFamily: 'Arial',
                             fontHeight: 20 * 2,
                             lineHeight: 24 * 2,
                             padding: 10,
                             surfaceColor: 'yellow',
                             textColor: 'black',
                             coor: {
                                 createdPoint: createdPoint
                             }
                         })
        const obj = comp.createObject(imageScene, {
                                          zoomer: zoomer, element,
                                          observeMouseArea: root
                                      })
    }
}
