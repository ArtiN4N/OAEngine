package OAEngine

import rl "vendor:raylib"

Configs :: struct {
    windowWidth: i32,
    windowHeight: i32,
    windowTitle: cstring,
    targetFPS: i32,

    vsync: bool,
    fullscreen: bool,
    resizeable: bool,

    flags: rl.ConfigFlags,

    useCam: bool,
}

create_flags_from_state :: proc(using cfg: ^Configs) {
    if vsync {
        flags += {rl.ConfigFlag.VSYNC_HINT}
    }
    if fullscreen {
        flags += {rl.ConfigFlag.FULLSCREEN_MODE}
    }
    if resizeable {
        flags += {rl.ConfigFlag.WINDOW_RESIZABLE}
    }
}
