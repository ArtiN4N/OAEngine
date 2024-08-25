package ui

import "core:fmt"
import rl "vendor:raylib"

// This function is used for easy access to rl vectors for rl drawing functions.
get_posvector_from_data :: proc(data: UIData) -> (position: rl.Vector2) {
    position = rl.Vector2{ data.x, data.y }
    return
}

// This function is used for easy access to rl vectors for rl drawing functions.
get_sizevector_from_data :: proc(data: UIData) -> (position: rl.Vector2) {
    position = rl.Vector2{ data.width, data.height }
    return
}

get_rectangle_from_data :: proc(data: UIData) -> (rect: rl.Rectangle) {
    rect = rl.Rectangle{ data.x, data.y, data.width, data.height }
    return
}

// Transforms absolute positions to for-drawing positions.
// For forms only, and uses pointer to a formparent.
get_draw_formdata :: proc(absoluteData: UIData, parentDimension: ^UIFormParent) -> (drawData: UIData) {
    parentData := parentDimension^
    drawData = UIData{
        // Origin is set to the middle of the bounding box for elements,
        // so subtract half the relevant axis' size to move it back to the northwest corner.
        x      = absoluteData.x - absoluteData.width / 2.0,
        y      = absoluteData.y - absoluteData.height / 2.0,

        // width and height stay unchanged
        width  = absoluteData.width,
        height = absoluteData.height,
    }

    return
}

// Transforms absolute positions to for-drawing positions.
// For elements only, and uses parent UIData.
get_draw_elementdata :: proc(absoluteData: UIData, parentData: ^UIData) -> (drawData: UIData) {
    parentData := parentData^
    drawData = UIData{
        // Origin is set to the middle of the bounding box for elements,
        // so subtract half the relevant axis' size to move it back to the northwest corner.
        x      = absoluteData.x - absoluteData.width / 2.0,
        y      = absoluteData.y - absoluteData.height / 2.0,

        // width and height stay unchanged
        width  = absoluteData.width,
        height = absoluteData.height,
    }

    return
}

get_draw_data :: proc { get_draw_formdata, get_draw_elementdata }

// Transforms relative data into absolute data.
// For forms only, and uses pointer to a formparent.
get_absolute_formdata :: proc(relativeData: UIData, parentDimension: ^UIFormParent) -> (absoluteData: UIData) {
    parentData := parentDimension^
    absoluteData = UIData{
        // relative measurements are on a scale of 0-1.
        // 1 = 100%, 0 = 0%.
        // relative positions start at the origin, so add 1 to the relative ratio.
        x      = parentData.x + (parentData.width / 2.0) + relativeData.x * parentData.width,
        y      = parentData.y + (parentData.height / 2.0) + relativeData.y * parentData.height,
        width  = parentData.width  * relativeData.width,
        height = parentData.height * relativeData.height,
    }

    return
}

// Transforms relative data into absolute data.
// For elements only, and uses parent UIData.
get_absolute_elementdata :: proc(relativeData: UIData, parentData: ^UIData) -> (absoluteData: UIData) {
    parentData := parentData^
    absoluteData = UIData{
        // relative measurements are on a scale from 0-1000.
        // 1000 = 100%, 0 = 0%.
        // relative positions start at the origin, so add 1 to the relative ratio.
        x      = parentData.x + relativeData.x * parentData.width,
        y      = parentData.y + relativeData.y * parentData.height,
        width  = parentData.width  * relativeData.width,
        height = parentData.height * relativeData.height,
    }

    return
}

get_absolute_data :: proc{ get_absolute_formdata, get_absolute_elementdata }