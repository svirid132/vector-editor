import QtQuick 2.15
import 'qrc:/javascript/painter.js' as Painter
import '../'

QtObject {
    id: root
    required property ImageZoomer zoomer
    function baseDraw(ctx, relativeToElement) {
        const zoomedElement = Painter.zoomElement(zoomer, relativeToElement)
        const zoomedSize = Painter.getSize(ctx, zoomedElement)
        const zoomedRectSize = Painter.getRectSize(zoomedSize)
        ctx.save()
        ctx.strokeStyle = 'blue'
        ctx.strokeRect(zoomedRectSize.x, zoomedRectSize.y, zoomedRectSize.width, zoomedRectSize.height)
        ctx.restore()
    }
}
