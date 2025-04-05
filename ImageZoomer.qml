import QtQuick 2.15
import 'qrc:/javascript/math.js' as Math

Item {
    id: root
    property var imageCoordinate
    signal zoomed()

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
        matrix = Math.multiplyMatrices(m_translate_2, m_2)
        zoomed()
    }
    function adjustToImage() {
        const imageWidth = imageCoordinate.endPoint.x - imageCoordinate.startPoint.x
        const imageHeight = imageCoordinate.endPoint.y - imageCoordinate.startPoint.y
        const imageRatio = imageWidth / imageHeight
        const winRatio = width / height
        if (imageRatio > winRatio) {
            const widthRatio = width / imageWidth
            const m_scale = [[widthRatio, 0, 0],
                             [0, widthRatio, 0],
                             0, 0, 1]
            matrix = Math.multiplyMatrices(m_scale, matrix)
            const zoomedStartPoint = Math.multiMatrixToPoint(matrix, imageCoordinate.startPoint)
            const zoomedEndPoint = Math.multiMatrixToPoint(matrix, imageCoordinate.endPoint)
            const ty = (height - zoomedEndPoint.y - zoomedStartPoint.y) / 2
            const m_translate = [[1, 0, 0],
                                 [0, 1, ty],
                                 0, 0, 1]
            matrix = Math.multiplyMatrices(m_translate, matrix)
        } else {
            const heightRatio = root.height / imageHeight
            const m_scale = [[heightRatio, 0, 0],
                             [0, heightRatio, 0],
                             0, 0, 1]
            matrix = Math.multiplyMatrices(m_scale, matrix)
            const zoomedStartPoint = Math.multiMatrixToPoint(matrix, imageCoordinate.startPoint)
            const zoomedEndPoint = Math.multiMatrixToPoint(matrix, imageCoordinate.endPoint)
            const tx = (width - zoomedEndPoint.x - zoomedStartPoint.x) / 2
            const m_translate = [[1, 0, tx],
                                 [0, 1, 0],
                                 0, 0, 1]
            matrix = Math.multiplyMatrices(m_translate, matrix)
        }
        zoomed()
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
