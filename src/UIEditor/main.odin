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

package uieditor

import "core:fmt"
import "core:strconv"
import rl "vendor:raylib"
import OAE "../OAEngine"

state: State

@(export)
game_update :: proc() -> bool {
    update(&state)
    draw(&state)
    return !rl.WindowShouldClose()
}

// create the game window
@(export)
game_init_window :: proc() {
    OAE.init_raylib_window(&state.cfg)
}

// destroy the game window
@(export)
game_shutdown_window :: proc() {
    OAE.destroy_raylib_window()
}

@(export)
game_force_reload :: proc() -> bool {
    return rl.IsKeyPressed(.F5)
}

@(export)
game_force_restart :: proc() -> bool {
    return rl.IsKeyPressed(.F6)
}
