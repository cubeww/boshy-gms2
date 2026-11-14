if (attack_kind != GreenGreensKrackoAttack.Minion) {
    exit;
}

var _shot = instance_place(x, y, obj_bullet);
if (_shot != noone) {
    instance_destroy(_shot);
    audio_play_sound(snd_hello_kitty_hit, 1, false);
    instance_destroy();
}
