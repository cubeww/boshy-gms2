function game_slightly_enabled() {
    // Fusion gated several developer actions on global string B being "Slightly".
    static _enabled = undefined;
    if (is_undefined(_enabled)) {
        _enabled = false;
        for (var _i = 1; _i <= parameter_count(); ++_i) {
            if (string_lower(parameter_string(_i)) == "-slightly") {
                _enabled = true;
                break;
            }
        }
    }
    return _enabled;
}

function ear_rape_spike_step() {
    spike_fire_wait_us -= delta_time;
    var _repeat = spike_fire_wait_us <= 0;
    if (_repeat) {
        spike_fire_wait_us += 50000;
    }

    spike_glow_wait_us -= delta_time;
    var _glow = spike_glow_wait_us <= 0;
    if (_glow) {
        spike_glow_wait_us += 30000;
    }
    if (instance_exists(obj_ear_rape_spike)) {
        // Boss overlap tests precede the shared movement and trail events.
        ear_rape_spike_boss_step();
        var _camera = view_camera[0];
        var _left = camera_get_view_x(_camera) - 32;
        var _top = camera_get_view_y(_camera) - 32;
        var _right = camera_get_view_x(_camera) + camera_get_view_width(_camera) + 32;
        var _bottom = camera_get_view_y(_camera) + camera_get_view_height(_camera) + 32;
        with (obj_ear_rape_spike) {
            if (room == rm_solgryn && solgryn_gameplay_layer) {
                // G888 moves the spike from the player's Fusion layer 4 to layer 2.
                solgryn_gameplay_layer = false;
                depth = layer_get_depth("Gameplay") + 1;
            }
            animation_counter += 80;
            if (animation_counter > 100) {
                animation_counter -= 100;
                image_index = 1 - image_index;
            }
            x += 8 * shot_facing;
            if (_glow) {
                instance_create_depth(x, y, depth, obj_ear_rape_spike_glow);
            }
            if (bbox_left <= _left || bbox_right + 1 >= _right || bbox_top <= _top || bbox_bottom + 1 >= _bottom) {
                instance_destroy();
            }
        }
    }

    var _key = ord("C");
    var _fire = keyboard_check_pressed(_key) || (global.spike_held_steps > 25 && _repeat);
    if (!keyboard_check(_key)) {
        global.spike_held_steps = 0;
        return;
    }
    ++global.spike_held_steps;
    if (!_fire || mouse_check_button(mb_left) || (room == rm_wow && wow_login_typing())) {
        return;
    }

    var _player = instance_find(obj_player, 0);
    if (_player != noone && !_player.dead) {
        instance_create_depth(floor(_player.x), floor(_player.y), _player.depth - 1, obj_ear_rape_spike, {
            shot_facing: _player.facing
        });
    }
    audio_play_sound(snd_secret_jtv_scope_shoot, 1, false);
}

function ear_rape_spike_contact(_target, _require_gameplay_layer = false) {
    var _hit = false;
    with (obj_ear_rape_spike) {
        if ((!_require_gameplay_layer || solgryn_gameplay_layer) && place_meeting(x, y, _target)) {
            _hit = true;
            break;
        }
    }
    return _hit;
}

