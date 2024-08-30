package ui

import rl "vendor:raylib"
import "core:fmt"
import "core:strings"

UIRectangleData :: struct {
    square: bool,
    rounded: struct {
        active: bool,
        roundness: f32,
        segments: i32
    },
    gradient: struct {
        active: bool,
        vertex1: rl.Color,
        vertex2: rl.Color,
        vertex3: rl.Color,
        vertex4: rl.Color
    }
}

init_uishapedata_rectangle :: proc(
    square: bool = false,
    rounded: bool = false,
    roundness: f32 = 0,
    segments: i32 = 1,

    gradient: bool = false,
    vertex1: rl.Color = rl.WHITE,
    vertex2: rl.Color = rl.WHITE,
    vertex3: rl.Color = rl.WHITE,
    vertex4: rl.Color = rl.WHITE
) -> (data: UIRectangleData) {
    data = UIRectangleData{
        square = square,
        rounded = {
            active = rounded,
            roundness = roundness,
            segments = segments
        },
        gradient = {
            active = gradient,
            vertex1 = vertex1,
            vertex2 = vertex2,
            vertex3 = vertex3,
            vertex4 = vertex4
        }
    }

    return
}

draw_uishape_rectangle :: proc(shape: ^UIShape, data: UIRectangleData) {
    shape.boundingData.draw = get_draw_data(shape.boundingData.absolute, shape.parentData)

    if data.square {
        if shape.boundingData.draw.width > shape.boundingData.draw.height {
            shape.boundingData.draw.width = shape.boundingData.draw.height
        } else if shape.boundingData.draw.width < shape.boundingData.draw.height {
            shape.boundingData.draw.height = shape.boundingData.draw.width
        }
    }

    rect := get_rectangle_from_data(shape.boundingData.draw)

    if data.rounded.active {
        if shape.lines {
            rl.DrawRectangleRoundedLines(
                rect, data.rounded.roundness, data.rounded.segments, shape.lineThick, shape.color
            )
        } else {
            rl.DrawRectangleRounded(rect, data.rounded.roundness, data.rounded.segments, shape.color)
        }

        return
    }

    if data.gradient.active {
        rl.DrawRectangleGradientEx(
            rect, data.gradient.vertex1, data.gradient.vertex2,
            data.gradient.vertex3, data.gradient.vertex4
        )

        return
    }

    if shape.lines {
        rl.DrawRectangleLinesEx(rect, shape.lineThick, shape.color)
    } else {
        rl.DrawRectangleRec(rect, shape.color)
    }
}

UICircleData :: struct {
    gradient: struct {
        active: bool,
        color2: rl.Color
    },
    sector: struct {
        active: bool,
        startAngle: f32,
        endAngle: f32,
        segments: i32
    }
}

init_uishapedata_circle :: proc(
    gradient: bool = false,
    color2: rl.Color = rl.WHITE,

    sector: bool = false,
    startAngle: f32 = 0,
    endAngle: f32 = 0,
    segments: i32 = 1
) -> (data: UICircleData) {
    data = UICircleData{
        gradient = {
            active = gradient,
            color2 = color2
        },
        sector = {
            active = sector,
            startAngle = startAngle,
            endAngle = endAngle,
            segments = segments
        }
    }

    return
}

draw_uishape_circle :: proc(shape: ^UIShape, data: UICircleData) {
    // No need to calculate draw data, since circles are drawn with their center already
    center := get_posvector_from_data(shape.boundingData.absolute)
    radius := shape.boundingData.absolute.width / 2

    if data.gradient.active {
        rl.DrawCircleGradient(
            i32(shape.boundingData.absolute.x), i32(shape.boundingData.absolute.y), radius,
            shape.color, data.gradient.color2
        )

        return
    }

    if data.sector.active {
        if shape.lines {
            rl.DrawCircleSectorLines(
                center, radius,
                data.sector.startAngle, data.sector.endAngle, data.sector.segments,
                shape.color
            )
        } else {
            rl.DrawCircleSector(
                center, radius,
                data.sector.startAngle, data.sector.endAngle, data.sector.segments,
                shape.color
            )
        }

        return
    }

    if shape.lines {
        rl.DrawCircleLinesV(center, radius, shape.color)
    } else {
        rl.DrawCircleV(center, radius, shape.color)
    }
}

