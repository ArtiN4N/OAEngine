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
    uis: map[string]OAU.UIForm,

    // Contains position (0, 0) and size of window.
    // Used for ui forms.
    formParent: OAU.UIFormParent,

    // for simple testing
    counter: int
}

update :: proc(state: ^State) {
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

generate_testform :: proc(form: ^OAU.UIForm) {
    form^ = OAU.init_uiform(
        relativeX = 0.0,
        relativeY = 0.0,
        relativeW = 0.9,
        relativeH = 0.9,
        parentData = &state.formParent,
        color = rl.WHITE,
    )

    text1 := OAU.init_uitext(
        zindex = 2,
        relativeX = 0.0,
        relativeY = 0.0,
        relativeW = 0.5,
        relativeH = 0.5,
        parentData = &form.data.absolute,
        content = "test content %v",
        textFormat = &state.counter,
        fontsize = 20,
        fontSpacing = 5,
        color = rl.BLACK
    )
    OAU.add_to_uiform(form, text1)

    button1 := OAU.init_uibutton(
        zindex = 1,
        relativeX = -0.15,
        relativeY = 0.0,
        relativeW = 0.333,
        relativeH = 0.1,
        parentData = &form.data.absolute,
        color = rl.DARKBLUE,
    )

    // Must append it to buttons array and use pointer from said array.
    // This ensures that parent data pointer stays valid out of scope.
    OAU.add_to_uiform(form, button1)
    OAU.add_uibutton_label(
        &form.buttons[0],
        labelZindex = 0,
        labelRelativeX = 0.0,
        labelRelativeY = 0.0,
        labelRelativeW = 0.5,
        labelRelativeH = 0.5,
        labelContent = "button",
        labelTextFormat = false,
        labelFontsize = 15,
        labelFontSpacing = 3,
        labelColor = rl.WHITE
    )

    triData := OAU.init_uishapedata_triangle(
        {0, 0}, {0.5, 0.9}, {0.8, 0.5}
    )
    triangle := OAU.init_uishape(3, 0.2, -0.3, 0.3, 0.2, &form.data.absolute, triData, false, rl.RED)
    OAU.add_to_uiform(form, triangle)

    return
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

    state.uis = make(map[string]OAU.UIForm)

    state.uis["testform"] = OAU.UIForm{}
    generate_testform(&state.uis["testform"])
    (&state.uis["testform"])^.active = true

    game_hot_reloaded(state.memory)
}

// destroy the state
@(export)
game_shutdown :: proc() {
    for _, &form in state.uis {
        OAU.delete_uiform(&form)
    }
    delete(state.uis)

    free(state.memory)
}
