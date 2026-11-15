++scene_steps;
shang_tsung_pose_step();
var _player = shang_actor_hit_player(instance_find(obj_player, 0));
// G43 treats the fighter as a hazard until G800 moves him to another layer.
if (_player != noone && hit_points > 0 && _player.boshy_mask_meeting(id) && _player.die()) {
    _player = noone;
}
var _alive = _player != noone && !_player.dead;

if (_alive && fight_age < 490 && keyboard_check_pressed(ord("S"))) {
    fight_age = 489;
    x = 574;
    boss_target_x = 574;
    boss_target_y = 371;
    shang_tsung_flash();
}

var _previous_age = fight_age;
if (hit_points > 0 && (fight_age < 750 || !awaiting_landing)) {
    ++fight_age;
}
shang_tsung_motion_step();
with (obj_shang_tsung_actor) {
    if (source_handle == 80) {
        shang_liu_kang_fall_step();
    }
}

if (hit_points > 0) {
    if (fight_age >= 0 && fight_age < 120) {
        --boss_target_x;
        shang_tsung_pose(1);
    }
    if (fight_age != _previous_age) {
        switch (fight_age) {
            case 120: shang_tsung_pose(0); break;
            case 150: add_dialogue(["So......"]); break;
            case 230: add_dialogue(["I herd u liek", "mudkipz..."]); break;
            case 450: add_dialogue(["Here is one!"]); break;
            case 490:
                // G682 resets the seconds counter without restarting the room's pulse.
                timer_base_seconds = -game_controller.frame_seconds;
                shang_tsung_pose(12);
                shang_spawn_intro(_player);
                audio_play_sound(snd_shang_tsung_mudkip_call, 2, false);
                // G683–684 stop the introduction, then start Wasteland if channel 2 is silent.
                if (intro_music != -1 && audio_is_playing(intro_music)) {
                    audio_stop_sound(intro_music);
                }
                intro_music = -1;
                if (!game_controller.stage_music_is_playing()) {
                    game_controller.start_stage_music(snd_shang_tsung_music, false, true);
                }
                break;
            case 510: audio_play_sound(snd_shang_tsung_fight, 2, false); break;
            case 620:
                if (_alive) {
                    add_dialogue(["DAMNIT!"]);
                }
                break;
            case 660:
                // G933 clears G689's direct Text Blitter text on creation and plays this cue.
                audio_play_sound(snd_shang_tsung_dialogue_open, 2, false);
                break;
        }
    }
    shang_tsung_attacks_step(_player);
    // G732 releases the clock after G675 has already run for this step.
    if (awaiting_landing && _alive && _player.y > 480) {
        awaiting_landing = false;
    }
} else if (victory_age < 0 && _alive) {
    // An early G800 win freezes the fight before G708 can remove the bridge.
    shang_tsung_victory_begin(_player);
}

if (victory_age >= 0 && _alive) {
    shang_tsung_victory_step(_player, timer_base_seconds + game_controller.frame_seconds);
}
shang_tsung_arena_step(_player, victory_age < 0 && fight_age >= 560 && !awaiting_landing);
if (_alive) {
    // G638 crops two pixels above the nominal page center.
    camera_set_view_pos(view_camera[0], 0, (_player.y >= 480 ? 480 : 0) - 2);
}
shang_actor_step(_player);

if (!instance_exists(obj_player)) {
    game_controller.fade_stage_music();
    if (!death_handled) {
        death_handled = true;
        if (fight_age >= 470 && fight_age <= 530) {
            add_dialogue(["HAHA! Noob!"]);
        }
    }
    if (defeat_announcement == -1 && array_length(game_controller.death_audio) > 0
        && !audio_is_playing(game_controller.death_audio[0])) {
        defeat_announcement = audio_play_sound(snd_shang_tsung_wins, 2, false);
    }
}

for (var _i = array_length(dialogue_lines) - 1; _i >= 0; --_i) {
    var _line = dialogue_lines[_i];
    ++_line.age;
    // G936–939 spend two steps building the initial bob counter.
    if (_line.age >= 3 && _line.age < 15 && _line.age mod 2 == 1) {
        var _amplitude = 15 - _line.age;
        _line.bob = (_line.age mod 4 == 1 ? -1 : 1) * _amplitude;
    }
    if (_line.shown < _line.length && (scene_steps mod 5 == 0 || scene_steps mod 5 == 3)) {
        ++_line.shown;
        audio_play_sound(snd_shang_tsung_dialogue_tick, 1, false);
    }
    if (_line.shown == _line.length && ++_line.hold_steps >= _line.length * 4) {
        array_delete(dialogue_lines, _i, 1);
    }
}

if (hit_flash_age > 0 && ++hit_flash_age >= 10) {
    hit_flash_age = 0;
}
// G638 sees the previous offsets; G1008 prepares the next pair after decrementing.
game_controller.scene_shake_x = shake_x;
game_controller.scene_shake_y = shake_y;
shake_strength = max(0, shake_strength - 1);
shake_x = shake_strength > 0 ? irandom_range(-shake_strength, shake_strength - 1) : 0;
shake_y = shake_strength > 0 ? irandom_range(-shake_strength, shake_strength - 1) : 0;
blur_strength *= 0.9;
if (blur_strength < 0.001) {
    blur_strength = 0;
}
var _angle = blur_strength > 0 && blur_angle == 0 ? irandom(359) : blur_angle;
game_controller.directional_blur_x = dcos(_angle) * blur_strength * 0.01;
game_controller.directional_blur_y = dsin(_angle) * blur_strength * 0.01;
