import QtQuick 2.15
import libs 1.0
import 'qrc:/javascript/math.js' as VectorMath

BaseMouseArea {
    id: root

    property string serializeElements
    property var newOvalElement: undefined

    onPressed: {
        if (pressedButton !== Qt.LeftButton) {
            return
        }

        const pressedPoint = zoomer.unzoomedPoint({x: mouse.x, y: mouse.y})
        serializeElements = JSON.stringify(elements)
        newOvalElement = {
            uuid: UuidHelper.generateUuid(),
            type: 'oval',
            fillColor: 'orange',
            strokeColor: 'red',
            strokeWidth: 2,
            radiusX: 0,
            radiusY: 0,
            coor: {
                centerPoint: {
                    x: pressedPoint.x,
                    y: pressedPoint.y
                }
            }
        }
    }
    onPositionChanged: {
        if (root.newOvalElement) {
            const posPoint = zoomer.unzoomedPoint({x: mouse.x, y: mouse.y})
            newOvalElement.radiusX = posPoint.x - newOvalElement.coor.centerPoint.x
            newOvalElement.radiusY = posPoint.y - newOvalElement.coor.centerPoint.y
            const newElements = JSON.parse(serializeElements)
            if (Math.abs(newOvalElement.radiusX) < 0.1 || Math.abs(newOvalElement.radiusY) < 0.1) {
                return
            }
            newElements.unshift(newOvalElement)
            scene.elements = newElements
        }
    }
    onReleased: {
        newOvalElement = undefined
    }
}
