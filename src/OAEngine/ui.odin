package OAEngine

import "core:fmt"
import math_bits "core:math/bits"
import rl "vendor:raylib"


UITextInput :: struct {
    zindex: u32,
}

draw_uitextinput :: proc(textInp: UITextInput) {

}

UIImage :: struct {
    zindex: u32,
}

draw_uiimage :: proc(img: UIImage) {

}

UIShape :: struct {
    zindex: u32,
}

draw_uishape :: proc(shape: UIShape) {

}

UIButton :: struct {
    zindex: u32,
}

draw_uibutton :: proc(button: UIButton) {

}

UIText :: struct {
    zindex: u32,
}

draw_uitext :: proc(text: UIText) {

}

draw_uielement :: proc{
    draw_uitext, draw_uibutton,
    draw_uishape, draw_uiimage,
    draw_uitextinput
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

    elements: struct {
        texts: [dynamic]UIText,
        buttons: [dynamic]UIButton,
        shapes: [dynamic]UIShape,
        images: [dynamic]UIImage,
        textInputs: [dynamic]UITextInput,
    },
}

init_uiform :: proc(
    active: bool, 
    x: i32, y: i32, w: i32, h: i32, 
    c: rl.Color,
    txtSize: int, btnSize: int, shpeSize: int, imgSize: int, txtInpSize: int
) -> UIForm {
    return UIForm{
        active = active,
        parent = {},
        x = x, y = y, 
        width = w, height = h, 
        color = c,
        elements = {
            texts = make([dynamic]UIText, txtSize, txtSize),
            buttons = make([dynamic]UIButton, btnSize, btnSize),
            shapes = make([dynamic]UIShape, shpeSize, shpeSize),
            images = make([dynamic]UIImage, imgSize, imgSize),
            textInputs = make([dynamic]UITextInput, txtInpSize, txtInpSize),
        }
    }
}

destroy_uiform :: proc(form: ^UIForm) {
    delete(form.elements.texts)
    delete(form.elements.buttons)
    delete(form.elements.shapes)
    delete(form.elements.images)
    delete(form.elements.textInputs)
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

draw_uiform :: proc(form: ^UIForm) {

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
    txtIndx, btnIndx, shpeIndx, imgIndx, txtInpIndx := 0, 0, 0, 0, 0
    selectedIndx := &txtIndx

    for i := 0; i < 
    len(form.elements.texts) + len(form.elements.buttons) + 
    len(form.elements.shapes) + len(form.elements.images) + 
    len(form.elements.textInputs); 
    i += 1 {
        // set lowestz to max value of u32
        lowestz: u32 = math_bits.U32_MAX
        fmt.printfln("lowest = {0}", lowestz)

        lowestz = min(
            form.elements.texts[txtIndx].zindex, form.elements.buttons[btnIndx].zindex, 
            form.elements.shapes[shpeIndx].zindex, form.elements.images[imgIndx].zindex, 
            form.elements.textInputs[txtInpIndx].zindex
        )

        selectedIndx = &txtIndx if form.elements.texts[txtIndx].zindex == lowestz else selectedIndx
        selectedIndx = &btnIndx if form.elements.buttons[btnIndx].zindex == lowestz else selectedIndx
        selectedIndx = &shpeIndx if form.elements.shapes[shpeIndx].zindex == lowestz else selectedIndx
        selectedIndx = &imgIndx if form.elements.images[imgIndx].zindex == lowestz else selectedIndx
        selectedIndx = &txtInpIndx if form.elements.textInputs[txtInpIndx].zindex == lowestz else selectedIndx

        switch selectedIndx {
            case &txtIndx:
                draw_uielement(form.elements.texts[selectedIndx^])
            case &btnIndx:
                draw_uielement(form.elements.buttons[selectedIndx^])
            case &shpeIndx:
                draw_uielement(form.elements.shapes[selectedIndx^])
            case &imgIndx:
                draw_uielement(form.elements.images[selectedIndx^])
            case &txtInpIndx:
                draw_uielement(form.elements.textInputs[selectedIndx^])
        }
        
        selectedIndx^ += 1
    }
}