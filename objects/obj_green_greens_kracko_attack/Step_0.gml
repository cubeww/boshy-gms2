if (!instance_exists(boss)) {
    instance_destroy();
    exit;
}

++age_steps;
switch (attack_kind) {
    case GreenGreensKrackoAttack.Lightning:
        image_index = age_steps div 2;
        if (image_index >= image_number) {
            instance_destroy();
        }
        break;
    case GreenGreensKrackoAttack.Minion:
        x -= left_speed;
        var _next_y = y + fall_speed;
        if (fall_speed >= 0 && terrain_meeting(x, _next_y)) {
            fall_speed = -2 - irandom(4);
        } else {
            y = _next_y;
            fall_speed += 0.2;
        }
        image_index = (age_steps div 5) mod image_number;
        break;
    case GreenGreensKrackoAttack.FallingStar:
        y += fall_speed;
        fall_speed += 0.3;
        image_index = floor(age_steps * 0.35) mod image_number;
        break;
    case GreenGreensKrackoAttack.SwingStar:
        orbit_angle += 1 + (boss.attack_age >= 1100) + (boss.attack_age >= 1200);
        var _radius = sign(arm_offset) * 64 + arm_offset;
        x = boss.target_x + dcos(orbit_angle) * _radius;
        y = boss.target_y - dsin(orbit_angle) * _radius;
        image_angle += 15;
        image_index = floor(age_steps * 0.8) mod image_number;
        break;
}

if ((y > 480 && (attack_kind == GreenGreensKrackoAttack.FallingStar || attack_kind == GreenGreensKrackoAttack.Minion))
    || (x < 3100 && attack_kind == GreenGreensKrackoAttack.Minion)) {
    instance_destroy();
}
