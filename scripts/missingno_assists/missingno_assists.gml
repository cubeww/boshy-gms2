function missingno_guard_step() {
    var _guard = instance_find(obj_missingno_guard, 0);
    if (_guard == noone) {
        return;
    }
    if (hit_points <= 0) {
        instance_destroy(_guard);
        return;
    }

    // G909–911 keep the guard centered below the boss and hide it when it descends.
    _guard.x = x;
    _guard.y = y + 16;
    var _scale = image_xscale + 0.6 + dsin((game_controller.frame_elapsed_us div 1000) / 3) * 0.35;
    _guard.image_xscale = _scale;
    _guard.image_yscale = _scale;
    _guard.image_alpha = max(25 / 255, _guard.image_alpha - 5 / 255);
    _guard.visible = target_y <= 128;
}

function missingno_guard_take_shot(_shot) {
    var _guard = instance_find(obj_missingno_guard, 0);
    if (_guard == noone || !_guard.visible) {
        return false;
    }

    // G912 only applies to regular player bullets and requires a shown guard.
    var _hit = false;
    with (_shot) {
        _hit = place_meeting(x, y, _guard);
    }
    if (_hit) {
        _guard.image_alpha = 1;
    }
    return _hit;
}

function missingno_assists_draw() {
    if (game_campaign_difficulty() != 0) {
        return;
    }

    // G634, G702 and G1132 place the Ez-mode bow at the boss's transformed action point.
    var _bow_x = x + lengthdir_x(4 * image_xscale, image_angle)
        + lengthdir_x(18 * image_yscale, image_angle + 90) - 8;
    var _bow_y = y + lengthdir_y(4 * image_xscale, image_angle)
        + lengthdir_y(18 * image_yscale, image_angle + 90) - 8 * image_yscale;
    var _angle = 45 + dsin(scene_steps * 4) * 10;
    draw_sprite_ext(spr_ryu_giant_bow, 0, _bow_x, _bow_y, 0.25, 0.25, _angle, c_white, 1);
}
