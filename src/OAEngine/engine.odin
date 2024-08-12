package OAEngine

import "core:fmt"
import rl "vendor:raylib"

Configs :: struct {
    windowWidth: i32,
    windowHeight: i32,
    windowTitle: cstring,
}

State :: struct {
    cfg: Configs,
}

set_state_cfgs_window :: proc(using config: ^Configs, width: i32, height: i32, title: cstring) {
    windowWidth = width
    windowHeight = height
    windowTitle = title
}

// Deletes a state struct
destroy_state :: proc(using state: ^State) {

}

//
init_raylib_window :: proc(using state: ^State) {
    rl.InitWindow(cfg.windowWidth, cfg.windowHeight, cfg.windowTitle)

    rl.SetTargetFPS(60)
}

//
destroy_raylib_window :: proc() {
   rl.CloseWindow()
}

// Checks to see if

draw :: proc(using state: ^State) {
    rl.BeginDrawing()
    defer rl.EndDrawing()

    rl.ClearBackground(rl.RAYWHITE)

    rl.DrawFPS(10, 10)
}
