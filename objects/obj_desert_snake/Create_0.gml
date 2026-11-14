mounted = false;
rider_contact = false;
spike_contact = noone;
image_speed = 1;
left_probe = { left: -7, top: -8, right: -6, bottom: 10 };
right_probe = { left: 6, top: -8, right: 7, bottom: 10 };
up_probe = { left: -5, top: -16, right: 5, bottom: -15 };
down_probe = { left: -6, top: 14, right: 6, bottom: 15 };
dust_clock = 20;

sync_rider_position = function(_player) {
    _player.x = x - 8 * _player.facing;
    _player.y = y;
    _player.refresh_collision_probes();
    var _sprite = _player.facing < 0 ? spr_desert_snake_left : spr_desert_snake;
    if (sprite_index != _sprite) {
        var _frame = image_index;
        sprite_index = _sprite;
        image_index = _frame;
    }
};
