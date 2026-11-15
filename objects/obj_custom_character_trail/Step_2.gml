if (++age >= lifetime) {
    instance_destroy();
    exit;
}
if (!is_undefined(trail)) {
    var _frame = custom_character_frame_at(trail, age - 1);
    if (trail.frames[_frame] != noone) {
        sprite_index = trail.frames[_frame];
        image_index = 0;
    }
}
