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

//
init_raylib_window :: proc(cfg: ^Configs) {
    create_flags_from_state(cfg)

    rl.SetConfigFlags(cfg.flags)

    rl.InitWindow(cfg.windowWidth, cfg.windowHeight, cfg.windowTitle)

    if cfg.targetFPS > 0 {
        rl.SetTargetFPS(cfg.targetFPS)
    }
}

//
destroy_raylib_window :: proc() {
    rl.CloseWindow()
}
