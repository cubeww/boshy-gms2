if (trophy_steps >= 0 && ++trophy_steps >= 226) {
    trophy_steps = -1;
}

var _player = instance_find(obj_player, 0);
prehistorik_pickups_step(_player);
if (instance_number(obj_bullet) >= 5 && game_trophy_unlock("TriggerFinger")) {
    show_trophy("TRIGGER FINGER!!");
}

if (_player == noone || _player.dead || _player.input_locked) {
    exit;
}

// G497 and G523 use separate trigger zones for the World 8 trophies.
if (_player.x >= 4075 && _player.x < 4110 && _player.y >= 979 && _player.y < 1423
    && game_has_item("Wily CD") && game_trophy_unlock("World8clear")) {
    show_trophy("World 8 CLEAR!");
}
if (_player.x >= 4234 && _player.x < 4269 && _player.y >= 981 && _player.y < 1425
    && global.run.world_deaths <= 30 && game_trophy_unlock("World8PROMODE")) {
    show_trophy("World 8 PRO MODE!");
}
