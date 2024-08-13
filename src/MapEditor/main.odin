package mapeditor

import "core:fmt"
import rl "vendor:raylib"
import OAE "../OAEngine"

main :: proc() {
    gameState := init_state()
    defer destroy_state(&gameState)

    // CONFIG OPTIONS
    gameState.cfg.windowWidth = 400
    gameState.cfg.windowHeight = 400
    gameState.cfg.windowTitle = "Game Title"

    gameState.cfg.targetFPS = 60

    gameState.cfg.vsync = true
    gameState.cfg.fullscreen = false
    gameState.cfg.resizeable = true
    //

    OAE.init_raylib_window(&gameState.cfg)
    defer OAE.destroy_raylib_window()

    for !rl.WindowShouldClose() {
        draw(&gameState)
    }
}
