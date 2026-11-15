if (!is_undefined(custom_bullet)) {
    var _frame = custom_character_frame_at(custom_bullet, age);
    var _sprite = custom_bullet.frames[_frame];
    if (_sprite != noone) {
        var _direction = reflected ? sign(dcos(reflection_angle)) : travel_direction;
        draw_sprite_ext(_sprite, 0, x, y, _direction == 0 ? travel_direction : _direction,
            image_yscale, image_angle, image_blend, image_alpha);
        exit;
    }
}
draw_self();
