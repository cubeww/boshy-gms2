global.run.boss_entry_steps += 1;

if (trophy_steps >= 0 && ++trophy_steps >= 226) {
    trophy_steps = -1;
}

var _player = instance_find(obj_player, 0);
var _pickup_active = prehistorik_pickup_slot >= 0;
prehistorik_pickups_step(_player);
if (_player == noone) {
    game_controller.fade_stage_music();
    exit;
}
if (!_pickup_active && prehistorik_pickup_slot >= 0) {
    // The pickup trigger clears the player's inverted gravity flag.
    _player.set_gravity_direction(1);
}

if (portal_steps >= 0) {
    var _duration = ceil(sprite_get_number(spr_tutorial_portal_transition) / 0.6);
    if (instance_exists(inst_vvvvvv_boss_portal)) {
        _player.x = inst_vvvvvv_boss_portal.x + 115;
    }
    if (++portal_steps >= _duration) {
        // Group 799 advances on the teleport animation's completion.
        portal_sound = -1;
        room_goto(rm_biollante);
        exit;
    }
    var _pixel_size = max(1, floor(portal_steps * 0.6));
    game_controller.teleport_mosaic_columns = game_controller.render_width div _pixel_size;
    game_controller.teleport_mosaic_rows = game_controller.render_height div _pixel_size;
    exit;
}

update_view(_player);
if (_player.input_locked) {
    exit;
}

if (point_in_rectangle(_player.x, _player.y, 2945, 2618, 3016, 2759)
    && game_has_item("Timer") && game_has_item("Chocolate CD") && game_trophy_unlock("World4clear")) {
    vvvvvv_show_trophy("World 4 CLEAR!");
}
if (point_in_rectangle(_player.x, _player.y, 2755, 2619, 2826, 2760)
    && global.run.world_deaths <= 15 && game_trophy_unlock("World4PROMODE")) {
    vvvvvv_show_trophy("World 4 PRO MODE!");
}
if (instance_number(obj_bullet) >= 5 && game_trophy_unlock("TriggerFinger")) {
    vvvvvv_show_trophy("TRIGGER FINGER!!");
}

// Groups 797–799 lock the player in the moving portal's horizontal range.
var _portal = inst_vvvvvv_boss_portal;
if (instance_exists(_portal) && _player.x >= _portal.x + 110 && _player.x <= _portal.x + 160
    && _player.y > _portal.y - 96) {
    _player.x = _portal.x + 120;
    _player.hsp = 0;
    _player.vsp = 0;
    _player.input_locked = true;
    portal_sound = audio_play_sound(snd_tutorial_teleport, 1, false);
    portal_steps = 0;
}
