enum DesertPhase {
    Right,
    Left,
    Fall,
    Rise
}

function desert_switch_enabled() {
    return struct_exists(global.run, "desert_switch") && global.run.desert_switch;
}

function desert_switch_touch(_player) {
    var _riding = desert_snake_is_mounted();
    with (obj_desert_switch) {
        // G930 fires on the upper probe's fresh collision with each switch.
        var _contact = !_riding && _player.probe_overlaps(_player.up_probe, id);
        if (_contact && !probe_contact) {
            global.run.desert_switch = !desert_switch_enabled();
            _player.vsp = 0;
            audio_play_sound(snd_desert_switch, 1, false);
            with (obj_desert_switch) {
                refresh_switch();
            }
            with (obj_desert_switch_block) {
                refresh_block();
            }
        }
        probe_contact = _contact;
    }
}

function desert_switch_shot() {
    // G938–939 see only the blocks currently sharing the bullet's layer.
    return place_meeting(x, y, obj_desert_switch_block);
}

function desert_phase_move_x(_player) {
    // Fusion Round() rounds a half-integer toward negative infinity.
    var _rightward = _player.hsp > 0.5;
    var _falling = _player.vsp > 0;
    with (obj_desert_phase_tile) {
        switch (phase) {
            case DesertPhase.Right: set_active(_rightward); break;
            case DesertPhase.Left: set_active(!_rightward); break;
            case DesertPhase.Fall: set_active(_falling); break;
            case DesertPhase.Rise:
                if (!_falling) {
                    set_active(true);
                }
                break;
        }
    }
}

function desert_phase_move_y(_player) {
    // G988 only updates the rising tiles during a downward Y loop.
    if (_player.vsp > 0) {
        with (obj_desert_phase_tile) {
            if (phase == DesertPhase.Rise) {
                set_active(false);
            }
        }
    }
}
