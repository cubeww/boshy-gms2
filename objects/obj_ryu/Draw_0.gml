if (fight_age >= 0 && intro_marker_y < 480) {
    draw_sprite(spr_ryu_intro_marker, 0, 1829, intro_marker_y);
}

if (ryu_pose_sprite != -1 && defeat_bounces < 4) {
    var _invert = (hit_flash_age >= 2 && hit_flash_age < 4) || (hit_flash_age >= 6 && hit_flash_age < 8);
    _invert = _invert && shader_is_compiled(shd_boss_hit_invert);
    if (_invert) {
        shader_set(shd_boss_hit_invert);
    }
    draw_sprite_ext(ryu_pose_sprite, ryu_pose_frame, x, y, image_xscale, image_yscale, image_angle, c_white, 1);
    if (_invert) {
        shader_reset();
    }
    if (!defeated && difficulty == 0) {
        // The original Ez-mode bow uses the boss hotspot, direction, and timer.
        var _bow_angle = ryu_pose_facing * 45 + dsin(scene_steps * 4) * 10;
        draw_sprite_ext(spr_ryu_giant_bow, 0, x, y, 0.15, 0.15, _bow_angle, c_white, 1);
    }
}

ryu_attacks_draw();
prehistorik_pickups_draw();

if (dance_active) {
    var _dance_age = victory_age - 499;
    if (_dance_age < 250) {
        var _angle = _dance_age < 200 ? dsin(scene_steps * 5) * 15 : 0;
        var _dance_frame = max(0, ((_dance_age - 1) * 7 - 1) div 100) mod 2;
        draw_sprite_ext(spr_boshy_right, _dance_frame, dance_x, dance_y,
            1, 1, _angle, c_white, 1);
    } else {
        draw_sprite(spr_ryu_victory_player, 0, dance_x, dance_y);
    }
}
