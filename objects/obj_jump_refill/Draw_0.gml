var _frame = floor(image_index) mod array_length(bob_offsets);
draw_sprite_ext(sprite_index, _frame, x, y + bob_offsets[_frame],
    image_xscale, image_yscale, image_angle, image_blend, image_alpha);
