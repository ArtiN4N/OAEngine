package OAEngine

import "core:fmt"
import rl "vendor:raylib"

Configs :: struct {
    windowWidth: i32,
    windowHeight: i32,
    windowTitle: cstring,
    targetFPS: i32,
    vsync: bool,
    fullscreen: bool,
    resizeable: bool,
}

State :: struct {
    cfg: Configs,
}

// Deletes a state struct
destroy_state :: proc(using state: ^State) {

}

//
init_raylib_window :: proc(using state: ^State) {
    flags: rl.ConfigFlags = {}
    if cfg.vsync {
        flags += {rl.ConfigFlag.VSYNC_HINT}
    }
    if cfg.fullscreen {
        flags += {rl.ConfigFlag.FULLSCREEN_MODE}
    }
    if cfg.resizeable {
        flags += {rl.ConfigFlag.WINDOW_RESIZABLE}
    }

    rl.SetConfigFlags(flags)

    rl.InitWindow(cfg.windowWidth, cfg.windowHeight, cfg.windowTitle)
    rl.SetTargetFPS(cfg.targetFPS)
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
