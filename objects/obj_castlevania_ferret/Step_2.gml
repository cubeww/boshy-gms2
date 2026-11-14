var _player = instance_find(obj_player, 0);
if (!released && _player != noone && _player.x >= 3895 && _player.x < 3947
    && _player.y >= 926 && _player.y < 1202) {
    // Group 1328 creates a second swirl at the ferret's action point.
    released = true;
    vertical_speed = -25;
    instance_create_depth(x - 66, y - 86, depth, obj_castlevania_ferret_swirl);
    audio_play_sound(snd_castlevania_lets_go, 1, false);
}
if (released) {
    // Group 1329 writes an integer position before adding gravity.
    y = floor(y + vertical_speed);
    vertical_speed += 0.75;
    var _stage = instance_find(obj_castlevania, 0);
    image_angle = dsin((_stage.stage_steps + 1) * 40) * 8;
}

// Group 1330 moves both swirls, including the one created this step.
with (obj_castlevania_ferret_swirl) {
    image_angle += 4;
    x -= 8;
    y -= 15;
    if (x < -128 || y < -160) {
        instance_destroy();
    }
}
