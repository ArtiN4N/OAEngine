package OAEngine

import "core:fmt"
import rl "vendor:raylib"

draw :: proc() {
    rl.BeginDrawing()
    defer rl.EndDrawing()

    rl.ClearBackground(rl.RAYWHITE)

    rl.DrawFPS(10, 10)
}
