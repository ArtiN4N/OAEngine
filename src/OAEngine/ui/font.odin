package ui

import "core:fmt"
import rl "vendor:raylib"


// Setting a font to the raylib default font function's return causes errors.
// The function only seems to work if its not stored.
// Thus, we use a union with the no_nil directive.
// Actual fonts are stored as pointers to fonts within a state or memory struct that contains assets.
UIFont :: union #no_nil { bool, ^rl.Font }

// Sets a uifont to a pointer to a font.
set_uifont :: proc(font: ^UIFont, ptr: ^rl.Font) {
    font := font
    font^ = ptr
}

// Return font if stored, and return of raylib's default font function otherwise.
get_fontdata :: proc(font: UIFont) -> rl.Font {
    switch v in font {
        case bool:
            return rl.GetFontDefault()
        case ^rl.Font:
            return v^
    }

    return rl.GetFontDefault()
}