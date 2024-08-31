package OAEngine

import rl "vendor:raylib"
import "core:fmt"

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

load_assetmanager_texture_file :: proc(manager: ^AssetManager, tag: string, filename: cstring, filter: rl.TextureFilter = .POINT) {
    manager.textures[tag] = rl.LoadTexture(filename)

    if !rl.IsTextureReady(manager.textures[tag]) {
        fmt.printfln("error loading texture at file {0}", filename)
    }
    rl.SetTextureFilter(manager.textures[tag], filter)
}

load_assetmanager_texture_image :: proc(manager: ^AssetManager, tag: string, image: rl.Image, filter: rl.TextureFilter = .POINT) {
    manager.textures[tag] = rl.LoadTextureFromImage(image)
    if !rl.IsTextureReady(manager.textures[tag]) {
        fmt.printfln("error loading texture at image {0}", image)
    }
    rl.SetTextureFilter(manager.textures[tag], filter)
}

load_assetmanager_texture :: proc {
    load_assetmanager_texture_file, load_assetmanager_texture_image,
}

load_assetmanager_font :: proc(manager: ^AssetManager, tag: string, filename: cstring) {
    manager.fonts[tag] = rl.LoadFont(filename)
}