if (trophy_steps >= 0 && ++trophy_steps >= 226) {
    trophy_steps = -1;
}
exit_notice_steps = max(0, exit_notice_steps - 1);

var _player = instance_find(obj_player, 0);
prehistorik_pickups_step(_player);
if (_player == noone || _player.input_locked) {
    exit;
}

// Group 744 reveals a solid tile and stops ascent when the player touches it from below.
if (_player.vsp < 0) {
    with (obj_castlevania_hidden_platform) {
        if (!visible && _player.boshy_mask_meeting(id)) {
            _player.vsp = 1;
            visible = true;
            var _backdrop = instance_create_layer(x, y, layer, obj_player_backdrop);
            _backdrop.sprite_index = sprite_index;
            _backdrop.image_xscale = image_xscale;
            _backdrop.image_yscale = image_yscale;
            _backdrop.image_angle = image_angle;
        }
    }
}

// Group 788 wraps the upper corridor back to its left edge.
if (_player.boshy_mask_meeting(inst_castlevania_upper_wrap)) {
    _player.x = 1281;
    _player.refresh_collision_probes();
}

if (_player.x >= 4738 && _player.x < 4768 && _player.y >= 1264 && _player.y < 1388
    && game_has_item("Scouter") && game_has_item("Keyboard Cat CD") && game_trophy_unlock("World6clear")) {
    castlevania_show_trophy("World 6 CLEAR!");
}
if (_player.x >= 4847 && _player.x < 4878 && _player.y >= 1223 && _player.y < 1383
    && global.run.world_deaths <= 15 && game_trophy_unlock("World6PROMODE")) {
    castlevania_show_trophy("World 6 PRO MODE!");
}
if (instance_number(obj_bullet) >= 5 && game_trophy_unlock("TriggerFinger")) {
    castlevania_show_trophy("TRIGGER FINGER!!");
}

// Group 869 enters the boss approach at (32, 96).
if (_player.boshy_mask_meeting(inst_castlevania_boss_door)) {
    room_goto(rm_skeleton_king);
    exit;
} else if (_player.boshy_mask_meeting(inst_castlevania_puzzle_door)) {
    exit_notice = "Secret puzzle room pending";
    exit_notice_steps = 100;
}