UIEllipseData :: struct {}

init_uishapedata_ellipse :: proc() -> (data: UIEllipseData) {
    data = UIEllipseData{}

    return
}

draw_uishape_ellipse :: proc(shape: ^UIShape, data: UIEllipseData) {
    // No need to calculate draw data, since circles are drawn with their center already
    radiusHori := shape.boundingData.absolute.width / 2
    radiusVert := shape.boundingData.absolute.height / 2

    if shape.lines {
        rl.DrawEllipseLines(
            i32(shape.boundingData.absolute.x), i32(shape.boundingData.absolute.y),
            radiusHori, radiusVert,
            shape.color
        )
    } else {
        rl.DrawEllipse(
            i32(shape.boundingData.absolute.x), i32(shape.boundingData.absolute.y),
            radiusHori, radiusVert,
            shape.color
        )
    }
}

// Note that the innerradius is a number from 0 to 1, that represents the relative portion of the inner circle.
// Meaning that, a value of 1 means the inner radius is equal to the outer radius, and 0 means there is no inner radius.
UIRingData :: struct {
    innerRadius: f32,
    startAngle: f32,
    endAngle: f32,
    segments: i32
}

init_uishapedata_ring :: proc(
    innerRadius: f32,
    startAngle: f32,
    endAngle: f32,
    segments: i32
) -> (data: UIRingData) {
    data = UIRingData{
        innerRadius = innerRadius,
        startAngle = startAngle,
        endAngle = endAngle,
        segments = segments
    }

    return
}

get_ring_innerradius_drawposition :: proc(radius: f32, drawBounding: UIData) -> (inner: f32) {
    inner = radius * (drawBounding.width / 2)

    return
}

draw_uishape_ring :: proc(shape: ^UIShape, data: UIRingData) {
    // No need to calculate draw data, since circles are drawn with their center already
    center := get_posvector_from_data(shape.boundingData.absolute)
    outerRadius := shape.boundingData.absolute.width / 2
    innerRadius := get_ring_innerradius_drawposition(data.innerRadius, shape.boundingData.absolute)

    if shape.lines {
        rl.DrawRingLines(
            center, innerRadius, outerRadius,
            data.startAngle, data.endAngle, data.segments,
            shape.color
        )
    } else {
        rl.DrawRing(
            center, innerRadius, outerRadius,
            data.startAngle, data.endAngle, data.segments,
            shape.color
        )
    }
}


// Vertexes are in counter-clockwise order.
// The data in the vertex vectors are relative measurements.
// They are relative to the parent UIShape object's absolute data.
UITriangleData :: struct {
    vertex1: rl.Vector2,
    vertex2: rl.Vector2,
    vertex3: rl.Vector2
}

init_uishapedata_triangle :: proc(
    vertex1: rl.Vector2,
    vertex2: rl.Vector2,
    vertex3: rl.Vector2
) -> (data: UITriangleData) {
    data = UITriangleData{
        vertex1 = vertex1,
        vertex2 = vertex2,
        vertex3 = vertex3
    }

    return
}

get_trianglevertex_drawposition :: proc(vertex: rl.Vector2, drawBounding: UIData) -> (position: rl.Vector2) {
    position = rl.Vector2{}

    position.x = drawBounding.x + vertex.x * drawBounding.width
    position.y = drawBounding.y + vertex.y * drawBounding.height

    return
}

