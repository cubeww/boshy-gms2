if (attack_kind == SaniczProjectile.OrbBurst) {
    // The source uses the finite Disappearing animation as the entire impact.
    image_index = (++projectile_age * 60 - 1) div 100;
    if (image_index >= image_number) {
        instance_destroy();
    }
    exit;
}
if (!launched) {
    exit;
}

if (attack_kind == SaniczProjectile.OrbShot) {
    travel_x += velocity_x;
    travel_y += velocity_y;
    var _next_x = floor(travel_x);
    var _next_y = floor(travel_y);
    if (instance_exists(inst_sanicz_floor) && place_meeting(_next_x, _next_y, inst_sanicz_floor)) {
        // Group 1177 creates the impact fourteen pixels below the projectile hotspot.
        instance_create_depth(_next_x, _next_y + 14, depth - 1, obj_sanicz_attack_hazard, {
            attack_kind: SaniczProjectile.OrbBurst,
            sprite_index: spr_sanicz_orb_fade
        });
        var _boss = instance_find(obj_sanicz, 0);
        if (_boss != noone) {
            _boss.shake_strength = 15;
        }
        instance_destroy();
        exit;
    }
    // Group 1241 turns the sprite using the actual movement between integer positions.
    var _angle = darctan2(x - _next_x, y - _next_y) + 180;
    image_angle = _angle - frac(_angle);
    x = _next_x;
    y = _next_y;
} else {
    // Groups 1240 and 1243 retain fractions in the movement accumulators.
    x = floor(travel_x);
    y = floor(travel_y);
    travel_x += velocity_x;
    travel_y += velocity_y;
}
if (x < -64 || x > room_width + 64 || y < -64 || y > room_height + 64) {
    instance_destroy();
}
