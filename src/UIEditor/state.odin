package uieditor

import "core:fmt"
import rl "vendor:raylib"
import OAE "../OAEngine"
import OAU "../OAEngine/ui"

// Holds all data of the game
State :: struct {
    memory: ^GameMemory,
    cfg: OAE.Configs,
    camera: OAE.Camera,
    uis: OAU.UIManager,
    assets: OAE.AssetManager,

    // Contains position (0, 0) and size of window.
    // Used for ui forms.
    formParent: OAU.UIFormParent,

    // for simple testing.
    counter: int
}

update :: proc(state: ^State) {
    mousePosition := rl.GetMousePosition()

    if rl.IsKeyPressed(.Q) {
        form := &state.uis["testform"]
        form.active = !form.active
    }
    if rl.IsKeyPressed(.A) {
        state.counter += 1
    }

    if rl.IsWindowResized() {
        state.cfg.windowWidth = rl.GetScreenWidth();
        state.cfg.windowHeight = rl.GetScreenHeight();
        state.formParent = { 0.0, 0.0, f32(state.cfg.windowWidth), f32(state.cfg.windowHeight) }
    }

    // Do input handling for ui forms
    if rl.IsMouseButtonReleased(.LEFT) {
        for _, &form in state.uis {
            if !form.active {
                continue
            }

            for button in form.buttons {
                if rl.CheckCollisionPointRec(mousePosition, OAU.get_rectangle_from_data(button.data.draw)) {
                    button.callback()
                }
            }
        }
    }
}

draw :: proc(state: ^State) {
    rl.BeginDrawing()
    defer rl.EndDrawing()

    rl.ClearBackground(rl.RAYWHITE)

    for _, &form in state.uis {
        if form.active {
            OAU.draw_uiform(&form)
        }
    }

    rl.DrawFPS(10, 10)
}

// create the game state and its memory
@(export)
game_init :: proc() {
    state = State{}

    state.counter = 10

    state.cfg.windowWidth = 800
    state.cfg.windowHeight = 800
    state.cfg.windowTitle = "Game Title"

    state.cfg.targetFPS = 30

    state.cfg.vsync = false
    state.cfg.fullscreen = false
    state.cfg.resizeable = true

    state.formParent = { 0.0, 0.0, f32(state.cfg.windowWidth), f32(state.cfg.windowHeight) }

    state.memory = new(GameMemory)

    state.memory^ = GameMemory {
    }

    state.uis = OAU.init_uimanager()
    OAU.create_uiform(&state.uis, "testform")
    generate_testform(&state.uis["testform"], active = true)

    state.assets = OAE.init_assetmanager()
    OAE.load_assetmanager_font()

    game_hot_reloaded(state.memory)
}

// destroy the state
@(export)
game_shutdown :: proc() {
    OAU.delete_uimanager(&state.uis)

    OAE.delete_assetmanager(&state.assets)

    free(state.memory)
}
