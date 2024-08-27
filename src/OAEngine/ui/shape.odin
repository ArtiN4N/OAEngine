package ui

import rl "vendor:raylib"
import "core:fmt"
import "core:strings"

UIRectangleData :: struct {
    width: f32,
    height: f32,
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
    width: f32,
    height: f32,

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
        width = width,
        height = height,

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

set_rectangle_boundingsize_absolute :: proc(data: UIRectangleData, bounding: ^UIData) {
    bounding.width = data.width
    bounding.height = data.height
}

draw_uishape_rectangle :: proc(shape: ^UIShape, data: UIRectangleData) {
    set_boundingsize_absolute(data, &shape.boundingData.absolute)
    shape.boundingData.draw = get_draw_data(shape.boundingData.absolute, shape.parentData)

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
    radius: f32,
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
    radius: f32,

    gradient: bool = false,
    color2: rl.Color = rl.WHITE,

    sector: bool = false,
    startAngle: f32 = 0,
    endAngle: f32 = 0,
    segments: i32 = 1
) -> (data: UICircleData) {
    data = UICircleData{
        radius = radius,
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

set_circle_boundingsize_absolute :: proc(data: UICircleData, bounding: ^UIData) {
    bounding.width = data.radius * 2.0
    bounding.height = data.radius * 2.0
}

draw_uishape_circle :: proc(shape: ^UIShape, data: UICircleData) {
    set_boundingsize_absolute(data, &shape.boundingData.absolute)
    shape.boundingData.draw = get_draw_data(shape.boundingData.absolute, shape.parentData)

    center := get_posvector_from_data(shape.boundingData.draw)

    if data.gradient.active {
        rl.DrawCircleGradient(
            i32(shape.boundingData.draw.x), i32(shape.boundingData.draw.y), data.radius,
            shape.color, data.gradient.color2
        )

        return
    }

    if data.sector.active {
        if shape.lines {
            rl.DrawCircleSectorLines(
                center, data.radius,
                data.sector.startAngle, data.sector.endAngle, data.sector.segments,
                shape.color
            )
        } else {
            rl.DrawCircleSector(
                center, data.radius,
                data.sector.startAngle, data.sector.endAngle, data.sector.segments,
                shape.color
            )
        }

        return
    }

    if shape.lines {
        rl.DrawCircleLinesV(center, data.radius, shape.color)
    } else {
        rl.DrawCircleV(center, data.radius, shape.color)
    }
}

UIEllipseData :: struct {
    radiusHori: f32,
    radiusVert: f32
}

init_uishapedata_ellipse :: proc(
    radiusHori: f32,
    radiusVert: f32
) -> (data: UIEllipseData) {
    data = UIEllipseData{
        radiusHori = radiusHori,
        radiusVert = radiusVert
    }

    return
}

set_ellipse_boundingsize_absolute :: proc(data: UIEllipseData, bounding: ^UIData) {
    bounding.width = data.radiusHori * 2.0
    bounding.height = data.radiusVert * 2.0
}

draw_uishape_ellipse :: proc(shape: ^UIShape, data: UIEllipseData) {
    set_boundingsize_absolute(data, &shape.boundingData.absolute)
    shape.boundingData.draw = get_draw_data(shape.boundingData.absolute, shape.parentData)

    if shape.lines {
        rl.DrawEllipseLines(
            i32(shape.boundingData.draw.x), i32(shape.boundingData.draw.y),
            data.radiusHori, data.radiusVert,
            shape.color
        )
    } else {
        rl.DrawEllipse(
            i32(shape.boundingData.draw.x), i32(shape.boundingData.draw.y),
            data.radiusHori, data.radiusVert,
            shape.color
        )
    }
}

UIRingData :: struct {
    innerRadius: f32,
    outerRadius: f32,
    startAngle: f32,
    endAngle: f32,
    segments: i32
}

init_uishapedata_ring :: proc(
    innerRadius: f32,
    outerRadius: f32,
    startAngle: f32,
    endAngle: f32,
    segments: i32
) -> (data: UIRingData) {
    data = UIRingData{
        innerRadius = innerRadius,
        outerRadius = outerRadius,
        startAngle = startAngle,
        endAngle = endAngle,
        segments = segments
    }

    return
}

set_ring_boundingsize_absolute :: proc(data: UIRingData, bounding: ^UIData) {
    bounding.width = data.outerRadius * 2.0
    bounding.height = data.outerRadius * 2.0
}

draw_uishape_ring :: proc(shape: ^UIShape, data: UIRingData) {
    set_boundingsize_absolute(data, &shape.boundingData.absolute)
    shape.boundingData.draw = get_draw_data(shape.boundingData.absolute, shape.parentData)

    center := get_posvector_from_data(shape.boundingData.draw)

    if shape.lines {
        rl.DrawRingLines(
            center, data.innerRadius, data.outerRadius,
            data.startAngle, data.endAngle, data.segments,
            shape.color
        )
    } else {
        rl.DrawRing(
            center, data.innerRadius, data.outerRadius,
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

init_uishape :: proc(
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

    switch v in shapeData {
        case UIRectangleData:
            set_boundingsize_absolute(v, &absoluteData)
        case UICircleData:
            set_boundingsize_absolute(v, &absoluteData)
        case UIEllipseData:
            set_boundingsize_absolute(v, &absoluteData)
        case UIRingData:
            set_boundingsize_absolute(v, &absoluteData)
        case UITriangleData:
    }

    shape = UIShape{
        zindex = zindex,

        boundingData = UIElementData{
            relative = relativeData,
            absolute = absoluteData,
            draw = get_draw_data(absoluteData, parentData)
        },
        parentData = parentData,

        shapeData = shapeData,

        lines = lines,
        lineThick = lineThick,
        color = color
    }

    return
}

set_boundingsize_absolute :: proc {
    set_rectangle_boundingsize_absolute,
    set_circle_boundingsize_absolute,
    set_ellipse_boundingsize_absolute,
    set_ring_boundingsize_absolute,
}

draw_uishape :: proc(shape: ^UIShape) {
    shape.boundingData.absolute = get_absolute_data(shape.boundingData.relative, shape.parentData)

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