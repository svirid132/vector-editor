import QtQuick 2.15
import libs 1.0
import 'qrc:/javascript/math.js' as VectorMath
import 'qrc:/javascript/painter.js' as Painter

BaseMouseArea {
    id: root

    property string serializeElements
    property var currentTextElement: undefined

    property var editableProperty

    onPressed: {
        if (pressedButton !== Qt.LeftButton) {
            return
        }
        const zoomedPressedPoint = {x: mouse.x, y: mouse.y}

        if (editableProperty && editableProperty.endSelection) {
            editableProperty.endSelection = undefined
        }

        for (let i = 0; i < elements.length; ++i) {
            const element = elements[i]
            const zoomedElement = Painter.zoomElement(zoomer, element)
            const isInside = Painter.isPointInsideElement(zoomedPressedPoint, zoomedElement, scene.context)
            if (isInside && element.type === 'text') {
                targetCurrentText(element, zoomedPressedPoint)
                return
            }
        }

        createNewText()
    }
    function targetCurrentText(element, zoomedPressedPoint) {
        currentTextElement = element
        const zoomedElement = Painter.zoomTextElement(zoomer, currentTextElement)
        const isPointInsideElement = Painter.isPoointInsideTextElement(root.scene.context, zoomedPressedPoint, zoomedElement)
        const cursorIndex = Painter.textCursorIndex(root.scene.context, zoomedPressedPoint, zoomedElement)
        editableProperty = {
            cursorIndex: cursorIndex,
            startSelection: {
                lineIndex: cursorIndex.lineIndex,
                columnIndex: cursorIndex.columnIndex
            }
        }
        scene.additionToElements = [{
                                        uuid: currentTextElement.uuid,
                                        obj: editableProperty
                                    }]
        root.scene.requestPaint()
        root.forceActiveFocus()
        timer.restart()
    }
    function createNewText() {
        currentTextElement = {
            uuid: UuidHelper.generateUuid(),
            type: 'text',
            lines: [
                'qweert',
                '123456789',
                'new-new'
            ],
            fontFamily: 'Arial',
            fontHeight: 20 * 2,
            lineHeight: 24 * 2,
            padding: 10,
            surfaceColor: 'yellow',
            textColor: 'black',
            coor: {
                createdPoint: pressedPoint
            }
        }
        editableProperty = {
            showCursor: false,
            cursorIndex: {
                lineIndex: 0,
                columnIndex: 1
            },
            startSelection: {
                lineIndex: 0,
                columnIndex: 1
            }
        }
        scene.additionToElements = [{
                                        uuid: currentTextElement.uuid,
                                        obj: editableProperty
                                    }]
        serializeElements = JSON.stringify(elements)
        const newElements = JSON.parse(serializeElements)
        newElements.unshift(currentTextElement)
        scene.elements = newElements

        root.scene.requestPaint()
        root.forceActiveFocus()
        timer.restart()
    }
    onPositionChanged: {
        const isLeftButton = pressedButton === Qt.LeftButton
        if (isPressed && isLeftButton) {
            const posPoint = {x: mouse.x, y: mouse.y}
            const zoomedElement = Painter.zoomTextElement(zoomer, currentTextElement)
            editableProperty.endSelection = Painter.textCursorIndex(root.scene.context, posPoint, zoomedElement)
            root.scene.requestPaint()
        }
    }
    onVisibleChanged: {
        if (!visible) {
            scene.additionToElements = []
        }
    }

    Keys.onPressed: function(event) {
        // line и текущий text
        const text = currentTextElement.lines[editableProperty.cursorIndex.lineIndex]
        const lines = currentTextElement.lines

        // cursorIndex
        const cursorIndex = editableProperty.cursorIndex

        // columnIndex
        const maxColumnIndex = text.length
        const minColumnIndex = 0
        const columnIndex = cursorIndex.columnIndex > maxColumnIndex ? maxColumnIndex : cursorIndex.columnIndex

        // lineIndex
        const maxLineIndex =  lines.length - 1
        const minLineIndex = 0
        const lineIndex = cursorIndex.lineIndex

        // Для селексирования
        if (editableProperty.endSelection) {

            let startSelection = JSON.parse(JSON.stringify(editableProperty.startSelection))
            let endSelection = JSON.parse(JSON.stringify(editableProperty.endSelection))
            if (Painter.isSwapTextSelection(startSelection, endSelection)) {
                const res = Painter.swapTextSelection(startSelection, endSelection)
                startSelection = res.startSelection
                endSelection = res.endSelection
            }
            if (event.key === Qt.Key_Backspace || event.key === Qt.Key_Delete) {
                if (startSelection.lineIndex === endSelection.lineIndex) {
                    const newText = lines[startSelection.lineIndex].slice(0, startSelection.columnIndex) + lines[startSelection.lineIndex].slice(endSelection.columnIndex + 1)
                    lines[startSelection.lineIndex] = newText
                } else {
                    const newText_1 = lines[startSelection.lineIndex].slice(0, startSelection.columnIndex)
                    lines[startSelection.lineIndex] = newText_1
                    const newText_2 = lines[endSelection.lineIndex].slice(endSelection.columnIndex + 1)
                    lines[startSelection.lineIndex] = newText_1 + newText_2
                    lines.splice(startSelection.lineIndex + 1, endSelection.lineIndex - startSelection.lineIndex)
                }
                editableProperty.endSelection = undefined
                event.accepted = true
            } else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                if (startSelection.lineIndex === endSelection.lineIndex) {
                    const newText_1 = lines[startSelection.lineIndex].slice(0, startSelection.columnIndex)
                    const newText_2 = lines[startSelection.lineIndex].slice(endSelection.columnIndex + 1)
                    lines[startSelection.lineIndex] = newText_1
                    lines.splice(startSelection.lineIndex + 1, 0, newText_2)
                    cursorIndex.columnIndex = 0
                    cursorIndex.lineIndex = startSelection.lineIndex + 1
                } else {
                    const newText_1 = lines[startSelection.lineIndex].slice(0, startSelection.columnIndex)
                    const newText_2 = lines[endSelection.lineIndex].slice(endSelection.columnIndex + 1)
                    lines[startSelection.lineIndex] = newText_1
                    lines.splice(startSelection.lineIndex + 1, endSelection.lineIndex - startSelection.lineIndex, newText_2)
                    cursorIndex.columnIndex = 0
                    cursorIndex.lineIndex = startSelection.lineIndex + 1
                }
                editableProperty.endSelection = undefined
                event.accepted = true
            } else if (event.key === Qt.Key_Up || event.key === Qt.Key_Left) {
                editableProperty.cursorIndex = startSelection
                editableProperty.endSelection = undefined
            } else if (event.key === Qt.Key_Down || event.key === Qt.Key_Right) {
                editableProperty.cursorIndex = {
                    columnIndex: endSelection.columnIndex + 1,
                    lineIndex: endSelection.lineIndex
                }
                editableProperty.endSelection = undefined
            } else if (event.text.length > 0) {
                const newText_1 = lines[startSelection.lineIndex].slice(0, startSelection.columnIndex)
                const newText_2 = lines[endSelection.lineIndex].slice(endSelection.columnIndex + 1)
                const newText = newText_1 + event.text + newText_2
                lines[startSelection.lineIndex] = newText
                cursorIndex.columnIndex += 1
                cursorIndex.lineIndex = startSelection.lineIndex
                lines.splice(startSelection.lineIndex + 1, endSelection.lineIndex - startSelection.lineIndex)
                editableProperty.endSelection = undefined
            }
        } else {
            // Для курсора
            if (event.key === Qt.Key_Backspace) {
                if (columnIndex === 0 && lineIndex === 0) {
                    // Ничего не делать
                } else if (columnIndex === 0 && lineIndex > 0) {
                    const prevLineIndex = lineIndex - 1
                    const leftText = lines[prevLineIndex]
                    const newText = leftText + lines[lineIndex]
                    lines[prevLineIndex] = newText
                    lines.splice(lineIndex, 1)
                    cursorIndex.columnIndex = leftText.length
                    cursorIndex.lineIndex = prevLineIndex
                } else {
                    lines[lineIndex] = text.slice(0, columnIndex - 1) + text.slice(columnIndex)
                    cursorIndex.columnIndex -= 1
                }
                event.accepted = true
            } else if(event.key === Qt.Key_Delete) {
                if (columnIndex === maxColumnIndex && lineIndex === maxLineIndex) {
                    // Ничего не делать
                } else if (columnIndex === maxColumnIndex) {
                    const nextLineIndex = lineIndex + 1
                    const rightText = lines[nextLineIndex]
                    const newText = lines[lineIndex] + rightText
                    lines[lineIndex] = newText
                    lines.splice(nextLineIndex, 1)
                } else {
                    lines[lineIndex] = text.slice(0, columnIndex) + text.slice(columnIndex + 1)
                }
                event.accepted = true
            } else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                const leftText = text.slice(0, columnIndex )
                const rightText = text.slice(columnIndex)
                lines[lineIndex] = leftText
                const newLineIndex = lineIndex + 1
                lines.splice(newLineIndex, 0, rightText)
                cursorIndex.lineIndex = newLineIndex
                cursorIndex.columnIndex = 0
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
                    cursorIndex.columnIndex = prevText.length
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
                    cursorIndex.columnIndex = 0
                    cursorIndex.lineIndex += 1
                } else {
                    cursorIndex.columnIndex += 1
                }
            } else if (event.text.length > 0) {
                lines[lineIndex] = text.slice(0, columnIndex + 1) + event.text + text.slice(columnIndex + 1)
                cursorIndex.columnIndex += 1
                event.accepted = true
            }
        }


        editableProperty.startSelection = cursorIndex
        root.scene.requestPaint()
    }

    // Мигающий курсор
    Timer {
        id: timer
        interval: 500
        repeat: true
        onTriggered: {
            root.editableProperty.showCursor = !root.editableProperty.showCursor
            root.scene.requestPaint()
        }
    }
}
