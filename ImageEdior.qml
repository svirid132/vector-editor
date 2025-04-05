import QtQuick 2.15
import QtQuick.Layouts 1.15
import libs 1.0
import 'painter'

Item {
    id: root
    property alias imageSource: image.source
    RowLayout {
        spacing: 0
        anchors.fill: parent
        ScrollView {
            id: vectorScollView
            Layout.fillWidth: true
            Layout.fillHeight: true
            zoomer: zoomer
            contentItem: MouseArea {
                id: mouseArea
                hoverEnabled: true
                onClicked: {
                    // handleClick(mouse)
                }
                Component.onCompleted: {
                    handleClick({x: 300, y: 300})
                }
                property point globalClickedPoint: Qt.point(0, 0)
                property string typeMouse: 'NONE'
                onWheel: {
                    if (wheel.modifiers & Qt.ControlModifier) {
                        const point = Qt.point(wheel.x, wheel.y)
                        const delta = wheel.angleDelta.y / 120
                        const zoom = 1 + delta / 10
                        zoomer.zoom(zoom, {x: point.x, y: point.y})
                    }
                }
                function handleClick(mouse) {
                    const point = {x: mouse.x, y: mouse.y}
                    const createdPoint = zoomer.unzoomedPoint(point)
                    const comp = Qt.createComponent("painter/TextPainter.qml")
                    const element = ({
                                         type: 'text',
                                         lines: [
                                             'sdklgjskgkljg',
                                             '0123456789',
                                             'fl',
                                             '0123456789'
                                         ],
                                         fontFamily: 'Arial',
                                         fontHeight: 20 * 2,
                                         lineHeight: 24 * 2,
                                         padding: 10,
                                         surfaceColor: 'yellow',
                                         textColor: 'black',
                                         coor: {
                                             createdPoint: createdPoint
                                         }
                                     })
                    const obj = comp.createObject(imageScene, {
                                                      zoomer: zoomer, element,
                                                      observeMouseArea: mouseArea
                                                  })
                }
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
                    image: Image {
                        id: image
                        visible: false
                        onStatusChanged: {
                            if (image.status === Image.Ready && zoomer.width != 0) {
                                console.log('this')
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
        Panel {
            Layout.preferredWidth: childrenRect.width
            Layout.fillHeight: true
        }
    }
}
