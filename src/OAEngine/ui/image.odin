package ui

import rl "vendor:raylib"
import "core:fmt"
import "core:strings"

UIImage :: struct {
    zindex: u32,
    data: UIElementData,
    parentData: ^UIData,
    keepRelativeRatio: bool,
    keepImgRatio: bool,
    rotation: f32,
    tint: rl.Color,
    texture: ^rl.Texture2D,
}

init_uiimage_relative :: proc(
    zindex: u32,
    relativeX, relativeY, relativeW, relativeH: f32,
    parentData: ^UIData,
    texture: ^rl.Texture2D,
    keepImgRatio: bool = true,
    tint: rl.Color = rl.WHITE,
    rotation: f32 = 0,
    keepRelativeRatio: bool = false
) -> (image: UIImage) {
    relativeData := UIData{ relativeX, relativeY, relativeW, relativeH }
    absoluteData := get_absolute_data(relativeData, parentData)

    image = UIImage{
        zindex = zindex,
        data = UIElementData{
            relative = relativeData,
            absolute = absoluteData,
            draw = get_draw_data(absoluteData, parentData),
            useAbs = false
        },
        parentData = parentData,
        keepRelativeRatio = keepRelativeRatio,
        keepImgRatio = keepImgRatio,
        rotation = rotation,
        tint = tint,
        texture = texture
    }

    return
}


init_uiimage_absolute :: proc(
    zindex: u32,
    relativeX, relativeY: f32,
    absoluteW, absoluteH: f32,
    parentData: ^UIData,
    texture: ^rl.Texture2D,
    keepImgRatio: bool = true,
    tint: rl.Color = rl.WHITE,
    rotation: f32 = 0,
    keepRelativeRatio: bool = true,
) -> (image: UIImage) {
    relativeData := UIData{ relativeX, relativeY, 0, 0 }
    absoluteData := get_absolute_data(relativeData, parentData)
    absoluteData = UIData{ absoluteData.x, absoluteData.y, absoluteW, absoluteH }

    image = UIImage{
        zindex = zindex,
        data = UIElementData{
            relative = relativeData,
            absolute = absoluteData,
            draw = get_draw_data(absoluteData, parentData),
            useAbs = true
        },
        parentData = parentData,
        keepRelativeRatio = keepRelativeRatio,
        keepImgRatio = keepImgRatio,
        rotation = rotation,
        tint = tint,
        texture = texture
    }

    return
}

draw_uiimage :: proc(img: ^UIImage) {
    if img.data.useAbs {
        absData := img.data.absolute
        img.data.absolute = get_absolute_data(img.data.relative, img.parentData)
        img.data.absolute = UIData{ img.data.absolute.x, img.data.absolute.y, absData.width, absData.height }
    } else {
        img.data.absolute = get_absolute_data(img.data.relative, img.parentData)
    }

    if img.keepRelativeRatio {
        using img.data
        if absolute.width > absolute.height {
            absolute.width = (img.data.relative.width / img.data.relative.height) * absolute.height
        } else {
            absolute.height = (img.data.relative.height / img.data.relative.width) * absolute.width
        }
    }

    texture := img.texture^

    if img.keepImgRatio {
        using img.data
        if absolute.width > absolute.height {
            absolute.width = f32(texture.width) / f32(texture.height) * absolute.height
        } else {
            absolute.height = f32(texture.height) / f32(texture.width) * absolute.width
        }
    }

    img.data.draw = get_draw_data(img.data.absolute, img.parentData)

    src := rl.Rectangle{ 0, 0, f32(texture.width), f32(texture.height) }
    dst := get_rectangle_from_data(img.data.draw)

    rl.DrawTexturePro(texture, src, dst, {0, 0}, img.rotation, img.tint)
}

