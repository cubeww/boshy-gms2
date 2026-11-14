enum NinjaGaidenFlyer {
    ClockSway,
    RandomSway,
    Pillars,
    PillarTrigger
}

function ninja_enemy_spawn_poof(_x, _y) {
    instance_create_layer(_x, _y, "Hazards", obj_ninja_gaiden_enemy_poof);
}

function ninja_enemy_destroy_flyer(_flyer) {
    with (_flyer) {
        ninja_enemy_spawn_poof(x, y);
        if (flyer_kind == NinjaGaidenFlyer.PillarTrigger) {
            ninja_phase_pillars_activate();
        }
        audio_play_sound(snd_ninja_gaiden_enemy_kill, 1, false);
        instance_destroy();
    }
}

function ninja_enemy_take_shot(_shot, _companion = false) {
    var _flyer = noone;
    with (_shot) {
        _flyer = instance_place(x, y, obj_ninja_gaiden_flyer);
    }
    if (_flyer == noone) {
        return false;
    }
    if (_companion) {
        // G813 can change the companion's direction only on the first group of flyers.
        if (_flyer.flyer_kind == NinjaGaidenFlyer.ClockSway && !_shot.reflected) {
            _shot.reflected = true;
            _shot.reflection_angle = irandom_range(4, 12) * 11.25;
            audio_play_sound(snd_green_greens_middle_reflect, 1, false);
        }
        return false;
    }

    // G812, G818, G840 and G1154 consume a regular player bullet.
    ninja_enemy_destroy_flyer(_flyer);
    return true;
}

function ninja_enemy_crusher_hit(_crusher) {
    // G841 applies only to the flyers that also control the falling pillars.
    with (obj_ninja_gaiden_flyer) {
        if (flyer_kind == NinjaGaidenFlyer.Pillars && place_meeting(x, y, _crusher)) {
            ninja_enemy_destroy_flyer(id);
        }
    }
}

function ninja_pillar_flyer_overlaps(_pillar) {
    var _overlap = false;
    with (obj_ninja_gaiden_flyer) {
        if (flyer_kind == NinjaGaidenFlyer.Pillars && place_meeting(x, y, _pillar)) {
            _overlap = true;
        }
    }
    return _overlap;
}
