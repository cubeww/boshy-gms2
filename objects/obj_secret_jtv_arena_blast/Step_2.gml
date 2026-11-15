image_index = floor(++blast_steps * 0.45);
if (image_index >= sprite_get_number(sprite_index)) {
    instance_destroy();
}
