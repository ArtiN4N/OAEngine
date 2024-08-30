package ui

import "core:fmt"
import math_bits "core:math/bits"
import rl "vendor:raylib"

// base struct that holds position and size for all Ui elements
UIData :: struct {
    x: f32,
    y: f32,
    width: f32,
    height: f32,
}

// stores relative, absolute, and for-drawing copies of position/size data
// all UI elements use relative positioning and sizing as a defualt
// since absolute measurements are requied to anchor those relative measurements,
// and UI elements are nested within other UI elements,
// each UI element must store its absolute measurement to serve as the parent measurements
// for another, relatively measured UI element
// All measurements assume an origin in the middle of the bounding box for the element,
// so the for-drawing copy acts as a convienient lookup for the data needed to draw things.
UIElementData :: struct {
    relative: UIData,
    absolute: UIData,
    draw: UIData,
    useAbs: bool
}

// UI forms are relative to the window.
// Since the window can be resized, pointers to ints are needed.
UIFormParent :: struct {
    x, y, width, height: f32
}

// The basic UI element. Acts as a container for a variable number of UI elements
// Size and position is measured relative to the window.
// Has a background color as a minimum component.
UIForm :: struct {
    active: bool,

    data: UIElementData,
    parentData: ^UIFormParent,
    color: rl.Color,
    square: bool,

    texts: [dynamic]UIText,
    buttons: [dynamic]UIButton,
    shapes: [dynamic]UIShape,
    images: [dynamic]UIImage,
    textInputs: [dynamic]UITextInput,
}

init_uiform_relative :: proc(
    relativeX, relativeY, relativeW, relativeH: f32,
    parentData: ^UIFormParent,
    color: rl.Color,
    square: bool,
) -> (form: UIForm) {
    relativeData := UIData{ relativeX, relativeY, relativeW, relativeH }
    absoluteData := get_absolute_data(relativeData, parentData)

    form = UIForm{
        active = false,

        data = UIElementData{
            relative = relativeData,
            absolute = absoluteData,
            draw = get_draw_data(absoluteData, parentData),
            useAbs = false
        },
        parentData = parentData,
        color = color,
        square = square,
        texts = make([dynamic]UIText),
        buttons = make([dynamic]UIButton),
        shapes = make([dynamic]UIShape),
        images = make([dynamic]UIImage),
        textInputs = make([dynamic]UITextInput),
    }

    return
}


init_uiform_absolute_size :: proc(
    relativeX, relativeY: f32,
    absoluteW, absoluteH: f32,
    parentData: ^UIFormParent,
    color: rl.Color,
    square: bool,
) -> (form: UIForm) {
    relativeData := UIData{ relativeX, relativeY, 0, 0 }
    absoluteData := get_absolute_data(relativeData, parentData)
    absoluteData = UIData{ absoluteData.x, absoluteData.y, absoluteW, absoluteH }

    if square {
        if absoluteData.height > absoluteData.width {
            absoluteData.height = absoluteData.width
        } else if absoluteData.height < absoluteData.width {
            absoluteData.width = absoluteData.height
        }
    }

    form = UIForm{
        active = false,

        data = UIElementData{
            relative = relativeData,
            absolute = absoluteData,
            draw = get_draw_data(absoluteData, parentData),
            useAbs = true
        },
        parentData = parentData,
        color = color,
        square = square,
        texts = make([dynamic]UIText),
        buttons = make([dynamic]UIButton),
        shapes = make([dynamic]UIShape),
        images = make([dynamic]UIImage),
        textInputs = make([dynamic]UITextInput),
    }

    return
}

add_texts_to_uiform :: proc(form: ^UIForm, texts: ..UIText) {
    append(&form.texts, ..texts)
}

add_buttons_to_uiform :: proc(form: ^UIForm, buttons: ..UIButton) {
    append(&form.buttons, ..buttons)
}

add_shapes_to_uiform :: proc(form: ^UIForm, shapes: ..UIShape) {
    append(&form.shapes, ..shapes)
}

add_images_to_uiform :: proc(form: ^UIForm, images: ..UIImage) {
    append(&form.images, ..images)
}

add_textinputs_to_uiform :: proc(form: ^UIForm, textinputs: ..UITextInput) {
    append(&form.textInputs, ..textinputs)
}

add_to_uiform :: proc{
    add_texts_to_uiform,
    add_buttons_to_uiform,
    add_shapes_to_uiform,
    add_images_to_uiform,
    add_textinputs_to_uiform,
}

delete_uiform :: proc(form: ^UIForm) {
    delete(form.texts)
    delete(form.buttons)
    delete(form.shapes)
    delete(form.images)
    delete(form.textInputs)
}

draw_uiform :: proc(form: ^UIForm) {
    if form.data.useAbs {
        absData := form.data.absolute
        form.data.absolute = get_absolute_data(form.data.relative, form.parentData)
        form.data.absolute = UIData{ form.data.absolute.x, form.data.absolute.y, absData.width, absData.height }
    } else {
        form.data.absolute = get_absolute_data(form.data.relative, form.parentData)
    }

    if form.square {
       if form.data.absolute.height > form.data.absolute.width {
        form.data.absolute.height = form.data.absolute.width
        } else if form.data.absolute.height < form.data.absolute.width {
            form.data.absolute.width = form.data.absolute.height
        }
    }

    form.data.draw = get_draw_data(form.data.absolute, form.parentData)

    rl.DrawRectangleV(
        get_posvector_from_data(form.data.draw),
        get_sizevector_from_data(form.data.draw),
        form.color
    )

    // loop through each array of ui elements.
    // we assume that each array is already sorted by zindex
    // continually grab the element with the lowest zindex and draw it
    txts := form.texts
    btns := form.buttons
    shps := form.shapes
    imgs := form.images
    tIns := form.textInputs

    txtIndx, btnIndx, shpIndx, imgIndx, tInIndx := 0, 0, 0, 0, 0
    selectedIndx := &txtIndx

    check_zindex :: proc(array: $A/[]$T, index: ^int, lowest: ^u32, selIndex: ^^int) {
        if len(array) > index^ {
            cur := array[index^]
            if cur.zindex < lowest^ {
                lowest^ = cur.zindex
                selIndex^ = index
            }
        }
    }

    totalElements := len(txts) + len(btns) + len(shps) + len(imgs) + len(tIns)
    for i := 0; i < totalElements; i += 1 {
        // set lowestz to max value of u32
        lowestz: u32 = math_bits.U32_MAX

        check_zindex(txts[:], &txtIndx, &lowestz, &selectedIndx)
        check_zindex(btns[:], &btnIndx, &lowestz, &selectedIndx)
        check_zindex(shps[:], &shpIndx, &lowestz, &selectedIndx)
        check_zindex(imgs[:], &imgIndx, &lowestz, &selectedIndx)
        check_zindex(tIns[:], &tInIndx, &lowestz, &selectedIndx)

        switch selectedIndx {
            case &txtIndx:
                draw_uielement(&txts[selectedIndx^])
            case &btnIndx:
                draw_uielement(&btns[selectedIndx^])
            case &shpIndx:
                draw_uielement(&shps[selectedIndx^])
            case &imgIndx:
                //draw_uielement(&imgs[selectedIndx^])
            case &tInIndx:
                //draw_uielement(&tIns[selectedIndx^])
        }

        selectedIndx^ += 1
    }
}
