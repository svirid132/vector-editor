import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import 'qrc:/javascript/painter.js' as Painter

Canvas {
    id: root
    required property Image image
    required property ImageZoomer zoomer
    property var elements: ([{
                                 type: 'text',
                                 lines: [
                                     'Qwerty',
                                     'Qwerty',
                                     'Qwerty'
                                 ],
                                 fontFamily: 'Arial',
                                 fontHeight: 20 * 2,
                                 lineHeight: 24 * 2,
                                 padding: 10,
                                 surfaceColor: '#22222222',
                                 textColor: 'black',
                                 coor: {
                                     createdPoint: {x: 200, y: 200}
                                 }
                             }])
    onPaint: {
        var ctx = getContext("2d")
        ctx.clearRect(0, 0, root.width, root.height)
        Painter.drawImage(ctx, root.zoomer, root.image)
        root.elements.forEach(function(element) {
            switch(element.type) {
            case 'text': {
                const zoomedElement = Painter.zoomTextElement(root.zoomer, element)
                Painter.drawTextElement(ctx, zoomedElement)
                break
            }
            }
        })
    }
    Connections {
        id: zoomerConnection
        target: root.zoomer
        function onZoomed() {
            root.requestPaint()
        }
    }

    ColumnLayout {
        Button {
            text: 'reset zoom'
            onClicked: {
                root.zoomer.resetZoom()
            }
        }
        Button {
            text: 'save image'
            onClicked: {
                var saved = image.grabToImage(function(result) {
                    if (result) {
                        var saved = result.saveToFile("E:/tmp/save.png");
                        console.log("Saved:", saved);
                    } else {
                        console.log("Failed to grab image");
                    }
                })
            }
        }
    }
}
