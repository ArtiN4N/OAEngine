package OAEngine

import rl "vendor:raylib"

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

camera_update :: proc(using cam: ^Camera) {
    view.target = rl.Vector2{ follow.x, follow.y }
}

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
