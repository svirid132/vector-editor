// математика
function multiplyMatrices(a, b) {
    const result = [
                     [0, 0, 0],
                     [0, 0, 0],
                     [0, 0, 1],
                 ];

    for (let i = 0; i < 2; i++) {
        for (let j = 0; j < 3; j++) {
            result[i][j] = 0;
            for (let k = 0; k < 3; k++) {
                result[i][j] += a[i][k] * b[k][j];
            }
        }
    }

    return result;
}

function multiMatrixToPoint(matrix, point) {
    const x = point.x
    const y = point.y

    const newX = matrix[0][0] * x + matrix[0][1] * y + matrix[0][2];
    const newY = matrix[1][0] * x + matrix[1][1] * y + matrix[1][2];

    return ({x: newX, y: newY})
}

function translate(p, pt) {
    const mat = [[1, 0, pt.x],
                 [0, 1, pt.y],
                 0, 0, 1]
    return multiMatrixToPoint(mat, p)
}

function multiMatrixScale(matrix, num) {
    const scale = matrix[0][0]
    return scale * num
}

// функции по умолчанию
function isPointInsideElement(point, element) {
    return isPointInsideSize(point, {startPoint: element.coor.startPoint, endPoint: element.coor.endPoint})
}

function isPointInsideSize(point, size) {
    const startPoint = size.startPoint
    const endPoint = size.endPoint
    const minX = Math.min(startPoint.x, endPoint.x)
    const maxX = Math.max(startPoint.x, endPoint.x)
    const minY = Math.min(startPoint.y, endPoint.y)
    const maxY = Math.max(startPoint.y, endPoint.y)

    return (
                point.x >= minX &&
                point.x <= maxX &&
                point.y >= minY &&
                point.y <= maxY
                )
}

function getRectSize(size) {
    return {
        x: size.startPoint.x,
        y: size.startPoint.y,
        width: size.endPoint.x - size.startPoint.x,
        height: size.endPoint.y - size.startPoint.y
    }
}

function getZoomedSize(zoomer, size) {
    const zoomedStartPoint = zoomer.zoomPoint(size.startPoint)
    const zoomedEndPoint = zoomer.zoomPoint(size.endPoint)
    return {startPoint: zoomedStartPoint, endPoint: zoomedEndPoint}
}

function drawImage(ctx, zoomer, element) {
    const coor = zoomer.imageCoordinate
    const zoomedStartPoint = zoomer.zoomPoint(coor.startPoint)
    const zoomedEndPoint = zoomer.zoomPoint(coor.endPoint)
    ctx.drawImage(element, zoomedStartPoint.x, zoomedStartPoint.y, zoomedEndPoint.x - zoomedStartPoint.x, zoomedEndPoint.y - zoomedStartPoint.y)
}

function translateSize(size, pt){
    return {
        startPoint: translate(size.startPoint, pt),
        endPoint: translate(size.endPoint, pt)
    }
}

// Текст
const ascentMulti = 0.8 // коэффицент восхождения шрифта
const descentMulti = 0.2 // коэффицент убывания шрифта

function isPoointInsideTextElement(ctx, point, element) {
    const size = getTextElementSize(ctx, element)
    return isPointInsideSize(point, size)
}

function insideTextCursorIndex(ctx, point, element) {
    const lines = element.lines
    for (let i = 0; i < lines.length; ++i) {
        const line = lines[i]
        const x = element.coor.createdPoint.x
        const y = element.coor.createdPoint.y + i * element.lineHeight - ascentMulti * element.fontHeight
        const width = getWidthText(ctx, line, element.fontHeight, element.fontFamily)
        const height = element.fontHeight
        const size = {
            startPoint: {x, y},
            endPoint: {x: x + width, y: y + height}}
        if (isPointInsideSize(point, size)) {
            let currentWidth = 0
            let currentText = ''
            const arr = line.split('')
            const needWidth = point.x - x
            for (let ind = 0; ind < arr.length; ++ind) {
                const charWidth = getWidthText(ctx, arr[ind], element.fontHeight, element.fontFamily)
                currentWidth += charWidth
                if (currentWidth >= needWidth) {
                    if (charWidth / 2 < currentWidth - needWidth) {
                        return { lineIndex: i, columnIndex: ind - 1 }
                    } else {
                        return { lineIndex: i, columnIndex: ind }
                    }
                }
            }

            return {lineIndex: i, columnIndex: -1}
        }
    }
    return undefined
}

