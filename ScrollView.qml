import QtQuick 2.15
import QtQuick.Controls 2.15

Control {
    id: root
    bottomPadding: horizontalBar.implicitHeight
    rightPadding: verticalBar.width
    required property ImageZoomer zoomer

    Connections {
        id: zoomerConnection
        target: root.zoomer
        enabled: !horizontalBar.pressed && !verticalBar.pressed
        function onZoomed() {
            const imageStartPoint = zoomer.imageCoordinate.startPoint
            const zoomedImageStartPoint= root.zoomer.zoomPoint(imageStartPoint)
            const imageEndPoint = zoomer.imageCoordinate.endPoint
            const zoomedImageEndPoint = root.zoomer.zoomPoint(imageEndPoint)
            const zoomedP0 =  {x: 0, y: 0}

            const zoomedImageWidth = zoomedImageEndPoint.x - zoomedImageStartPoint.x
            const leftPaddingImageByX = zoomedP0.x - zoomedImageStartPoint.x
            if (zoomedImageWidth <= root.availableWidth) {
                horizontalBar.minimumSize = 1.0
                horizontalBar.position = 0.0
            } else {
                horizontalBar.minimumSize = root.availableWidth / zoomedImageWidth
                horizontalBar.position = leftPaddingImageByX / (zoomedImageWidth - root.availableWidth)
            }

            const zoomedImageHeight = zoomedImageEndPoint.y - zoomedImageStartPoint.y
            const topPaddingImageByY = zoomedP0.y - zoomedImageStartPoint.y
            if (zoomedImageHeight <= root.availableHeight) {
                verticalBar.minimumSize = 1.0
                verticalBar.position = 0.0
            } else {
                verticalBar.minimumSize = root.availableHeight / zoomedImageHeight
                verticalBar.position = topPaddingImageByY / (zoomedImageHeight - root.availableHeight)
            }
        }
    }

    background: Item {
        clip: true
        ScrollBar {
            id: horizontalBar
            orientation: Qt.Horizontal
            width: root.width - verticalBar.width
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            policy: ScrollBar.AlwaysOn
            onPositionChanged: {
                if (pressed && minimumSize < 1.0) {
                    const imageStartPoint = zoomer.imageCoordinate.startPoint
                    const zoomedImageStartPoint = root.zoomer.zoomPoint(imageStartPoint)
                    const imageEndPoint = zoomer.imageCoordinate.endPoint
                    const zoomedImageEndPoint= root.zoomer.zoomPoint(imageEndPoint)

                    const zoomedImageWidth = zoomedImageEndPoint.x - zoomedImageStartPoint.x
                    const leftPadding = - position * (zoomedImageWidth - root.availableWidth)
                    zoomer.translate({x: -zoomedImageStartPoint.x, y: 0})
                    zoomer.translate({x: leftPadding, y: 0})
                }
            }
        }
        ScrollBar {
            id: verticalBar
            orientation: Qt.Vertical
            height: root.height - horizontalBar.height
            anchors.right: parent.right
            policy: ScrollBar.AlwaysOn
            onPositionChanged: {
                if (pressed && minimumSize < 1.0) {
                    const imageStartPoint = zoomer.imageCoordinate.startPoint
                    const zoomedImageStartPoint = root.zoomer.zoomPoint(imageStartPoint)
                    const imageEndPoint = zoomer.imageCoordinate.endPoint
                    const zoomedImageEndPoint= root.zoomer.zoomPoint(imageEndPoint)

                    const zoomedImageHeight = zoomedImageEndPoint.y - zoomedImageStartPoint.y
                    const leftPadding = - position * (zoomedImageHeight - root.availableHeight)
                    zoomer.translate({x: 0, y: -zoomedImageStartPoint.y})
                    zoomer.translate({x: 0, y: leftPadding})
                }
            }
        }
    }
}
