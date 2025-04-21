import QtQuick 2.15
import QtQuick.Layouts 1.15
import libs 1.0
import 'painter'
import 'javascript/math.js' as Math
import 'scence-mouse-area'
import App.Backend 1.0

Item {
    id: root
    property alias imageSource: image.source
    enum MOUSE_TYPE {
        NONE,
        PRESSED_MIDDLE_BUTTON
    }
    RowLayout {
        spacing: 0
        anchors.fill: parent
        ScrollView {
            id: vectorScollView
            Layout.fillWidth: true
            Layout.fillHeight: true
            zoomer: zoomer
            contentItem: ScenceMouseArea {
                id: mouseArea
                zoomer: zoomer
                scene: imageScene
                ImageZoomer {
                    id: zoomer
                    anchors.fill: parent
                    Component.onCompleted: {
                        zoomer.imageCoordinate = ({
                                                      startPoint: {x: 0, y: 0},
                                                      endPoint: {x: image.sourceSize.width, y: image.sourceSize.height}
                                                  })
                        zoomer.adjustToImage()
                    }
                }
                ImageScene {
                    id: imageScene
                    anchors.fill: parent
                    drawAfter: function(ctx) {
                        mouseArea.drawAdditionElement(ctx)
                    }
                    image: Image {
                        id: image
                        visible: false
                        onStatusChanged: {
                            if (image.status === Image.Ready && zoomer.width != 0) {
                                zoomer.imageCoordinate = ({
                                                              startPoint: {x: 0, y: 0},
                                                              endPoint: {x: image.sourceSize.width, y: image.sourceSize.height}
                                                          })
                                zoomer.adjustToImage()
                            }
                        }
                    }
                    zoomer: zoomer
                }
            }
        }
        Component {
            id: savedImageSceneComp
            ImageScene {
                id: savedImageScene
                image: imageScene.image
                elements: imageScene.elements
                width: imageScene.image.sourceSize.width
                height: imageScene.image.sourceSize.height
                signal paintedDone()
                ImageZoomer {
                    id: zoomerCopyd
                    anchors.fill: savedImageScene
                    imageCoordinate: ({
                                          startPoint: {x: 0, y: 0},
                                          endPoint: {x: imageScene.image.sourceSize.width, y: imageScene.image.sourceSize.height}
                                      })
                }
                zoomer: zoomerCopyd
                visible: false
                onPainted: {
                    Qt.callLater(function() {
                        paintedDone()
                    });
                }
            }
        }

        Panel {
            Layout.preferredWidth: childrenRect.width
            Layout.fillHeight: true
            onModeChanged: {
                switch(mode) {
                case Panel.SELECTABLE:
                    mouseArea.mode = ScenceMouseArea.SELECTABLE
                    break
                case Panel.TEXT:
                    mouseArea.mode = ScenceMouseArea.CREATABLE_TEXT
                    break
                case Panel.RECT:
                    mouseArea.mode = ScenceMouseArea.CREATABLE_RECTANGLE
                    break
                case Panel.OVAL:
                    mouseArea.mode = ScenceMouseArea.CREATABLE_ELLIPSE
                    break
                }
            }

            onSave: {
                const obj = savedImageSceneComp.createObject(root)
                obj.paintedDone.connect(function() {
                    const data = obj.toDataURL("image/png")
                    CanvasExporter.saveCanvasImage(data)
                    obj.destroy()
                })
            }
        }
    }
}
