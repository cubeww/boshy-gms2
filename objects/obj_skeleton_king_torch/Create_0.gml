torch_attached = false;
torch_dropped = false;
torch_fall_speed = 0;
image_xscale = 0.5;
image_yscale = 0.5;

skeleton_king_torch_step = function(_player) {
    // Groups 899–903 carry the torch until the arena gate closes.
    if (_player != noone && _player.boshy_mask_meeting(id)) {
        torch_attached = true;
    }

    if (torch_dropped) {
        x += 4;
        y = floor(y + torch_fall_speed);
        torch_fall_speed += 0.5;
        image_angle += 4;
        if (bbox_top >= room_height) {
            instance_destroy();
        }
    } else if (torch_attached && _player != noone) {
        var _torch_sprite = _player.facing < 0 ? spr_skeleton_king_approach_torch_left
            : spr_skeleton_king_approach_torch;
        if (sprite_index != _torch_sprite) {
            var _frame = image_index;
            sprite_index = _torch_sprite;
            image_index = _frame;
        }
        image_angle = -45 * _player.facing;
        x = _player.x;
        y = _player.y;
    }
};
