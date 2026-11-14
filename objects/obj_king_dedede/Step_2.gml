++room_steps;
hit_flash_steps = max(0, hit_flash_steps - 1);
var _player = instance_find(obj_player, 0);
if (_player == noone) {
    game_controller.fade_stage_music();
}

if (trophy_pending && room_steps mod 100 == 0) {
    trophy_pending = false;
    trophy_steps = 0;
    audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
    audio_play_sound(snd_tutorial_achievement_success, 1, false);
}
if (trophy_steps >= 0 && ++trophy_steps >= 226) {
    trophy_steps = -1;
}

if (!dedede_falling && !dedede_defeated) {
    king_dedede_attacks_step(_player);
    _player = instance_find(obj_player, 0);
}
king_dedede_wrong_effect_step();
if (_player != noone && instance_exists(floor_spike) && _player.x > 320 && _player.die()) {
    king_dedede_puzzle_prompt("WHERE U GOING?!", 5000);
    _player = noone;
}

if (dedede_falling) {
    // Group 690 keeps rearming the hit flash throughout the fall.
    y += 2;
    image_angle -= 1;
    if (hit_flash_steps == 0) {
        hit_flash_steps = 10;
    }
    if (place_meeting(x, y, floor_spike) || y >= 439) {
        dedede_falling = false;
        dedede_defeated = true;
        dedede_show_puzzle = false;
        defeat_start_x = x;
        sprite_index = spr_king_dedede_right_answer;
        image_index = 0;
        if (game_controller.stage_music_instance != -1) {
            audio_stop_sound(game_controller.stage_music_instance);
            game_controller.stage_music_instance = -1;
        }
        audio_play_sound(snd_king_dedede_hit, 1, false);
    }
}

if (!dedede_defeated) {
    exit;
}

++defeat_steps;
if (defeat_steps < 300) {
    // Groups 694–698 count from -100. The recoil starts after 100 steps and reverses every two steps.
    var _shake_age = defeat_steps - 100;
    if (_shake_age > 0) {
        var _direction = ((_shake_age - 1) div 2) mod 2 == 0 ? 1 : -1;
        x = floor(defeat_start_x + _direction * _shake_age * 0.05);
    }
    exit;
}

var _cutscene_steps = defeat_steps - 299;
switch (_cutscene_steps) {
    case 1:
        instance_destroy(floor_spike);
        cutscene_king = instance_create_depth(574, 408, depth, obj_hazard, {
            sprite_index: spr_king_dedede_left, image_speed: 0,
            image_xscale: 5, image_yscale: 5, visible: false
        });
        audio_play_sound(snd_king_dedede_heal, 1, false);
        break;
    case 100:
        cutscene_vsp = -6;
        cutscene_king.y -= 22;
        audio_play_sound(snd_king_dedede_jump, 1, false);
        break;
    case 200:
        cutscene_king.sprite_index = spr_king_dedede_right_answer;
        cutscene_king.image_index = 0;
        audio_play_sound(snd_hello_kitty_roar, 1, false);
        break;
    case 300:
        knight = instance_create_depth(cutscene_king.x - 27, cutscene_king.y - 50, depth, obj_green_greens_prop, {
            sprite_index: spr_king_dedede_meta_knight, image_speed: 0,
            image_xscale: 3, image_yscale: 3, visible: false
        });
        var _king_x = cutscene_king.x;
        var _king_y = cutscene_king.y;
        instance_destroy(cutscene_king);
        cutscene_king = instance_create_depth(_king_x, _king_y, depth, obj_green_greens_prop, {
            sprite_index: spr_king_dedede_defeat_king, image_speed: 0,
            image_xscale: 5, image_yscale: 5, visible: false
        });
        audio_play_sound(snd_king_dedede_blood_rip, 1, false);
        audio_play_sound(snd_king_dedede_swordhit, 1, false);
        break;
    case 380:
        instance_destroy(cutscene_king);
        cutscene_king = noone;
        break;
    case 449:
        hadoken = instance_create_depth(696, 100, depth, obj_green_greens_prop, {
            sprite_index: spr_king_dedede_hadoken, image_speed: 0, visible: false
        });
        audio_play_sound(snd_king_dedede_hadoken, 1, false);
        break;
}

if (_cutscene_steps < 200) {
    cutscene_king.image_index = floor((_cutscene_steps - 1) * 0.2) mod 2;
} else if (_cutscene_steps >= 300 && _cutscene_steps < 380) {
    cutscene_king.image_index = floor((_cutscene_steps - 300) * 0.2);
}
if (_cutscene_steps >= 100 && _cutscene_steps < 150) {
    --cutscene_king.x;
    cutscene_king.y = floor(cutscene_king.y + cutscene_vsp);
    cutscene_vsp += 0.2;
} else if (_cutscene_steps >= 200 && _cutscene_steps < 280) {
    cutscene_king.x += irandom(1) - irandom(1);
}

if (instance_exists(knight) && _cutscene_steps < 550
    && (room_steps * 20 div 50) > ((room_steps - 1) * 20 div 50)) {
    --knight.x;
    knight.y -= 2;
}

if (instance_exists(hadoken) && exit_open) {
    ++hadoken_age;
    var _frame = hadoken_age div 2;
    if (_frame < hadoken.image_number) {
        hadoken.image_index = _frame;
    } else {
        instance_destroy(hadoken);
        hadoken = noone;
    }
} else if (instance_exists(hadoken) && instance_exists(knight)) {
    hadoken.x -= 5;
    hadoken.image_index = floor(hadoken_age * 0.3) mod 2;
    ++hadoken_age;
    knight.y = max(100, knight.y);
    var _knight = knight;
    var _impact = false;
    with (hadoken) {
        _impact = place_meeting(x, y, _knight);
    }
    if (_impact) {
        hadoken.sprite_index = spr_king_dedede_hadoken_explosion;
        hadoken.image_index = 0;
        hadoken_age = 0;
        exit_open = true;
        // Group 740 emits 360 particles. Reduced blood settings still reduce the burst.
        repeat (floor(360 * min(1, global.settings.blood_intensity / 50))) {
            instance_create_depth(knight.x, knight.y, depth - 1, obj_blood);
        }
        instance_destroy(knight);
        knight = noone;
        audio_play_sound(snd_king_dedede_explosion, 1, false);
        trophy_pending = game_trophy_unlock("KingDeDeDe");
    }
}

if (exit_open && _player != noone && _player.x > 630) {
    game_enter_ryu(_player.y - 3);
}
