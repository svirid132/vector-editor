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

function multiMatrixScale(matrix, num) {
    const scale = matrix[0][0]
    return scale * num
}

function isPointInsideRectangle(point, startPoint, endPoint) {
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

function getVector(p1, p2) {
    return ({
        x: p2.x - p1.x,
        y: p2.y - p1.y
    })
}
