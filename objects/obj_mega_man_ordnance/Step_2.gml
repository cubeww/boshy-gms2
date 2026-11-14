switch (ordnance_kind) {
    case MegaManOrdnance.Bomb:
    case MegaManOrdnance.SecondaryBomb:
        mega_man_bomb_ordnance_step();
        break;

    case MegaManOrdnance.Charge:
        mega_man_charge_step();
        if (++ordnance_age >= 400) {
            instance_destroy();
        }
        break;

    case MegaManOrdnance.Spinner:
        // G715–719 update position and angle before advancing the sine phase.
        x += ordnance_direction;
        y = floor(300 + dsin(ordnance_age * 2) * 150);
        image_angle = (image_angle - 5 * ordnance_direction) mod 360;
        if (++ordnance_age >= 300) {
            instance_destroy();
        }
        break;
}