function getTextColumnIndex(ctx, x, line, fontHeight, fontFamily) {
    let currentWidth = 0
    const arr = line.split('')
    const firstWidth = getWidthText(ctx, arr[0], fontHeight, fontFamily)
    if (x < firstWidth) {
        return -1
    }
    for (let ind = 0; ind < arr.length; ++ind) {
        const charWidth = getWidthText(ctx, arr[ind], fontHeight, fontFamily)
        currentWidth += charWidth
        if (currentWidth >= x) {
            if (charWidth / 2 < (currentWidth - x)) {
                return ind - 1
            } else {
                return ind
            }
        }
    }
    return arr.length - 1
}

function textCursorIndex(ctx, point, element) {
    const lines = element.lines

    // Когда Y вышел за пределы
    const minY = element.coor.createdPoint.y - ascentMulti * element.fontHeight
    let currentY = minY + ascentMulti * element.fontHeight
    for (let index = 1; index < lines.length; ++index) {
        currentY += element.lineHeight
    }
    const maxY = currentY
    let lineIndex = -1
    const textX = point.x - element.coor.createdPoint.x
    if (point.y < minY) {
        lineIndex = 0
        const columnIndex = getTextColumnIndex(ctx, textX, lines[0], element.fontHeight, element.fontFamily)
        return { lineIndex: 0, columnIndex: columnIndex }
    } else if (point.y > maxY) {
        const lastIndex = lines.length - 1
        const columnIndex = getTextColumnIndex(ctx, textX, lines[lastIndex], element.fontHeight, element.fontFamily)
        return { lineIndex: lastIndex, columnIndex: columnIndex }
    }

    for (let i = 0; i < lines.length; ++i) {
        const line = lines[i]
        const y = element.coor.createdPoint.y + i * element.lineHeight - ascentMulti * element.fontHeight
        const height = element.fontHeight
        if (y <= point.y && (y + height) >= point.y) {
            const columnIndex = getTextColumnIndex(ctx, textX, lines[i], element.fontHeight, element.fontFamily)
            return { lineIndex: i, columnIndex: columnIndex}
        }
        if (y > point.y) {
            const columnIndex = getTextColumnIndex(ctx, textX, lines[i], element.fontHeight, element.fontFamily)
            return { lineIndex: i, columnIndex: columnIndex}
        }
    }

    return undefined
}

function zoomTextElement(zoomer, element) {
    const zoomedTextElement = JSON.parse(JSON.stringify(element))
    zoomedTextElement.padding = zoomer.zoomNum(element.padding)
    zoomedTextElement.lineHeight = zoomer.zoomNum(element.lineHeight)
    zoomedTextElement.fontHeight = zoomer.zoomNum(element.fontHeight)
    zoomedTextElement.coor.createdPoint = zoomer.zoomPoint(element.coor.createdPoint)

    return zoomedTextElement
}

function getWidthText(ctx, text, fontHeight, fontFamily) {
    ctx.save()
    ctx.font = fontHeight + 'px ' + fontFamily
    const width = ctx.measureText(text).width
    ctx.restore()
    return width
}

function getWidthTextElement(ctx, element) {
    let maxWidthText = 0
    element.lines.forEach(function(line) {
        maxWidthText = Math.max(maxWidthText, getWidthText(ctx, line, element.fontHeight, element.fontFamily))
    })

    return maxWidthText
}

function getTextElementSize(ctx, element) {
    const createdPoint = element.coor.createdPoint
    const width = getWidthTextElement(ctx, element)
    const startPoint = {
        x: createdPoint.x - element.padding,
        y: createdPoint.y - element.fontHeight * ascentMulti - element.padding
    }
    const endPoint = {
        x: createdPoint.x + width + element.padding,
        y: createdPoint.y + (element.lines.length - 1) * element.lineHeight + element.fontHeight * descentMulti + element.padding
    }
    return { startPoint, endPoint }
}

