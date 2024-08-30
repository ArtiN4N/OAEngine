package ui

import rl "vendor:raylib"
import "core:fmt"
import "core:strings"

SPACING_DEFAULT :: 2

// A basic text UI element in UI forms.
// Can store a pointer to a bool, int, or string for optional formatted printing with a variable.
UIText :: struct {
    zindex: u32,

    data: UIElementData,
    parentData: ^UIData,

    content: string,
    // No_nil union will default to bool, in case text has no variable formatting.
    format: union #no_nil { bool, ^bool, ^int, ^string},

    // Set fontsize to 0 to indicate that the provided height (normally not used) is to be used for the font size.
    // Fontsize is roughly equal to the height in pixels of the text.
    fontsize: f32,
    fontSpacing: f32,

    color: rl.Color,
    font: UIFont
}

init_uitext_relative :: proc(
    zindex: u32,
    relativeX, relativeY, relativeW, relativeH: f32,
    parentData: ^UIData,
    content: string, textFormat: union #no_nil { bool, ^bool, ^int, ^string },
    fontsize: f32 = 0, fontSpacing: f32 = SPACING_DEFAULT,
    color: rl.Color, font: UIFont = false
) -> (text: UIText) {
    relativeData := UIData{ relativeX, relativeY, relativeW, relativeH }
    absoluteData := get_absolute_data(relativeData, parentData)
    text = {
        zindex = zindex,

        data = UIElementData{
            relative = relativeData,
            absolute = absoluteData,
            draw = get_draw_data(absoluteData, parentData),
            useAbs = false
        },
        parentData = parentData,

        content = content,
        format = textFormat,

        fontsize = fontsize,
        fontSpacing = fontSpacing,

        color = color,
        // Default the font (stored with a no_nil union) to storing "false".
        // This indicates to the program to use raylib's default font.
        // Can set this font using the "set_uifont" procedure
        font = UIFont{}
    }

    return
}

init_uitext_absolute_size :: proc(
    zindex: u32,
    relativeX, relativeY: f32,
    absoluteW, absoluteH: f32,
    parentData: ^UIData,
    content: string, textFormat: union #no_nil { bool, ^bool, ^int, ^string },
    fontsize: f32 = 0, fontSpacing: f32 = SPACING_DEFAULT,
    color: rl.Color, font: UIFont = false
) -> (text: UIText) {
    relativeData := UIData{ relativeX, relativeY, 0, 0 }
    absoluteData := get_absolute_data(relativeData, parentData)
    absoluteData = UIData{ absoluteData.x, absoluteData.y, absoluteW, absoluteH }

    text = {
        zindex = zindex,

        data = UIElementData{
            relative = relativeData,
            absolute = absoluteData,
            draw = get_draw_data(absoluteData, parentData),
            useAbs = false
        },
        parentData = parentData,

        content = content,
        format = textFormat,

        fontsize = fontsize,
        fontSpacing = fontSpacing,

        color = color,
        // Default the font (stored with a no_nil union) to storing "false".
        // This indicates to the program to use raylib's default font.
        // Can set this font using the "set_uifont" procedure
        font = UIFont{}
    }

    return
}

draw_uitext :: proc(text: ^UIText) {
    // If using a formatting variable, extract it into the cstring.
    cstr: cstring
    switch v in text.format {
        case bool:
            cstr = fmt.caprint(text.content)
        case ^bool:
            cstr = fmt.caprintf(text.content, v^)
        case ^int:
            cstr = fmt.caprintf(text.content, v^)
        case ^string:
            cstr = fmt.caprintf(text.content, v^)
    }

    // Update the absolute and for-drawing data for the element.
    if text.data.useAbs {
        absData := text.data.absolute
        text.data.absolute = get_absolute_data(text.data.relative, text.parentData)
        text.data.absolute = UIData{ text.data.absolute.x, text.data.absolute.y, absData.width, absData.height }
    } else {
        text.data.absolute = get_absolute_data(text.data.relative, text.parentData)
    }

    // A fontsize of 0 indicates that the user wants to use their provided height for the text,
    // as the fontsize used to draw.
    fontsize := f32(text.data.absolute.height)
    if text.fontsize > 0 {
        fontsize = text.fontsize
    }

    // get the size of the text field for position calculations
    realSize := rl.MeasureTextEx(get_fontdata(text.font), cstr, fontsize, text.fontSpacing)

    text.data.absolute.width  = realSize.x
    text.data.absolute.height = realSize.y
    text.data.draw = get_draw_data(text.data.absolute, text.parentData)

    rl.DrawTextEx(
        get_fontdata(text.font), cstr,
        get_posvector_from_data(text.data.draw),
        fontsize, text.fontSpacing, text.color
    )

    delete(cstr)
}