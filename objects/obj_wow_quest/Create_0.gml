enum WowQuestState { Waiting, Dialogue, Accepted, Declined, Closed }

trigger_left = 1674;
trigger_top = 1436;
trigger_right = 1737;
trigger_bottom = 1740;
axe_x = 1746;
axe_y = 1652;

quest_state = WowQuestState.Waiting;
quest_age = 0;
quest_sounds = [];
image_speed = 0;

update_quest = function(_player) {
    switch (quest_state) {
        case WowQuestState.Waiting:
            // G1085 creates the quest at its authored anchor once the player approaches the king.
            if (_player != noone
                && point_in_rectangle(_player.x, _player.y, trigger_left, trigger_top, trigger_right, trigger_bottom)) {
                quest_state = WowQuestState.Dialogue;
                array_push(quest_sounds, audio_play_sound(snd_wow_quest_open, 1, false));
            }
            break;

        case WowQuestState.Dialogue:
            // G1080–G1084 select one of the three original hover frames.
            var _mouse = wow_mouse_room_position();
            var _accept = !is_undefined(_mouse)
                && point_in_rectangle(_mouse.x, _mouse.y, x + 30, y + 265, x + 180, y + 280);
            var _decline = !is_undefined(_mouse)
                && point_in_rectangle(_mouse.x, _mouse.y, x + 29, y + 281, x + 77, y + 295);
            image_index = _accept ? 1 : (_decline ? 2 : 0);

            if (_player == noone) {
                break;
            }
            var _click = mouse_check_button_pressed(mb_left);
            if ((_accept && _click) || keyboard_check_pressed(global.settings.keys.shoot)) {
                quest_state = WowQuestState.Accepted;
                with (obj_wow) {
                    stop_stage_music();
                }
                array_push(quest_sounds, audio_play_sound(snd_wow_quest_accept, 1, false));
            } else if (_decline && _click) {
                quest_state = WowQuestState.Declined;
                array_push(quest_sounds, audio_play_sound(snd_wow_quest_decline, 1, false));
            }
            break;

        case WowQuestState.Accepted:
            // G1086 begins the fade on the acceptance step. G1087 jumps at age 70.
            if (++quest_age >= 69) {
                quest_state = WowQuestState.Closed;
                if (_player != noone) {
                    game_travel_by_teleporter(rm_cheetah_men, undefined, undefined, false);
                }
            }
            break;

        case WowQuestState.Declined:
            // G1088–G1091 scale the axe for its first nine steps and hit on age 25.
            if (++quest_age == 25 && _player != noone) {
                array_push(quest_sounds, audio_play_sound(snd_wow_quest_axe_hit, 1, false));
                if (_player.die()) {
                    with (obj_wow) {
                        stop_stage_music();
                    }
                }
            }
            break;
    }
};
