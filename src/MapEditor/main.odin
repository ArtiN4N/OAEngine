// This file is compiled as part of the `odin.dll` file. It contains the
// procs that `game.exe` will call, such as:
//
// game_init: Sets up the game state
// game_update: Run once per frame
// game_shutdown: Shuts down game and frees memory
// game_memory: Run just before a hot reload, so game.exe has a pointer to the
//		game's memory.
// game_hot_reloaded: Run after a hot reload so that the `g_mem` global variable
//		can be set to whatever pointer it was in the old DLL.

package mapeditor

import "core:fmt"
import "core:strconv"
import rl "vendor:raylib"
import OAE "../OAEngine"

state: State

update :: proc(using state: ^State) {
    if rl.IsKeyDown(.UP) {
        state.memory.counter += 1
        state.counter2 += 1
    }
}

draw :: proc(using state: ^State) {
    rl.BeginDrawing()
    defer rl.EndDrawing()

    rl.ClearBackground(rl.RAYWHITE)

    rl.DrawFPS(10, 10)

    rl.DrawText(fmt.ctprintf("counter = {0}", state.memory.counter), 20, 20, 40, rl.RED)

    rl.DrawText(fmt.ctprintf("counter = {0}", state.counter2), 20, 80, 40, rl.RED)
}

@(export)
game_update :: proc() -> bool {
    update(&state)
    draw(&state)
    return !rl.WindowShouldClose()
}

// create the game state and its memory
@(export)
game_init :: proc() {
    state = State{}

    state.cfg.windowWidth = 400
    state.cfg.windowHeight = 400
    state.cfg.windowTitle = "Game Title"

    state.cfg.targetFPS = 60

    state.cfg.vsync = true
    state.cfg.fullscreen = false
    state.cfg.resizeable = true

    state.counter2 = 10

    state.memory = new(GameMemory)

    state.memory^ = GameMemory {
        counter = 100,
    }

    game_hot_reloaded(state.memory)
}

// create the game window
@(export)
game_init_window :: proc() {
    OAE.init_raylib_window(&state.cfg)
}

// destroy the state
@(export)
game_shutdown :: proc() {
    free(state.memory)
}

// destroy the game window
@(export)
game_shutdown_window :: proc() {
    OAE.destroy_raylib_window()
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

@(export)
game_force_reload :: proc() -> bool {
    return rl.IsKeyPressed(.F5)
}

@(export)
game_force_restart :: proc() -> bool {
    return rl.IsKeyPressed(.F6)
}
