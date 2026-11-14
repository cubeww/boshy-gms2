var _boss = instance_find(obj_missingno, 0);
if (_boss == noone) {
    exit;
}

// G724 and G728 start the source ROM-corruption loop at age 600 or on skip.
if (!glitch_active && _boss.fight_age >= 600) {
    glitch_active = true;
}
if (!glitch_active) {
    exit;
}

// G907 decreases the ink parameter toward 100. G712 fades the loop out on defeat.
if (_boss.hit_points <= 0) {
    ink = min(128, ink + 2);
} else {
    ink = max(100, ink - 1);
}
image_index = (glitch_age * 3 div 10) mod image_number;
++glitch_age;
