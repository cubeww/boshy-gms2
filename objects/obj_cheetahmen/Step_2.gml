if (trophy_steps >= 0 && ++trophy_steps >= 226) {
    trophy_steps = -1;
}

if (pipe_steps >= 0) {
    if (++pipe_steps >= 50) {
        room_goto(rm_mario);
    }
    exit;
}

cheetahmen_early_step(live_player());
cheetahmen_late_step(live_player());
prehistorik_pickups_step(live_player());

var _player = live_player();
if (_player != noone && _player.touching_hazard()) {
    _player.die();
    _player = noone;
}

// Fusion group 46 checks contact before groups 722–734 spawn and move arrows.
cheetahmen_step_archer(_player);
cheetahmen_step_arrows();
if (_player == noone) {
    game_controller.fade_stage_music();
    exit;
}

if (!_player.input_locked) {
    // Groups 701–702 remove the portal after Gastly is caught.
    var _portal = inst_cheetahmen_gastly_portal;
    if (instance_exists(_portal) && _player.boshy_mask_meeting(_portal)) {
        room_goto(rm_gastly);
        exit;
    }

    // Groups 735–737 hide the player and wait one second before Mario's room.
    var _pipe = inst_cheetahmen_mario_pipe;
    if (instance_exists(_pipe) && player_overlaps(_player, _pipe.x, _pipe.y, _pipe.x + 34, _pipe.y + 32)) {
        _player.visible = false;
        _player.input_locked = true;
        _player.hsp = 0;
        _player.vsp = 0;
        pipe_steps = 0;
        pipe_sound = audio_play_sound(snd_cheetahmen_pipe, 1, false);
    }

    if (point_in_rectangle(_player.x, _player.y, 5127, 492, 5244, 593)
        && game_has_item("Trololol CD") && game_has_item("Rupees") && game_trophy_unlock("World3clear")) {
        cheetahmen_show_trophy("World 3 CLEAR!");
    }
    if (point_in_rectangle(_player.x, _player.y, 4764, 375, 4881, 476)
        && global.run.world_deaths <= 15 && game_trophy_unlock("World3PROMODE")) {
        cheetahmen_show_trophy("World 3 PRO MODE!");
    }
}
if (instance_number(obj_bullet) >= 5 && game_trophy_unlock("TriggerFinger")) {
    cheetahmen_show_trophy("TRIGGER FINGER!!");
}
update_view(_player);
