package OAEngine

import rl "vendor:raylib"

// structure that holds a raylib camera, and a pointer to a vector
// must have its own struct since rl.Camera2D cannot follow a defined vector
// instead it has its own target vector, that can be changed
// this struct serves to "attach" cameras to vectors via a pointer
Camera :: struct {
    view: rl.Camera2D,
    follow: ^rl.Vector2,
}

init_camera :: proc(vec: ^rl.Vector2) -> Camera {
    view := rl.Camera2D{}

    camera := Camera{
        view,
        vec,
    }

    return camera
}

// moves cameras target to the follow vector pointer stored in the struct
camera_update :: proc(using cam: ^Camera) {
    view.target = rl.Vector2{ follow.x, follow.y }
}

// changes the follow vector pointer
set_camera_follow :: proc(using cam: ^Camera, target: ^rl.Vector2) {
    follow = target
}

set_camera_offset :: proc(using cam: ^Camera, offset: rl.Vector2) {
    view.offset = offset
}

set_camera_rotation :: proc(using cam: ^Camera, rotation: f32) {
    view.rotation = rotation
}

set_camera_zoom :: proc(using cam: ^Camera, zoom: f32) {
    view.zoom = zoom
}

draw_with_camera :: proc(using state: ^State) {

}
