function textElementSize(ctx, element) {
    const lines = element.text.split(/\n/)
    let maxWidthText = 0
    lines.forEach(function(line) {
        maxWidthText = Math.max(maxWidthText, ctx.measureText(line).width)
    });
    const ascentMulti = 0.8 // коэффицент восхождения шрифта
    const descentMulti = 0.2 // коэффицент убывания шрифта
    const createdPoint = element.coor.createdPoint
    const startPoint = {
        x: createdPoint.x - element.padding,
        y: createdPoint.y - element.fontHeight * ascentMulti - elementPadding
    }
    const endPoint = {
        x: createdPoint.x + maxWidthText + element.padding,
        y: createdPoint.y + (lines.length - 1) * element.lineHeight + element.fontHeight * descentMulti + element.padding
    }
    return {
        startPoint,
        endPoint
    }
}

function getTextIndexByMouse(ctx, zoomer, element, p) {
    ctx.save()
    const zoomedFontHeight = zoomer.zoomNum(element.fontHeight)
    const lines = element.text.split(/\n/)
    const ascentMulti = 0.8 // коэффицент восхождения шрифта
    const descentMulti = 0.2 // коэффицент убывания шрифта
    ctx.restore()
}
