package OAEngine

import "core:fmt"
import rl "vendor:raylib"

State :: struct {
    cfg: Configs,
    cam: rl.Camera2D,
}

// Deletes a state struct
destroy_state :: proc(using state: ^State) {

}

//
init_raylib_window :: proc(using state: ^State) {
    create_flags_from_state(&state.cfg)

    rl.SetConfigFlags(state.cfg.flags)

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
