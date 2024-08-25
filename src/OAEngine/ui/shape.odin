package ui

import rl "vendor:raylib"
import "core:fmt"
import "core:strings"

UIShapeType :: enum { RECTANGLE, CIRCLE, ELLIPSE, RING, TRIANGLE }

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

set_rectangle_boundingsize_absolute :: proc(data: UIRectangleData, bounding: ^UIData) {
    bounding.width = data.width
    bounding.height = data.height
}

UICircleData :: struct {
    radius: f32,
    gradient: bool,
    sector: struct {
        active: bool,
        startAngle: f32,
        endAngle: f32,
        segments: i32
    }
}

set_circle_boundingsize_absolute :: proc(data: UICircleData, bounding: ^UIData) {
    bounding.width = data.radius * 2.0
    bounding.height = data.radius * 2.0
}

UIEllipseData :: struct {
    radiusW: f32,
    radiusH: f32
}

set_ellipse_boundingsize_absolute :: proc(data: UIEllipseData, bounding: ^UIData) {
    bounding.width = data.radiusW * 2.0
    bounding.height = data.radiusH * 2.0
}

UIRingData :: struct {
    innerRadius: f32,
    outerRadius: f32,
    startAngle: f32,
    endAngle: f32,
    segments: int
}

set_ring_boundingsize_absolute :: proc(data: UIRingData, bounding: ^UIData) {
    bounding.width = data.outerRadius * 2.0
    bounding.height = data.outerRadius * 2.0
}

// Vertexes are in counter-clockwise order.
// The data in the vertex vectors are relative measurements.
// They are relative to the parent UIShape object's absolute data.
UITriangleData :: struct {
    vertex1: rl.Vector2,
    vertex2: rl.Vector2,
    vertex3: rl.Vector2
}

get_trianglevertex_drawposition :: proc(vertex: rl.Vector2, drawBounding: UIData) -> (position: rl.Vector2) {
    position = rl.Vector2{}

    position.x = drawBounding.x + vertex.x * drawBounding.width
    position.y = drawBounding.y + vertex.y * drawBounding.height

    return
}

set_triangle_boundingsize_absolute :: proc(data: UITriangleData, bounding: ^UIData) {
    // If the beginnning vertx is in the middle of the two others, on either axis,
    // then that axis' size is the absolute sum of the differences between both vertexes
    // and the beggining vertex, on said axis.
    // Otherwise, the axis size is the absolute difference between the minimum and maximum vertex.

    // First for width.
    if data.vertex2.x - data.vertex1.x == 0 {
        bounding.width = abs(data.vertex3.x - data.vertex1.x)
    }
    else if data.vertex3.x - data.vertex1.x == 0 {
        bounding.width = abs(data.vertex2.x - data.vertex1.x)
    }
    else if
        (data.vertex2.x - data.vertex1.x) / abs(data.vertex2.x - data.vertex1.x) !=
        (data.vertex3.x - data.vertex1.x) / abs(data.vertex3.x - data.vertex1.x)
    {
        //hello 
        // Vertexes are on either side of original vertex. Sum their distances.
        bounding.width = abs(data.vertex2.x - data.vertex1.x) + abs(data.vertex3.x - data.vertex1.x)
    }
    else if abs(data.vertex2.x - data.vertex1.x) > abs(data.vertex3.x - data.vertex1.x) {
        bounding.width = abs(data.vertex2.x - data.vertex1.x)
    }
    else {
        bounding.width = abs(data.vertex3.x - data.vertex1.x)
    }


    // Then for height.
    if data.vertex2.y - data.vertex1.y == 0 {
        bounding.height = abs(data.vertex3.y - data.vertex1.y)
    }
    else if data.vertex3.y - data.vertex1.y == 0 {
        bounding.height = abs(data.vertex2.y - data.vertex1.y)
    }
    else if
        (data.vertex2.y - data.vertex1.y) / abs(data.vertex2.y - data.vertex1.y) !=
        (data.vertex3.y - data.vertex1.y) / abs(data.vertex3.y - data.vertex1.y)
    {
        // Vertexes are on either side of original vertex. Sum their distances.
        bounding.height = abs(data.vertex2.y - data.vertex1.y) + abs(data.vertex3.y - data.vertex1.y)
    }
    else if abs(data.vertex2.y - data.vertex1.y) > abs(data.vertex3.y - data.vertex1.y) {
        bounding.height = abs(data.vertex2.y - data.vertex1.y)
    }
    else {
        bounding.height = abs(data.vertex3.y - data.vertex1.y)
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

    shapeType: UIShapeType,
    shapeData: UIShapeData,

    lines: bool,
    lineThick: f32,
    color: rl.Color,
}

set_boundingsize_absolute :: proc {
    set_rectangle_boundingsize_absolute,
    set_circle_boundingsize_absolute,
    set_ellipse_boundingsize_absolute,
    set_ring_boundingsize_absolute,
    set_triangle_boundingsize_absolute,
}

draw_uishape :: proc(shape: ^UIShape) {
    shape.boundingData.absolute = get_absolute_data(shape.boundingData.relative, shape.parentData)

    switch v in shape.shapeData {
        case UIRectangleData:
            set_boundingsize_absolute(v, &shape.boundingData.absolute)
            shape.boundingData.draw = get_draw_data(shape.boundingData.absolute, shape.parentData)

            rect := get_rectangle_from_data(shape.boundingData.draw)

            if v.rounded.active {
                if shape.lines {
                    rl.DrawRectangleRoundedLines(rect, v.rounded.roundness, v.rounded.segments, shape.lineThick, shape.color)
                } else {
                    rl.DrawRectangleRounded(rect, v.rounded.roundness, v.rounded.segments, shape.color)
                }

                return
            }

            if v.gradient.active {
                rl.DrawRectangleGradientEx(rect, v.gradient.vertex1, v.gradient.vertex2, v.gradient.vertex3, v.gradient.vertex4)
            }

            if shape.lines {
                rl.DrawRectangleLinesEx(rect, shape.lineThick, shape.color)
            } else {
                rl.DrawRectangleRec(rect, shape.color)
            }

        case UICircleData:
            set_boundingsize_absolute(v, &shape.boundingData.absolute)
            shape.boundingData.draw = get_draw_data(shape.boundingData.absolute, shape.parentData)
        case UIEllipseData:
            set_boundingsize_absolute(v, &shape.boundingData.absolute)
            shape.boundingData.draw = get_draw_data(shape.boundingData.absolute, shape.parentData)
        case UIRingData:
            set_boundingsize_absolute(v, &shape.boundingData.absolute)
            shape.boundingData.draw = get_draw_data(shape.boundingData.absolute, shape.parentData)
        case UITriangleData:
            shape.boundingData.draw = get_draw_data(shape.boundingData.absolute, shape.parentData)

            drawVert1 := get_trianglevertex_drawposition(v.vertex1, shape.boundingData.draw)
            drawVert2 := get_trianglevertex_drawposition(v.vertex2, shape.boundingData.draw)
            drawVert3 := get_trianglevertex_drawposition(v.vertex3, shape.boundingData.draw)

            if shape.lines {
                rl.DrawTriangleLines(drawVert1, drawVert2, drawVert3, shape.color)
            } else {
                rl.DrawTriangle(drawVert1, drawVert2, drawVert3, shape.color)
            }

    }
}