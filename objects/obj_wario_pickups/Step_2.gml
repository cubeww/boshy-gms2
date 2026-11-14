if (trophy_steps >= 0 && ++trophy_steps >= 226) {
    trophy_steps = -1;
}

var _player = instance_find(obj_player, 0);
prehistorik_pickups_step(_player);
if (_player == noone || _player.input_locked) {
    exit;
}

// Groups 496 and 522 award trophies in separate areas near the end of the route.
if (_player.x >= 1961 && _player.x < 2049 && _player.y >= 957 && _player.y < 1399
    && game_has_item("Barrel Roll CD") && game_has_item("Cake") && game_trophy_unlock("World5clear")) {
    wario_show_trophy("World 5 CLEAR!");
}
if (_player.x >= 1712 && _player.x < 1754 && _player.y >= 1301 && _player.y < 1399
    && global.run.world_deaths <= 15 && game_trophy_unlock("World5PROMODE")) {
    wario_show_trophy("World 5 PRO MODE!");
}
if (instance_number(obj_bullet) >= 5 && game_trophy_unlock("TriggerFinger")) {
    wario_show_trophy("TRIGGER FINGER!!");
}

// Group 746 advances on contact with the exit marker.
if (_player.boshy_mask_meeting(inst_wario_boss_exit)) {
    room_goto(rm_sanicz);
}
