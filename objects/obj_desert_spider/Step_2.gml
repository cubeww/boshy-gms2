++scene_steps;
if (attack_age < 0) {
    var _player = instance_find(obj_player, 0);
    if (_player == noone || floor(_player.x) < trigger_zone[0] || floor(_player.x) >= trigger_zone[2]
        || floor(_player.y) < trigger_zone[1] || floor(_player.y) >= trigger_zone[3]) {
        exit;
    }
    // G1200–1202 reveal at the corridor trigger and enlarge before the first descent.
    attack_age = 0;
    visible = true;
    scream = audio_play_sound(snd_kid_icarus_spider_scream, 1, false);
    image_xscale = 2;
    image_yscale = 2;
}
if (attack_age >= 100) {
    exit;
}

var _elapsed_ms = scene_steps * 20;
if (attack_age < 35) {
    y += 10;
    image_angle = floor(dsin(_elapsed_ms) * 20);
}

// G1203 increments between the first descent and the recoil.
++attack_age;
if (attack_age >= 35 && attack_age <= 70) {
    y -= 20;
    image_angle = floor(dsin(_elapsed_ms div 3) * 10);
}
if (attack_age == 70) {
    audio_stop_sound(scream);
    scream = audio_play_sound(snd_kid_icarus_spider_scream, 1, false);
}
if (attack_age >= 70 && attack_age < 100) {
    y += 40;
    image_angle = 0;
}
