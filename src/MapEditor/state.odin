package mapeditor

import "core:fmt"
import rl "vendor:raylib"
import OAE "../OAEngine"

// Holds all data of the game
State :: struct {
    cfg: OAE.Configs,
    camera: OAE.Camera,
}

init_state :: proc() -> State {
    state := State{}

    return state
}

// Deletes a state struct
destroy_state :: proc(using state: ^State) {

}

draw :: proc(using state: ^State) {
    rl.BeginDrawing()
    defer rl.EndDrawing()

    rl.ClearBackground(rl.RAYWHITE)

    rl.DrawFPS(10, 10)
}
