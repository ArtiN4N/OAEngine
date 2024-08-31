package ui

import rl "vendor:raylib"
import "core:fmt"
import "core:strings"

UIImage :: struct {
    zindex: u32,

    data: UIElementData,
    parentData: ^UIData,

    rotation: f32,
    tint: rl.Color,

    texture: ^rl.Texture2D,

    scale: struct {
        active: bool,
        scalar: f32
    }
}

init_uiimage :: proc() {
    
}

draw_uiimage :: proc(img: UIImage) {

}

