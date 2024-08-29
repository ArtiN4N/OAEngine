package ui

import rl "vendor:raylib"
import "core:fmt"

// Essentially a rectangle (sometimes) containing text within.
// When clicked, the callback procedure assigned to the button runs.
UIButton :: struct {
    zindex: u32,

    data: UIElementData,
    parentData: ^UIData,

    color: rl.Color,

    // The optional text. Since the text doesnt exist in memory,
    // instead of having the option of it just not existing, the text should be set to an empty string.
    label: UIText,

    // The callback function, that serves as the button's functionality
    callback: proc(),
}

init_uibutton :: proc(
    zindex: u32,
    relativeX, relativeY, relativeW, relativeH: f32,
    parentData: ^UIData,
    color: rl.Color,
    callback: proc()
) -> (button: UIButton) {
    relativeData := UIData{ relativeX, relativeY, relativeW, relativeH }
    absoluteData := get_absolute_data(relativeData, parentData)

    button = UIButton{
        zindex = zindex,

        data = UIElementData{
            relative = relativeData,
            absolute = absoluteData,
            draw = get_draw_data(button.data.absolute, parentData)
        },
        parentData = parentData,

        color = color,

        label = UIText{},

        callback = callback
    }

    return
}

// Button labels must be attached after they are saved in an array attached to a state struct.
// This is because the label requires a pointer to the data of the button.
// But if the label is created early, the defined button instance will go out of scope, and with it, the pointer.
// So instead, create the button, duplicate the data to a spot where it wont go out of scope,
// and use that pointer for the label.
add_uibutton_label :: proc(
    button: ^UIButton,
    labelZindex: u32,
    labelRelativeX, labelRelativeY, labelRelativeW, labelRelativeH: f32,
    labelContent: string, labelTextFormat: union #no_nil { bool, ^bool, ^int, ^string },
    labelFontsize: f32 = 0, labelFontSpacing: f32 = SPACING_DEFAULT,
    labelColor: rl.Color, labelFont: UIFont = false
) {
    button.label = init_uitext(
        labelZindex,
        labelRelativeX, labelRelativeY, labelRelativeW, labelRelativeH,
        &button.data.absolute,
        labelContent, labelTextFormat,
        labelFontsize, labelFontSpacing,
        labelColor, labelFont
    )

    return
}

draw_uibutton :: proc(button: ^UIButton) {
    button.data.absolute = get_absolute_data(button.data.relative, button.parentData)
    button.data.draw = get_draw_data(button.data.absolute, button.parentData)

    rl.DrawRectangleV(
        get_posvector_from_data(button.data.draw),
        get_sizevector_from_data(button.data.draw),
        button.color
    )

    // Don't bother if empty string.
    // Should make checkboxes more efficient.
    if button.label.content != "" {
        draw_uielement(&button.label)
    }
}