import QtQuick 2.15
import 'qrc:/javascript/math.js' as Math

Item {
    id: root
    property var imageCoordinate
    signal zoomed()
    onWidthChanged: {
        if (imageCoordinate) {
            zoom(1.0, {x: 0, y: 0})
        }

    }
    onHeightChanged: {
        if (imageCoordinate) {
            zoom(1.0, {x: 0, y: 0})
        }
    }

    property var savedZoom: JSON.parse(JSON.stringify(root.matrix))
    function saveZoom() {
        savedZoom = JSON.parse(JSON.stringify(root.matrix))
    }
    function restoreZoom() {
        matrix = JSON.parse(JSON.stringify(savedZoom))
    }

    function zoom(scale, p) {
        var m_translate_1 = [[1, 0, -p.x],
                             [0, 1, -p.y],
                             [0, 0, 1]]
        var m_scale = [[scale, 0, 0],
                       [0, scale, 0],
                       0, 0, 1]
        var m_translate_2 = [[1, 0, p.x],
                             [0, 1, p.y],
                             [0, 0, 1]]
        const m_1 = Math.multiplyMatrices(m_translate_1, matrix)
        const m_2 = Math.multiplyMatrices(m_scale, m_1)
        const tmpMatrix = Math.multiplyMatrices(m_translate_2, m_2)
        tmpMatrix[0][0] = tmpMatrix[0][0].toFixed(2)
        tmpMatrix[1][1] = tmpMatrix[1][1].toFixed(2)
        const maxZoom = 2.5
        let maxUnzoom
        const imageWidth = imageCoordinate.endPoint.x - imageCoordinate.startPoint.x
        const imageHeight = imageCoordinate.endPoint.y - imageCoordinate.startPoint.y
        const imageRatio = imageWidth / imageHeight
        const screenRatio = width / height
        if (imageRatio >= screenRatio) {
            maxUnzoom = width / imageWidth
            if (tmpMatrix[0][0] < maxUnzoom) {
                tmpMatrix[0][0] = maxUnzoom
                tmpMatrix[1][1] = maxUnzoom
            } else if (tmpMatrix[0][0] > maxZoom && scale > 1.0) {
                limitImageToScreen()
                return
            }
        } else {
            maxUnzoom = height / imageHeight
            if (tmpMatrix[1][1] < maxUnzoom) {
                tmpMatrix[0][0] = maxUnzoom
                tmpMatrix[1][1] = maxUnzoom
            } else if (tmpMatrix[1][1] > maxZoom && scale > 1.0) {
                limitImageToScreen()
                return
            }
        }
        matrix = tmpMatrix
        console.log(matrix[0][0])
        limitImageToScreen()
        zoomed()
    }
    function adjustToImage() {
        let maxUnzoom
        const imageWidth = imageCoordinate.endPoint.x - imageCoordinate.startPoint.x
        const imageHeight = imageCoordinate.endPoint.y - imageCoordinate.startPoint.y
        const imageRatio = imageWidth / imageHeight
        const screenRatio = width / height
        if (imageRatio >= screenRatio) {
            maxUnzoom = width / imageWidth
            zoom(maxUnzoom, {x: 0, y: 0})
        } else {
            maxUnzoom = height / imageHeight
            zoom(maxUnzoom, {x: 0, y: 0})
        }
    }
    function limitImageToScreen() {
        const zoomedImageSize = {
            startPoint: zoomPoint(imageCoordinate.startPoint),
            endPoint: zoomPoint(imageCoordinate.endPoint)
        }
        const imageWidth = zoomedImageSize.endPoint.x - zoomedImageSize.startPoint.x
        const imageHeight = zoomedImageSize.endPoint.y - zoomedImageSize.startPoint.y
        const imageRatio = imageWidth / imageHeight
        const screenRatio = width / height
        const screenStartPoint = {x: 0, y: 0}
        const screenEndPoint = {x: root.width, y: root.height}
        if (imageRatio >= screenRatio) {
            if (zoomedImageSize.startPoint.x > screenStartPoint.x) {
                translate({x: -zoomedImageSize.startPoint.x, y: 0})
            }
            if (imageHeight > root.height && zoomedImageSize.startPoint.y > 0) {
                translate({x: 0, y: -zoomedImageSize.startPoint.y})
            }
            if (imageHeight < root.height) {
                const y = (root.height - imageHeight) / 2
                translate({x: 0, y: -zoomedImageSize.startPoint.y})
                translate({x: 0, y: y})
            }
            if (zoomedImageSize.endPoint.x < screenEndPoint.x) {
                const x = screenEndPoint.x - zoomedImageSize.endPoint.x
                translate({x: x, y: 0})
            }
            if (imageHeight > root.height && zoomedImageSize.endPoint.y < screenEndPoint.y) {
                const y = screenEndPoint.y - zoomedImageSize.endPoint.y
                translate({x: 0, y: y})
            }
        } else {
            if (imageWidth < root.width) {
                const x = (root.width - imageWidth) / 2
                translate({x: -zoomedImageSize.startPoint.x, y: 0})
                translate({x: x, y: 0})
            }
            if (zoomedImageSize.startPoint.y > screenStartPoint.y) {
                translate({x: 0, y: -zoomedImageSize.startPoint.y})
            }
            if (imageWidth > root.width && zoomedImageSize.startPoint.x > screenStartPoint.x) {
                translate({x: -zoomedImageSize.startPoint.x, y: 0})
            }
            if (zoomedImageSize.endPoint.y < screenEndPoint.y) {
                const y = screenEndPoint.y - zoomedImageSize.endPoint.y
                translate({x: 0, y: y})
            }
            if (imageWidth > root.width && zoomedImageSize.endPoint.x < screenEndPoint.x) {
                const x = screenEndPoint.x - zoomedImageSize.endPoint.x
                translate({x: x, y: 0})
            }
        }
    }
    function translate(p) {
        var m_translate = [[1, 0, p.x],
                           [0, 1, p.y],
                           [0, 0, 1]]
        matrix = Math.multiplyMatrices(m_translate, matrix)
        zoomed()
    }
    function zoomPoint(p) {
        return Math.multiMatrixToPoint(matrix, p)
    }
    function zoomNum(num) {
        return Math.multiMatrixScale(matrix, num)
    }
    function unzoomedPoint(p) {
        const m_scale = [[ 1 / matrix[0][0], 0, 0],
                         [0, 1 / matrix[1][1], 0],
                         [0, 0, 1]]
        const m_translate = [[ 1, 0, -matrix[0][2]],
                             [0, 1, -matrix[1][2]],
                             [0, 0, 1]]
        const mat = Math.multiplyMatrices(m_scale, m_translate)
        return Math.multiMatrixToPoint(mat, p)
    }
    property var matrix: [
        [1, 0, 0],
        [0, 1, 0],
        [0, 0, 1]
    ]
}
