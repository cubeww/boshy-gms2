if (shot_spent) {
    var _frame = (++impact_steps * 25 - 1) div 100;
    if (_frame >= image_number) {
        instance_destroy();
        exit;
    }
    image_index = _frame;
    exit;
}

switch (shot_kind) {
    case GradiusShot.Laser: x += 30; break;
    case GradiusShot.Normal: x += 25; break;
    case GradiusShot.Missile:
        x += 1;
        y = floor(y + missile_fall);
        missile_fall += 0.4;
        break;
}

if (bbox_left >= room_width || bbox_top >= room_height || bbox_right < 0 || bbox_bottom < 0) {
    instance_destroy();
}
