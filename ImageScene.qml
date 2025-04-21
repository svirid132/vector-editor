import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import 'qrc:/javascript/painter.js' as Painter
import libs 1.0

Canvas {
    id: root
    required property Image image
    required property ImageZoomer zoomer
    property var elements: ([{
                                    uuid: UuidHelper.generateUuid(),
                                    type: 'oval',
                                    fillColor: 'orange',
                                    strokeColor: 'red',
                                    strokeWidth: 2,
                                    radiusX: 100,
                                    radiusY: 50,
                                    coor: {
                                        centerPoint: {
                                            x: 100,
                                            y: 100
                                        }
                                    }
                                },
                                {
                                    uuid: UuidHelper.generateUuid(),
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
                                },
                                {
                                    uuid: UuidHelper.generateUuid(),
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
                                        createdPoint: {x: 200, y: 600}
                                    }
                                },
                                {
                                    uuid: UuidHelper.generateUuid(),
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
                                        createdPoint: {x: 500, y: 200}
                                    }
                                },
                                {
                                    uuid: UuidHelper.generateUuid(),
                                    type: 'rect',
                                    fillColor: 'orange',
                                    strokeColor: 'red',
                                    strokeWidth: 10,
                                    coor: {
                                        startPoint: {
                                            x: 100,
                                            y: 100
                                        },
                                        endPoint: {
                                            x: 300,
                                            y: 300
                                        }
                                    }
                                }
                            ])
    property var additionToElements: []
    onElementsChanged: {
        root.requestPaint()
    }
    property var drawAfter: function() {}
    onPaint: {
        var ctx = getContext("2d")
        ctx.clearRect(0, 0, root.width, root.height)
        Painter.drawImage(ctx, root.zoomer, root.image)
        root.elements.slice().reverse().forEach(function(element) {
            switch(element.type) {
            case 'text': {
                const zoomedElement = Painter.zoomTextElement(root.zoomer, element)
                const ind = additionToElements.findIndex(it => it.uuid === element.uuid)
                if (ind === -1) {
                    Painter.drawTextElement(ctx, zoomedElement)
                } else {
                    Painter.drawTextElement(ctx, zoomedElement, additionToElements[ind].obj)
                }
                break
            }
            case 'rect': {
                const zoomedRectElement = Painter.zoomRectElement(root.zoomer, element)
                Painter.drawRect(ctx, zoomedRectElement)
                break
            }
            case 'oval': {
                const zoomedOvalElement = Painter.zoomOvalElement(root.zoomer, element)
                Painter.drawOval(ctx, zoomedOvalElement)
                break
            }
            }
        })
        root.drawAfter(ctx)
    }
    Connections {
        id: zoomerConnection
        target: root.zoomer
        function onZoomed() {
            root.requestPaint()
        }
    }
}
