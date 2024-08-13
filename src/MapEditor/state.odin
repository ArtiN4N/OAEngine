package mapeditor

import "core:fmt"
import rl "vendor:raylib"
import OAE "../OAEngine"

// Holds all data of the game
State :: struct {
    memory: ^GameMemory,
    cfg: OAE.Configs,
    camera: OAE.Camera,
    counter2: int,
}
