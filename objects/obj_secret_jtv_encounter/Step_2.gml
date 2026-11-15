var _player = instance_find(obj_player, 0);
var _alive = _player != noone && !_player.dead;
++scene_steps;

// G807–809 start the encounter when the player walks into the chat area.
if (!arena_started && _alive && _player.x >= 2136 && _player.x <= 2213
    && _player.y >= 1853 && _player.y <= 1889) {
    arena_start();
}

var _chat_phase = SecretJtvChatPhase.Idle;
if (victory_steps >= 0) {
    _chat_phase = SecretJtvChatPhase.Victory;
} else if (arena_started) {
    _chat_phase = _alive ? SecretJtvChatPhase.Active : SecretJtvChatPhase.Dead;
}
var _new_chat_line = secret_jtv_dialogue_step(_chat_phase);
// G945 also lifts Kappa as the victory messages arrive, before the final explosion.
if (arena_started && (fight_age < 130 || victory_steps >= 0) && _new_chat_line && instance_exists(boss)) {
    boss.y -= 16;
}

hit_flash_steps = max(0, hit_flash_steps - 1);
if (arena_started && hp <= 0 && victory_steps < 0) {
    arena_begin_victory();
}
if (victory_steps >= 0) {
    // G840–846 fill the arena with small explosions, then swing the gate down.
    ++victory_steps;
    if (victory_steps <= 101) {
        arena_impact(25, 2);
        instance_create_depth(1921 + irandom(599), 1460 + irandom(399), effect_depth,
            obj_secret_jtv_arena_blast);
        if (victory_steps mod 10 == 0) {
            audio_play_sound(snd_green_greens_kracko_explosion, 1, false);
        }
    }
    if (victory_steps == 101) {
        instance_create_depth(2235, 1684, effect_depth, obj_secret_jtv_arena_blast, {
            image_xscale: 6, image_yscale: 6
        });
        instance_destroy(boss);
        audio_play_sound(snd_king_dedede_explosion, 1, false);
    }
    if (victory_steps > 101) {
        left_gate.image_angle = -min(90, victory_steps - 101);
        arena_cleared = true;
    }
} else if (arena_started && _alive) {
    ++fight_age;
    ++shot_timer;
    if (fight_age > 50 && fight_age <= 130) {
        inst_secret_jtv_controller.shake_view(fight_age - 49);
        blur_strength = 1;
    }
    if (fight_age == 130) {
        boss.x = 2445;
        boss.y = 1652;
        boss.sprite_index = spr_secret_jtv_scope_boss_left;
        fire_overlay.image_alpha = 1 - 90 / 128;
        fire_overlay.visible = true;
    }
    if (fight_age == 190) {
        audio_play_sound(snd_mario_power_up, 1, false);
    }
    var _growth = 0;
    if (fight_age >= 190 && fight_age <= 200) {
        _growth = 0.08;
    } else if (fight_age >= 210 && fight_age <= 220) {
        _growth = 0.1;
    } else if (fight_age >= 230 && fight_age <= 240) {
        _growth = 0.15;
    }
    boss.image_xscale += _growth;
    boss.image_yscale = boss.image_xscale;

    if (fight_age >= 130 && fight_age < 900) {
        boss.y = floor(1700 + dsin(fight_age * 5) * 100);
    }
    if (fight_age == 249) {
        shot_timer = 0;
    } else if (fight_age >= 250 && fight_age < 900) {
        if (shot_timer == 26) {
            arena_charge_scopes();
        }
        if (shot_timer >= 50) {
            arena_launch_scopes(_player, false);
            shot_timer = 0;
        }
        if (fight_age >= 500) {
            ++shot_timer;
        }
    }

    if (fight_age == 900) {
        shot_timer = 0;
        attack_y_target = 1850;
    } else if (fight_age == 1050) {
        attack_y_target = 1550;
    }
    if (fight_age >= 900) {
        boss.y = floor(lerp(boss.y, attack_y_target, 0.2) + 1);
    }
    if (fight_age >= 980 && fight_age < 1080) {
        boss.x -= shot_timer - 80;
    }
    if (fight_age >= 1080) {
        boss.x = floor(2240 + dsin(scene_steps * 20 / 3) * 280);
        boss.image_angle = point_direction(_player.x, _player.y, boss.x, boss.y);
        if (fight_age < 1500) {
            if (shot_timer == 10) {
                arena_charge_scopes();
            }
            if (shot_timer >= 25) {
                arena_launch_scopes(_player, true);
                shot_timer = 0;
            }
        }
    }
    if (fight_age >= 1550 && fight_age < 1650 && shot_timer >= 14) {
        shot_timer = 0;
        instance_create_depth(1907 + irandom(349), 1440, effect_depth, obj_secret_jtv_arena_floor_hazard);
        arena_impact(5, 1.5);
    }
    if (fight_age == 1700) {
        fight_age = 241;
        boss.image_angle = 0;
        boss.x = 2445;
        boss.y = 1652;
    }
}

if (arena_started) {
    // G1114 chooses a new blur angle independently of the viewport shake.
    blur_strength *= 0.9;
    var _blur_radius = blur_strength * 0.01;
    if (_blur_radius > 0.0001) {
        var _blur_angle = irandom(359);
        game_controller.directional_blur_x = lengthdir_x(_blur_radius, _blur_angle);
        game_controller.directional_blur_y = lengthdir_y(_blur_radius, _blur_angle);
    } else {
        game_controller.directional_blur_x = 0;
        game_controller.directional_blur_y = 0;
    }
}
