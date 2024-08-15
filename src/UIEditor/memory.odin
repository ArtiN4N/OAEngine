package uieditor

import OAE "../OAEngine"

GameMemory :: struct {
    // stuff that needs to be saved in memory goes here
    
}

@(export)
game_memory :: proc() -> rawptr {
    return state.memory
}

@(export)
game_memory_size :: proc() -> int {
    return size_of(state.memory)
}

@(export)
game_hot_reloaded :: proc(mem: rawptr) {
    state.memory = (^GameMemory)(mem)
}