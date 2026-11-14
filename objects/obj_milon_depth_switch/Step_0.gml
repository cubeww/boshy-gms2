if (switch_age < 0) {
    var _player = instance_find(obj_player, 0);
    if (_player != noone && _player.boshy_mask_meeting(id)) {
        // Group 937 changes the switch animation and removes its linked block.
        switch_age = 0;
        sprite_index = spr_milon_depth_switch_on;
        with (inst_milon_depths_mechanics_2247) {
            instance_destroy();
        }
    }
} else {
    image_index = min(image_number - 1, (++switch_age * 50 - 1) div 100);
}
