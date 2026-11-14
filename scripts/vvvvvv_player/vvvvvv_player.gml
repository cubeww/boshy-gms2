enum VvvvvvTrigger {
    GravityUp,
    GravityDown,
    EnableFlip,
    DisableFlip,
    WrapDownLeft,
    WrapLeft,
    WrapRight,
    WrapUp,
    WrapDown,
    WarpAhead,
    WarpBack
}

function vvvvvv_jump_step(_jump_held) {
    // Groups 76–77 switch gravity once per held input on a supporting surface.
    if (!_jump_held) {
        if (grounded) {
            gravity_flip_latched = false;
        }
        return;
    }
    if (gravity_flip_enabled && grounded && !gravity_flip_latched) {
        gravity_flip_latched = true;
        set_gravity_direction(-gravity_direction);
        jumped_this_step = true;
        var _sound = global.settings.special_jump_sounds ? character.jump_sound : snd_jump;
        if (_sound != noone) {
            audio_play_sound(_sound, 1, false);
        }
    }
}

function vvvvvv_apply_triggers() {
    ds_list_clear(vvvvvv_trigger_list);
    if (!boshy_mask_meeting(obj_vvvvvv_trigger, vvvvvv_trigger_list)) {
        return;
    }
    var _gravity = gravity_direction;
    var _play_sound = false;
    for (var _i = 0; _i < ds_list_size(vvvvvv_trigger_list); ++_i) {
        var _trigger = vvvvvv_trigger_list[| _i];
        switch (_trigger.trigger_kind) {
            case VvvvvvTrigger.GravityUp:
                if (_gravity > 0) {
                    _gravity = -1;
                    _play_sound = true;
                }
                break;
            case VvvvvvTrigger.GravityDown:
                if (_gravity < 0) {
                    _gravity = 1;
                    _play_sound = true;
                }
                break;
            case VvvvvvTrigger.EnableFlip:
                gravity_flip_enabled = true;
                break;
            case VvvvvvTrigger.DisableFlip:
                gravity_flip_enabled = false;
                _gravity = 1;
                break;
            case VvvvvvTrigger.WrapDownLeft:
                wrap_page_x = undefined;
                wrap_page_y = undefined;
                x -= 8;
                y += 480;
                break;
            case VvvvvvTrigger.WarpAhead:
                if (_gravity < 0) {
                    wrap_page_x = undefined;
                    wrap_page_y = undefined;
                    x += 2560;
                    y += 1920;
                }
                break;
            case VvvvvvTrigger.WarpBack:
                if (_gravity > 0) {
                    wrap_page_x = undefined;
                    wrap_page_y = undefined;
                    x -= 2560;
                    y -= 1920;
                }
                break;
        }
    }
    if (_gravity != gravity_direction) {
        set_gravity_direction(_gravity, _play_sound);
        if (_play_sound) {
            audio_play_sound(snd_vvvvvv_gravity_flip, 1, false);
        }
    }
}

function vvvvvv_wrap_horizontal() {
    var _keys = global.settings.keys;
    var _trigger = keyboard_check(_keys.right) ? vvvvvv_find_trigger(VvvvvvTrigger.WrapLeft) : noone;
    if (_trigger != noone) {
        wrap_page_x = floor(_trigger.x / 640) * 640;
        x -= 625;
    } else {
        _trigger = keyboard_check(_keys.left) ? vvvvvv_find_trigger(VvvvvvTrigger.WrapRight) : noone;
        if (_trigger == noone) {
            return;
        }
        // Left-edge markers can sit a few pixels outside the page they wrap.
        wrap_page_x = ceil(_trigger.x / 640) * 640;
        x += 625;
    }
    if (gravity_direction < 0) {
        y += 2;
    }
    refresh_collision_probes();
}

function vvvvvv_wrap_vertical() {
    var _kind = gravity_direction < 0 ? VvvvvvTrigger.WrapDown : VvvvvvTrigger.WrapUp;
    var _trigger = vvvvvv_find_trigger(_kind);
    if (_trigger != noone) {
        wrap_page_y = floor(_trigger.y / 480) * 480;
        y -= 480 * gravity_direction;
        refresh_collision_probes();
    }
}

function vvvvvv_find_trigger(_kind) {
    ds_list_clear(vvvvvv_trigger_list);
    if (boshy_mask_meeting(obj_vvvvvv_trigger, vvvvvv_trigger_list)) {
        for (var _i = 0; _i < ds_list_size(vvvvvv_trigger_list); ++_i) {
            var _trigger = vvvvvv_trigger_list[| _i];
            if (_trigger.trigger_kind == _kind) {
                return _trigger;
            }
        }
    }
    return noone;
}
