if (already_caught) {
    game_return_from_gastly(316, 290);
    exit;
}

++transition_age;
dialogue_letters = min(dialogue_letters + 1, string_length(dialogue));
if (reward_notice_age >= 0) {
    ++reward_notice_age;
}

var _player = instance_find(obj_player, 0);
if (_player == noone) {
    game_controller.fade_stage_music();
    exit;
}

if (capturing) {
    gastly_angle = dsin(current_time / 3) * 20;
}
if ((capturing || caught) && _player.grounded) {
    _player.input_locked = true;
    _player.hsp = 0;
    _player.vsp = 0;
    _player.pose = PlayerPose.Idle;
    _player.pose_frame = 0;
}

// Once the encounter is catchable, wait for the player to land a shot.
if (battle_age == 700 && has_awesome_sauce && !capturing && !caught) {
    exit;
}
++battle_age;
if (battle_age > 0 && battle_age <= 75) {
    gastly_x += 3;
}
if (has_awesome_sauce && battle_age >= 500 && battle_age <= 522) {
    --gastly_hp;
}
if (!has_awesome_sauce && battle_age >= 860 && battle_age < 870) {
    gastly_x -= 15;
    gastly_y += 8;
}

switch (battle_age) {
    case 75:
        gastly_sprite = spr_gastly_idle;
        set_dialogue("Wild GASTLY appeared!");
        audio_play_sound(snd_gastly_cry, 1, false);
        break;
    case 250:
        if (has_awesome_sauce) {
            set_dialogue("BOSHY's AWESOMENESS is\ntoo much for GASTLY!");
        } else {
            set_dialogue("BOSHY is immobilized\nfor the next turn! His\nAWESOMENESS level is\nNOT ENOUGH!");
        }
        break;
    case 500:
        if (has_awesome_sauce) {
            set_dialogue("Wild GASTLY is\nimmobilized by BOSHY's\nAWESOMENESS!");
        } else {
            set_dialogue("Wild GASTLY used\nSHROOM!");
        }
        break;
    case 650:
        if (has_awesome_sauce) {
            set_dialogue("Wild GASTLY is\ncatchable!");
        } else {
            audio_play_sound(snd_gastly_power_up, 1, false);
        }
        break;
    case 660: if (!has_awesome_sauce) { gastly_scale += 0.2; } break;
    case 670: if (!has_awesome_sauce) { gastly_scale += 0.4; } break;
    case 680: if (!has_awesome_sauce) { gastly_scale += 0.8; } break;
    case 700:
        if (has_awesome_sauce && !capturing && !caught) {
            _player.input_locked = false;
        }
        break;
    case 750:
        if (!has_awesome_sauce) {
            set_dialogue("BOSHY is still\nimmobilized!");
        }
        break;
    case 800:
        if (capturing) {
            capturing = false;
            caught = true;
            set_dialogue("GOTCHA! GASTLY was\ncaught!");
            audio_pause_sound(game_controller.stage_music_instance);
            audio_play_sound(snd_gastly_catch, 1, false);
            if (game_collect_item("Gastly", "Gastly")) {
                reward_notice_age = 0;
                audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
                audio_play_sound(snd_tutorial_achievement_success, 1, false);
            }
        }
        break;
    case 880:
        if (!has_awesome_sauce) {
            set_dialogue("GASTLY used TACKLE!");
            _player.die();
        }
        break;
    case 900:
        audio_stop_sound(game_controller.stage_music_instance);
        game_controller.stage_music_instance = -1;
        set_dialogue("Press F9 to\ncall/dismiss GASTLY");
        break;
    case 1000:
        game_controller.start_stage_music(snd_gastly_victory_music, false, false);
        break;
    case 1600:
        game_return_from_gastly(316, 290);
        break;
}
