++age_steps;
shake_steps = max(0, shake_steps - 1);
var _time_ms = age_steps * 20;

if (exit_ready) {
    exit;
}

var _player = instance_find(obj_player, 0);

if (defeated) {
    ++y;
    if (y < 580 && age_steps mod 5 == 0) {
        if (death_rumble != -1) {
            audio_stop_sound(death_rumble);
        }
        death_rumble = audio_play_sound(snd_hello_kitty_small_explosion, 1, false);
        stage_controller.blur_strength = 2;
        spawn_attack(HelloKittyAttack.DeathFlash, x, y, 0, 0, 0.8 + random(0.6));
        spawn_attack(HelloKittyAttack.Explosion,
            x + irandom(49) - irandom(49), y + irandom(79) - irandom(79), irandom(359));
    }
    if (y == 400) {
        audio_play_sound(snd_hello_kitty_explosion, 1, false);
    }
    if (y == 590) {
        if (_player != noone) {
            stage_controller.game_controller.start_stage_music(snd_hello_kitty_victory, false, false);
        }
        spawn_attack(HelloKittyAttack.DeathFlash, x, y, 0, 0, 3);
        spawn_attack(HelloKittyAttack.Explosion,
            x + irandom(49) - irandom(49), y + irandom(79) - irandom(79), 0, 0, 4);
    }
    if (y >= 600) {
        exit_ready = true;
        visible = false;
        stage_controller.open_exit();
    }
    image_index = 16 + ((age_steps div 10) mod 2);
    exit;
}

if (!combat_active) {
    ++opening_steps;
    if (opening_steps == 80) {
        arena_revealed = true;
        if (_player != noone) {
            stage_controller.game_controller.start_stage_music(snd_hello_kitty_entrance, false, false);
        }
    }
    if (opening_steps >= 80 && opening_steps < 500) {
        if ((_time_ms div 50) > ((_time_ms - 20) div 50)) {
            --y;
        }
        image_index = 12 + ((opening_steps div 10) mod 2);
    }
    if (opening_steps >= 500 && opening_steps < 680) {
        image_angle += 2;
    }
    if (opening_steps >= 680 && opening_steps < 1500 && opening_steps mod 50 == 0) {
        spawn_attack(HelloKittyAttack.OpeningClone, 517, -9);
    }
    if (opening_steps >= 700 && opening_steps < 1350) {
        image_angle = dsin(_time_ms / 3) * 25;
    } else if (opening_steps == 680 || opening_steps == 1350) {
        image_angle = 0;
    }
    if (opening_steps == 1350 && _player != noone) {
        taunt_voice = play_boshy_voice(snd_hello_kitty_taunt);
        var _music = stage_controller.game_controller.stage_music_instance;
        if (_music != -1) {
            audio_sound_gain(_music, global.settings.music_volume * 0.007, 0);
        }
    }
    if (keyboard_check(ord("S")) && opening_steps < 1500) {
        opening_steps = 1499;
    }
    if (opening_steps == 1500) {
        combat_active = true;
        arena_revealed = true;
        x = 540;
        y = 324;
        image_angle = 0;
        image_xscale = 5;
        image_yscale = 5;
        image_index = 16;
        with (obj_hello_kitty_attack) {
            if (boss == other.id && attack_kind == HelloKittyAttack.OpeningClone) {
                instance_destroy();
            }
        }
        if (_player != noone) {
            stage_controller.game_controller.start_stage_music(snd_hello_kitty_music, false);
            audio_play_sound(snd_hello_kitty_roar, 1, false);
        }
    }
    exit;
}

++attempt_steps;
attack_steps = (attack_steps + 1) mod 1800;
image_index = 16 + ((age_steps div 10) mod 2);

if (attack_steps < 400 || attack_steps >= 600) {
    y = round(240 + dsin(_time_ms / 8) * 150);
} else if (attack_steps < 500 && _player != noone) {
    y += sign(_player.y - y) * floor(abs(_player.y - y) * 0.05);
}

if (attack_steps < 400 && age_steps mod 50 == 0 && _player != noone) {
    var _shot_x = x - 20;
    var _shot_y = y - 5;
    var _aim = point_direction(_shot_x, _shot_y, _player.x, _player.y);
    spawn_attack(HelloKittyAttack.AimedHeart, _shot_x, _shot_y, round(_aim / 11.25) * 11.25, 12.5);
    shake_steps = 15;
}

switch (attack_steps) {
    case 550:
        spawn_attack(HelloKittyAttack.Laser, 307, y);
        break;
    case 750:
    case 860:
    case 930:
        if (_player != noone) {
            spawn_attack(HelloKittyAttack.Laser, 307, _player.y);
        }
        break;
}

if (attack_steps >= 950 && attack_steps < 1300 && age_steps mod 40 == 0) {
    spawn_attack(HelloKittyAttack.FallingClone, 20 + irandom(299), -38);
}
if (attack_steps >= 1300 && attack_steps < 1600 && age_steps mod 4 == 0) {
    var _angle = 180 + dsin(_time_ms / 5) * 45 + irandom(4) - irandom(4);
    spawn_attack(HelloKittyAttack.SpiralHeart, 552, 249, _angle, 2);
}
