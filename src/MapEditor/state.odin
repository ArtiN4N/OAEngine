package OAEngine

import "core:fmt"
import rl "vendor:raylib"

// Holds all data of the game
State :: struct {
    cfg: Configs,
    camera: Camera,
}

init_state :: proc() -> State {
    state := State{}
    state.drawLayer1 = make([dynamic]drawCallback)

    return state
}

// Deletes a state struct
destroy_state :: proc(using state: ^State) {
    delete(drawLayer1)
}

draw :: proc(using state: ^State) {
    rl.BeginDrawing()
    defer rl.EndDrawing()

    rl.ClearBackground(rl.RAYWHITE)

    rl.DrawFPS(10, 10)
}
