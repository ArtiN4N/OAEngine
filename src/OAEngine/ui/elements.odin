package ui

import rl "vendor:raylib"
import "core:fmt"
import "core:strings"

UITextInput :: struct {
    zindex: u32,

    data: UIElementData,
    parentData: ^UIData,

    content: string,
    // Shows a default string when the input is empty.
    defaultContent: string,

    fontsize: f32,
    fontSpacing: f32,

    color: rl.Color,
    font: UIFont
}

draw_uitextinput :: proc(textInp: UITextInput) {

}

draw_uielement :: proc{draw_uitext, draw_uibutton, draw_uishape, draw_uiimage, draw_uitextinput}
