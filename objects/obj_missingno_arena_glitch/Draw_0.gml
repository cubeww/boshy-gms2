if (glitch_active && ink < 128) {
    draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, c_white, 1 - ink / 128);
}
