++scene_steps;
if (ryu_pose_return_to_idle) {
    ryu_set_pose(0, ryu_pose_facing);
}
if (ryu_pose_sprite != -1) {
    var _frames = sprite_get_number(ryu_pose_sprite);
    // Fusion advances the clip before running pose cues, once the counter exceeds 100.
    var _speed = round(sprite_get_speed(ryu_pose_sprite) * 2);
    var _previous_frame = max(0, (ryu_pose_ticks * _speed - 1) div 100);
    var _frame = max(0, (++ryu_pose_ticks * _speed - 1) div 100);
    switch (ryu_pose) {
        case 0: case 7: case 14:
            ryu_pose_frame = _frame mod _frames;
            break;
        case 17: case 20:
            // These clips loop back to their last frame.
            ryu_pose_frame = min(_frame, _frames - 1);
            break;
        default:
            var _repeats = ryu_pose == 16 ? 15 : 1;
            var _end = _frames * _repeats;
            ryu_pose_frame = min(_frame, _end - 1) mod _frames;
            // A cue that reasserts the clip on its completion step keeps the last frame.
            ryu_pose_return_to_idle = _previous_frame < _end && _frame >= _end;
            break;
    }
    image_index = ryu_pose_frame;
}
if (hit_flash_age >= 0 && ++hit_flash_age >= 10) {
    hit_flash_age = -1;
}
if (trophy_index < array_length(trophy_titles)) {
    if (trophy_steps == 0) {
        audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
        audio_play_sound(snd_tutorial_achievement_success, 1, false);
    }
    if (++trophy_steps >= 226) {
        ++trophy_index;
        trophy_steps = 0;
    }
}

var _player = instance_find(obj_player, 0);
if (_player != noone && fight_age < 0 && _player.x >= 1280) {
    instance_create_layer(1264, 0, "Gameplay", obj_solid, { sprite_index: spr_ryu_arena_gate });
    _player.x += 16;
    x = 1849;
    y = -56;
    fight_age = 0;
    ryu_set_pose(0, -1);
    // G71 starts the theme when Ryu enters if channel 2 is idle.
    if (!game_controller.stage_music_is_playing()) {
        game_controller.start_stage_music(snd_ryu_music, false, false, 48000);
    }
}

