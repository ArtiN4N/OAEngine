package OAEngine

import rl "vendor:raylib"


// struct that stores assets in one place for reuse.
// Loaded assets are assigned to a tag, which interfaces with the map where all data is stored.
AssetManager :: struct {
    textures: map[string]rl.Texture2D,
    fonts: map[string]rl.Font,
}

init_assetmanager :: proc() -> (manager: AssetManager) {
    manager = AssetManager{
        textures = make(map[string]rl.Texture2D),
        fonts = make(map[string]rl.Font)
    }

    return
}

delete_assetmanager :: proc(manager: ^AssetManager) {
    for _, &texture in manager.textures {
        rl.UnloadTexture(texture)
    }
    delete(manager.textures)

    for _, &font in manager.fonts {
        rl.UnloadFont(font)
    }
    delete(manager.fonts)
}

load_assetmanager_texture_file :: proc(manager: ^AssetManager, tag: string, filename: cstring) {
    manager.textures[tag] = rl.LoadTexture(filename)
}

load_assetmanager_texture_image :: proc(manager: ^AssetManager, tag: string, image: rl.Image) {
    manager.textures[tag] = rl.LoadTextureFromImage(image)
}

load_assetmanager_texture :: proc {
    load_assetmanager_texture_file, load_assetmanager_texture_image
}

load_assetmanager_font :: proc(manager: ^AssetManager, tag: string, filename: cstring) {
    manager.fonts[tag] = rl.LoadFont(filename)
}