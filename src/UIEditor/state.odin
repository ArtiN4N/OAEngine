package uieditor

import "core:fmt"
import rl "vendor:raylib"
import OAE "../OAEngine"
<<<<<<< ours
=======
import OAU "../OAEngine/ui"
>>>>>>> theirs

// Holds all data of the game
State :: struct {
    memory: ^GameMemory,
    cfg: OAE.Configs,
    camera: OAE.Camera,
<<<<<<< ours
    uis: [dynamic]^OAE.UIForm,
}

update :: proc(state: ^State) {
=======
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
>>>>>>> theirs
}

draw :: proc(state: ^State) {
    rl.BeginDrawing()
    defer rl.EndDrawing()

    rl.ClearBackground(rl.RAYWHITE)

<<<<<<< ours
    for form in state.uis {
        if form.active {
            OAE.draw_form(form)
=======
    for _, &form in state.uis {
        if form.active {
            OAU.draw_uiform(&form)
>>>>>>> theirs
        }
    }

    rl.DrawFPS(10, 10)
}

<<<<<<< ours
=======
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

    return
}

>>>>>>> theirs
// create the game state and its memory
@(export)
game_init :: proc() {
    state = State{}

<<<<<<< ours
=======
    state.counter = 10

>>>>>>> theirs
    state.cfg.windowWidth = 800
    state.cfg.windowHeight = 800
    state.cfg.windowTitle = "Game Title"

<<<<<<< ours
    state.cfg.targetFPS = 0
=======
    state.cfg.targetFPS = 30
>>>>>>> theirs

    state.cfg.vsync = false
    state.cfg.fullscreen = false
    state.cfg.resizeable = true

<<<<<<< ours
=======
    state.formParent = { 0.0, 0.0, f32(state.cfg.windowWidth), f32(state.cfg.windowHeight) }

>>>>>>> theirs
    state.memory = new(GameMemory)

    state.memory^ = GameMemory {
    }

<<<<<<< ours
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
=======
    state.uis = make(map[string]OAU.UIForm)

    state.uis["testform"] = OAU.UIForm{}
    generate_testform(&state.uis["testform"])
    (&state.uis["testform"])^.active = true
>>>>>>> theirs

    game_hot_reloaded(state.memory)
}

// destroy the state
@(export)
game_shutdown :: proc() {
<<<<<<< ours
    for &form in state.uis {
        OAE.destroy_uiform(form)
=======
    for _, &form in state.uis {
        OAU.delete_uiform(&form)
>>>>>>> theirs
    }
    delete(state.uis)

    free(state.memory)
}
