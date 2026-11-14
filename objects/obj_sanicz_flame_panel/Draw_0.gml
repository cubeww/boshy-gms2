gpu_set_blendmode(bm_add);
// Both scenes share the same fire frames. The Sanicz source uses a top-left hotspot.
draw_sprite(sprite_index, image_index, x, y + sprite_get_yoffset(sprite_index));
gpu_set_blendmode(bm_normal);
