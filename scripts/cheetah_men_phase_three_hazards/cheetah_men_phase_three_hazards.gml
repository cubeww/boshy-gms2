enum CheetahMenPhaseThreeHazard {
    SlantedDrop,
    BounceTarget,
    FallingTarget
}

function cheetah_men_phase_three_spawn(_kind, _x, _y, _hsp = 0) {
    return instance_create_layer(_x, _y, "Hazards", obj_cheetah_men_phase3_hazard, {
        hazard_kind: _kind,
        travel_x: _hsp
    });
}

function cheetah_men_phase_three_shift_drop() {
    // G1194 advances the original actor one pixel at each clock interval.
    with (obj_cheetah_men_phase3_hazard) {
        if (hazard_kind == CheetahMenPhaseThreeHazard.SlantedDrop) {
            ++x;
        }
    }
}

function cheetah_men_phase_three_arm_drop() {
    // G1196 enlarges the offscreen actor in place rather than spawning it in the arena.
    with (obj_cheetah_men_phase3_hazard) {
        if (hazard_kind == CheetahMenPhaseThreeHazard.SlantedDrop) {
            image_xscale = 10;
            image_yscale = 10;
        }
    }
}

function cheetah_men_phase_three_drop() {
    with (obj_cheetah_men_phase3_hazard) {
        if (hazard_kind == CheetahMenPhaseThreeHazard.SlantedDrop) {
            drop_active = true;
        }
    }
}

function cheetah_men_phase_three_hazards_step(_player, _time_ms) {
    with (obj_cheetah_men_phase3_hazard) {
        switch (hazard_kind) {
            case CheetahMenPhaseThreeHazard.SlantedDrop:
                // G1197 begins the drop when the third Cheetah is defeated.
                if (drop_active) {
                    image_angle = 15;
                    y += 4;
                    if (bbox_top >= room_height) {
                        instance_destroy();
                    }
                }
                break;

            case CheetahMenPhaseThreeHazard.BounceTarget:
                // G1191: these targets move horizontally at a fixed speed.
                x += travel_x;
                if (bbox_right < 0) {
                    instance_destroy();
                }
                break;

            case CheetahMenPhaseThreeHazard.FallingTarget:
                // G41 checks the precise hazard mask before the G1198 movement.
                if (_player != noone && instance_exists(_player) && _player.boshy_mask_meeting(id)
                    && _player.die()) {
                    _player = noone;
                }
                y += 3;
                image_angle = 90 + dsin(_time_ms div 3) * 20;
                if (bbox_top >= room_height) {
                    instance_destroy();
                }
                break;
        }
    }
}

function cheetah_men_phase_three_check_player(_player) {
    // G1185 runs the Down probe first, then G1186 tests the Up probe.
    with (obj_cheetah_men_phase3_hazard) {
        if (hazard_kind == CheetahMenPhaseThreeHazard.BounceTarget
            && _player.probe_overlaps(_player.down_probe, id)) {
            _player.vsp = -8;
            _player.grounded = false;
            _player.air_jump_available = true;
            _player.jump_cut_enabled = false;
            cheetah_men_spawn(CheetahMenAttack.Explosion, x, y);
            instance_destroy();
        }
    }

    with (obj_cheetah_men_phase3_hazard) {
        if (hazard_kind == CheetahMenPhaseThreeHazard.BounceTarget
            && _player.probe_overlaps(_player.up_probe, id)) {
            return _player.die();
        }
    }
    return false;
}

function cheetah_men_phase_three_take_shot(_shot) {
    // G1181 destroys Active 35 on a player bullet. Companion fire uses its own event.
    if (_shot.object_index != obj_bullet) {
        return false;
    }
    with (obj_cheetah_men_phase3_hazard) {
        if (hazard_kind != CheetahMenPhaseThreeHazard.FallingTarget) {
            continue;
        }
        var _target = id;
        var _hit = false;
        with (_shot) {
            _hit = place_meeting(x, y, _target);
        }
        if (_hit) {
            audio_play_sound(snd_cheetah_men_phase3_target_hit, 1, false);
            cheetah_men_spawn(CheetahMenAttack.Explosion, x, y);
            instance_destroy();
            return true;
        }
    }
    return false;
}
