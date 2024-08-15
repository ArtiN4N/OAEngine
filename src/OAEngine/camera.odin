package OAEngine

import rl "vendor:raylib"

// structure that holds a raylib camera, and a pointer to a vector
// must have its own struct since rl.Camera2D cannot follow a defined vector
// instead it has its own target vector, that can be changed
// this struct serves to "attach" cameras to vectors via a pointer
Camera :: struct {
    view: rl.Camera2D,
    follow: ^rl.Vector2,
    following: bool,
}

init_camera :: proc() -> Camera {
    camera := Camera{}
    camera.following = false

    return camera
}

// moves cameras target to the follow vector pointer stored in the struct
camera_update_follow :: proc(cam: ^Camera) {
    if (!cam.following) { return }
    cam.view.target = rl.Vector2{ cam.follow.x, cam.follow.y }
}

camera_update_no_follow :: proc(cam: ^Camera, x: f32, y: f32) {
    cam.view.target = rl.Vector2{ x, y }
}

camera_update ::proc{ camera_update_follow, camera_update_no_follow }

// changes the follow vector pointer
set_camera_follow :: proc(cam: ^Camera, target: ^rl.Vector2) {
    cam.follow = target
    cam.following = true
}

set_camera_offset :: proc(cam: ^Camera, offset: rl.Vector2) {
    cam.view.offset = offset
}

set_camera_rotation :: proc(cam: ^Camera, rotation: f32) {
    cam.view.rotation = rotation
}

set_camera_zoom :: proc(cam: ^Camera, zoom: f32) {
    cam.view.zoom = zoom
}
