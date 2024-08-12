package mapeditor

import "core:fmt"
import rl "vendor:raylib"
import OAE "../OAEngine"

main :: proc() {
    using OAE

    gameState := State{}
    defer destroy_state(&gameState)

    // CONFIG OPTIONS
    gameState.cfg.windowWidth = 100
    gameState.cfg.windowHeight = 100
    gameState.cfg.windowTitle = "Game Title"
    gameState.cfg.targetFPS = 60
    gameState.cfg.vsync = true
    gameState.cfg.fullscreen = false
    gameState.cfg.resizeable = true

    init_raylib_window(&gameState)
    defer destroy_raylib_window()

    for !rl.WindowShouldClose() {
        draw(&gameState)
    }
}
