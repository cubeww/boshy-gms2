function bomberman_attacks_setup() {
    attack_phase = -1;
    attack_pulse = 0;
    attack_pool = [];
    attack_audio = [];
}

function bomberman_attack_sound(_sound) {
    // Retain only live handles so repeated attack sounds remain bounded.
    for (var _i = array_length(attack_audio) - 1; _i >= 0; --_i) {
        if (!audio_is_playing(attack_audio[_i])) {
            array_delete(attack_audio, _i, 1);
        }
    }
    var _handle = audio_play_sound(_sound, 1, false);
    array_push(attack_audio, _handle);
    return _handle;
}

function bomberman_attacks_cleanup() {
    for (var _i = 0; _i < array_length(attack_audio); ++_i) {
        audio_stop_sound(attack_audio[_i]);
    }
    attack_audio = [];
}

function bomberman_attacks_clear() {
    // G1124 leaves the orbit star's existing flames and rollers' pellets to expire normally.
    with (obj_bomberman_ordnance) {
        if (attack_kind != BombermanAttack.FireTrail && attack_kind != BombermanAttack.RollerPellet) {
            instance_destroy();
        }
    }
    bomberman_attacks_cleanup();
}

function bomberman_teleport(_sound) {
    var _effect = instance_create_layer(x, y, layer, obj_bomberman_attack_effect);
    _effect.sprite_index = spr_bomberman_teleport_puff;
    _effect.image_xscale = image_xscale;
    _effect.image_yscale = image_yscale;
    bomberman_attack_sound(_sound);
}

