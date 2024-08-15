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

create_flags_from_state :: proc(cfg: ^Configs) {
    if cfg.vsync {
        cfg.flags += {rl.ConfigFlag.VSYNC_HINT}
    }
    if cfg.fullscreen {
        cfg.flags += {rl.ConfigFlag.FULLSCREEN_MODE}
    }
    if cfg.resizeable {
        cfg.flags += {rl.ConfigFlag.WINDOW_RESIZABLE}
    }
}

init_raylib_window :: proc(cfg: ^Configs) {
    create_flags_from_state(cfg)

    rl.SetConfigFlags(cfg.flags)

    rl.InitWindow(cfg.windowWidth, cfg.windowHeight, cfg.windowTitle)

    if cfg.targetFPS > 0 {
        rl.SetTargetFPS(cfg.targetFPS)
    }
}

destroy_raylib_window :: proc() {
    rl.CloseWindow()
}