if (_player != noone && fight_age >= 0 && !defeated) {
    ++fight_age;
    if (fight_age <= 450) {
        ++y;
    }
    if (fight_age <= 800) {
        ++intro_marker_y;
    }
    switch (fight_age) {
        case 520:
            ryu_set_pose(14);
            ryu_start_dialogue("So . . . We meet\nagain Akuma...");
            break;
        case 650:
            ryu_set_pose(18);
            ryu_start_dialogue("WHAT?! You're not\nAkuma!");
            break;
        case 751:
            ryu_set_pose(19);
            ryu_start_dialogue("What are YOU doing\nhere?!");
            break;
        case 851:
            ryu_set_pose(14);
            ryu_start_dialogue("Nvm! I need to\npractice my down\nforward punch spam\ntechnique anyway...");
            break;
        case 649: case 750: case 850: case 1079:
            dialogue_lines = [];
            break;
    }
    if (fight_age < 1080 && keyboard_check_pressed(ord("S"))) {
        fight_age = 1080;
        dialogue_lines = [];
        y = 390;
        intro_marker_y = 800;
        arena_flash = 1;
        // Fusion group 708 seeks the music channel to 21,500 milliseconds.
        if (game_controller.stage_music_instance != -1) {
            audio_sound_set_track_position(game_controller.stage_music_instance, 21.5);
        }
    }
    if (fight_age == 1080 && attempt_start_second < 0) {
        // G698 and G708 reset the score timer while preserving the room's one-second pulse.
        attempt_start_second = game_controller.frame_seconds;
    }
    if (fight_age >= 1080) {
        fight_age = ryu_attacks_step(_player, fight_age);
        if (!instance_exists(_player)) {
            _player = noone;
        }
    }
} else if (_player != noone && defeated) {
    ++victory_age;
    if (defeat_bounces < 4) {
        // The opaque bottom edge of each frame in the native collapse clip.
        var _foot_offsets = [39, 39, 30, 30, 36];
        var _floor = 439 - _foot_offsets[ryu_pose_frame];
        x = clamp(x + defeat_hsp, 1300, 1910);
        if ((x == 1300 && defeat_hsp < 0) || (x == 1910 && defeat_hsp > 0)) {
            defeat_hsp = -defeat_hsp;
        }
        y += defeat_vsp;
        defeat_vsp += 0.1;
        if (y >= _floor && defeat_vsp > 0) {
            y = _floor;
            defeat_vsp *= -0.6;
            ++defeat_bounces;
        }
    }

    if (prehistorik_pickup_slot < 0 && array_length(prehistorik_pickup_entries) > 0) {
        var _chest = prehistorik_pickup_entries[0];
        if (!_chest.collected) {
            _chest.y = min(_chest.y + 1, 432);
        }
    }
    prehistorik_pickups_step(_player);

    // Fusion groups 775–809 replace the player with a zoomed victory double for 300 steps.
    var _dance_age = victory_age - 499;
    // An active costume reveal keeps its camera and input lock through the dance window.
    if (_dance_age == 1 && prehistorik_pickup_slot < 0) {
        dance_active = true;
        _player.x = 1600;
        _player.y = 380;
        _player.hsp = 0;
        _player.vsp = 0;
        _player.input_locked = true;
        _player.visible = false;
        dance_sound = audio_play_sound(snd_ryu_victory, 1, false);
    }
    if (dance_active) {
        if (_dance_age > 1 && _dance_age <= 200) {
            dance_x += (_dance_age <= 50 || _dance_age > 150) ? 1 : -1;
        }
        if (_dance_age == 250) {
            dance_y -= 16;
        }
    }
    if (_dance_age == 300) {
        if (dance_active) {
            dance_active = false;
            _player.x = dance_x;
            _player.y = dance_y;
            _player.visible = true;
            _player.input_locked = false;
            _player.grounded = false;
        }
        if (instance_exists(right_gate)) {
            instance_destroy(right_gate);
        }
        exit_ready = true;
    }
    // Fusion #595 is an invisible transition strip just beyond the gate removed by group 809.
    if (exit_ready && !_player.input_locked && _player.bbox_right >= 1925 && _player.bbox_left < 1925 + sprite_get_width(spr_ryu_exit)
        && _player.bbox_bottom >= -33 && _player.bbox_top < -33 + sprite_get_height(spr_ryu_exit)) {
        if (!teleporter_rush_exit()) {
            room_goto(rm_cheetahmen);
        }
        exit;
    }
}

if (array_length(dialogue_lines) > 0 && _player != noone) {
    // BossChat appends one character every 50 ms (groups 887–893).
    var _letters = min(dialogue_length, (++dialogue_steps * 2) div 5);
    if (_letters > dialogue_letters) {
        dialogue_letters = _letters;
        audio_play_sound(snd_ryu_dialogue_tick, 1, false);
    }
}

ryu_attack_entities_step();
ryu_cameos_step(_player);
shake_strength = max(0, shake_strength - 1);
arena_flash = max(0, arena_flash - 10 / 128);
if (blur_strength > 0) {
    blur_strength *= 0.9;
    if (blur_strength < 0.05) {
        blur_strength = 0;
    }
}
var _blur_angle = irandom(359);
game_controller.directional_blur_x = dcos(_blur_angle) * blur_strength * 0.01;
game_controller.directional_blur_y = dsin(_blur_angle) * blur_strength * 0.01;

if (_player == noone) {
    prehistorik_pickups_step(noone);
    chest_view_update(game_controller, noone, -1);
    game_controller.fade_stage_music();
    exit;
}
if (!_player.input_locked && _player.touching_hazard()) {
    _player.die();
    chest_view_update(game_controller, noone, -1);
    game_controller.fade_stage_music();
    exit;
}
ryu_update_view(_player);
