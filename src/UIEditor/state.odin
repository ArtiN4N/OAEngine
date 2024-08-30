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

generate_testform :: proc(form: ^OAU.UIForm) {
    form^ = OAU.init_uiform_relative(
        relativeX = 0.0,
        relativeY = 0.0,
        relativeW = 0.9,
        relativeH = 0.9,
        parentData = &state.formParent,
        color = rl.WHITE,
        square = false,
    )

    text1 := OAU.init_uitext_relative(
        zindex = 2,
        relativeX = 0.0,
        relativeY = 0.4,
        relativeW = 0.5,
        relativeH = 0.5,
        parentData = &form.data.absolute,
        content = "bottom text = %v",
        textFormat = &state.counter,
        fontsize = 20,
        fontSpacing = 5,
        color = rl.BLACK
    )
    OAU.add_to_uiform(form, text1)

    button1callback :: proc() {
        form := &state.uis["testform"]
        form.shapes[1].color = rl.BLACK
    }

    button1mousedown :: proc(color: rl.Color, framesSinceRelease: int) -> rl.Color {
        startFactor: f32 = -0.3
        endFactor: f32 = 0
        frameDuration := 10

        if framesSinceRelease > frameDuration {
            return color
        }

        // y = mx+b
        factor := f32(framesSinceRelease) * (startFactor - endFactor) / f32(-frameDuration) + startFactor

        return rl.ColorBrightness(color, factor)
    }

    button1 := OAU.init_uibutton_relative(
        zindex = 1,
        relativeX = 0,
        relativeY = 0,
        relativeW = 0.2,
        relativeH = 0.1,
        parentData = &form.data.absolute,
        color = rl.DARKBLUE,
        callback = button1callback,
        mousedown = button1mousedown
    )

    // Must append it to buttons array and use pointer from said array.
    // This ensures that parent data pointer stays valid out of scope.
    OAU.add_to_uiform(form, button1)
    OAU.add_uibutton_label(
        &form.buttons[0],
        labelZindex = 0,
        labelRelativeX = 0.0,
        labelRelativeY = 0.0,
        labelRelativeW = 1,
        labelRelativeH = 0.3,
        labelContent = "button",
        labelTextFormat = false,
        labelFontsize = 0,
        labelFontSpacing = 3,
        labelColor = rl.WHITE
    )

    rectData := OAU.init_uishapedata_rectangle(square = true)
    rectangle := OAU.init_uishape_relative(3, -0.45, -0.45, 0.1, 0.1, &form.data.absolute, rectData, false, rl.RED)

    circData := OAU.init_uishapedata_circle()
    circle := OAU.init_uishape_relative(4, -0.15, -0.45, 0.1, 0, &form.data.absolute, circData, false, rl.GREEN)

    ellData := OAU.init_uishapedata_ellipse()
    ellipse := OAU.init_uishape_relative(4, -0.3, -0.45, 0.15, 0.1, &form.data.absolute, ellData, false, rl.PURPLE)

    ringData := OAU.init_uishapedata_ring(0.5, 0, 360, 50)
    ring := OAU.init_uishape_relative(4, 0, -0.45, 0.1, 0, &form.data.absolute, ringData, false, rl.BLUE)

    triData := OAU.init_uishapedata_triangle(
        {0.5, 0.1}, {0, 0.8}, {0.9, 1}
    )
    triangle := OAU.init_uishape_relative(3, 0.15, -0.45, 0.1, 0.1, &form.data.absolute, triData, false, rl.RED)


    OAU.add_to_uiform(form, triangle, rectangle, circle, ellipse, ring)

    return
}

// create the game state and its memory
@(export)
game_init :: proc() {
    state = State{}

    state.counter = 10

    state.cfg.windowWidth = 800
    state.cfg.windowHeight = 400
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
