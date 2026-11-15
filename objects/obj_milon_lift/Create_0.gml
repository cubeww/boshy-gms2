vertical_step = 1;
touching_backdrop = false;
image_speed = 0;

milon_rider_probe_overlaps = function(_player_x, _player_y) {
    // Active 23 is a 16 x 16 mask with its hotspot at (7, 13).
    var _x = floor(_player_x);
    var _y = floor(_player_y);
    return collision_rectangle(_x - 7, _y - 13, _x + 8, _y + 2, id, true, false) != noone;
};

launch_rider = function(_player) {
    // G740 and G800 use a full jump and reset the air jump.
    _player.vsp = -_player.character.movement.jump_speed;
    _player.grounded = false;
    _player.air_jump_available = true;
    _player.jumped_this_step = true;
    _player.jump_cut_enabled = false;
    audio_play_sound(snd_skeleton_king_hop, 1, false);
};
