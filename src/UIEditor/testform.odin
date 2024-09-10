package uieditor

import "core:fmt"
import rl "vendor:raylib"
import OAE "../OAEngine"
import OAU "../OAEngine/ui"

generate_testform :: proc(form: ^OAU.UIForm, active: bool = false) {
    form^ = OAU.init_uiform_relative(
        relativeX = 0.0,
        relativeY = 0.0,
        relativeW = 0.9,
        relativeH = 0.9,
        parentData = &state.formParent,
        color = rl.WHITE,
        keepRatio = false,
    )
    form.active = active

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

    rectData := OAU.init_uishapedata_rectangle(keepRatio = true)
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

    img1 := OAU.init_uiimage_relative(5, 0, 0, 0.2, 0.2, &form.data.absolute, &state.assets.textures["testimg"])

    OAU.add_to_uiform(form, img1)

    return
}