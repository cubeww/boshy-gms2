if (combat_active && !defeated) {
    with (obj_bullet) {
        if (!other.defeated && place_meeting(x, y, other.id)) {
            instance_destroy();
            other.take_hit(1);
        }
    }
}

// Fusion advances the active flash after resolving shots and clears it at age 10.
if (hit_flash_age >= 0) {
    ++hit_flash_age;
    if (hit_flash_age == 10) {
        hit_flash_age = -1;
    }
}
