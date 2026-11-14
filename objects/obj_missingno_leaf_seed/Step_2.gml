// G892–893 integrate the launch, then drift down at one pixel per event.
x += seed_hsp;
y += seed_vsp;
++seed_vsp;
if (seed_vsp > 1) {
    seed_vsp = 1;
    seed_hsp = 0;
    if (++seed_drift_steps > 25) {
        var _player = instance_find(obj_player, 0);
        // The original direction expression reads zero coordinates when the player is missing.
        var _target_x = _player == noone ? 0 : _player.x;
        var _target_y = _player == noone ? 0 : _player.y;
        var _angle = darctan2(_target_x - x, _target_y - y) - 90;
        instance_create_layer(x, y, "Hazards", obj_missingno_razor_leaf,
            { image_angle: sign(_angle) * floor(abs(_angle)) });
        with (obj_missingno) {
            missingno_attack_kick(10, 1.5);
        }
        audio_play_sound(snd_king_dedede_roll, 1, false);
        instance_destroy();
    }
}
