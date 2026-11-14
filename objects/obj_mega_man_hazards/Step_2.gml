++hazard_age;

switch (hazard_type) {
    case MegaManHazard.Buster:
    case MegaManHazard.SkeletonShot:
    case MegaManHazard.Burst:
    case MegaManHazard.SplitShot:
    case MegaManHazard.SplitShard:
    case MegaManHazard.Fireball:
        // Collision events use the last position published by the fixed-precision movement group.
        if (hazard_type >= MegaManHazard.Burst) {
            var _contact = place_meeting(x, y, obj_player_backdrop);
            if (_contact && !touching_backdrop) {
                switch (hazard_type) {
                    case MegaManHazard.Burst:
                        for (var _turn = 135; _turn <= 225; _turn += 45) {
                            mega_man_spawn_shot(MegaManHazard.SplitShot, x, y, image_angle + _turn, 4, 0.8);
                        }
                        instance_destroy();
                        exit;
                    case MegaManHazard.SplitShot:
                        mega_man_spawn_shot(MegaManHazard.SplitShard, x, y, image_angle + 135, 6, 0.6);
                        mega_man_spawn_shot(MegaManHazard.SplitShard, x, y, image_angle + 225, 6, 0.6);
                        break;
                    case MegaManHazard.Fireball:
                        var _flame = mega_man_spawn_shot(MegaManHazard.FloorFlame, x, 448, 0, 0);
                        _flame.image_yscale = 5;
                        instance_destroy();
                        exit;
                }
                if (hazard_age > 3) {
                    instance_destroy();
                    exit;
                }
            }
            touching_backdrop = _contact;
        }
        x = floor(stored_x);
        y = floor(stored_y);
        stored_x += lengthdir_x(travel_speed, image_angle);
        stored_y += lengthdir_y(travel_speed, image_angle);
        if (bbox_right < 0 || bbox_left >= room_width || bbox_bottom < 0 || bbox_top >= room_height) {
            instance_destroy();
        }
        break;

    case MegaManHazard.FloorFlame:
        // G897–898 only scale the Y axis, and the disappearing animation runs for 15 cycles.
        image_yscale = 5 - hazard_age * 0.025;
        if (hazard_age >= 120) {
            instance_destroy();
        }
        break;

    case MegaManHazard.Swoop:
        // G777–778 increment the wave counter between horizontal and vertical updates.
        if (travel_speed == 0) {
            break;
        }
        x += travel_speed;
        var _wave = dsin(hazard_age * 5);
        y = floor(stored_y + _wave * 32);
        var _angle = _wave * -25;
        image_angle = _angle - frac(_angle);
        if (bbox_right < -32 || bbox_left >= room_width + 32) {
            instance_destroy();
        }
        break;

    case MegaManHazard.DivingSpark:
        // G779 eases horizontal position even before the row is launched by G770.
        var _delta = target_x - x;
        x = floor(x + _delta * 0.2 + clamp(target_x, -1, 1));
        if (rising) {
            y = floor(y + travel_y);
            travel_y += 0.2;
            if (travel_y > 1) {
                var _fire_x = x + round(lengthdir_x(-17, image_angle));
                var _fire_y = y + round(lengthdir_y(-17, image_angle));
                // Fusion chooses the next counterclockwise artwork on a direction tie.
                mega_man_dividing_shard(_fire_x, _fire_y, spr_mega_man_hazards_diving_shard_right, 97, 236, 15);
                mega_man_dividing_shard(_fire_x, _fire_y, spr_mega_man_hazards_diving_shard, -97, 236, 25);
                mega_man_dividing_shard(_fire_x, _fire_y, spr_mega_man_hazards_diving_shard, 0, 256, 35);
                instance_destroy();
            }
        }
        break;

    case MegaManHazard.DivingShard:
        stored_x += travel_x;
        stored_y += travel_y;
        x = floor(stored_x);
        y = floor(stored_y);
        if (x < -64 || x > room_width + 64 || y < -64 || y > room_height + 64) {
            instance_destroy();
        }
        break;
}
