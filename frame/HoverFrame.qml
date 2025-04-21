import QtQuick 2.15
import 'qrc:/javascript/painter.js' as Painter

BaseFrame {
    id: root
    function draw(ctx, relativeToElement) {
        baseDraw(ctx, relativeToElement)
    }
}
