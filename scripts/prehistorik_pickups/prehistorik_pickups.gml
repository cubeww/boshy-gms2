function prehistorik_pickups_setup(_entries = undefined, _reveal_sprite = spr_prehistorik_pickups, _show_trophy = undefined) {
    if (is_undefined(_entries)) {
        // Frame 2 objects 152, 164, 199, 290, and 278, with their native save keys.
        _entries = [
            inst_prehistorik_chest_awesome_sauce.pickup,
            inst_prehistorik_chest_lalalalalala_cd.pickup,
            inst_prehistorik_chest_mixer.pickup,
            inst_prehistorik_chest_luigi.pickup,
            inst_prehistorik_chest_mr_game_and_watch.pickup
        ];
    }
    prehistorik_pickup_entries = _entries;
    prehistorik_pickup_reveal_sprite = _reveal_sprite;
    prehistorik_pickup_show_trophy = is_undefined(_show_trophy) ? prehistorik_show_trophy : _show_trophy;

    for (var _i = 0; _i < array_length(prehistorik_pickup_entries); ++_i) {
        var _entry = prehistorik_pickup_entries[_i];
        _entry.collected = _entry.unlock_key == "" ? game_has_item(_entry.item)
            : struct_exists(global.profile.character_unlocks, _entry.unlock_key);
    }

    prehistorik_pickup_slot = -1;
    prehistorik_pickup_age = 0;
    prehistorik_pickup_clock = 0;
    prehistorik_pickup_player = noone;
    prehistorik_pickup_cue = -1;
    prehistorik_pickup_music = -1;
    prehistorik_pickup_message_age = -1;
    prehistorik_pickup_message = undefined;
}

function prehistorik_pickups_step(_player) {
    ++prehistorik_pickup_clock;
    if (prehistorik_pickup_message_age >= 0 && ++prehistorik_pickup_message_age >= 300) {
        prehistorik_pickup_message_age = -1;
    }

    if (prehistorik_pickup_slot >= 0) {
        if (_player == noone || _player.dead) {
            if (instance_exists(prehistorik_pickup_player)) {
                prehistorik_chest_pose_step(prehistorik_pickup_player, -1);
            }
            prehistorik_pickups_cleanup();
            if (prehistorik_pickup_music != -1) {
                audio_resume_sound(prehistorik_pickup_music);
                prehistorik_pickup_music = -1;
            }
            prehistorik_pickup_slot = -1;
            prehistorik_pickup_player = noone;
            return;
        }

        ++prehistorik_pickup_age;
        prehistorik_chest_pose_step(_player, prehistorik_pickup_age < 360 ? prehistorik_pickup_age : -1);
        var _entry = prehistorik_pickup_entries[prehistorik_pickup_slot];
        if (prehistorik_pickup_age == 250) {
            if (_entry.unlock_key == "") {
                prehistorik_pickup_message = {
                    top: 18, lines: ["SECRET ITEM!", string_upper(_entry.item) + " ACQUIRED!"]
                };
            } else {
                prehistorik_pickup_message = {
                    top: 39, lines: ["CHARACTER UNLOCKED!!", string_upper(_entry.unlock_key)]
                };
            }
            prehistorik_pickup_message_age = 0;
        }

        if (prehistorik_pickup_age == 315) {
            if (_entry.unlock_key == "") {
                var _new_trophy = _entry.trophy != "" && !game_trophy_is_unlocked(_entry.trophy);
                if (game_collect_item(_entry.item, _entry.trophy) && _new_trophy) {
                    prehistorik_pickup_show_trophy(_entry.trophy_title);
                }
            } else {
                game_character_unlock(_entry.unlock_key);
            }
            _entry.collected = true;
        }

        if (prehistorik_pickup_age == 330 && prehistorik_pickup_music != -1) {
            audio_resume_sound(prehistorik_pickup_music);
            prehistorik_pickup_music = -1;
        }

        if (prehistorik_pickup_age >= 360) {
            _player.visible = true;
            _player.input_locked = false;
            prehistorik_pickup_slot = -1;
            prehistorik_pickup_player = noone;
        }
        return;
    }

    if (_player == noone || _player.dead || _player.input_locked) {
        return;
    }

    var _bob = round(dsin(prehistorik_pickup_clock * 10) * 3);
    for (var _i = 0; _i < array_length(prehistorik_pickup_entries); ++_i) {
        var _entry = prehistorik_pickup_entries[_i];
        if (_entry.collected || (_entry.unlock_key == "Mr Game And Watch" && !prehistorik_morshu_trade_ready)) {
            continue;
        }

        var _y = _entry.y + _bob;
        // Image 2507's 16 by 16 visible footprint relative to its original hotspot.
        if (_player.bbox_right < _entry.x - 8 || _player.bbox_left >= _entry.x + 8
            || _player.bbox_bottom < _y - 15 || _player.bbox_top >= _y + 1) {
            continue;
        }

        prehistorik_pickup_slot = _i;
        prehistorik_pickup_age = 0;
        prehistorik_pickup_player = _player;
        prehistorik_chest_pose_step(_player, 0);
        _player.visible = false;
        _player.input_locked = true;
        _player.hsp = 0;
        _player.vsp = 0;

        var _track = game_controller.stage_music_instance;
        if (_track != -1 && audio_is_playing(_track) && !audio_is_paused(_track)) {
            audio_pause_sound(_track);
            prehistorik_pickup_music = _track;
        }
        prehistorik_pickup_cue = audio_play_sound(snd_prehistorik_pickup, 1, false);
        return;
    }
}

