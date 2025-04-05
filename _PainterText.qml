import QtQuick 2.15
import libs 1.0
import QtQuick.Layouts 1.15

Canvas {
    id: root
    required property Zoomer zoomer
    anchors.fill: parent

    ///////////////////////////////////
    ///////Работа с текстом////////////
    ///////////////////////////////////
    // оригинальные координаты и размеры
    QtObject {
        id: origCoor
        property real x: 0
        property real y: 0
        property real width: image.sourceSize.width
        property real height: image.sourceSize.height
        // только текст
        property real fontHeight: 20
        property real lineHeight: 24
        property string font: fontHeight + 'px Arial'
        // точки начало и конца
        property point startPoint: Qt.point(x, y)
        property point endPoint: Qt.point(x + width, y + height)
    }
    property point startPoint: Qt.point(100, 100)

    // Увеличеные/уменьшенные размеры
    property point zoomedStartPoint: root.zoomer.handlePoint(startPoint)
    property real zoomedFontHeight: root.zoomer.multi(fontHeight)
    property real zoomedLineHeight: root.zoomer.multi(lineHeight)
    property string zoomedFont: zoomedFontHeight + 'px Arial'
    // Работа с текстом
    property bool showCursor: false
    property string inputText: 'qwerty\nqwerty'
    property var textLines: root.inputText.split(/\n/)
    onTextLinesChanged: {
        root.requestPaint()
    }
    property alias origCoor: origCoor
    // Рисовать текст
    function drawText(ctx) {
        ctx.save()
        ctx.font = root.zoomedFont;
        let displayText = root.inputText + (root.showCursor ? "|" : ""); // мигающий курсор
        textLines.forEach((line, i) => {
                              // Добавляем курсор к последней строке
                              if (i === textLines.length - 1 && root.showCursor) {
                                  line += "|";
                              }

                              ctx.fillText(line, zoomedStartPoint.x, zoomedStartPoint.y + i * zoomedLineHeight);
                          });
        ctx.restore()
    }

    // Ввод с клавиатуры
    focus: true
    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Backspace) {
            inputText = inputText.slice(0, -1)
            event.accepted = true
        }else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
            inputText += '\n'
            event.accepted = true
        } else if (event.text.length > 0) {
            inputText += event.text
            event.accepted = true
        }
    }

    // Мигающий курсор
    Timer {
        id: timer
        interval: 500; running: true; repeat: true
        onTriggered: {
            root.showCursor = !root.showCursor
            root.requestPaint()
        }
    }
    function startBlinkCursor() {
        timer.start()
    }
    function stopBlinkCursor() {
        timer.stop()
    }

    // Zoomer меняет размеры zoomed свойств
    Connections {
        id: conntections
        target: root.zoomer
        function onZoomed() {
            const zoomer = root.zoomer
            root.zoomedStartPoint = zoomer.handlePoint(root.startPoint)
            root.zoomedFontHeight = zoomer.multi(root.fontHeight)
            root.zoomedLineHeight = zoomer.multi(root.lineHeight)
            root.requestPaint()
        }
    }

    // Рисуем
    onPaint: {
        var ctx = getContext("2d")
        ctx.clearRect(0, 0, root.width, root.height)

        drawText(ctx)
    }
}
