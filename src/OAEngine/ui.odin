package OAEngine

import "core:fmt"
import rl "vendor:raylib"


UIInput :: struct {
    
}

UIImage :: struct {
    
}

UIShape :: struct {
    
}

UIButton :: struct {
    
}

UIText :: struct {

}

UIParent :: struct {
    
}

UIForm :: struct {
    active: bool,

    // Whether the size, position is relative to its parent container
    // relative sizes are out of a ratio to 1000
    // meaning that a value of 0 is 0% of its parents, 500 50%, 1000 100%
    parent: struct {
        relative: bool,
        x: i32,
        y: i32,
        width: i32,
        height: i32,
    },

    x: i32,
    y: i32,
    width: i32,
    height: i32,

    color: rl.Color,
}

init_uiform :: proc(active: bool, x: i32, y: i32, width: i32, height: i32, color: rl.Color) -> UIForm {
    return {
        active,
        {},
        x, y, width, height, 
        color,
    }
}

add_uiparent_from_form :: proc(form: ^UIForm, rel: bool, parent: UIForm) {
    if !parent.parent.relative {
        form.parent = { rel, parent.x, parent.y, parent.width, parent.height }
        return
    }
    
    // calculate absolute size of parent from the relative size of the parents parent
    realW := i32( f32(parent.width) / 1000 * f32(parent.parent.width) )
    realH := i32( f32(parent.height) / 1000 * f32(parent.parent.height) )

    realX := i32( f32(parent.parent.x) + f32(parent.x) / 1000 * f32(parent.parent.width) )
    realY := i32( f32(parent.parent.y) + f32(parent.y) / 1000 * f32(parent.parent.height) )

    form.parent = { rel, realX, realY, realW, realH }
}

add_uiparent_from_dimension :: proc(form: ^UIForm, rel: bool, pX: i32, pY: i32, pW: i32, pH: i32) {
    form.parent = { rel, pX, pY, pW, pH }
}

add_uiparent :: proc{ add_uiparent_from_form, add_uiparent_from_dimension }

draw_form :: proc(form: UIForm) {

    dX := form.x
    dY := form.y
    dW := form.width
    dH := form.height

    if form.parent.relative {
        dW = i32( f32(dW) / 1000 * f32(form.parent.width) )
        dH = i32( f32(dH) / 1000 * f32(form.parent.height) )

        dX = i32( f32(form.parent.x) + f32(dX) / 1000 * f32(form.parent.width) )
        dY = i32( f32(form.parent.y) + f32(dY) / 1000 * f32(form.parent.height) )
    }

    rl.DrawRectangle(dX, dY, dW, dH, form.color)
}