function drawSelectLine(ctx, createdPoint, lineIndex, leftText, text, font, textFont) {
    ctx.save()
    const startSelectSize = {
        startPoint: {
            x: 0,
            y: 0
        },
        endPoint: {
            x: getWidthText(ctx, text, font.fontHeight, font.fontFamily),
            y: font.lineHeight
        }
    }
    const createdSelectPoint = {
        x: createdPoint.x + getWidthText(ctx, leftText, font.fontHeight, font.fontFamily),
        y: createdPoint.y + font.lineHeight * lineIndex - font.fontHeight * ascentMulti
    }
    const txSelectLine = translateSize(startSelectSize, createdSelectPoint)
    const selectLineRectSize = getRectSize(txSelectLine)
    ctx.fillStyle = '#3399FF'
    ctx.fillRect(selectLineRectSize.x, selectLineRectSize.y, selectLineRectSize.width, selectLineRectSize.height)
    const createdTextPoint = {
        x: createdPoint.x + getWidthText(ctx, leftText, font.fontHeight, font.fontFamily),
        y: createdPoint.y + font.lineHeight * lineIndex
    }
    ctx.font = textFont
    ctx.fillStyle = 'white'
    ctx.fillText(text, createdTextPoint.x, createdTextPoint.y);
    ctx.restore()
}

function drawTextElement(ctx, element, editableProperty) {
    // временные значения
    ctx.save()
    const lines = element.lines
    element.lines = lines
    let maxWidthText = 0
    lines.forEach(function(line) {
        maxWidthText = Math.max(maxWidthText, ctx.measureText(line).width)
    });
    const textSize = getTextElementSize(ctx, element)
    const textRectSize = getRectSize(textSize)
    const textFont = element.fontHeight + 'px ' + element.fontFamily
    ctx.font = textFont
    ctx.fillStyle = element.surfaceColor
    ctx.fillRect(textRectSize.x, textRectSize.y, textRectSize.width, textRectSize.height)
    ctx.fillStyle = element.textColor
    lines.forEach(function(line, i) {
        ctx.fillText(line, element.coor.createdPoint.x, element.coor.createdPoint.y + i * element.lineHeight);
    });

    // для редактирования
    if (editableProperty) {
        // Работа с выделеным тесктом
        if (editableProperty.startSelection && editableProperty.endSelection) {
            const rects = []
            const startSelection = editableProperty.startSelection
            const endSelection = editableProperty.endSelection
            const startSelectLine = lines[startSelection.lineIndex]
            // для start
            const startText = startSelection.lineIndex === endSelection.lineIndex ?
                                startSelectLine.slice(startSelection.columnIndex, endSelection.columnIndex + 1) :
                                startSelectLine.slice(startSelection.columnIndex, startSelectLine.length)
            const leftStartText = startSelectLine.slice(0, startSelection.columnIndex)
            const font = {fontHeight: element.fontHeight, lineHeight: element.lineHeight, fontFamily: element.fontFamily}
            drawSelectLine(ctx, element.coor.createdPoint, startSelection.lineIndex, leftStartText, startText, font, textFont)
            for (let ind = startSelection.lineIndex + 1; ind < endSelection.lineIndex; ++ind) {
                const text = lines[ind]
                drawSelectLine(ctx, element.coor.createdPoint, ind, '', text, font, textFont)
            }
            if (startSelection.lineIndex !== endSelection.lineIndex) {
                const endSelectLine = lines[endSelection.lineIndex]
                const text = endSelectLine.slice(0, endSelection.columnIndex + 1)
                drawSelectLine(ctx, element.coor.createdPoint, endSelection.lineIndex, '', text, font, textFont)
            } // Работа с курсором
        } else if (editableProperty.showCursor) {
            const cursorSize = {
                startPoint: {x: 0, y: 0},
                endPoint: {x: 2, y: element.fontHeight}
            }
            const cursorIndex = editableProperty.cursorIndex
            const text = lines[cursorIndex.lineIndex].slice(0, cursorIndex.columnIndex + 1)
            const textWidth = getWidthText(ctx, text,  element.fontHeight, element.fontFamily)
            const createdCursorPoint = {
                x: element.coor.createdPoint.x + textWidth + cursorSize.endPoint.x / 2,
                y: element.coor.createdPoint.y + element.lineHeight * cursorIndex.lineIndex - element.fontHeight * ascentMulti
            }
            const trCursorSize = translateSize(cursorSize, createdCursorPoint)
            const cursorRectSize = getRectSize(trCursorSize)
            ctx.fillRect(cursorRectSize.x, cursorRectSize.y, cursorRectSize.width, cursorRectSize.height)
        }
    }

    ctx.restore()
}
