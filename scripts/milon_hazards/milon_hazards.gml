enum MilonHazard {
    Blade,
    HomingOrb,
    NarrowSpike,
    Hopper,
    Spider
}

function milon_in_zone(_player, _left, _top, _right, _bottom) {
    return _player != noone && _player.x >= _left && _player.x < _right
        && _player.y >= _top && _player.y < _bottom;
}

function milon_hazard_shot() {
    var _hazard = instance_place(x, y, obj_milon_hazard);
    if (_hazard == noone) {
        return false;
    }

    switch (_hazard.hazard_kind) {
        case MilonHazard.Blade:
            _hazard.armed = true;
            break;
        case MilonHazard.HomingOrb:
            audio_play_sound(snd_mario_bump, 1, false);
            instance_destroy(_hazard);
            return true;
        case MilonHazard.Hopper:
            // G818 destroys the waiting hopper without consuming the shot.
            if (_hazard.x >= 7785) {
                repeat (floor(213 * global.settings.blood_intensity / 100)) {
                    instance_create_depth(_hazard.x, _hazard.y, _hazard.depth - 1, obj_blood);
                }
                audio_play_sound(snd_milon_hopper_voice, 1, false);
                instance_destroy(_hazard);
            }
            break;
    }
    return false;
}
