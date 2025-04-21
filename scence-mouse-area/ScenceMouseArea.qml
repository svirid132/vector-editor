import QtQuick 2.15
import QtQuick.Controls 2.15
import '../'
import '../frame'

Item {
    id: root
    required property ImageZoomer zoomer
    required property ImageScene scene
    property int mode: ScenceMouseArea.CREATABLE_RECTANGLE
    property string selectedUuid: ''
    focus: true
    onSelectedUuidChanged: {
        scene.requestPaint()
    }
    function drawAdditionElement(ctx) {
        const selectedElement = scene.elements.find(element => element.uuid === selectedUuid)
        if (selectedElement) {
            editableFrame.draw(ctx, selectedElement)
        }

        if (root.mode === ScenceMouseArea.SELECTABLE) {
            selectableMouseArea.drawHoverElement(ctx, selectedUuid)
        }
    }

    enum SCENCE_MOUSE_AREA_MODE {
        SELECTABLE,
        CREATABLE_RECTANGLE,
        CREATABLE_ELLIPSE,
        CREATABLE_TEXT
    }

    EditableFrame {
        id: editableFrame
        zoomer: root.zoomer
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Delete) {
            scene.elements = scene.elements.filter((element) => element.uuid !== selectedUuid)
            event.accepted = true
        }
    }

    SelectableMouseArea {
        id: selectableMouseArea
        anchors.fill: parent
        enabled: root.mode === ScenceMouseArea.SELECTABLE
        visible: enabled
        zoomer: root.zoomer
        scene: root.scene
        onPressedUuid: {
            root.selectedUuid = uuid
        }
    }

    TextMouseArea {
        id: textMouseArea
        anchors.fill: parent
        enabled: root.mode === ScenceMouseArea.CREATABLE_TEXT
        visible: enabled
        zoomer: root.zoomer
        scene: root.scene
    }

    RectangleMouseArea {
        id: rectangleMouseArea
        anchors.fill: parent
        enabled: root.mode === ScenceMouseArea.CREATABLE_RECTANGLE
        visible: enabled
        zoomer: root.zoomer
        scene: root.scene
    }

    OvalMouseArea {
        id: ovalMouseArea
        anchors.fill: parent
        enabled: root.mode === ScenceMouseArea.CREATABLE_ELLIPSE
        visible: enabled
        zoomer: root.zoomer
        scene: root.scene
    }
}
