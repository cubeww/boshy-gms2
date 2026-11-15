function sanicz_victory_setup() {
    victory_age = -1;
    victory_hide_boss = false;
    victory_exit_steps = 0;
    victory_trophy_pending = false;
    victory_speed_pending = false;
    victory_trophy_title = "";
    victory_trophy_age = -1;
}

function sanicz_victory_begin(_seconds) {
    if (victory_age >= 0) {
        return;
    }

    // Groups 1202–1205 interrupt the attack timeline and center the hurt pose.
    victory_age = 0;
    x = 317;
    y = 139;
    sanicz_set_pose(15);
    sanicz_attacks_clear_for_victory();
    if (game_controller.stage_music_instance != -1) {
        audio_stop_sound(game_controller.stage_music_instance);
        game_controller.stage_music_instance = -1;
    }
    audio_play_sound(snd_king_dedede_explosion, 1, false);
    audio_play_sound(snd_sanicz_voice_31, 1, false);

    var _progress = game_current_progress();
    if (_seconds < _progress.sonic_best_time) {
        _progress.sonic_best_time = _seconds;
        global.profile.dirty = true;
        audio_play_sound(snd_hello_kitty_new_record, 1, false);
    }
    if (_seconds < 70) {
        victory_speed_pending = game_trophy_unlock("SonicSpeed");
    }
    victory_trophy_pending = game_trophy_unlock("Sonic");
    game_profile_save();
}

function sanicz_victory_blast(_x, _y, _scale) {
    instance_create_depth(_x, _y, depth - 2, obj_sanicz_victory_blast, {
        image_angle: irandom(359),
        image_xscale: _scale,
        image_yscale: _scale
    });
}

function sanicz_victory_step() {
    ++victory_age;
    if (!victory_hide_boss) {
        // Groups 1206–1207 each start a blast at their own interval.
        if (victory_age mod 5 == 0) {
            sanicz_victory_blast(x + irandom(49) - irandom(49), y + irandom(49) - irandom(49), 1);
            image_xscale += 0.2;
            shake_strength = 15;
        }
        if (victory_age mod 10 == 0) {
            sanicz_victory_blast(x + irandom(49) - irandom(49), y + irandom(49) - irandom(49), 1);
            image_xscale += 0.1;
            shake_strength = 15;
            audio_play_sound(snd_green_greens_kracko_explosion, 1, false, 0.2);
        }
        image_yscale = image_xscale;
        if (round(image_xscale * 10) > 70) {
            // Group 1209 replaces the boss with the larger final blast.
            sanicz_victory_blast(x, y, 3);
            victory_hide_boss = true;
            sprite_index = -1;
            shake_strength = 50;
            audio_play_sound(snd_biollante_explosion_final, 1, false);
        }
    } else if (!instance_exists(obj_sanicz_victory_blast)) {
        // Group 1208 advances to Castlevania at (31, 1289) after the blasts finish.
        if (++victory_exit_steps >= 100) {
            if (!teleporter_rush_exit()) {
                room_goto(rm_castlevania);
            }
            return;
        }
    }

    if (victory_trophy_age >= 0 && ++victory_trophy_age >= 226) {
        victory_trophy_age = -1;
    }
    if (victory_speed_pending) {
        victory_speed_pending = false;
        sanicz_victory_show_trophy("Sonic Speedrun!");
    } else if (victory_trophy_pending && victory_trophy_age < 0
        && game_controller.frame_second_tick && game_controller.frame_seconds mod 2 == 0) {
        victory_trophy_pending = false;
        sanicz_victory_show_trophy("You're too fast!");
    }
}

function sanicz_victory_show_trophy(_title) {
    victory_trophy_title = _title;
    victory_trophy_age = 0;
    audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
    audio_play_sound(snd_tutorial_achievement_success, 1, false);
}

function sanicz_victory_draw_hud(_viewport) {
    var _left = _viewport.left;
    var _top = _viewport.top;
    var _scale = _viewport.width / game_controller.render_width;

    if (victory_trophy_age >= 0) {
        var _alpha = 1 - max(0, victory_trophy_age - 200) / 26;
        draw_sprite_ext(spr_tutorial_achievement_banner, 0, _left + 434 * _scale, _top + 7 * _scale,
            _scale, _scale, 0, c_white, _alpha);
        draw_sprite_ext(spr_trophy_icon, 1, _left + 438 * _scale, _top + 12 * _scale,
            0.5 * _scale, 0.5 * _scale, 0, c_white, _alpha);
        var _text = string_copy(victory_trophy_title, 1, victory_trophy_age);
        draw_boshy_text(_text, _left + (628 - string_length(victory_trophy_title) * 8) * _scale,
            _top + 22 * _scale, _alpha, _scale);
    }
}

function sanicz_cameo_step() {
    if (fight_age == 3600 && victory_age < 0) {
        // Group 1196 brings Tails in from the left.
        instance_create_depth(-140, 347, depth - 1, obj_sanicz_cameo, {
            sprite_index: spr_sanicz_cameo
        });
    }

    var _boss = id;
    with (obj_sanicz_cameo) {
        if (sprite_index == spr_sanicz_cameo) {
            var _contact = _boss.sprite_index != -1 && place_meeting(x, y, _boss);
            if (_contact && !boss_contact) {
                // Group 1197 launches twelve rings on each new contact with Sanicz.
                _boss.sanicz_set_pose(15);
                _boss.shake_strength = 20;
                audio_play_sound(snd_sanicz_hit, 1, false);
                repeat (12) {
                    var _ring = instance_create_depth(_boss.x, _boss.y, depth - 1, obj_sanicz_cameo, {
                        sprite_index: spr_sanicz_ring
                    });
                    _ring.horizontal_speed = (-10 - irandom(54)) * 0.1;
                    _ring.vertical_speed = (-110 - irandom(69)) * 0.1;
                }
                horizontal_speed = -5;
                vertical_speed = -10;
                recoiling = true;
            }
            boss_contact = _contact;
            if (recoiling) {
                y = floor(y + vertical_speed);
                vertical_speed += 0.4;
                image_angle = (image_angle + 1) mod 360;
                horizontal_speed -= 0.4;
            }
            x = floor(x + horizontal_speed);
            horizontal_speed += 0.4;
            if (y > 580 || (!recoiling && x > room_width + 120)) {
                instance_destroy();
            }
        }
    }
    with (obj_sanicz_cameo) {
        if (sprite_index == spr_sanicz_ring) {
            sanicz_ring_step();
        }
    }
}

function sanicz_ring_step() {
    // Groups 1199–1200 retain fractional ring motion and bounce on first floor contact.
    x = floor(ring_x);
    y = floor(ring_y);
    vertical_speed += 0.4;
    ring_x += horizontal_speed;
    ring_y += vertical_speed;
    var _contact = instance_exists(inst_sanicz_floor) && place_meeting(x, y, inst_sanicz_floor);
    if (_contact && !floor_contact) {
        vertical_speed *= -0.9;
    }
    floor_contact = _contact;
    if (x < -64 || y > room_height + 64) {
        instance_destroy();
    }
}
