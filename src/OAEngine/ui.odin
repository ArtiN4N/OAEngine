package OAEngine

import "core:fmt"
import rl "vendor:raylib"


UITextInput :: struct {
    zindex: u32,
}

UIImage :: struct {
    zindex: u32,
}

UIShape :: struct {
    zindex: u32,
}

UIButton :: struct {
    zindex: u32,
}

UIText :: struct {
    zindex: u32,
}

UIInfo :: struct {
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

UIForm :: struct(T: int, B: int, S: int, I: int, TI: int) {
    info: UIInfo,

    texts: [T]UIText,
    buttons: [B]UIButton,
    shapes: [S]UIShape,
    images: [I]UIImage,
    textInputs: [TI]UITextInput,
}

init_uiform :: proc(
    active: bool, 
    x: i32, y: i32, w: i32, h: i32, 
    c: rl.Color,
    $T: int, $B: int, $S: int, $I: int, $TI: int
) -> UIForm(T, B, S, I, TI) {
    return UIForm(T, B, S, I, TI){
        UIInfo{
            active = active,
            parent = {},
            x = x, y = y, width = w, height = h, 
            color = c,
        },
        {}, {}, {}, {}, {},
    }
}

add_uiparent_from_form :: proc(form: ^UIInfo, rel: bool, parent: UIInfo) {
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

add_uiparent_from_dimension :: proc(form: ^UIInfo, rel: bool, pX: i32, pY: i32, pW: i32, pH: i32) {
    form.parent = { rel, pX, pY, pW, pH }
}

add_uiparent :: proc{ add_uiparent_from_form, add_uiparent_from_dimension }

draw_uiform :: proc(form: UIForm($T, $B, $S, $I, $TI)) {

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

    // loop through each array of ui elements.
    // we assume that each array is already sorted by zindex
    // continually grab the element with the lowest zindex and draw it
    txtIndx, btnIndx, shpeIndx, imgIndx, txtInpIndx := 0
    selected := &form.texts
    selectedIndx := &txtIndx

    for i := 0; i < T + B + S + I + TI; i += 1 {
        // set lowestz to max value of u32
        lowestz = 0 - 1
        fmt.printfln("lowest = {0}", lowestz)

        lowestz = min(
            form.texts[txtIndx].zindex, form.buttons[btnIndx].zindex, 
            form.shapes[shpeIndx].zindex, form.images[imgIndx].zindex, 
            form.textInputs[txtInpIndx].zindex
        )

        selectedIndx, selected = &txtIndx, &form.texts if form.texts[txtIndx].zindex == lowestz else selectedIndx, selected
        selectedIndx, selected = &btnIndx, &form.buttons if form.buttons[btnIndx].zindex == lowestz else selectedIndx, selected
        selectedIndx, selected = &shpeIndx, &form.shapes if form.shapes[shpeIndx].zindex == lowestz else selectedIndx, selected
        selectedIndx, selected = &imgIndx, &form.images if form.images[imgIndx].zindex == lowestz else selectedIndx, selected
        selectedIndx, selected = &txtInpIndx, &form.textInputs if form.textInputs[txtInpIndx].zindex == lowestz else selectedIndx, selected

        draw_uielement(selected[selectedIndx])
        selectedIndx += 1
    }

    for text in form.texts {
        draw_uitext(text)
    }
}