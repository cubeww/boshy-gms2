brick_panorama_ready = shader_is_compiled(shd_skeleton_king_panorama);
if (brick_panorama_ready) {
    brick_uvs = sprite_get_uvs(sprite_index, 0);
    brick_scroll_uniform = shader_get_uniform(shd_skeleton_king_panorama, "u_scroll");
    brick_bounds_uniform = shader_get_uniform(shd_skeleton_king_panorama, "u_tile_bounds");
}
brick_scroll = 0;
brick_elapsed_ms = 0;
