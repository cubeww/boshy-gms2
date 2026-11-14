enum DesertSecretFloorAction {
    Slow, Fast, EnablePlant, ResumePlant, PausePlant, FragmentFloor, ResetPlant, RemovePlant
}

rise_speed = 1;
rider_contact = false;
image_speed = 0;
image_index = 0;

advance = function(_player) {
    if (_player != noone && !_player.dead) {
        _player.refresh_collision_probes();
        var _touching_floor = _player.probe_overlaps(_player.down_probe, id);
        if (_touching_floor && _player.probe_overlaps(_player.up_probe, obj_player_backdrop)
            && _player.die()) {
            _player = noone;
        }
    } else {
        _player = noone;
    }
    // G915 also clears the carry flag when the player overlaps a wall-jump marker.
    if (_player == noone || _player.boshy_mask_meeting(obj_ninja_gaiden_wall_jump)) {
        rider_contact = false;
    }

    y -= rise_speed;
    if (rider_contact) {
        // G917 still carries this frame if the unstuck loop clears the flag for the next one.
        var _unstuck = { left: -7, top: -4, right: 6, bottom: -3 };
        repeat (rise_speed * 3) {
            _player.refresh_collision_probes();
            if (_player.grounded && !_player.probe_overlaps(_player.down_probe, id)) {
                rider_contact = false;
            }
            if (!_player.probe_overlaps(_unstuck, id)) {
                break;
            }
            --_player.y;
            _player.grounded = true;
        }
        with (obj_bullet) {
            y -= other.rise_speed;
        }
        _player.y -= rise_speed;
    }
    if (_player != noone) {
        _player.refresh_collision_probes();
        if (_player.probe_overlaps(_player.down_probe, id)) {
            rider_contact = true;
            if (_player.vsp >= 0) {
                _player.grounded = true;
                _player.vsp = 0;
            }
        }
    }

    // G923–925 and G947–966 use floor contact with the invisible authored markers.
    var _plant = instance_find(obj_desert_secret_laser_plant, 0);
    var _floor = id;
    with (obj_desert_secret_floor_trigger) {
        if (!place_meeting(x, y, _floor)) {
            continue;
        }
        switch (floor_action) {
            case DesertSecretFloorAction.Slow:
                _floor.rise_speed = 1;
                break;
            case DesertSecretFloorAction.Fast:
                _floor.rise_speed = 2;
                break;
            case DesertSecretFloorAction.EnablePlant:
                _floor.image_index = 1;
                if (_plant != noone) {
                    _plant.attack_enabled = true;
                    _plant.intro_cue = audio_play_sound(snd_desert_secret_stone_attack, 1, false);
                }
                break;
            case DesertSecretFloorAction.ResumePlant:
                _floor.image_index = 1;
                if (_plant != noone) {
                    _plant.attack_enabled = true;
                    _plant.attack_clock = 0;
                    _plant.vertical_offset = 92;
                }
                break;
            case DesertSecretFloorAction.PausePlant:
                _floor.image_index = 1;
                if (_plant != noone) {
                    _plant.stop_beam();
                    _plant.attack_enabled = false;
                    _plant.vertical_offset = 92;
                }
                break;
            case DesertSecretFloorAction.FragmentFloor:
                _floor.rise_speed = 2;
                _floor.image_index = 2;
                break;
            case DesertSecretFloorAction.ResetPlant:
                if (_plant != noone) {
                    _plant.attack_enabled = true;
                    _plant.vertical_offset = 92;
                    _plant.lift_steps = 0;
                    _plant.attack_clock = 0;
                    _plant.attack_lane = 0;
                }
                break;
            case DesertSecretFloorAction.RemovePlant:
                if (_plant != noone) {
                    _plant.stop_beam();
                    instance_destroy(_plant);
                    _plant = noone;
                }
                break;
        }
        instance_destroy();
    }
    if (_plant != noone) {
        _plant.advance_attack(_player, rise_speed);
    }
};