function prehistorik_pickups_draw() {
    var _bob = round(dsin(prehistorik_pickup_clock * 10) * 3);
    for (var _i = 0; _i < array_length(prehistorik_pickup_entries); ++_i) {
        var _entry = prehistorik_pickup_entries[_i];
        if (!_entry.collected && _i != prehistorik_pickup_slot) {
            draw_sprite(spr_prehistorik_pickups, 0, _entry.x, _entry.y + _bob);
        }
    }

    if (prehistorik_pickup_slot < 0 || !instance_exists(prehistorik_pickup_player)) {
        return;
    }
    var _player = prehistorik_pickup_player;
    var _reveal = prehistorik_pickup_age >= 250;
    if (prehistorik_pickup_age < 315) {
        var _frame = 0;
        if (_reveal) {
            _frame = prehistorik_pickup_entries[prehistorik_pickup_slot].art;
        } else if (prehistorik_pickup_age >= 100) {
            _frame = 1;
        }
        var _sprite = _reveal ? prehistorik_pickup_reveal_sprite : spr_prehistorik_pickups;
        draw_sprite(_sprite, _frame, _player.x, _player.y - 3);
    }

    prehistorik_draw_chest_pose(_player);
}

function chest_draw_overlay(_draw) {
    var _overlay = method(id, _draw);
    var _game = instance_find(obj_game, 0);
    // The native message and trophy layer is above the Viewport sprite.
    if (_game != noone && (!is_undefined(_game.chest_view_crop) || game_view_mirrored())) {
        array_push(_game.chest_view_overlays, _overlay);
        return;
    }

    var _camera = camera_get_active();
    _overlay({
        left: _camera == -1 ? 0 : camera_get_view_x(_camera),
        top: _camera == -1 ? 0 : camera_get_view_y(_camera),
        scale_x: _camera == -1 ? 1 : camera_get_view_width(_camera) / 640,
        scale_y: _camera == -1 ? 1 : camera_get_view_height(_camera) / 480
    });
}

function chest_draw_overlays(_game, _viewport) {
    var _overlays = _game.chest_view_overlays;
    var _count = array_length(_overlays);
    if (_count == 0) {
        return;
    }

    _game.chest_view_overlays = [];
    var _view = {
        left: _viewport.left,
        top: _viewport.top,
        scale_x: _viewport.width / 640,
        scale_y: _viewport.height / 480
    };
    for (var _i = 0; _i < _count; ++_i) {
        var _draw = _overlays[_i];
        _draw(_view);
    }
}

function prehistorik_pickups_draw_hud() {
    if (prehistorik_pickup_message_age >= 0) {
        chest_draw_overlay(prehistorik_pickups_draw_message);
    }
}

function prehistorik_pickups_draw_message(_view) {
    var _left = _view.left;
    var _top = _view.top;
    var _scale = _view.scale_x;
    draw_sprite_ext(spr_prehistorik_pickup_message, 0, _left + 5 * _scale, _top + 5 * _scale,
        _scale, _scale, 0, c_white, 1);

    var _age = prehistorik_pickup_message_age;
    var _bounce = 0;
    if (_age < 15) {
        var _beat = _age div 2;
        _bounce = (15 - 2 * _beat) * (_beat mod 2 == 0 ? -1 : 1);
    }

    var _message = prehistorik_pickup_message;
    var _remaining = _age;
    for (var _i = 0; _i < array_length(_message.lines) && _remaining > 0; ++_i) {
        var _line = _message.lines[_i];
        var _letters = min(_remaining, string_length(_line));
        draw_boshy_text(string_copy(_line, 1, _letters), _left + (238 - _letters * 8) * _scale,
            _top + (_message.top + _i * 9 + _bounce) * _scale, 1, _scale);
        _remaining -= _letters + 1;
    }
}

function prehistorik_pickups_cleanup() {
    if (prehistorik_pickup_cue != -1) {
        audio_stop_sound(prehistorik_pickup_cue);
        prehistorik_pickup_cue = -1;
    }
}
