import QtQuick 2.15
import '../frame'
import '../'
import 'qrc:/javascript/painter.js' as Painter
import 'qrc:/javascript/math.js' as VectorMath

BaseMouseArea {
    id: root
    property var posPoint
    property string currentHoveredUuid: ''
    property var copedMovedElement
    signal pressedUuid(string uuid)
    onCurrentHoveredUuidChanged: {
        scene.requestPaint()
    }
    function drawHoverElement(ctx, exceptionUuid) {
        if (!root.containsMouse || isPressed) {
            return
        }
        const hoveredElement = elements.find(element => element.uuid === currentHoveredUuid && element.uuid !== exceptionUuid)
        if (hoveredElement) {
            hoverFrame.draw(ctx, hoveredElement)
        }
    }
    function getUuidByPoint(ctx, point) {
        for (let i = 0; i < elements.length; ++i) {
            const isPointInside = Painter.isPointInsideElement(point, elements[i], ctx)
            if (isPointInside) {
                return elements[i].uuid
            }
        }
        return ''
    }
    onPressed: {
        if (pressedButton !== Qt.LeftButton) {
            return
        }
        if (currentHoveredUuid) {
            const element = scene.elements.find(element => element.uuid === currentHoveredUuid)
            copedMovedElement = JSON.parse(JSON.stringify(element))
        }
        pressedUuid(currentHoveredUuid)
    }
    onPositionChanged: {
        posPoint = zoomer.unzoomedPoint({x: mouse.x, y: mouse.y})
        currentHoveredUuid = getUuidByPoint(scene.context, posPoint)

        if (copedMovedElement) {
            const moveVector = VectorMath.getVector(pressedPoint, posPoint)
            const newElement = Painter.translateElement(copedMovedElement, moveVector)
            scene.elements = scene.elements.map(function(element) {
                if (element.uuid === newElement.uuid) {
                    return newElement
                }
                return element
            }
            )
        }
    }
    onReleased: {
        copedMovedElement = undefined
    }
    HoverFrame {
        id: hoverFrame
        zoomer: root.zoomer
    }
}
