function prehistorik_exit_setup() {
    prehistorik_boss_threshold = inst_prehistorik_boss_threshold;
    prehistorik_exit_elevator = inst_prehistorik_exit_elevator;
    prehistorik_exit_elevator_enabled = game_has_item("Metal Gear");
    prehistorik_exit_elevator_velocity = 2;

    prehistorik_morshu = inst_prehistorik_morshu;
    prehistorik_morshu_wallet = inst_prehistorik_morshu_wallet;
    prehistorik_morshu_spike = inst_prehistorik_morshu_spike;
    prehistorik_morshu_trade_ready = false;
    prehistorik_morshu_has_rupee = false;
    prehistorik_morshu_steps = 0;
}

function prehistorik_exit_move_elevator(_player) {
    var _lift = prehistorik_exit_elevator;
    var _dy = prehistorik_exit_elevator_velocity;
    var _blocked = false;
    with (_lift) {
        _blocked = terrain_meeting(x, y + _dy);
    }

    var _riding = _player != noone && _player.probe_overlaps(_player.down_probe, _lift);
    if (_blocked) {
        prehistorik_exit_elevator_velocity = -_dy;
        return;
    }

    _lift.y += _dy;
    if (_riding) {
        _player.y += _dy;
    }
}

function prehistorik_exit_step(_player) {
    if (prehistorik_exit_elevator_enabled) {
        prehistorik_exit_move_elevator(_player);
    }
    if (prehistorik_morshu_trade_ready && instance_exists(prehistorik_morshu_spike)) {
        prehistorik_morshu_spike.y += 1;
        if (prehistorik_morshu_spike.y > room_height + 32) {
            instance_destroy(prehistorik_morshu_spike);
        }
    }

    if (_player == noone) {
        return;
    }

    if (prehistorik_morshu_steps > 0) {
        ++prehistorik_morshu_steps;
        switch (prehistorik_morshu_steps) {
            case 5:
                audio_pause_sound(game_controller.stage_music_instance);
                prehistorik_morshu.voice_instance = audio_play_sound(snd_prehistorik_morshu_offer, 1, false);
                break;
            case 400:
                if (prehistorik_morshu_has_rupee) {
                    prehistorik_morshu.voice_instance = audio_play_sound(snd_prehistorik_morshu_accept, 1, false);
                    audio_play_sound(snd_prehistorik_morshu_success, 1, false);
                    prehistorik_morshu_wallet.image_index = 0;
                    prehistorik_morshu_trade_ready = true;
                    prehistorik_morshu_steps = -1;
                    _player.input_locked = false;
                    audio_resume_sound(game_controller.stage_music_instance);
                } else {
                    prehistorik_morshu.voice_instance = audio_play_sound(snd_prehistorik_morshu_refuse, 1, false);
                    audio_resume_sound(game_controller.stage_music_instance);
                }
                break;
            case 700:
                prehistorik_morshu_steps = -1;
                prehistorik_morshu.sprite_index = spr_prehistorik_morshu_angry;
                if (!_player.die()) {
                    _player.input_locked = false;
                }
                break;
        }
        return;
    }

    if (_player.input_locked) {
        return;
    }

    if (point_in_rectangle(_player.x, _player.y, 3537, 1316, 3609, 1398)
        && game_has_item("Lalalalalala CD") && game_has_item("AwesomeSauce") && game_has_item("Mixer")
        && game_trophy_unlock("World1clear")) {
        prehistorik_show_trophy("WORLD 1 CLEAR!");
    }

    if (collision_rectangle(_player.bbox_left, _player.bbox_top, _player.bbox_right,
        _player.bbox_bottom, prehistorik_boss_threshold, true, false) != noone) {
        room_goto(rm_hello_kitty);
        return;
    }

    if (prehistorik_morshu_steps == 0 && collision_rectangle(_player.bbox_left, _player.bbox_top,
        _player.bbox_right, _player.bbox_bottom, prehistorik_morshu, true, false) != noone) {
        prehistorik_morshu_has_rupee = game_has_item("Rupees")
            && !struct_exists(global.profile.character_unlocks, "Mr Game And Watch");
        prehistorik_morshu_wallet.image_index = prehistorik_morshu_has_rupee ? 1 : 0;
        prehistorik_morshu_wallet.visible = true;
        prehistorik_morshu_steps = 1;
        _player.input_locked = true;
        _player.x = prehistorik_morshu.x - 65;
        _player.y = prehistorik_morshu.y;
        _player.hsp = 0;
        _player.vsp = 0;
    }
}
