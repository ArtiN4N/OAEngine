package OAEngine

import "core:fmt"
import rl "vendor:raylib"

State :: struct {
    cfg: Configs,
    cam: Camera,
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

draw :: proc(using state: ^State) {
    rl.BeginDrawing()
    defer rl.EndDrawing()

    rl.ClearBackground(rl.RAYWHITE)

    rl.DrawFPS(10, 10)

    if state.cfg.useCam {
        rl.BeginMode2D(state.cam)
        draw_with_camera(state)
        rl.EndMode2D()
    }
}
