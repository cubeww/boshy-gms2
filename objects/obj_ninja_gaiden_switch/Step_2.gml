var _player = instance_find(obj_player, 0);
if (switch_pressed) {
    image_index = min(image_index, image_number - 1);
    if (image_index >= image_number - 1) {
        image_speed = 0;
    }
} else if (_player != noone && _player.boshy_mask_meeting(id)) {
    // G921 and G1157 remove the whole Switchblock family.
    switch_pressed = true;
    sprite_index = spr_ninja_gaiden_switch_pressed;
    image_index = 0;
    image_speed = 1;
    with (obj_ninja_gaiden_switch_block) {
        instance_destroy();
    }
    if (stops_crusher) {
        with (obj_ninja_gaiden_crusher) {
            crusher_stopped = true;
        }
    }
}