function ear_rape_spike_boss_step() {
    switch (room) {
        case rm_hello_kitty:
            with (obj_hello_kitty) {
                if (!defeated && ear_rape_spike_contact(id)) {
                    take_hit(4, snd_mario_bump);
                }
            }
            break;
        case rm_green_greens:
            with (obj_green_greens_kracko) {
                if (hit_points > 0 && ear_rape_spike_contact(id)) {
                    --hit_points;
                    if (hit_flash_age < 0) {
                        hit_flash_age = 1;
                    }
                    if (hit_points == 0) {
                        target_y = y;
                        stage_controller.game_controller.stop_stage_music();
                    }
                }
            }
            break;
        case rm_king_dedede:
            with (obj_king_dedede) {
                if (!dedede_falling && !dedede_defeated && ear_rape_spike_contact(id)) {
                    take_hit(snd_mario_bump);
                }
            }
            break;
        case rm_ryu:
            with (obj_ryu) {
                if (hit_points > 0 && ear_rape_spike_contact(id)) {
                    take_hit(5, snd_mario_bump);
                }
            }
            break;
        case rm_mario:
            with (obj_mario) {
                if (fight_age > 400 && hit_points > 0 && ear_rape_spike_contact(id)) {
                    take_hit(5);
                }
            }
            break;
        case rm_biollante:
            with (obj_biollante) {
                if (fight_age >= 830 && victory_age < 0 && ear_rape_spike_contact(id)) {
                    take_hit(5);
                }
            }
            break;
        case rm_sanicz:
            with (obj_sanicz) {
                if (victory_age < 0 && ear_rape_spike_contact(id)) {
                    // G1219 is unconditional, including the >=3520 branch in G1215.
                    if (fight_age >= 3520) {
                        audio_play_sound(snd_mario_bump, 1, false);
                    }
                    take_hit(fight_age >= 3520 ? 20 : 15);
                }
            }
            break;
        case rm_skeleton_king:
            with (obj_skeleton_king) {
                if (king_started && !king_defeated && king_age >= 280 && ear_rape_spike_contact(king_body_mask)) {
                    skeleton_king_damage(5);
                }
            }
            break;
        case rm_mega_man:
            with (obj_mega_man) {
                if (victory_age >= 0) {
                    continue;
                }
                if (ear_rape_spike_contact(id)) {
                    hit_points = max(0, hit_points - 5);
                    if (hit_flash_age == 0) {
                        hit_flash_age = 1;
                    }
                    audio_play_sound(snd_mario_bump, 1, false);
                }
                with (obj_mega_man_actor) {
                    if ((enemy_kind != MegaManActor.Dragon || enemy_age >= 50) && ear_rape_spike_contact(id)) {
                        enemy_health = max(0, enemy_health - 2);
                        switch (enemy_kind) {
                            case MegaManActor.MetalMan:
                            case MegaManActor.BombMan: other.secondary_hp = enemy_health; break;
                            case MegaManActor.Skeleton: other.secondary_hp = enemy_health div 3; break;
                            case MegaManActor.Dragon: other.secondary_hp = enemy_health div 4; break;
                        }
                        if (enemy_flash == 0) {
                            enemy_flash = 1;
                        }
                        audio_play_sound(snd_mario_bump, 1, false);
                    }
                }
            }
            break;
        case rm_shang_tsung:
            with (obj_shang_tsung) {
                if (hit_points > 0 && ear_rape_spike_contact(id)) {
                    hit_points = max(0, hit_points - 5);
                    if (hit_flash_age == 0) {
                        hit_flash_age = 1;
                    }
                    audio_play_sound(snd_mario_bump, 1, false);
                }
            }
            break;
        case rm_missingno:
            with (obj_missingno) {
                if (victory_age < 0 && hit_points > 0 && ear_rape_spike_contact(id)) {
                    hit_points = max(0, hit_points - 5);
                    if (hit_flash_age == 0) {
                        hit_flash_age = 1;
                    }
                    audio_play_sound(snd_mario_bump, 1, false);
                }
            }
            break;
        case rm_secret_jtv:
            with (obj_secret_jtv_encounter) {
                if (arena_started && victory_steps < 0 && ear_rape_spike_contact(boss)) {
                    hp = max(0, hp - 5);
                    if (hit_flash_steps == 0) {
                        hit_flash_steps = 10;
                    }
                    audio_play_sound(snd_mario_bump, 1, false);
                }
            }
            break;
        case rm_solgryn:
            with (obj_solgryn) {
                if (victory_age < 0 && hit_points > 0 && ear_rape_spike_contact(id, true)) {
                    hit_points = max(0, hit_points - 5);
                    if (solgryn_actor_flash_age == 0) {
                        solgryn_actor_flash_age = 1;
                    }
                    audio_play_sound(snd_mario_bump, 1, false);
                }
            }
            break;
    }
}
