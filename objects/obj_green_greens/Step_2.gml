if (trophy_steps >= 0 && ++trophy_steps >= 226) {
    trophy_steps = -1;
}

green_greens_events_step(live_player());
green_greens_kracko_step(live_player());
green_greens_pickups_step(live_player());

var _player = live_player();
if (_player == noone) {
    update_view(noone);
    game_controller.fade_stage_music();
    exit;
}
// Group 1107 updates Active 13 after the room's platform and encounter events.
early_rider_probe_x = floor(_player.x);
early_rider_probe_y = floor(_player.y);
if (_player.touching_hazard()) {
    _player.die();
    update_view(noone);
    game_controller.fade_stage_music();
    exit;
}

// Source groups 655, 672–673 and 680 rotate the first corridor between its trigger strips.
if (player_overlaps(_player, 636, 1440, 642, 1872) || player_overlaps(_player, 1289, 1440, 1295, 1872)) {
    rotating_view = false;
} else if (player_overlaps(_player, 641, 1440, 647, 1872) || player_overlaps(_player, 1285, 1440, 1291, 1872)) {
    rotating_view = true;
}
if (rotating_view) {
    view_rotation = (view_rotation + 1) mod 360;
}
game_controller.screen_rotation = rotating_view ? view_rotation : 0;

// Source groups 778–782 and 798 flip the later corridor every 30 steps.
if (player_overlaps(_player, 5104, 1023, 5110, 1455) || player_overlaps(_player, 5768, 1024, 5774, 1456)) {
    flip_view_steps = -1;
    game_controller.flip_view_y = false;
} else if (flip_view_steps < 0 && (player_overlaps(_player, 5104, 887, 5125, 906)
    || player_overlaps(_player, 5113, 1024, 5764, 1456))) {
    flip_view_steps = 0;
}
if (flip_view_steps >= 0 && ++flip_view_steps == 30) {
    flip_view_steps = 0;
    game_controller.flip_view_y = !game_controller.flip_view_y;
}

var _music = _player.x < 2550 ? snd_green_greens_music : snd_green_greens_plains;
if (!instance_exists(kracko_boss) && _music != region_music) {
    region_music = _music;
    global.run.music_position = 0;
    game_controller.start_stage_music(_music);
}

// Fusion group 754 advances when the player touches the black door.
if (player_overlaps(_player, 6960, 1208, 6976, 1232)) {
    room_goto(rm_king_dedede);
    exit;
}
update_view(_player);