draw_uishape_triangle :: proc(shape: ^UIShape, data: UITriangleData) {
    shape.boundingData.draw = get_draw_data(shape.boundingData.absolute, shape.parentData)

    drawVert1 := get_trianglevertex_drawposition(data.vertex1, shape.boundingData.draw)
    drawVert2 := get_trianglevertex_drawposition(data.vertex2, shape.boundingData.draw)
    drawVert3 := get_trianglevertex_drawposition(data.vertex3, shape.boundingData.draw)

    /*rl.DrawRectangle(
        i32(shape.boundingData.draw.x), i32(shape.boundingData.draw.y),
        i32(shape.boundingData.draw.width), i32(shape.boundingData.draw.height),
        rl.BLACK
    )*/

    if shape.lines {
        rl.DrawTriangleLines(drawVert1, drawVert2, drawVert3, shape.color)
    } else {
        rl.DrawTriangle(drawVert1, drawVert2, drawVert3, shape.color)
    }
}

UIShapeData :: union {
    UIRectangleData,
    UICircleData,
    UIEllipseData,
    UIRingData,
    UITriangleData
}

UIShape :: struct {
    zindex: u32,

    boundingData: UIElementData,
    parentData: ^UIData,

    shapeData: UIShapeData,

    lines: bool,
    lineThick: f32,
    color: rl.Color,
}

init_uishape_relative :: proc(
    zindex: u32,
    relativeX, relativeY, relativeW, relativeH: f32,
    parentData: ^UIData,
    shapeData: UIShapeData,
    lines: bool,
    color: rl.Color,
    lineThick: f32 = 1
) -> (shape: UIShape) {
    relativeData := UIData{ relativeX, relativeY, relativeW, relativeH }
    absoluteData := get_absolute_data(relativeData, parentData)

    shape = UIShape{
        zindex = zindex,

        boundingData = UIElementData{
            relative = relativeData,
            absolute = absoluteData,
            draw = get_draw_data(absoluteData, parentData),
            useAbs = false
        },
        parentData = parentData,

        shapeData = shapeData,

        lines = lines,
        lineThick = lineThick,
        color = color
    }

    return
}

init_uishape_absolute :: proc(
    zindex: u32,
    relativeX, relativeY: f32,
    absoluteW, absoluteH: f32,
    parentData: ^UIData,
    shapeData: UIShapeData,
    lines: bool,
    color: rl.Color,
    lineThick: f32 = 1
) -> (shape: UIShape) {
    relativeData := UIData{ relativeX, relativeY, 0, 0 }
    absoluteData := get_absolute_data(relativeData, parentData)
    absoluteData = UIData{ absoluteData.x, absoluteData.y, absoluteW, absoluteH }

    shape = UIShape{
        zindex = zindex,

        boundingData = UIElementData{
            relative = relativeData,
            absolute = absoluteData,
            draw = get_draw_data(absoluteData, parentData),
            useAbs = false
        },
        parentData = parentData,

        shapeData = shapeData,

        lines = lines,
        lineThick = lineThick,
        color = color
    }

    return
}

draw_uishape :: proc(shape: ^UIShape) {
    if shape.boundingData.useAbs {
        absData := shape.boundingData.absolute
        shape.boundingData.absolute = get_absolute_data(shape.boundingData.relative, shape.parentData)
        shape.boundingData.absolute = UIData{
            shape.boundingData.absolute.x, shape.boundingData.absolute.y,
            absData.width, absData.height
        }
    } else {
        shape.boundingData.absolute = get_absolute_data(shape.boundingData.relative, shape.parentData)
    }

    switch v in shape.shapeData {
        case UIRectangleData:
            draw_uishape_rectangle(shape, v)
        case UICircleData:
            draw_uishape_circle(shape, v)
        case UIEllipseData:
            draw_uishape_ellipse(shape, v)
        case UIRingData:
            draw_uishape_ring(shape, v)
        case UITriangleData:
            draw_uishape_triangle(shape, v)
    }
}