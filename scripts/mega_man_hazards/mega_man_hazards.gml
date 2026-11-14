enum MegaManHazard {
    Buster,
    SkeletonShot,
    Burst,
    SplitShot,
    SplitShard,
    Fireball,
    FloorFlame,
    Swoop,
    DivingSpark,
    DivingShard
}

function mega_man_spawn_shot(_kind, _x, _y, _angle, _speed, _scale = 1) {
    static _sprites = [
        spr_mega_man_hazards_buster, spr_mega_man_hazards_skeleton_shot,
        spr_mega_man_hazards_electricity, spr_mega_man_hazards_electricity, spr_mega_man_hazards_electricity,
        spr_mega_man_hazards_fireball, spr_mega_man_hazards_floor_flame,
        spr_mega_man_hazards_swoop, spr_mega_man_hazards_diving_spark, spr_mega_man_hazards_diving_shard
    ];
    return instance_create_depth(floor(_x), floor(_y), depth - 1, obj_mega_man_hazards, {
        hazard_type: _kind,
        travel_speed: _speed,
        sprite_index: _sprites[_kind],
        image_angle: _angle - frac(_angle),
        image_xscale: _scale,
        image_yscale: _scale
    });
}

function mega_man_spawn_swoop(_x, _y, _facing, _speed) {
    var _shot = mega_man_spawn_shot(MegaManHazard.Swoop, _x, _y, 0, _speed * _facing);
    if (_facing < 0) {
        _shot.sprite_index = spr_mega_man_hazards_swoop_left;
    }
}

function mega_man_spawn_diving_spark(_x, _target_x, _angle = 0) {
    var _spark = mega_man_spawn_shot(MegaManHazard.DivingSpark, _x, 350, _angle, 0);
    _spark.target_x = _target_x;
}

function mega_man_spin_diving_sparks() {
    with (obj_mega_man_hazards) {
        if (hazard_type == MegaManHazard.DivingSpark) {
            image_angle = (image_angle + 10) mod 360;
        }
    }
}

function mega_man_launch_diving_sparks() {
    with (obj_mega_man_hazards) {
        if (hazard_type == MegaManHazard.DivingSpark) {
            rising = true;
            travel_y = -10;
        }
    }
}

function mega_man_clear_diving_sparks() {
    with (obj_mega_man_hazards) {
        if (hazard_type == MegaManHazard.DivingSpark) {
            instance_destroy();
        }
    }
}

function mega_man_clear_electric_shots() {
    with (obj_mega_man_hazards) {
        if (hazard_type >= MegaManHazard.Burst && hazard_type <= MegaManHazard.SplitShard) {
            instance_destroy();
        }
    }
}

function mega_man_dividing_shard(_x, _y, _sprite, _dx, _dy, _speed) {
    var _shard = mega_man_spawn_shot(MegaManHazard.DivingShard, _x, _y, 0, 0);
    _shard.sprite_index = _sprite;
    // Fusion's built-in Shoot motion uses 8.8 direction coefficients and a speed divided by eight.
    _shard.travel_x = _dx * _speed / 2048;
    _shard.travel_y = _dy * _speed / 2048;
}
