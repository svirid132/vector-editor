import QtQuick 2.15
import QtQuick.Layouts 1.15
import 'qrc:/javascript/painter.js' as Painter

ItemPainter {
    id: root
    anchors.fill: parent

    property var element: ({
                               type: 'text',
                               fontFamily: 'Arial',
                               fontHeight: 20 * 2,
                               lineHeight: 24 * 2,
                               padding: 10,
                               surfaceColor: 'yellow',
                               textColor: 'black',
                               coor: {
                                   createdPoint: {x: 300, y: 300}
                               }
                           })
    property var editableElement: {
        const copedElement = JSON.parse(JSON.stringify(element))
        return copedElement
    }
    property var editableProperty: {
        return ({
                    showCursor: false,
                    cursorIndex: {
                        lineIndex: 0,
                        columnIndex: 0
                    }
                })
    }

    // onMouseStatusChanged: {
    //     if (mouseStatus === ItemPainter.PRESSED) {
    //     }
    // }

    onPressed: {
        const pressed = root.zoomedPressedPoint // unzoomed точка
        const zoomedElement = Painter.zoomTextElement(root.zoomer, root.editableElement)
        const isPointInsideElement = Painter.isPoointInsideTextElement(root.context, pressed, zoomedElement)
        if (isPointInsideElement) {
            const cursorIndex = Painter.insideTextCursorIndex(root.context, pressed, zoomedElement)
            if (cursorIndex) {
                editableProperty.cursorIndex = cursorIndex
                editableProperty.startSelection = {
                    lineIndex: cursorIndex.lineIndex,
                    columnIndex: cursorIndex.columnIndex + 1
                }
                root.requestPaint()
            }
        }
    }
    onTranslatePressed: {
        if (editableProperty.startSelection) {
            const point = {x: mouse.x, y: mouse.y}
            const zoomedElement = Painter.zoomTextElement(root.zoomer, root.editableElement)
            editableProperty.endSelection = Painter.textCursorIndex(root.context, point, zoomedElement)
            root.requestPaint()
        }
    }

    // Ввод с клавиатуры
    focus: true
    Keys.onPressed: function(event) {
        // line и текущий text
        const text = editableElement.lines[editableProperty.cursorIndex.lineIndex]
        const lines = editableElement.lines

        // cursorIndex
        const cursorIndex = editableProperty.cursorIndex

        // columnIndex
        const maxColumnIndex = text.length - 1
        const minColumnIndex = -1
        const columnIndex = cursorIndex.columnIndex > maxColumnIndex ? maxColumnIndex : cursorIndex.columnIndex

        // lineIndex
        const maxLineIndex =  lines.length - 1
        const minLineIndex = 0
        const lineIndex = cursorIndex.lineIndex

        if (event.key === Qt.Key_Backspace) {
            if (columnIndex === -1 && lineIndex === 0) {
                // Ничего не делать
            } else if (columnIndex === -1 && lineIndex > 0) {
                const prevLineIndex = lineIndex - 1
                const leftText = lines[prevLineIndex]
                const newText = leftText + lines[lineIndex]
                lines[prevLineIndex] = newText
                lines.splice(lineIndex, 1)
                cursorIndex.columnIndex = leftText.length - 1
                cursorIndex.lineIndex = prevLineIndex
            } else {
                lines[lineIndex] = text.slice(0, columnIndex) + text.slice(columnIndex + 1)
                cursorIndex.columnIndex -= 1
            }
            event.accepted = true
        } else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
            const leftText = text.slice(0, columnIndex + 1)
            const rightText = text.slice(columnIndex + 1)
            lines[lineIndex] = leftText
            const newLineIndex = lineIndex + 1
            lines.splice(newLineIndex, 0, rightText)
            cursorIndex.lineIndex = newLineIndex
            cursorIndex.columnIndex = -1
            event.accepted = true
        } else if (event.key === Qt.Key_Up) {
            if (lineIndex !== minLineIndex) {
                cursorIndex.lineIndex -= 1
            }
        } else if (event.key === Qt.Key_Down) {
            if (cursorIndex.lineIndex !== maxLineIndex) {
                cursorIndex.lineIndex += 1
            }
        } else if(event.key === Qt.Key_Left) {
            if (columnIndex === minColumnIndex &&
                    lineIndex === minLineIndex) {
                // Ничего не делаем
            } else if (columnIndex === minColumnIndex) {
                cursorIndex.lineIndex -= 1
                const prevLineIndex = lineIndex - 1
                const prevText = lines[ prevLineIndex ]
                cursorIndex.columnIndex = prevText.length - 1
            } else {
                if ( columnIndex >= maxColumnIndex ) {
                    cursorIndex.columnIndex = maxColumnIndex
                }
                cursorIndex.columnIndex -= 1
            }
        } else if(event.key === Qt.Key_Right) {
            if (columnIndex === maxColumnIndex &&
                    lineIndex === maxLineIndex) {
                // Ничего не делаем
            }
            else if (columnIndex >= maxColumnIndex) {
                cursorIndex.columnIndex = -1
                cursorIndex.lineIndex += 1
            } else {
                cursorIndex.columnIndex += 1
            }
        } else if (event.text.length > 0) {
            lines[lineIndex] = text.slice(0, columnIndex + 1) + event.text + text.slice(columnIndex + 1)
            cursorIndex.columnIndex += 1
            event.accepted = true
        }
        root.requestPaint()
    }

    // Мигающий курсор
    Timer {
        id: timer
        interval: 500; running: true; repeat: true
        onTriggered: {
            root.editableProperty.showCursor = !root.editableProperty.showCursor
            root.requestPaint()
        }
    }

    // Рисуем
    onPaint: {
        var ctx = getContext("2d")
        ctx.clearRect(0, 0, root.width, root.height)
        const zoomedElement = Painter.zoomTextElement(root.zoomer, root.editableElement)
        Painter.drawTextElement(ctx, zoomedElement, root.editableProperty)
    }
}
