import QtQuick 2.15
import libs 1.0
import 'qrc:/javascript/math.js' as VectorMath

BaseMouseArea {
    id: root

    property string serializeElements
    property var newRectElement: undefined

    onPressed: {
        if (pressedButton !== Qt.LeftButton) {
            return
        }
        const pressedPoint = zoomer.unzoomedPoint({x: mouse.x, y: mouse.y})
        serializeElements = JSON.stringify(elements)
        newRectElement = {
            uuid: UuidHelper.generateUuid(),
            type: 'rect',
            fillColor: 'orange',
            strokeColor: 'red',
            strokeWidth: 10,
            coor: {
                startPoint: {
                    x: pressedPoint.x,
                    y: pressedPoint.y
                },
                endPoint: {
                    x: pressedPoint.x,
                    y: pressedPoint.y
                }
            }
        }
    }
    onPositionChanged: {
        if (root.newRectElement) {
            const posPoint = zoomer.unzoomedPoint({x: mouse.x, y: mouse.y})
            newRectElement.coor.endPoint = posPoint
            const diagonal = VectorMath.getVector(newRectElement.coor.startPoint, newRectElement.coor.endPoint)
            const newElements = JSON.parse(serializeElements)
            if (Math.abs(diagonal.x) < 0.1 || Math.abs(diagonal.y) < 0.1) {
                scene.elements = newElements
                return
            }
            newElements.unshift(newRectElement)
            scene.elements = newElements
        }
    }
    onReleased: {
        newRectElement = undefined
    }
}
