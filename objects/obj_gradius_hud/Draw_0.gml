var _ship = instance_find(obj_gradius_player, 0);
if (_ship != noone) {
    // Group 965 forces the current highlight and clamps at the final sprite frame.
    draw_sprite_ext(sprite_index, min(_ship.pending_upgrade, image_number - 1), x, y, 2, 2, 0, c_white, 1);
}
