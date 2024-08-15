package uieditor

import "core:fmt"
import rl "vendor:raylib"
import OAE "../OAEngine"

// Holds all data of the game
State :: struct {
    memory: ^GameMemory,
    cfg: OAE.Configs,
    camera: OAE.Camera,
    uis: [dynamic]^OAE.UIForm,
}

update :: proc(state: ^State) {
}

draw :: proc(state: ^State) {
    rl.BeginDrawing()
    defer rl.EndDrawing()

    rl.ClearBackground(rl.RAYWHITE)

    for form in state.uis {
        if form.active {
            OAE.draw_form(form)
        }
    }

    rl.DrawFPS(10, 10)
}

// create the game state and its memory
@(export)
game_init :: proc() {
    state = State{}

    state.cfg.windowWidth = 800
    state.cfg.windowHeight = 800
    state.cfg.windowTitle = "Game Title"

    state.cfg.targetFPS = 0

    state.cfg.vsync = false
    state.cfg.fullscreen = false
    state.cfg.resizeable = true

    state.memory = new(GameMemory)

    state.memory^ = GameMemory {
    }

    state.uis = make([dynamic]OAE.UIForm)
    fmt.println("made ui dynamic array")

    form1 := OAE.init_uiform(
        true,
        10, 10, 780, 780,
        rl.BLACK,
    )
    append(&state.uis, form1)
    OAE.add_uiparent(&state.uis[0], false, 0, 0, state.cfg.windowWidth, state.cfg.windowHeight)
    fmt.printfln("parent = {0}", state.uis[0].parent)

    form2 := OAE.init_uiform(
        false,
        200, 200, 600, 600,
        rl.GREEN,
    )
    append(&state.uis, form2)
    OAE.add_uiparent(&state.uis[1], true, state.uis[0])

    form3 := OAE.init_uiform(
        false,
        800, 800, 100, 100,
        rl.BLUE,
    )
    append(&state.uis, form3)
    OAE.add_uiparent(&state.uis[2], true, state.uis[1])

    game_hot_reloaded(state.memory)
}

// destroy the state
@(export)
game_shutdown :: proc() {
    for &form in state.uis {
        OAE.destroy_uiform(form)
    }
    delete(state.uis)

    free(state.memory)
}
