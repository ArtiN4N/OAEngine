package mapeditor

import "core:fmt"
import rl "vendor:raylib"
import OAE "../OAEngine"

// Holds all data of the game
State :: struct {
    memory: ^GameMemory,
    cfg: OAE.Configs,
    camera: OAE.Camera,
}

update :: proc(using state: ^State) {
}

draw :: proc(using state: ^State) {
    rl.BeginDrawing()
    defer rl.EndDrawing()

    rl.ClearBackground(rl.RAYWHITE)

    rl.DrawFPS(10, 10)
}

// create the game state and its memory
@(export)
game_init :: proc() {
    state = State{}

    state.cfg.windowWidth = 800
    state.cfg.windowHeight = 800
    state.cfg.windowTitle = "Game Title"

    state.cfg.targetFPS = 1000

    state.cfg.vsync = true
    state.cfg.fullscreen = false
    state.cfg.resizeable = true

    state.memory = new(GameMemory)

    state.memory^ = GameMemory {
    }

    game_hot_reloaded(state.memory)
}

// destroy the state
@(export)
game_shutdown :: proc() {
    free(state.memory)
}

@(export)
game_memory :: proc() -> rawptr {
    return state.memory
}

@(export)
game_memory_size :: proc() -> int {
    return size_of(state.memory)
}

@(export)
game_hot_reloaded :: proc(mem: rawptr) {
    state.memory = (^GameMemory)(mem)
}