function bomberman_attacks_step(_player) {
    ++attack_pulse;

    if (attack_phase == -1) {
        // G1139–1149. The opening alternates the raised pose in 20-step bursts.
        if (fight_age == 5) {
            bomberman_pose(1);
            bomberman_set_direction(8);
        }
        if (fight_age == 50) {
            bomberman_attack_sound(snd_bomberman_intro_voice);
        }
        if (fight_age <= 200) {
            if (attack_pulse == 1) {
                bomberman_set_direction((boss_direction + 16) mod 32);
                bomberman_attack_sound(snd_bomberman_burst);
                shake_strength = 3;
            }
            if (attack_pulse < 10) {
                y += 2;
            } else if (attack_pulse >= 20) {
                attack_pulse = 0;
            }
        }
        switch (fight_age) {
            case 200: game_controller.start_stage_music(snd_bomberman_music, true, false, 44100); break;
            case 240: bomberman_pose(18); break;
            case 260: bomberman_pose(0); break;
            case 320: bomberman_pose(12); break;
            case 350:
                bomberman_attack_sound(snd_bomberman_laugh);
                bomberman_pose(17);
                break;
        }
        if (fight_age < 349 && _player != noone && keyboard_check_pressed(global.settings.keys.skip)) {
            fight_age = 349;
            x = 308;
            y = 117;
            game_controller.start_stage_music(snd_bomberman_music, true, false, 44100);
        }
    }

    // G1150–1157. Each attack begins with a warning and a second teleport flash.
    switch (fight_age) {
        case 400:
            visible = false;
            bomberman_teleport(snd_bomberman_disappear);
            break;
        case 430:
            x = 80 + irandom(479);
            y = 200 + irandom(bomberman_has_rollers() ? 24 : 134);
            bomberman_pose(0);
            bomberman_teleport(snd_bomberman_teleport_warning);
            break;
        case 485:
            visible = true;
            bomberman_teleport(snd_bomberman_reappear);
            break;
        case 500:
            if (_player == noone) {
                attack_phase = -2;
            } else {
                // The Random Pool returns each attack once before refilling.
                if (array_length(attack_pool) == 0) {
                    attack_pool = [1, 2, 3, 4, 5, 6];
                }
                var _index = irandom(array_length(attack_pool) - 1);
                attack_phase = attack_pool[_index];
                array_delete(attack_pool, _index, 1);
            }
            break;
    }

    switch (attack_phase) {
        case -2:
            if (fight_age == 510) {
                bomberman_attack_sound(snd_bomberman_laugh);
                bomberman_pose(17);
            } else if (fight_age >= 550 && fight_age <= 600) {
                fight_age = 550;
            }
            break;

        case 1:
            // G1160–1166. Fifteen shots form a single angled fan.
            if (fight_age == 525 && _player != noone && _player.x != x) {
                bomberman_set_direction(_player.x < x ? 16 : 0);
                bomberman_attack_sound(snd_bomberman_die_2);
                bomberman_pose(18);
            } else if (fight_age == 550) {
                bomberman_pose(14);
            }
            if (fight_age == 560) {
                var _start = -90 - (boss_direction - 8) * 5;
                var _turn = -14 * ((boss_direction - 8) / 8);
                repeat (15) {
                    bomberman_spawn_ordnance(BombermanAttack.SlashRing, x, y, _start, 0.75);
                    _start += _turn;
                }
                shake_strength = 10;
                bomberman_attack_sound(snd_bomberman_die_4);
            }
            if (fight_age >= 560) {
                with (obj_bomberman_ordnance) {
                    if (attack_kind == BombermanAttack.SlashRing) {
                        travel_speed += 0.15;
                    }
                }
            }
            if (fight_age == 600) {
                fight_age = 399;
            }
            break;

        case 2:
            // G1169–1176. Rollers prevent the low arena teleport.
            switch (fight_age) {
                case 505: if (bomberman_has_rollers()) fight_age = 399; break;
                case 510:
                    visible = false;
                    bomberman_teleport(snd_bomberman_disappear);
                    break;
                case 530:
                    x = 328;
                    y = 265;
                    bomberman_pose(0);
                    bomberman_teleport(snd_bomberman_teleport_warning);
                    break;
                case 560:
                    visible = true;
                    bomberman_teleport(snd_bomberman_reappear);
                    break;
                case 580: bomberman_attack_sound(snd_bomberman_link); break;
                case 600: bomberman_attack_sound(snd_bomberman_will_die); break;
            }
            if (fight_age >= 580 && attack_pulse >= 15) {
                bomberman_pose(13);
                var _bomb = bomberman_spawn_ordnance(BombermanAttack.BounceBomb, x, y);
                _bomb.velocity_x = (irandom(59) - irandom(59)) * 0.1;
                _bomb.velocity_y = -8 - irandom(49) * 0.1;
                attack_pulse = 0;
                shake_strength = 4;
                bomberman_attack_sound(snd_bomberman_burst);
            }
            if (fight_age == 700) {
                fight_age = 399;
            }
            break;

        case 3:
            // G1179–1183. The star sheds fire as its radius expands.
            if (fight_age == 510) {
                bomberman_pose(12);
                bomberman_attack_sound(snd_bomberman_koridai);
                with (obj_bomberman_ordnance) {
                    if (attack_kind == BombermanAttack.OrbitStar || attack_kind == BombermanAttack.FireTrail) {
                        instance_destroy();
                    }
                }
            }
            if (fight_age >= 530 && fight_age <= 580) {
                shake_strength = 5;
            }
            switch (fight_age) {
                case 570:
                    bomberman_pose(16);
                    bomberman_spawn_ordnance(BombermanAttack.OrbitStar, x, y);
                    shake_strength = 16;
                    bomberman_attack_sound(snd_bomberman_die_2);
                    break;
                case 600:
                    bomberman_pose(17);
                    bomberman_attack_sound(snd_bomberman_laugh);
                    break;
                case 640: fight_age = 399; break;
            }
            break;

        case 4:
            // G1186–1189. Each flame keeps its floor anchor while the next spawns 16 pixels farther right.
            if (fight_age == 510) {
                bomberman_pose(12);
                bomberman_attack_sound(snd_bomberman_join);
            }
            if (fight_age >= 530 && fight_age <= 580) {
                shake_strength = 5;
            }
            if (fight_age >= 575 && fight_age <= 665) {
                var _fire = bomberman_spawn_ordnance(BombermanAttack.BlueFlame,
                    (fight_age - 575) * 16 + irandom(3) - irandom(3), 312);
                _fire.animation_rate = 20 + irandom(59);
            } else if (fight_age == 675) {
                fight_age = 399;
            }
            break;

        case 5:
            // G1192–1197. Two rollers enter from opposite ends and emit bouncing pellets.
            switch (fight_age) {
                case 510: bomberman_attack_sound(snd_bomberman_face_will_die); break;
                case 540:
                    bomberman_pose(13);
                    shake_strength = 10;
                    break;
                case 550:
                    bomberman_attack_sound(snd_bomberman_roller_burst);
                    bomberman_spawn_ordnance(BombermanAttack.Roller, 125, -50, 0, 0, 1);
                    bomberman_attack_sound(snd_bomberman_roller_burst);
                    bomberman_spawn_ordnance(BombermanAttack.Roller, 515, -50, 0, 0, -1);
                    break;
                case 575:
                    bomberman_pose(17);
                    bomberman_attack_sound(snd_bomberman_laugh);
                    break;
                case 610: fight_age = 399; break;
            }
            break;

        case 6:
            // G1200–1206. Six delayed embers leave the current pose's action point.
            switch (fight_age) {
                case 510: bomberman_attack_sound(snd_bomberman_must_join); break;
                case 535: bomberman_pose(13); break;
                case 550: bomberman_pose(19); break;
                case 575:
                    attack_pulse = 0;
                    bomberman_attack_sound(snd_bomberman_ember_burst);
                    break;
                case 620: bomberman_pose(0); break;
                case 640: fight_age = 399; break;
            }
            if (fight_age >= 575 && fight_age <= 580) {
                var _point = bomberman_pose_action_point();
                var _ember = bomberman_spawn_ordnance(BombermanAttack.OrbitEmber,
                    x + _point[0] * image_xscale, y + _point[1] * image_yscale, attack_pulse);
                _ember.expires_at = 30 + attack_pulse * 0.35;
                attack_pulse += 60;
            }
            break;
    }
}
